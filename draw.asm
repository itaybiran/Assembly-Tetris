
x equ [word ptr bp + 8] ; x of the pixel
y equ [word ptr bp + 6] ; y of the pixel
color equ [byte ptr bp + 4] ; color of the pixel

;Draws pixel
proc drawPixel
	push bp ;backup
	mov bp, sp
	PushAll ;backup

	mov ah, 0Ch
	mov al, color
	mov cx, x ; 0 <= x <= 319
	mov dx, y ; 0 <= y <= 199
	int 10h ;interrupt to draw a pixel

	PopAll ;backup
	pop bp ;backup
	ret 6
endp drawPixel
	
;=============================================================================================================================================	

color equ [word ptr bp + 4] ; color
		
;Changes the background color to the chosen color
proc backgroundColor
	push bp ;backup
	mov bp, sp

;draws an oblong in the size of the screen and the color we chose:
	add dx, 199
	r:	
		add cx, 319
		co:
			push cx
			push dx
			push color
			call drawPixel ;draws pixel
			dec cx
			cmp cx, 0
		jne co
		dec dx
		cmp dx, 0
	jne r

	pop bp ;backup
	ret 2
endp backgroundColor
	
;=============================================================================================================================================	

;Draws the board of the game
proc BoardDrawer
	push 7h ; קובע את צבע הרקע לאפור
	call backgroundColor ; מגדיר את צבע הרקע
	push 0
	push 0
	push 0
	call drawPixel ;draws pixel in the top left corner
	
	push 58 ;x
	push 0h ; קובע צבע לשחור
	call drawLineX ; מצייר את הקו האנכי הראשון מצד שמאל
	
	push 59 ;x
	push 0h ; קובע צבע לשחור
	call drawLineX ; מצייר את הקו האנכי הראשון מצד שמאל

	push 60 ;x
	push 0ffh ; קובע צבע ללבן
	call drawLineX ; מצייר את הקו האנכי הראשון מצד שמאל
	
	push 160 ;x
	push 0ffh ;קובע צבע ללבן
	call drawLineX ; מצייר את הקו האנכי הראשון מצד ימין
	
	push 161 ;x
	push 0h ; קובע צבע לשחור
	call drawLineX ; ; מצייר את הקו האנכי הראשון מצד ימין
	
	push 162
	push 0h ; קובע צבע לשחור
	call drawLineX ; מצייר את הקו האנכי הראשון מצד ימין

	push 15 ;y
	push 0h ; קובע צבע לשחור
	call drawLineY ; מצייר את הקו האופקי הראשון מלמעלה
	
	push 16 ;y
	push 0h ; קובע צבע לשחור
	call drawLineY ; מצייר את הקו האופקי הראשון מלמעלה
	
	push 4h ; קובע צבע לשחור
	call drawFrame ; מצייר את המסגרת של המסך
	
	push 0 ; x
	push 0 ; y
	push 57 ; length
	push 14 ; width
	push 0E0h ;color
	call drawOblong ; מצייר את הריבוע בצידו השמאלי העליון של המסך

	push 0 ;color
	call Draw_Middle_Oblong ; מצייר את המלבן העליון באמצע המסך

	push 162 ; x
	push 0 ; y
	push 156 ; length
	push 14 ; width
	push 0E0h ;color
	call drawOblong ; מצייר את הריבוע בצידו הימני העליון של המסך
	
	push 0 ; x
	push 16 ; y
	push 57 ; length
	push 181 ; width
	push 0F7h ;color
	call drawOblong ; מצייר את הריבוע בצידו השמאלי התחתון של המסך
	
	push 162 ; x
	push 16 ; y
	push 156 ; length
	push 181 ; width
	push 0F7h ;color
	call drawOblong ; מצייר את הריבוע בצידו הימני התחתון של המסך
	
	push 60
	push 100
	push 17
	push 0ffh ;קובע צבע ללבן
	call drawSmallLineY ; מצייר את הקו הלבן האופקי הראשון בלוח
	
	mov ax, 27 
	; draw the Y lines on the board:
	DOIt:
		push 61
		push 99
		push ax
		push 0ffh ;קובע צבע ללבן
		call drawSmallLineY
		add ax, 10
		cmp ax, 197
	jne DOIt

	mov ax, 70 
	; draw the X lines on the board:
	DOIt2:
		push 18
		push 179
		push ax
		push 0ffh ;קובע צבע ללבן
		call drawSmallLineX
		add ax, 10
		cmp ax, 160
	jne DOIt2
	ret
