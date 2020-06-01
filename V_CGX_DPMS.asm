;----------------------------------------------------------

	XDEF     _v_cgx_dpms_set

;----------------------------------------------------------

	include	 exec/funcdef.i
	include	 exec/exec.i
	include	 exec/exec_lib.i
	include	 exec/exec.i
	include	 exec/exec_lib.i
	include	 graphics/gfxbase.i
	include	 graphics/view.i

;----------------------------------------------------------


; void CVideoCtrlTagList(struct ViewPort *, struct TagItem *)
;                        A0                 A1

_LVOCVideoCtrlTagList EQU -162

;----------------------------------------------------------
	
	cnop 0,4

_v_cgx_dpms_set:

	movem.l  d2/d3/a2/a6,-(sp)         ; push

	moveq.l  #0,d2                     ; result
	move.l   d0,d3                     ; dpms mode

	move.l   $4.w,a6                   ; sys base
	lea.l    _GFXName(pc),a1           ; gfx name
	moveq.l  #0,d0                     ; gfx version
	jsr      _LVOOpenLibrary(a6)       ; gfx open
	tst.l    d0                        ; gfx ok ?
	beq.s    .exit                     ; gfx fail
	move.l   d0,a1                     ; gfx base
	move.l   d0,a2                     ; gfx base
	move.l   gb_ActiView(a2),a2        ; gfx base -> actiview
	move.l   v_ViewPort(a2),a2         ; gfx base -> actiview -> viewport
	jsr      _LVOCloseLibrary(a6)      ; gfx close

	lea.l    _CGXName(pc),a1           ; cgx name
	moveq.l  #0,d0                     ; cgx version
	jsr      _LVOOpenLibrary(a6)       ; cgx open
	tst.l    d0                        ; cgx ok ?
	beq.s    .exit                     ; cgx fail
	move.l   d0,a6                     ; cgx base
	move.l   a2,a0                     ; gfx viewport
	lea.l    _CVideoCtrlTagList(pc),a1 ; cgx taglist
	move.l   d3,4(a1)                  ; cgx dpms mode
	jsr      _LVOCVideoCtrlTagList(a6) ; cgx video control
	moveq.l  #1,d2                     ; result

	move.l   a6,a1                     ; cgx base
	move.l   $4.w,a6                   ; sys base
	jsr      _LVOCloseLibrary(a6)      ; cgx close

.exit
	move.l   d2,d0                     ; result
	movem.l  (sp)+,d2/d3/a2/a6         ; pop
	rts                                ; exit

;----------------------------------------------------------

	cnop 0,4

_CVideoCtrlTagList:
	dc.l $88002001,0 ; DPMS Level
	dc.l $00000000,0 ; TAG Done

_GFXName:
	dc.b "graphics.library",0

_CGXName:
	dc.b "cybergraphics.library",0

	cnop 0,4

;----------------------------------------------------------
