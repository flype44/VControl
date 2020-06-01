;----------------------------------------------------------
	
	XDEF     _v_fpu_isok
	XDEF     _v_fpu_toggle

;----------------------------------------------------------

	include	 exec/funcdef.i
	include	 exec/exec.i
	include	 exec/exec_lib.i
	include  exec/execbase.i

;----------------------------------------------------------

	machine  mc68040

;----------------------------------------------------------

	cnop 0,4

_v_fpu_isok:
	; 
	; If the fpu is disabled in the apollo-core, then the fmoves 
	; will still works, but not the arithmetics fpu instructions.
	; For example, FADD wont trap, but result will be null value.
	; 
	; Output:
	; D0 = 0 means FPU is disabled.
	; D0 = 1 means FPU is enabled.
	; 
.init
	moveq.l  #0,d0                  ; Default is False
	move.l   $4.w,a0                ; ExecBase
	move.w   AttnFlags(a0),d1       ; ExecBase->AttnFlags
.881
	btst     #AFB_68881,d1          ; AttnFlags & 68881 ?
	bne.s    .test                  ; 
.882
	btst     #AFB_68882,d1          ; AttnFlags & 68882 ?
	bne.s    .test                  ; 
.040
	btst     #AFB_FPU40,d1          ; AttnFlags & FPU40 ?
	beq.s    .exit                  ; 
.test
	moveq.l  #1,d0                  ;  d0 = 1
	fmove.l  d0,fp0                 ; fp0 = 1
	fadd.x   fp0,fp0                ; fp0 = 2
	fmove.l  fp0,d0                 ;  d0 = 2
	tst.l    d0                     ;  d0 is NULL ?
	sne      d0                     ; To Bool
	and.l    #1,d0                  ; True or False
.exit
	rts

;----------------------------------------------------------

VS_FPUENABLE  EQU 1
VS_FPUDISABLE EQU 2
VS_FPUControl EQU -6

	cnop 0,4

_v_fpu_toggle:
	; 
	; Switch FPU off using vampiresupport.resource
	;
	; Input:
	; D0 = 1 means Enable FPU.
	; D0 = 2 means Disable FPU.
	; 
	; Output:
	; D0 = 0 means Failure.
	; D0 = 1 means Success.
	; 
	movem.l  d2/a6,-(sp)            ; Push
	move.l   d0,d2                  ; Input
	move.l   4.w,a6                 ; ExecBase
	lea.l    .name(pc),a1           ; Name
	jsr      _LVOOpenResource(a6)   ; OpenResource(name)
	tst.l    d0                     ; Success ?
	beq.s    .failure               ; Skip on error
	move.l   d0,a6                  ; VSBase
	move.l   d2,d0                  ; State
	jsr      VS_FPUControl(a6)      ; VSBase->FPUControl(State)
	moveq.l  #1,d0                  ; Return Code
	bra.s    .success               ; Skip
.failure
	moveq.l  #0,d0                  ; Return Code
.success
	movem.l  (sp)+,d2/a6            ; Pop
	rts                             ; Return
.name
	dc.b     "vampiresupport.resource",0

;----------------------------------------------------------

	cnop 0,4

