;----------------------------------------------------------

	XDEF    _v_cpu_cacr
	XDEF    _v_cpu_cacr_dcache_on
	XDEF    _v_cpu_cacr_dcache_off
	XDEF    _v_cpu_cacr_icache_on
	XDEF    _v_cpu_cacr_icache_off

;----------------------------------------------------------

	include	 exec/funcdef.i
	include	 exec/exec.i
	include	 exec/exec_lib.i
	
;----------------------------------------------------------

	machine  mc68020

;----------------------------------------------------------

	cnop 0,4

_v_cpu_cacr:
	movem.l  a5/a6,-(sp)
	move.l   $4.w,a6
	lea.l    .supv(pc),a5
	jsr      _LVOSupervisor(a6)
	movem.l  (sp)+,a5/a6
	rts
.supv:
	movec    cacr,d0
	rte

;----------------------------------------------------------
	
	cnop 0,4

_v_cpu_cacr_dcache_on:
	movem.l  a5/a6,-(sp)
	move.l   $4.w,a6
	lea.l    .supv(pc),a5
	jsr      _LVOSupervisor(a6)
	movem.l  (sp)+,a5/a6
	rts
.supv:
	movec    cacr,d0
	bset     #31,d0
	movec    d0,cacr
	movec    cacr,d0
	rte

;----------------------------------------------------------

	cnop 0,4

_v_cpu_cacr_dcache_off:
	movem.l  a5/a6,-(sp)
	move.l   $4.w,a6
	lea.l    .supv(pc),a5
	jsr      _LVOSupervisor(a6)
	movem.l  (sp)+,a5/a6
	rts
.supv:
	movec    cacr,d0
	bclr     #31,d0
	movec    d0,cacr
	movec    cacr,d0
	rte

;----------------------------------------------------------

	cnop 0,4

_v_cpu_cacr_icache_on:
	movem.l  a5/a6,-(sp)
	move.l   $4.w,a6
	lea.l    .supv(pc),a5
	jsr      _LVOSupervisor(a6)
	movem.l  (sp)+,a5/a6
	rts
.supv:
	movec    cacr,d0
	bset     #15,d0
	movec    d0,cacr
	movec    cacr,d0
	rte

;----------------------------------------------------------

	cnop 0,4

_v_cpu_cacr_icache_off:
	movem.l  a5/a6,-(sp)
	move.l   $4.w,a6
	lea.l    .supv(pc),a5
	jsr      _LVOSupervisor(a6)
	movem.l  (sp)+,a5/a6
	rts
.supv:
	movec    cacr,d0
	bclr     #15,d0
	movec    d0,cacr
	movec    cacr,d0
	rte

;----------------------------------------------------------

	cnop 0,4

