;----------------------------------------------------------

	XDEF     _v_read_serialnumber
	XDEF     _v_read_revisionstring
	XDEF     _v_read_flashidentifier

;----------------------------------------------------------

	machine  mc68020

;----------------------------------------------------------

VBOARD_V600  EQU $01
VBOARD_V500  EQU $02
VBOARD_V4    EQU $03
VBOARD_V666  EQU $04
VBOARD_V4SA  EQU $05
VBOARD_V1200 EQU $06
VBOARD_V4000 EQU $07
VBOARD_VCD32 EQU $08

;----------------------------------------------------------

VMAGIC       EQU $56616D70  ; Ascii "Vamp"

VREG_SPI_W   EQU $00DFF1F8  ; 32-bits SPI Write
VREG_SPI_R   EQU $00DFF1FA  ; 32-bits SPI Read
VREG_SN_LO   EQU $00DFF3F0  ; 64-bits Serial Lo (V4)
VREG_SN_HI   EQU $00DFF3F4  ; 64-bits Serial Hi (V4)
VREG_BOARD   EQU $00DFF3FC  ; 16-bits Model + xFreq

FLASH_MAGIC  EQU $42420000  ; Flash SPI interface
FLASH_CS     EQU $1         ; 
FLASH_CSn    EQU $0         ; 
FLASH_CLK    EQU $2         ; 
FLASH_CLKn   EQU $0         ; 
FLASH_MOSI   EQU $4         ; 

;----------------------------------------------------------

	cnop 0,4

flash_read:
	lsl.l    #8,d1
	move.b   #3,d1
	bsr.b    flash_byte
	rol.l    #8,d1
	bsr.b    flash_byte
	rol.l    #8,d1
	bsr.b    flash_byte
	rol.l    #8,d1
	bsr.b    flash_byte
	subq     #1,d3
	move.l   d3,d4
	swap     d4
.loop2
.loop1
	bsr.b    flash_byte
	move.b   d0,(a2)+
	dbra     d3,.loop1
	dbra     d4,.loop2
	bsr.b    flash_deselect
	rts

;----------------------------------------------------------

	cnop 0,4

flash_select:
	move.l   #FLASH_MAGIC+FLASH_CSn+FLASH_CLKn,d0
	move.l   d0,VREG_SPI_W
	rts

;----------------------------------------------------------

	cnop 0,4

flash_deselect:
	move.l   #FLASH_MAGIC+FLASH_CS+FLASH_CLK,d3
	move.l   d3,VREG_SPI_W
	rts

;----------------------------------------------------------

	cnop 0,4

flash_byte:
	moveq.l  #7,d2
	bsr      flash_select
.loop
	lsl.b    #1,d1
	scs.b    d0
	andi.w   #FLASH_MOSI,d0
	move.l   d0,VREG_SPI_W
	ori.w    #FLASH_CLK,d0
	move.l   d0,VREG_SPI_W
	or.w     VREG_SPI_R,d1
	dbra     d2,.loop
	move.b   d1,d0
	rts

;----------------------------------------------------------

	cnop 0,4

v_read_sn_v3:
	move.b   #$5A,d1
	bsr.b    flash_byte
	clr.w    d1
	bsr.b    flash_byte
	clr.w    d1
	bsr.b    flash_byte
	move.b   #$F8,d1
	bsr.b    flash_byte
	bsr.b    flash_byte
	bsr.b    flash_byte
	lsl.l    #8,d1
	bsr.b    flash_byte
	lsl.l    #8,d1
	bsr.b    flash_byte
	lsl.l    #8,d1
	bsr.b    flash_byte
	move.l   d1,d3
	bsr.b    flash_byte
	lsl.l    #8,d1
	bsr.b    flash_byte
	lsl.l    #8,d1
	bsr.b    flash_byte
	lsl.l    #8,d1
	bsr.b    flash_byte
	move.l   d3,d0
	bsr.b    flash_deselect
	rts

