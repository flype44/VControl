;----------------------------------------------------------

	XDEF     _v_cpu_pcr
	XDEF     _v_cpu_pcr_ess_on
	XDEF     _v_cpu_pcr_ess_off
	XDEF     _v_cpu_pcr_dfp_on
	XDEF     _v_cpu_pcr_dfp_off
	XDEF     _v_cpu_pcr_etu_on
	XDEF     _v_cpu_pcr_etu_off

;----------------------------------------------------------

	include	 exec/funcdef.i
	include	 exec/exec.i
	include	 exec/exec_lib.i
	
;----------------------------------------------------------

	machine  mc68060

;----------------------------------------------------------
	
	cnop 0,4

_v_cpu_pcr:
	movem.l  a5/a6,-(sp)
	move.l   $4.w,a6
	lea.l    .supv(pc),a5
	jsr      _LVOSupervisor(a6)
	movem.l  (sp)+,a5/a6
	rts
.supv:
	movec    pcr,d0
	rte

;----------------------------------------------------------
; PCR: Enable SuperScalar Bit = 1
;----------------------------------------------------------
	
	cnop 0,4

_v_cpu_pcr_ess_on:
	movem.l  a5/a6,-(sp)
	move.l   $4.w,a6
	lea.l    .supv(pc),a5
	jsr      _LVOSupervisor(a6)
	movem.l  (sp)+,a5/a6
	rts
.supv:
	movec    pcr,d0
	bset     #0,d0
	movec    d0,pcr
	movec    pcr,d0
	rte

;----------------------------------------------------------
; PCR: Enable SuperScalar Bit = 0
;----------------------------------------------------------

	cnop 0,4

_v_cpu_pcr_ess_off:
	movem.l  a5/a6,-(sp)
	move.l   $4.w,a6
	lea.l    .supv(pc),a5
	jsr      _LVOSupervisor(a6)
	movem.l  (sp)+,a5/a6
	rts
.supv:
	movec    pcr,d0
	bclr     #0,d0
	movec    d0,pcr
	movec    pcr,d0
	rte

;----------------------------------------------------------
; PCR: Disable Floating Point = 1
;----------------------------------------------------------

	cnop 0,4

_v_cpu_pcr_dfp_on:
	movem.l  a5/a6,-(sp)
	move.l   $4.w,a6
	lea.l    .supv(pc),a5
	jsr      _LVOSupervisor(a6)
	movem.l  (sp)+,a5/a6
	rts
.supv:
	movec    pcr,d0
	bset     #1,d0
	movec    d0,pcr
	movec    pcr,d0
	rte

;----------------------------------------------------------
; PCR: Disable Floating Point = 0
;----------------------------------------------------------

	cnop 0,4

_v_cpu_pcr_dfp_off:
	movem.l  a5/a6,-(sp)
	move.l   $4.w,a6
	lea.l    .supv(pc),a5
	jsr      _LVOSupervisor(a6)
	movem.l  (sp)+,a5/a6
	rts
.supv:
	movec    pcr,d0
	bclr     #1,d0
	movec    d0,pcr
	movec    pcr,d0
	rte

;----------------------------------------------------------
; PCR: Enable Turtle Bit = 1
;----------------------------------------------------------

	cnop 0,4

_v_cpu_pcr_etu_on:
	movem.l  a5/a6,-(sp)
	move.l   $4.w,a6
	lea.l    .supv(pc),a5
	jsr      _LVOSupervisor(a6)
	movem.l  (sp)+,a5/a6
	rts
.supv:
	movec    pcr,d0
	bset     #7,d0
	movec    d0,pcr
	movec    pcr,d0
	rte

;----------------------------------------------------------
; PCR: Enable Turtle Bit = 0
;----------------------------------------------------------

	cnop 0,4

_v_cpu_pcr_etu_off:
	movem.l  a5/a6,-(sp)
	move.l   $4.w,a6
	lea.l    .supv(pc),a5
	jsr      _LVOSupervisor(a6)
	movem.l  (sp)+,a5/a6
	rts
.supv:
	movec    pcr,d0
	bclr     #7,d0
	movec    d0,pcr
	movec    pcr,d0
	rte

;----------------------------------------------------------

	cnop 0,4
