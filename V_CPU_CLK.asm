;----------------------------------------------------------

	XDEF     _v_cpu_multiplier

;----------------------------------------------------------

	include  exec/funcdef.i
	include  exec/exec.i
	include  exec/exec_lib.i
	include  dos/dos.i
	include  dos/dos_lib.i
	include  devices/timer.i

;----------------------------------------------------------

    RSRESET
sid_Clock    rs.l 1
sid_MsgPort  rs.l 1
sid_xFreq    rs.l 1
sid_Running  rs.l 1
sid_SIZE     rs.l 0

;----------------------------------------------------------

	machine  mc68020

;----------------------------------------------------------

	cnop 0,4

_v_cpu_multiplier:
	
	movem.l  d2-d7/a2-a6,-(sp)
	
    lea.l    SoftIntData(pc),a4

    lea.l    DOSName(pc),a1
    moveq.l  #0,d0
    move.l   $4.w,a6
    jsr      _LVOOpenLibrary(a6)
    move.l   d0,a3
    tst.l    d0
    beq.w    .exit

	lea.l    MySoftInt(pc),a0
	lea.l    SoftIntCode(pc),a1
	move.l   a1,IS_CODE(a0)
	lea.l    SoftIntData(pc),a1
	move.l   a1,IS_DATA(a0)
	move.b   #32,LN_PRI(a0)
	jsr      _LVOCreateMsgPort(a6)
	move.l   d0,sid_MsgPort(a4)
	tst.l    d0
	beq.w    .closedos
	
	move.l   d0,a0
	lea.l    MySoftInt(pc),a1
	move.b   #NT_MSGPORT,LN_TYPE(a0)
	move.b   #PA_SOFTINT,MP_FLAGS(a0)
	move.l   a1,MP_SIGTASK(a0)

	lea.l    MyTimeReq(pc),a0
	move.b   #NT_REPLYMSG,LN_TYPE(a0)
	move.w   #IOTV_SIZE,MN_LENGTH(a0)
	move.l   sid_MsgPort(a4),MN_REPLYPORT(a0)

	lea.l    TimerName(pc),a0
	moveq.l  #UNIT_MICROHZ,d0
	lea.l    MyTimeReq(pc),a1
	moveq.l  #0,d1
	jsr      _LVOOpenDevice(a6)
	tst.l    d0
	bne.s    .delport

	move.l   #1,sid_Running(a4)
	lea.l    MyTimeReq(pc),a1
	move.w   #TR_ADDREQUEST,IO_COMMAND(a1) 
	move.l   #1,IOTV_TIME+TV_SECS(a1)
	move.l   #0,IOTV_TIME+TV_MICRO(a1)
	LINKLIB  DEV_BEGINIO,IO_DEVICE(a1)
	dc.w     $4e7a,$0809
	move.l   d0,sid_Clock(a4)
.wait
	tst.l    sid_Running(a4)
	beq.s    .done
	move.l   #10,d1
	move.l   a3,a6
	jsr      _LVODelay(a6)
	bra.s    .wait

.done
	move.l   $4.w,a6
	lea.l    MyTimeReq(pc),a1
	jsr      _LVOCloseDevice(a6)
    
.delport
	move.l   sid_MsgPort(a4),a0
	jsr      _LVODeleteMsgPort(a6)
    
.closedos
	move.l   a3,a1
	jsr      _LVOCloseLibrary(a6)

.exit
	move.l   sid_xFreq(a4),d0
	movem.l  (sp)+,d2-d7/a2-a6
	rts

;----------------------------------------------------------

	cnop 0,4

SoftIntCode:
	move.l   a4,-(sp)
	move.l   a1,a4
	move.l   sid_MsgPort(a4),a0
	move.l   $4.w,a6
	jsr      _LVOGetMsg(a6)
	dc.w     $4e7a,$0809
	sub.l    sid_Clock(a4),d0
	divu.l   ex_EClockFrequency(a6),d0
	divu.l   #10,d0
	move.l   d0,sid_xFreq(a4)
	move.l   #0,sid_Running(a4)
	move.l   (sp)+,a4
	moveq.l  #0,d0
	rts

;----------------------------------------------------------

	cnop 0,4

MySoftInt    ds.b IS_SIZE
MyTimeReq    ds.b IOTV_SIZE
SoftIntData  ds.b sid_SIZE

	cnop 0,4

DOSName      DOSNAME
TimerName    TIMERNAME

	cnop 0,4

;----------------------------------------------------------
