;----------------------------------------------------------

	XDEF     _v_joyport_init

;----------------------------------------------------------

	include	 exec/funcdef.i
	include  exec/exec.i
	include  libraries/lowlevel.i
	include  lvo/exec_lib.i
	include  lvo/lowlevel_lib.i

;----------------------------------------------------------

	machine  mc68020

	cnop 0,4

_v_joyport_init:

	movem.l  d2-d7/a2-a6,-(sp)         ; Push
	
	lea.l    LibName(pc),a1            ; LibName
	moveq.l  #0,d0                     ; LibVersion
	move.l   $4.w,a6                   ; SysBase
	JSRLIB   OpenLibrary               ; SysBase->OpenLibrary()
	move.l   d0,a2                     ; LibBase
	beq.w    .err                      ; Skip
	
	move.l   a2,a0                     ; LibBase
	add.l    #_LVOReadJoyPort+2,a0     ; LibFunction
	move.l   (a0),a0                   ; Libfunction->Marker
	cmp.l    #'JOYP',2(a0)             ; Check if installed
	beq.w    .err                      ; Already installed
	
	move.l   #MEMF_PUBLIC,d1           ; MemType
	move.l   #PatchEnd,d0              ; MemSize
	subi.l   #PatchStart,d0            ; MemSize
	move.l   d0,PatchSize              ; MemSize
	JSRLIB   AllocMem                  ; SysBase->AllocMem()
	move.l   d0,PatchMem               ; MemAddr
	beq.s    .err                      ; Skip

	JSRLIB   Disable                   ; SysBase->Disable()

	move.l   a2,a1                     ; LibBase
	move.l   #_LVOReadJoyPort,a0       ; LibFunction
	move.l   PatchMem(pc),d0           ; NewFunction
	JSRLIB   SetFunction               ; SysBase->SetFunction()
	move.l   d0,PatchOldFunc           ; OldFunction
	
	lea.l    PatchStart(pc),a0         ; Source
	move.l   PatchMem(pc),a1           ; Destination
	move.l   #PatchEnd,d0              ; MemSize
	subi.l   #PatchStart,d0            ; MemSize
	subq.l   #1,d0                     ; Size in bytes - 1
.copy
	move.b   (a0)+,(a1)+               ; Copy routine
	dbf      d0,.copy                  ; Continue
	
	JSRLIB   Enable                    ; SysBase->Enable()
	moveq.l  #0,d0                     ; Return Code = NO ERROR
	movem.l  (sp)+,d2-d7/a2-a6         ; Pop
	rts                                ; Exit
.err
	moveq.l  #5,d0                     ; Return Code = ERROR
	movem.l  (sp)+,d2-d7/a2-a6         ; Pop
	rts                                ; Exit

;----------------------------------------------------------

	cnop 0,4

PatchMem:
	dc.l     0
PatchStart:
	bra.b    ReadJoyPort               ; $00
	dc.b     'JOYP'                    ; $02
PatchSize:
	dc.l     0                         ; $06
PatchOldFunc:
	dc.l     0                         ; $0A

;----------------------------------------------------------

	cnop 0,4

ReadJoyPort:
	cmp.w    #0,d0                     ; Port #0
	beq.s    .joy1                     ; 
	cmp.w    #1,d0                     ; Port #1
	beq.s    .joy0                     ; 
.joyX
	move.l   PatchOldFunc(pc),-(sp)    ; Old function
	rts                                ; Return
.joy0
	move.w   $dff220,d0                ; JOY1
	btst     #0,d0                     ; Plugged ?
	beq.s    .joy0                     ; Skip
	lea.l    JOY1MAP(pc),a0            ; JOY1MAP[]
	bsr.s    ReadJoyPortBits           ; Examine
	rts                                ; Return
.joy1
	move.w   $dff222,d0                ; JOY2
	btst     #0,d0                     ; Plugged ?
	beq.s    .joyX                     ; Skip
	lea.l    JOY2MAP(pc),a0            ; JOY2MAP[]
	bsr.s    ReadJoyPortBits           ; Examine
	rts                                ; Return

;----------------------------------------------------------

	cnop 0,4

