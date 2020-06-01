;----------------------------------------------------------

	XDEF     _v_maprom

;----------------------------------------------------------

	machine  mc68000

;----------------------------------------------------------

ROMSTART1    EQU $00E00000            ; Direct ROM 1 Location 
ROMSTART2    EQU $00F80000            ; Direct ROM 2 Location

MAPROMSTART1 EQU $0FF00000            ; Mapped ROM 1 Location
MAPROMSTART2 EQU $0FF80000            ; Mapped ROM 2 Location

;----------------------------------------------------------

	cnop 0,4

_v_maprom:

	move.l   a0,d0                    ; ROM

	clr.l    $4.w                     ; Kill ExecBase

	move.w   #$b00b,$dff3fe           ; MapROM Off
	tst.w    $dff002                  ; Sync

	move.l   d0,a0                    ; ROM Data
	lea.l    MAPROMSTART1,a1          ; MAP Location 1
	move.l   #((1024*512)/4),d1       ; 512 KB / 4
1$	move.l   (a0)+,(a1)+              ; Copy
	subq.l   #1,d1                    ; Next
	bne.s    1$                       ; Continue

	lea.l    MAPROMSTART2,a1          ; MAP Location 2
	move.l   #((1024*512)/4),d1       ; 512 KB / 4
2$	move.l   (a0)+,(a1)+              ; Copy
	subq.l   #1,d1                    ; Next
	bne.s    2$                       ; Continue

	move.l   d0,a0                    ; ROM Data
	lea.l    ROMSTART1,a1             ; ROM Location 1
	move.l   #((1024*512)/4),d1       ; 512 KB / 4
3$	move.l   (a0)+,(a1)+              ; Copy
	subq.l   #1,d1                    ; Next
	bne.s    3$                       ; Continue

	lea.l    ROMSTART2,a1             ; ROM Location 2
	move.l   #((1024*512)/4),d1       ; 512 KB / 4
4$	move.l   (a0)+,(a1)+              ; Copy
	subq.l   #1,d1                    ; Next
	bne.s    4$                       ; Continue

	move.w   #$0001,$dff3fe           ; MapROM On
	tst.w    $dff002                  ; Sync

	lea.l    $01000000,a0             ; End of ROM
	sub.l    -$14(a0),a0              ; End of ROM - ROMSize = PC
	move.l   4(a0),a0                 ; Get Initial Program Counter
	subq.l   #2,a0                    ; Now points to second RESET
	reset                             ; First RESET instruction
	jmp      (a0)                     ; CPU Prefetch executes this

;----------------------------------------------------------

	cnop 0,4
