; ---------------------------------------------------------------------------
; Subroutine to remember whether an object is destroyed/collected
; ---------------------------------------------------------------------------

MarkObjGone:
RememberState:
Sprite_OnScreen_Test:
		move.w	x_pos(a0),d0

Sprite_OnScreen_Test2:
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.offscreen:
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

MarkObjGone_Collision:
RememberState_Collision:
Sprite_CheckDeleteTouch3:
Sprite_OnScreen_Test_Collision:
		move.w	x_pos(a0),d0

.skipxpos:
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		jsr	(Add_SpriteToCollisionResponseList).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.offscreen:
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

Delete_Sprite_If_Not_In_Range:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		rts
; ---------------------------------------------------------------------------

.offscreen:
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

Sprite_CheckDelete:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.offscreen:
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		bset	#7,status(a0)
		move.l	#Delete_Current_Sprite,address(a0)
		rts

; =============== S U B R O U T I N E =======================================

Sprite_CheckDelete2:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.offscreen:
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		bset	#4,$38(a0)
		move.l	#Delete_Current_Sprite,address(a0)

.return:
		rts

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteXY:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_FlickerMove:
		bsr.w	MoveSprite
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite_3
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite_3
		bchg	#6,$38(a0)
		beq.s	Sprite_CheckDelete2.return
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteTouch:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Sprite_CheckDelete.offscreen
		jsr	(Add_SpriteToCollisionResponseList).w
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteTouch2:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Sprite_CheckDelete2.offscreen
		jsr	(Add_SpriteToCollisionResponseList).w
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteTouchXY:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		jsr	(Add_SpriteToCollisionResponseList).w
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteSlotted:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	Go_Delete_SpriteSlotted
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Go_Delete_SpriteSlotted:
		move.w	respawn_addr(a0),d0
		beq.s	Go_Delete_SpriteSlotted2
		movea.w	d0,a2
		bclr	#7,(a2)

Go_Delete_SpriteSlotted2:
		move.l	#Delete_Current_Sprite,address(a0)
		bset	#7,status(a0)

Remove_From_TrackingSlot:
		move.b	$3B(a0),d0
		movea.w	$3C(a0),a1
		bclr	d0,(a1)
		rts

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteTouchSlotted:
		tst.b	status(a0)
		bmi.s	Go_Delete_SpriteSlotted3
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	Go_Delete_SpriteSlotted
		jsr	(Add_SpriteToCollisionResponseList).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Go_Delete_SpriteSlotted3:
		move.l	#Delete_Current_Sprite,address(a0)
		bra.s	Remove_From_TrackingSlot

; =============== S U B R O U T I N E =======================================

Obj_WaitOffscreen:
		move.l	#Map_Offscreen,mappings(a0)
		bset	#2,render_flags(a0)
		move.b	#64/2,width_pixels(a0)
		move.b	#64/2,height_pixels(a0)
		move.l	(sp)+,$34(a0)
		move.l	#+,address(a0)
+		tst.b	render_flags(a0)
		bmi.s	+
		jmp	Sprite_OnScreen_Test(pc)
; ---------------------------------------------------------------------------
+		move.l	$34(a0),address(a0)			; Restore normal object operation when onscreen
		rts
; ---------------------------------------------------------------------------
Map_Offscreen:	dc.w Map_Offscreen-Map_Offscreen