endp BoardDrawer

;=============================================================================================================================================	
		
color equ [word ptr bp + 4] ;color

; פרוצדורה שמציירת מסגרת למסך בהתאם לצבע שנבחר
proc drawFrame
	push 0 ;x
	push 0 ;color ; מגדיר צבע
	call drawLineX ; מצייר קו אנכי בחלקו הימני של מסגרת המסך
	
	push 319 ;x
	push 0 ;color ; מגדיר צבע
	call drawLineX ; מצייר קו אנכי בחלקו השמאלי של מסגרת המסך
	
	push 0 ;y
	push 0 ;color ; מגדיר צבע
	call drawLineY ; מצייר קו אופקי בחלקו העליון של מסגרת המסך
	
	push 199 ;y
	push 0 ;color ; מגדיר צבע
	call drawLineY ; מצייר קו אופקי בחלקו התחתון של מסגרת המסך
	
	push 198 ;y
	push 0 ;color ; מגדיר צבע
	call drawLineY ; מצייר קו אופקי בחלקו התחתון של מסגרת המסך
	ret 2
endp drawFrame

;=============================================================================================================================================	

;פרוצדורה שמציירת קו אופקי
y equ [word ptr bp + 6] ;y
color equ [word ptr bp + 4] ;color

proc drawLineY
	push bp ;backup
	mov bp, sp
	
	mov cx, 319

	startDrawPixelLoopy:
		push cx ;x
		push y ;y
		push color ;color
		call drawPixel ;draws pixel
		
		cmp cx, 0
		je endLoopy
	loop startDrawPixelLoopy
	
	endLoopy:	
		pop bp ;backup
	ret 4
endp drawLineY
	
;=============================================================================================================================================	
		
x equ [word ptr bp + 6] ;x
color equ [word ptr bp + 4] ;color

;פרוצדורה שמציירת קו אנכי
proc drawLineX
	push bp ;backup
	mov bp, sp
	
	mov cx, 199

	startDrawPixelLoopx:
		push x ;x
		push cx ;y
		push color ;color
		call drawPixel ;draws
		
		cmp cx, 0
		je endLoopx
	loop startDrawPixelLoopx
	
	endLoopx:
		pop bp ;backup
	ret 4
endp drawLineX
	
;=============================================================================================================================================	
		
y1 equ [word ptr bp + 10] ; נקודת התחלה של הקו
long equ [word ptr bp + 8] ; אורך הקו
x equ [word ptr bp + 6] ; שיעור האיקס של הקו
color equ [word ptr bp + 4] ; צבע הקו

;פרוצדורה שמציירת קו אנכי מנקודה לנקודה
proc drawSmallLineX
	push bp ;backup
	mov bp, sp
	
	mov cx, long
	add cx, y1
	
	startDrawPixelLoopx1:
		push x ;x
		push cx ;y
		push color ;color
		call drawPixel ;draws pixel
		
		cmp cx, y1
		je endLoopx1
	loop startDrawPixelLoopx1
	
	endLoopx1:
		pop bp ;backup
	ret 8
endp drawSmallLineX
	
;=============================================================================================================================================		

x1 equ [word ptr bp + 10] ; נקודת התחלה של הקו
long equ [word ptr bp + 8] ; אורך הקו
y equ [word ptr bp + 6] ; שיעור הוואי של הקו
color equ [word ptr bp + 4] ; צבע הקו

;פרוצדורה שמציירת קו אופקי מנקודה לנקודה
proc drawSmallLineY
	push bp ;backup
	mov bp, sp
	
	mov cx, long
	add cx, x1
	
	startDrawPixelLoopy1:
		push cx ;x
		push y ;y
		push color ;color
		call drawPixel ;draws pixel
		
		cmp cx, x1
		je endLoopy1
	loop startDrawPixelLoopy1
	
	endLoopy1:
		pop bp ;backup
	ret 8
