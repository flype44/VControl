;----------------------------------------------------------

	XDEF	_v_cpu_is080

;----------------------------------------------------------

	include	exec/funcdef.i
	include	exec/exec.i
	include	exec/exec_lib.i

;----------------------------------------------------------

	machine	mc68060

;----------------------------------------------------------

IllegalInstructionVector EQU $10

	cnop 0,4

_v_cpu_is080:
	movem.l d1-a6,-(sp)
	move.l  $4.w,a6
	move.w  AttnFlags(a6),d0
	and.w   #AFF_68010|AFF_68020|AFF_68030|AFF_68040,d0
	beq.s   .fail
	jsr     _LVODisable(a6)
	lea.l   .check(pc),a5
	jsr     _LVOSupervisor(a6)
	jsr     _LVOEnable(a6)
	cmp.w   #$0440,d0
	bne.s   .fail
	moveq.l #1,d0
	bra.s   .done
.fail
	moveq.l #0,d0
.done
	movem.l (sp)+,d1-a6
	rts
.check
	movec   VBR,a0
	lea.l   .trapcatch(pc),a1
	move.l  IllegalInstructionVector(a0),a5
	move.l  a1,IllegalInstructionVector(a0)
	moveq.l #0,d0
	movec   PCR,d0
	swap    d0
	move.l  a5,IllegalInstructionVector(a0)
	rte
.trapcatch
	addq.l  #4,2(sp)
	nop
	rte

;----------------------------------------------------------
