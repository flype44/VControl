;----------------------------------------------------------

	include	 exec/funcdef.i
	include  exec/exec.i
	include  exec/exec_lib.i
	include  libraries/lowlevel.i
	include  lvo/lowlevel_lib.i

;----------------------------------------------------------
;	
;	NAME
;		v_joyport_init
;	
;	SYNOPSIS
;		ULONG result = v_joyport_init(void)
;		D0
;	
; 	FUNCTION
;		This function installs 'our' replacement for
;		the lowlevel.library -> ReadJoyPort() function.
;		It returns NO ERROR (0) or DOS WARN (5) on error.
;	
;----------------------------------------------------------

	cnop     0,4
	
	xdef     _v_joyport_init
	
_v_joyport_init:

	movem.l  d2-d7/a2-a6,-(sp)         ; Push
	
	;------------------------------------------------------
	; Open the operating-system "lowlevel.library"
	;------------------------------------------------------
	
	lea.l    .name(pc),a1              ; LibName
	moveq.l  #0,d0                     ; LibVersion
	move.l   $4.w,a6                   ; SysBase
	JSRLIB   OpenLibrary               ; SysBase->OpenLibrary()
	move.l   d0,a2                     ; LibBase
	beq.w    .warn                     ; Skip
	
	;------------------------------------------------------
	; Check if the patch is already installed
	;------------------------------------------------------
	
	move.l   a2,a0                     ; LibBase
	add.l    #_LVOReadJoyPort+2,a0     ; LibFunction
	move.l   (a0),a0                   ; LibFunction->Marker
	cmp.l    #'JOYP',2(a0)             ; Check if installed
	beq.w    .warn                     ; Already installed
	
	;------------------------------------------------------
	; Allocate memory for the patch
	;------------------------------------------------------
	
	move.l   #MEMF_PUBLIC,d1           ; MemType
	move.l   #_v_joyport_end,d0        ; MemSize
	subi.l   #_v_joyport_new,d0        ; MemSize
	JSRLIB   AllocMem                  ; SysBase->AllocMem()
	move.l   d0,d2                     ; MemAddr
	beq.s    .warn                     ; Skip
	
	;------------------------------------------------------
	; Replace the ReadJoyPort() function
	;------------------------------------------------------
	
	JSRLIB   Disable                   ; SysBase->Disable()

	move.l   a2,a1                     ; LibBase
	move.l   #_LVOReadJoyPort,a0       ; LibFunction
	move.l   d2,d0                     ; NewFunction
	JSRLIB   SetFunction               ; SysBase->SetFunction()
	move.l   d0,_v_joyport_old         ; OldFunction
	
	lea.l    _v_joyport_new(pc),a0     ; Source
	move.l   d2,a1                     ; Destination
	move.l   #_v_joyport_end,d0        ; MemSize
	subi.l   #_v_joyport_new,d0        ; MemSize
	subq.l   #1,d0                     ; MemSize
.copy
	move.b   (a0)+,(a1)+               ; Copy routine
	dbf      d0,.copy                  ; Continue
	
	JSRLIB   Enable                    ; SysBase->Enable()
	
	;------------------------------------------------------
	; All done, we can set the exit codes and exit
	;------------------------------------------------------
	
	moveq.l  #0,d0                     ; ExitCode = OK
	bra.s    .exit                     ; Continue
	
.warn
	moveq.l  #5,d0                     ; ExitCode = WARN
	
.exit
	movem.l  (sp)+,d2-d7/a2-a6         ; Pop
	rts                                ; Exit

.name
	dc.b     "lowlevel.library",0

;----------------------------------------------------------
;	
;	NAME
;		_v_joyport_new
;	
;	SYNOPSIS
;		ULONG portState = ReadJoyPort(ULONG portNumber)
;		D0                            D0
;	
; 	FUNCTION
;		This function is 'our' replacement for the
;		lowlevel.library -> ReadJoyPort() function.
;		It remaps the SAGA JOYxSTATE bits to the 
;		legacy Commodore Amiga CD32 controller values.
;	
;----------------------------------------------------------

	cnop     0,4

_v_joyport_new:
	
	bra.b    _v_joyport_code           ; Entry code
	
	dc.b     'JOYP'                    ; Owner marker
	
_v_joyport_old:
	
	dc.l     0                         ; Original code
	
_v_joyport_code:
	
	;------------------------------------------------------
	; PortNumber 0 or 1, else
	; fall back to original function
	;------------------------------------------------------
	
	cmp.w    #1,d0                     ; 1 => JOY1STATE
	beq.s    .joy1                     ; 
	cmp.w    #0,d0                     ; 0 => JOY2STATE
	beq.s    .joy2                     ; 
	