endp drawSmallLineY

;=============================================================================================================================================		

x equ [word ptr bp + 10] ;x of the rect
y equ [word ptr bp + 8] ;y of the rect
leng equ [word ptr bp + 6] ;length of the rect
color equ [word ptr bp + 4] ;color of the rect

;Draws Rect
proc drawRect
	push bp ;backup
	mov bp, sp
	
	;draws the rect:
	mov dx, leng
	add dx, y
	rows:	
		mov cx, leng
		add cx, x
		columns:
			push cx ;x
			push dx ;y
			push color ;color
			call drawPixel ;draws pixel
			dec cx
			cmp cx, x ;check if it ended the line
		jne columns ;if it didn't continue
		dec dx 
		cmp dx, y ;check if it ended all the lines
	jne rows ;if it didn't continue
	
	pop bp ;backup
	ret 8
endp drawRect
	
;=============================================================================================================================================		

x equ [word ptr bp + 12] ;x of the oblong
y equ [word ptr bp + 10] ;y of the oblong
OLength equ [word ptr bp + 8] ;length of the oblong
OWidth equ [word ptr bp + 6] ;width of the oblong
color equ [word ptr bp + 4] ;color of the oblong

;פעולה שמציירת מלבן
proc drawOblong
	push bp ;backup
	mov bp, sp
	
	;draws the oblong:
	mov dx, OWidth
	add dx, y
	row:	
		mov cx, OLength
		add cx, x
		column:
			push cx ;x
			push dx ;x
			push color ;color
			call drawPixel ;draws pixel
			dec cx
			cmp cx, x ;check if it ended the line
		jne column ;if it didn't continue
		dec dx
		cmp dx, y ;check if it ended all the lines
	jne row ;if it didn't continue
	
	pop bp ;backup
	ret 10
endp drawOblong
	
;=============================================================================================================================================	
	
x equ [word ptr bp + 8] ;x
y equ [word ptr bp + 6] ;y
color equ [word ptr bp + 4] ;color

;draws a one by one cube - a block - every cube in Tetris is built from 4 of those
proc draw_Small_Cube
	push bp ;backup
	mov bp, sp
	PushAll ;backup
	
	;draws the one by one cube:
	dec x ; חישובים לקראת ציור הקו או הריבוע הבא
	
	push x ;x
	push y ;y
	push 10 ;length
	push color ;color
	call drawRect ;draws rect

	inc y ; חישובים לקראת ציור הקו או הריבוע הבא
	inc x ; חישובים לקראת ציור הקו או הריבוע הבא
	
	push y ; y
	push 9 ; length
	push x ; x
	push [color_Of_Lines] ; color
	call drawSmallLineX ; מצייר קו אנכי לאמצע הקוביה
	
	add x, 10 ; חישובים לקראת ציור הקו או הריבוע הבא

	push y ; y
	push 9 ; length
	push x ; x
	push [color_Of_Lines] ; color
	call drawSmallLineX ; מצייר קו אנכי לאמצע הקוביה
	
	sub x, 10 ; חישובים לקראת ציור הקו או הריבוע הבא
	add y, 9 ; חישובים לקראת ציור הקו או הריבוע הבא

	push x ; x
	push 10 ; length
	push y ; y
	push [color_Of_Lines] ; color
	call drawSmallLineY ; מצייר קו אופקי לקוביה

	PopAll ;backup
	pop bp ;backup
	ret 6
endp draw_Small_Cube
	
;=============================================================================================================================================	
		
x equ [word ptr bp + 6] ;x
y equ [word ptr bp + 4] ;y

