;----------------------------------------------------------

	XDEF     _v_cpu_vbr
	XDEF     _v_cpu_vbr_on
	XDEF     _v_cpu_vbr_off
	XDEF     _v_cpu_vbr_move

;----------------------------------------------------------

	include	 exec/funcdef.i
	include	 exec/exec.i
	include	 exec/exec_lib.i
	
;----------------------------------------------------------

VBR_SIZE     EQU $100
VBR_FLAGS    EQU MEMF_FAST ; !MEMF_REVERSE
VBR_OWNER    EQU $56425243 ; 'VBRC' compatible with VBRControl.

;----------------------------------------------------------

	machine  mc68010

;----------------------------------------------------------
	
	cnop 0,4

_v_cpu_vbr:
	movem.l  a5/a6,-(sp)                 ; Store registers
	moveq.l  #0,d0                       ; Result
	move.l   $4.w,a6                     ; SysBase
	btst     #AFB_68010,AttnFlags+1(a6)  ; Check if 68010+
	beq.s    .exit                       ; Else, skip
	lea.l    .super(pc),a5               ; Code
	jsr      _LVOSupervisor(a6)          ; Supervisor(code)
.exit
	movem.l  (sp)+,a5/a6                 ; Restore registers
	RTS                                  ; Return
.super:
	movec    VBR,d0                      ; Get VBR address
	RTE                                  ; Return Exception

;----------------------------------------------------------

	cnop 0,4

_v_cpu_vbr_off:
	movem.l	 d7/a6,-(sp)                 ; Store registers
	clr.l    d0                          ; Reset result
.check
	bsr.s    _v_cpu_vbr                  ; Get VBR address
	move.l   d0,d7                       ; Store address
	tst.l    d0                          ; Check address
	beq.s    .done                       ; Skip install
.install
	move.l   d7,a0                       ; Source
	sub.l    a1,a1                       ; Destination
	bsr.s    _v_cpu_vbr_move             ; Change VBR location
.unalloc
	move.l   d7,a1                       ; Source
	subq.w   #4,a1                       ; Source - 4
	cmp.l    #VBR_OWNER,(a1)             ; Is it our MARKER ?
	bne.s    .done                       ; Skip
	move.l   $4.w,a6                     ; SysBase
	jsr      _LVOFreeVec(a6)             ; FreeVec(mem)
	moveq.l  #1,d0                       ; Success
.done
	movem.l  (sp)+,d7/a6                 ; Restore registers
	RTS                                  ; Return

;----------------------------------------------------------

	cnop 0,4

_v_cpu_vbr_on:
	movem.l	 d7/a6,-(sp)                 ; Store registers
	clr.l    d0                          ; Reset result
.check
	bsr.s    _v_cpu_vbr                  ; Get VBR address
	move.l   d0,d7                       ; Store address
	tst.l    d0                          ; Check address
	beq.s    .alloc                      ; 
	bra.s    .done                       ; Skip install
.alloc
	move.l   #VBR_SIZE+4,d0              ; Mem Size
	move.l   #VBR_FLAGS,d1               ; Mem Flags
	move.l   $4.w,a6                     ; SysBase
	jsr      _LVOAllocVec(a6)            ; AllocVec(size, flags)
	tst.l    d0                          ; Is NULL ?
	beq.s    .done                       ; Exit on error
.install
	move.l   d7,a0                       ; Source
	move.l   d0,a1                       ; Destination
	move.l   #VBR_OWNER,(a1)+            ; Add our MARKER
	bsr.s    _v_cpu_vbr_move             ; Change VBR location
	moveq.l  #1,d0                       ; Success
.done
	movem.l  (sp)+,d7/a6                 ; Restore registers
	RTS                                  ; Return

;----------------------------------------------------------

	cnop 0,4

_v_cpu_vbr_move:
	movem.l	 a4/a5/a6,-(sp)              ; Store registers
.init
	move.l   $4.w,a6                     ; SysBase
	move.l   a1,a4                       ; Store destination
	jsr      _LVODisable(a6)             ; Disable multitasking
	jsr      _LVOForbid(a6)              ; Disable multitasking
	moveq.l  #32-1,d0                    ; Number of iterations
.copy
	move.l   (a0)+,(a1)+                 ; Copy 32 bits
	move.l   (a0)+,(a1)+                 ; Copy 32 bits
	dbf      d0,.copy                    ; Continue
.update
	lea.l    .super(PC),a5               ; Code
	jsr      _LVOSupervisor(a6)          ; Supervisor(code)
	jsr      _LVOPermit(a6)              ; Enable multitasking
	jsr      _LVOEnable(a6)              ; Enable multitasking
.done
	movem.l  (sp)+,a4/a5/a6              ; Restore registers
	RTS                                  ; Return
.super
	movec    a4,VBR                      ; Write VBR
	RTE                                  ; Return Exception

;----------------------------------------------------------

	cnop 0,4