.old
	move.l   _v_joyport_old(pc),-(sp)  ; Fall back
	rts                                ; Return
	
	;------------------------------------------------------
	; Read SAGA JOY1STATE
	;------------------------------------------------------
	
.joy1
	move.w   $DFF220,d1                ; JOY1STATE
	btst.l   #0,d1                     ; Is plugged ?
	beq.s    .old                      ; Skip if unplugged
	lea.l    .joy1map(pc),a0           ; Conversion table
	bra.s    .conv                     ; Continue
	
	;------------------------------------------------------
	; Read SAGA JOY2STATE
	;------------------------------------------------------
	
.joy2
	move.w   $DFF222,d1                ; JOY2STATE
	btst.l   #0,d1                     ; Is plugged ?
	beq.s    .old                      ; Skip if unplugged
	lea.l    .joy2map(pc),a0           ; Conversion table
	
	;------------------------------------------------------
	; Convert JOYxSTATE to CD32 values
	;------------------------------------------------------
	
.conv
	move.l   d2,a1                     ; Push
	move.l   #JP_TYPE_GAMECTLR,d0      ; CD32 Controller type
	moveq.l  #0,d2                     ; CD32 Controller value
.loop
	lsr.w    #1,d1                     ; JOYxSTATE >> 1
	beq.s    .done                     ; Done if no more bits
	btst.l   #0,d1                     ; Get SAGA bit
	beq.s    .skip                     ; Skip if FALSE
	move.b   (a0),d2                   ; Conversion table
	bset.l   d2,d0                     ; Set CD32 bit
.skip
	add.l    #1,a0                     ; Next table entry
	bra.s    .loop                     ; Continue
.done
	move.l   a1,d2                     ; Pop
	rts                                ; Return
	
	;------------------------------------------------------
	; JOY1STATE to CD32 conversion table
	;------------------------------------------------------
	
	cnop     0,4
	
.joy1map
	dc.b     JPB_BUTTON_RED            ; JOY1STATE(01)
	dc.b     JPB_BUTTON_BLUE           ; JOY1STATE(02)
	dc.b     JPB_BUTTON_GREEN          ; JOY1STATE(03)
	dc.b     JPB_BUTTON_YELLOW         ; JOY1STATE(04)
	dc.b     JPB_BUTTON_REVERSE        ; JOY1STATE(05)
	dc.b     JPB_BUTTON_FORWARD        ; JOY1STATE(06)
	dc.b     JPB_BUTTON_REVERSE        ; JOY1STATE(07)
	dc.b     JPB_BUTTON_FORWARD        ; JOY1STATE(08)
	dc.b     JPB_BUTTON_PLAY           ; JOY1STATE(09)
	dc.b     JPB_BUTTON_PLAY           ; JOY1STATE(10)
	dc.b     JPB_BUTTON_PLAY           ; JOY1STATE(11)
	dc.b     JPB_JOY_UP                ; JOY1STATE(12)
	dc.b     JPB_JOY_DOWN              ; JOY1STATE(13)
	dc.b     JPB_JOY_LEFT              ; JOY1STATE(14)
	dc.b     JPB_JOY_RIGHT             ; JOY1STATE(15)
	
	;------------------------------------------------------
	; JOY2STATE to CD32 conversion table
	;------------------------------------------------------
	
	cnop     0,4
	
.joy2map
	dc.b     JPB_BUTTON_RED            ; JOY2STATE(01)
	dc.b     JPB_BUTTON_BLUE           ; JOY2STATE(02)
	dc.b     JPB_BUTTON_GREEN          ; JOY2STATE(03)
	dc.b     JPB_BUTTON_YELLOW         ; JOY2STATE(04)
	dc.b     JPB_BUTTON_FORWARD        ; JOY2STATE(05)
	dc.b     JPB_BUTTON_REVERSE        ; JOY2STATE(06)
	dc.b     JPB_BUTTON_FORWARD        ; JOY2STATE(07)
	dc.b     JPB_BUTTON_REVERSE        ; JOY2STATE(08)
	dc.b     JPB_BUTTON_PLAY           ; JOY2STATE(09)
	dc.b     JPB_BUTTON_PLAY           ; JOY2STATE(10)
	dc.b     JPB_BUTTON_PLAY           ; JOY2STATE(11)
	dc.b     JPB_JOY_UP                ; JOY2STATE(12)
	dc.b     JPB_JOY_DOWN              ; JOY2STATE(13)
	dc.b     JPB_JOY_LEFT              ; JOY2STATE(14)
	dc.b     JPB_JOY_RIGHT             ; JOY2STATE(15)
	
	;------------------------------------------------------
	; END OF PATCH
	;------------------------------------------------------
	
	cnop     0,4
	
_v_joyport_end:

;----------------------------------------------------------