;draws a one by one cube background
proc draw_Small_Cube_BackGround
	push bp ;backup
	mov bp, sp
	PushAll ;backup
	
	dec x ; חישובים לקראת ציור הקו או הריבוע הבא
	
	push x ;x
	push y ;y
	push 10 ;length
	push 7 ;color
	call drawRect

	inc x ; חישובים לקראת ציור הקו או הריבוע הבא
	
	push x ; x
	push 10 ; length
	push y ; y
	push 0ffh ;קובע צבע
	call drawSmallLineY ; מצייר קו אופקי לקוביה

	inc y ; חישובים לקראת ציור הקו או הריבוע הב

	push y ; y
	push 9 ; length
	push x ; x
	push 0ffh ;קובע צבע
	call drawSmallLineX ; מצייר קו אנכי לאמצע הקוביה
	
	add x, 10 ; חישובים לקראת ציור הקו או הריבוע הבא

	push y ; y
	push 9 ; length
	push x ; x
	push 0ffh ;קובע צבע
	call drawSmallLineX ; מצייר קו אנכי לאמצע הקוביה
	
	sub x, 10 ; חישובים לקראת ציור הקו או הריבוע הבא
	add y, 9 ; חישובים לקראת ציור הקו או הריבוע הבא

	push x ; x
	push 10 ; length
	push y ; y
	push 0ffh ;קובע צבע
	call drawSmallLineY ; מצייר קו אופקי לקוביה

	PopAll ;backup
	pop bp ;backup
	ret 4
endp draw_Small_Cube_BackGround
	
;=============================================================================================================================================	
		
; Draws one of the cubes according to the color , x and y values of the blocks
proc drawALLCubes

;Block 1:
	;set x of block 1:
	mov ax, [xCube1] 
	add ax, [xCube]
	;set y of block 1:
	mov bx, [yCube1]
	add bx, [yCube]
	
	;draws block 1:
	push ax ;x
	push bx ;y
	push [colorBlock] ;color
	call draw_Small_Cube ;Draws a block

;Block 2:	
	;set x of block 2:
	mov ax, [xCube2]
	add ax, [xCube]
	;set y of block 2:
	mov bx, [yCube2]
	add bx, [yCube]

	;draws block 2:
	push ax ;x
	push bx ;y
	push [colorBlock] ;color
	call draw_Small_Cube ;Draws a block

;Block 3:
	;set x of block 3:
	mov ax, [xCube3]
	add ax, [xCube]
	;set y of block 3:
	mov bx, [yCube3]
	add bx, [yCube]
		
	;draws block 3:
	push ax ;x
	push bx ;y
	push [colorBlock] ;color
	call draw_Small_Cube ;Draws a block
	
;Block 4:
	;set x of block 4:
	mov ax, [xCube4]
	add ax, [xCube]
	;set y of block 4:
	mov bx, [yCube4]
	add bx, [yCube]
		
	;draws block 4:
	push ax ;x
	push bx ;y
	push [colorBlock] ;color
	call draw_Small_Cube ;Draws a block

	ret
endp drawAllCubes
	
;=============================================================================================================================================	
		
; Draws background of one of the cubes according to x and y values of the blocks
proc drawALLCubes_BackGround

;Block 1:
	;set x of block 1:
	mov ax, [xCube1] 
	add ax, [xCube]
	;set y of block 1:
	mov bx, [yCube1]
	add bx, [yCube]

	;draws block 1 background:
	push ax ;x
	push bx ;y
	call draw_Small_Cube_BackGround ;Draws a background again 
	
;Block 2:	
	;set x of block 2:
	mov ax, [xCube2]
	add ax, [xCube]
	;set y of block 2:
	mov bx, [yCube2]
	add bx, [yCube]

	;draws block 2 background:
	push ax ;x
	push bx ;y
	call draw_Small_Cube_BackGround ;Draws a background again
	
;Block 3:
	;set x of block 3:
	mov ax, [xCube3]
	add ax, [xCube]
	;set y of block 3:
	mov bx, [yCube3]
	add bx, [yCube]
	
	;draws block 3 background:
	push ax ;x
	push bx ;y
	call draw_Small_Cube_BackGround ;Draws a background again

;Block 4:
	;set x of block 4:
	mov ax, [xCube4]
	add ax, [xCube]
	;set y of block 4:
	mov bx, [yCube4]
	add bx, [yCube]
	
	;draws block 4 background:
	push ax ;x
	push bx ;y
	call draw_Small_Cube_BackGround ;Draws a background again

	ret
endp drawAllCubes_BackGround

;=============================================================================================================================================