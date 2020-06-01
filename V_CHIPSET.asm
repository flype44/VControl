;----------------------------------------------------------
	
	XDEF    _v_chipset_akiko
	XDEF    _v_chipset_audio_rev
	XDEF    _v_chipset_video_rev

;----------------------------------------------------------

	include	exec/funcdef.i
	include	exec/exec.i
	include	exec/exec_lib.i

;----------------------------------------------------------

gb_ChunkyToPlanarPtr EQU 508 ; gfxbase v40

;----------------------------------------------------------

	cnop 0,4

_v_chipset_audio_rev:
	;
	; Detect audio-out chip revision 
	; using the POTINP register.
	; 
	lea.l   $dff000,a0
	move.w  $16(a0),d0
	andi.l  #%11111110,d0
	lsr.l   #1,d0
	rts

;----------------------------------------------------------

	cnop 0,4

_v_chipset_video_rev:
	;
	; Detect video-out chip revision 
	; using the DENISEID register.
	; 
	; The original Denise (8362) does 
	; not have this register, so whatever 
	; value is left over on the bus from 
	; the last cycle will be there.
	; 
	movem.l d1/d2/a0,-(sp)
	lea.l   $dff000,a0
	move.w  $7c(a0),d0
	and.w   #$ff,d0
	moveq.l #31-1,d2
.loop
	move.w  $7c(a0),d1
	and.w   #$ff,d1
	cmp.b   d0,d1
	bne.s   .ocs
	dbf     d2,.loop
	or.b    #$f0,d0
	cmp.b   #$f8,d0
	bne.s   .ecs
	moveq.l #2,d0 ; AGA Alice (4203)
	bra.s   .done
.ecs
	moveq.l #1,d0 ; ECS Denise (8373)
	bra.s   .done
.ocs
	moveq.l #0,d0 ; OCS Denise (8362)
.done
	movem.l (sp)+,d1/d2/a0
	rts

;----------------------------------------------------------

	cnop 0,4

_v_chipset_akiko:
	;
	; Detect AKIKO presence 
	; Check graphics V40
	; Set graphics -> C2P address
	; 
	movem.l a6,-(sp)                           ; push
	cmpi.w  #$CAFE,$B80002                     ; akiko id value
	bne.s   .failure                           ; akiko detected ?
	lea.l   GfxName(pc),a1                     ; name
	moveq.l #40,d0                             ; version
	move.l  $4.w,a6                            ; sysbase
	jsr     _LVOOpenLibrary(a6)                ; openlib(a1,d0)
	tst.l   d0                                 ; success ?
	beq.s   .failure                           ; skip if < v40
	move.l  d0,a1                              ; gfxbase
	move.l  #$B80038,gb_ChunkyToPlanarPtr(a1)  ; akiko c2p address
	jsr     _LVOCloseLibrary(a6)               ; closelib(a1)
	moveq.l #1,d0                              ; success
	movem.l (sp)+,a6                           ; pop
	rts                                        ; return
.failure
	moveq.l #0,d0                              ; error
	movem.l (sp)+,a6                           ; pop
	rts                                        ; return

	cnop 0,4

GfxName:
	dc.b "graphics.library",0

	cnop 0,4

;----------------------------------------------------------
