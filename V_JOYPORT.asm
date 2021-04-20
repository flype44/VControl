;----------------------------------------------------------

	include	 exec/funcdef.i
	include  exec/exec.i
	include  exec/exec_lib.i
	include  libraries/lowlevel.i
;	include  libraries/lowlevel_lib.i
	include  lvo/lowlevel_lib.i

;----------------------------------------------------------
;	
;	STRUCT VJOYP
;	
;----------------------------------------------------------

EXECBASE     EQU 4
VJOYP_MARK   EQU 'JOYP'

	RSRESET
jp_New  RS.W 1    ; New code
jp_Old  RS.L 1    ; Old function
jp_Mark RS.B 4    ; Our marker
jp_Size RS.L 0    ; SizeOf

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
	
	lea.l    LOWLEVELNAME(pc),a1       ; Library Name
	move.l   LOWLEVELVERSION(pc),d0    ; Library Version
	move.l   EXECBASE.w,a6             ; SysBase
	jsr      _LVOOpenLibrary(a6)       ; SysBase->OpenLibrary()
	move.l   d0,a2                     ; Library Base
	beq.w    .failure                  ; Failed
	
	;------------------------------------------------------
	; Check if 'our' patch is already installed
	;------------------------------------------------------
	
	move.l   a2,a0                     ; Library  Base
	adda.l   #_LVOReadJoyPort+2,a0     ; Library Function
	move.l   (a0),a0                   ; Library Function
	cmp.l    #VJOYP_MARK,jp_Mark(a0)   ; Check 'our' mark
	beq.s    .uninstall                ; Already installed
	
	;------------------------------------------------------
	; Install 'our' ReadJoyPort() replacement
	;------------------------------------------------------

.install	

	move.l   #MEMF_PUBLIC,d1           ; Memory Type
	move.l   #_v_joyport_end,d0        ; Memory Size
	subi.l   #_v_joyport_new,d0        ; Memory Size
	jsr      _LVOAllocVec(a6)          ; SysBase->AllocVec()
	move.l   d0,d2                     ; Memory Address
	beq.s    .failure                  ; Failed
	
	jsr      _LVODisable(a6)           ; SysBase->Disable()
	
	move.l   a2,a1                     ; Library Base
	move.l   d2,d0                     ; Function Entry
	move.l   #_LVOReadJoyPort,a0       ; Function Offset
	jsr      _LVOSetFunction(a6)       ; SysBase->SetFunction()
	move.l   d0,_v_joyport_old         ; Old Function Entry
	
	lea.l    _v_joyport_new(pc),a0     ; Memory Source
	move.l   d2,a1                     ; Memory Destination
	move.l   #_v_joyport_end,d0        ; Memory Size
	subi.l   #_v_joyport_new,d0        ; Memory Size
	subq.l   #1,d0                     ; Memory Size
.copy
	move.b   (a0)+,(a1)+               ; Copy routine
	dbf      d0,.copy                  ; Continue
	
	jsr      _LVOEnable(a6)            ; SysBase->Enable()
	
	bra.s    .success                  ; Continue
	
	;------------------------------------------------------
	; Uninstall 'our' ReadJoyPort() replacement
	;------------------------------------------------------
	
.uninstall	
	
	jsr      _LVODisable(a6)           ; SysBase->Disable()
	
	move.l   a2,a1                     ; Library Base
	move.l   jp_Old(a0),d0             ; Function Entry
	move.l   #_LVOReadJoyPort,a0       ; Function Offset
	jsr      _LVOSetFunction(a6)       ; SysBase->SetFunction()
	move.l   d0,a1                     ; Old Function Entry
	jsr      _LVOFreeVec(a6)           ; SysBase->FreeVec()
	
	jsr      _LVOEnable(a6)            ; SysBase->Enable()

	;------------------------------------------------------
	; Exit code
	;------------------------------------------------------
	
.success
	moveq.l  #0,d0                     ; ExitCode = OK
	bra.s    .exit                     ; Continue
	
.failure
	moveq.l  #5,d0                     ; ExitCode = WARN
	
.exit
	movem.l  (sp)+,d2-d7/a2-a6         ; Pop
	rts                                ; Exit

LOWLEVELVERSION:
	dc.l     40

LOWLEVELNAME:
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
;		It converts all the SAGA JOYxSTATE bits to the
;		legacy Commodore Amiga CD32 controller values.
;	
;----------------------------------------------------------

	cnop     0,4

_v_joyport_new:
	
	bra.s    _v_joyport_code           ; Entry code
	
_v_joyport_old:
	
	dc.l     0                         ; Old Function Entry
	
_v_joyport_mark:
	
	dc.l     VJOYP_MARK                ; 4-bytes mark
	
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
	; Convert SAGA JOYxSTATE to CD32 values
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
	addq.l   #1,a0                     ; Next table entry
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
