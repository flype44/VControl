;----------------------------------------------------------

	XDEF     _v_cpu_is2p

;----------------------------------------------------------

	include	 exec/funcdef.i
	include	 exec/exec.i
	include	 exec/exec_lib.i

;----------------------------------------------------------

	machine  mc68060

	cnop 0,4

_v_cpu_is2p:

	movem.l  d2-d7/a5-a6,-(sp)

	clr.l    d0
	
	move.l   $4.w,a6
	jsr      _LVODisable(a6)
	jsr      _LVOForbid(a6)

	lea.l    .pcr_get(pc),a5
	jsr      _LVOSupervisor(a6)
	
	lea.l    .pcr_1p(pc),a5
	jsr      _LVOSupervisor(a6)
	bsr      benchmark
	move.l   d0,d2

	lea.l    .pcr_2p(pc),a5
	jsr      _LVOSupervisor(a6)
	bsr      benchmark
	move.l   d0,d3

	lea.l    .pcr_set(pc),a5
	jsr      _LVOSupervisor(a6)

	jsr      _LVOPermit(a6)
	jsr      _LVOEnable(a6)

	move.l   d2,d0
	mulu.l   #100,d0
	divu.l   d3,d0
	cmp.l    #125,d0
	sgt      d0
	and.l    #1,d0

	movem.l	 (sp)+,d2-d7/a5-a6
	rts

;----------------------------------------------------------

.pcr_get
	movec    pcr,d7
	rte

.pcr_set
	movec    d7,pcr
	rte

.pcr_1p
	move.l   d7,d0
	bclr     #0,d0
	movec    d0,pcr
	rte

.pcr_2p
	move.l   d7,d0
	bset     #0,d0
	movec    d0,pcr
	rte

;----------------------------------------------------------

	cnop 0,4

benchmark:
	movem.l  d2-d7,-(sp)
	dc.w     $4e7a,$7809
	move.l   #32000,d6
1$	and.l    #$7fff,d2
	add.l    #$7fff,d5
	eor.l    #$7fff,d4
	sub.l    #$7fff,d1
	dbf      d6,1$
	dc.w     $4e7a,$0809
	sub.l    d7,d0
	movem.l  (sp)+,d2-d7
	rts

;----------------------------------------------------------

	cnop 0,4