ReadJoyPortBits:
	movem.l  d1/d2/d3/a0,-(sp)         ; Push
	move.l   d0,d1                     ; JOYxBTN
	move.l   #JP_TYPE_GAMECTLR,d0      ; CD32 Controller type
	moveq.l  #1,d2                     ; Bits 1-to-15
.loop
	btst.l   d2,d1                     ; Get SAGA Bit
	beq.s    .skip                     ; Skip if False
	move.l   (a0,d2.l*4),d3            ; JOYxMAP[i]
	bset.l   d3,d0                     ; Set CD32 Bit
.skip
	addq.l   #1,d2                     ; Next SAGA Bit
	cmpi.l   #15,d2                    ; Last SAGA Bit ?
	ble.s    .loop                     ; Continue
.done
	movem.l  (sp)+,d1/d2/d3/a0         ; Pop
	rts                                ; Return

;----------------------------------------------------------

	cnop 0,4

JOY1MAP:
	dc.l     JPB_BUTTON_PLAY           ; SAGA JOY1 Bit 00 (ignored)
	dc.l     JPB_BUTTON_RED            ; SAGA JOY1 Bit 01
	dc.l     JPB_BUTTON_BLUE           ; SAGA JOY1 Bit 02
	dc.l     JPB_BUTTON_GREEN          ; SAGA JOY1 Bit 03
	dc.l     JPB_BUTTON_YELLOW         ; SAGA JOY1 Bit 04
	dc.l     JPB_BUTTON_REVERSE        ; SAGA JOY1 Bit 05
	dc.l     JPB_BUTTON_FORWARD        ; SAGA JOY1 Bit 06
	dc.l     JPB_BUTTON_REVERSE        ; SAGA JOY1 Bit 07
	dc.l     JPB_BUTTON_FORWARD        ; SAGA JOY1 Bit 08
	dc.l     JPB_BUTTON_PLAY           ; SAGA JOY1 Bit 09
	dc.l     JPB_BUTTON_PLAY           ; SAGA JOY1 Bit 10
	dc.l     JPB_BUTTON_PLAY           ; SAGA JOY1 Bit 11
	dc.l     JPB_JOY_UP                ; SAGA JOY1 Bit 12
	dc.l     JPB_JOY_DOWN              ; SAGA JOY1 Bit 13
	dc.l     JPB_JOY_LEFT              ; SAGA JOY1 Bit 14
	dc.l     JPB_JOY_RIGHT             ; SAGA JOY1 Bit 15

;----------------------------------------------------------

	cnop 0,4

JOY2MAP:
	dc.l     JPB_BUTTON_PLAY           ; SAGA JOY2 Bit 00 (ignored)
	dc.l     JPB_BUTTON_RED            ; SAGA JOY2 Bit 01
	dc.l     JPB_BUTTON_BLUE           ; SAGA JOY2 Bit 02
	dc.l     JPB_BUTTON_GREEN          ; SAGA JOY2 Bit 03
	dc.l     JPB_BUTTON_YELLOW         ; SAGA JOY2 Bit 04
	dc.l     JPB_BUTTON_FORWARD        ; SAGA JOY2 Bit 05
	dc.l     JPB_BUTTON_REVERSE        ; SAGA JOY2 Bit 06
	dc.l     JPB_BUTTON_FORWARD        ; SAGA JOY2 Bit 07
	dc.l     JPB_BUTTON_REVERSE        ; SAGA JOY2 Bit 08
	dc.l     JPB_BUTTON_PLAY           ; SAGA JOY2 Bit 09
	dc.l     JPB_BUTTON_PLAY           ; SAGA JOY2 Bit 10
	dc.l     JPB_BUTTON_PLAY           ; SAGA JOY2 Bit 11
	dc.l     JPB_JOY_UP                ; SAGA JOY2 Bit 12
	dc.l     JPB_JOY_DOWN              ; SAGA JOY2 Bit 13
	dc.l     JPB_JOY_LEFT              ; SAGA JOY2 Bit 14
	dc.l     JPB_JOY_RIGHT             ; SAGA JOY2 Bit 15

;----------------------------------------------------------

PatchEnd:

LibName:
	dc.b     "lowlevel.library",0

;----------------------------------------------------------

	cnop 0,4