;----------------------------------------------------------

	cnop 0,4

v_read_sn_v4:
	move.l   VREG_SN_LO,d0
	move.l   VREG_SN_HI,d1
	rts

;----------------------------------------------------------

	cnop 0,4

_v_read_serialnumber:

	; uint8_t _v_read_sn(uint8_t *buffer[18])
	; D0                          A0
	; 
	; note:
	; the provided buffer must be 18-bytes length, and
	; should be initialized with "0000000000000000-0".

	movem.l  d2-d7,-(sp)            ; Push

	tst.l    a0                     ; is null ?
	beq.w    .err                   ; exit if null

	move.w   VREG_BOARD,d0          ; get vampire model
	lsr.w    #8,d0                  ; upper byte
	tst.b    d0                     ; is zero ?
	beq.w    .err                   ; exit if zero

	cmp.b    #VBOARD_V500,d0
	beq.s    .v3

	cmp.b    #VBOARD_V600,d0
	beq.s    .v3

	cmp.b    #VBOARD_V1200,d0
	beq.s    .v3
	
	cmp.b    #VBOARD_V4,d0
	beq.s    .v4

	cmp.b    #VBOARD_V4SA,d0
	beq.s    .v4

	cmp.b    #VBOARD_V666,d0
	beq.s    .v4
	
	bra.w    .err

.v3
	bsr      v_read_sn_v3           ; read serial into d0.l/d1.l
	bra.s    .l0                    ; format the result

.v4
	bsr      v_read_sn_v4           ; read serial into d0.l/d1.l

.l0
	clr.l    d7                     ; checksum
	add.l    #16,a0                 ; end of string
	moveq.l  #1,d6

.l1
	move.l   d1,d2
	andi.l   #$88888888,d2
	lsr.l    #3,d2
	move.l   d1,d3
	andi.l   #$44444444,d3
	lsr.l    #2,d3
	move.l   d1,d4
	andi.l   #$22222222,d4
	lsr.l    #1,d4
	or.l     d3,d4
	and.l    d2,d4
	mulu.l   #7,d4
	moveq.l  #3,d5

.l2
	unpk     d1,d3,#$3030
	unpk     d4,d2,#0
	add.w    d3,d2
	add.b    d3,d7
	lsr.w    #8,d3
	add.b    d3,d7
	move.w   d2,-(a0)               ; XXXXXXXXXXXXXXXX-0
	lsr.l    #8,d1
	lsr.l    #8,d4
	dbra     d5,.l2
	move.l   d0,d1
	dbra     d6,.l1
	andi.b   #$f,d7
	subi.b   #10,d7
	sge      d6
	andi.b   #$07,d6
	addi.b   #$3A,d7
	add.b    d6,d7
	
	move.b   #'-',16(a0)            ; Checksum into X
	move.b   d7,16+1(a0)            ; 0000000000000000-X
	move.b   #0,16+2(a0)            ; Terminate string
	
	movem.l  (sp)+,d2-d7            ; Pop
	moveq.l  #1,d0                  ; Success
	rts

.err
	movem.l  (sp)+,d2-d7            ; Pop
	moveq.l  #0,d0                  ; Error
	rts

;----------------------------------------------------------

	cnop 0,4

_v_read_flashidentifier:
	move.b   #$AB,d1
	bsr      flash_byte
	bsr      flash_byte
	bsr      flash_byte
	bsr      flash_byte
	bsr      flash_byte
	bsr      flash_deselect
	rts

;----------------------------------------------------------

	cnop 0,4

_v_read_revisionstring:
	moveq.l  #0,d5
	moveq.l  #31,d6
.loop
	move.l   a0,a2
	move.l   d5,d1
	move.l   #256,d3
	bsr      flash_read
	addi.l   #65536,d5
	cmpi.l   #VMAGIC,(a0)
	dbeq     d6,.loop
	moveq.l  #1,d0
	rts

;----------------------------------------------------------

	cnop 0,4

