
;procedure that begins the program
proc begin
	mov ax, @data
	mov ds, ax
	ret
endp begin
	
;=============================================================================================================================================	

;procedure that exits the program
proc escape
	push ax ;backup
	mov ax, 4c00h
	int 21h
	pop ax ;backup
	ret
endp escape
	
;=============================================================================================================================================		
		
;Changes to Text Mode
proc textMod
	push ax ;backup
	mov al, 3h
	mov ah, 0
	int 10h
	pop ax ;backup
	ret
endp textMod		
	
;=============================================================================================================================================	

;Changes to Graphic Mode
proc graphicMod
	push ax ;backup
	mov al, 13h
	mov ah, 0
	int 10h
	pop ax ;backup
	ret
endp graphicMod
	
;=============================================================================================================================================

;Clears the buffer
proc clearkeyboardbuffer 
	mov ah,0ch
	mov al,0
	int 21h
	ret
endp clearkeyboardbuffer
	
;=============================================================================================================================================	
		
;Reads the time
proc readTime
	mov ah, 2ch
	int 21h
	ret
endp readTime ;Return: CH = hour | CL = minute | DH = second | DL = 1/100 seconds
	
;=============================================================================================================================================	
		
;Waits one second
proc second
	push bp ;backup
	PushAll ;backup
	mov cx, 10
	mov dx, 0
	mov ah, 86h
	int 15h ;waits a second
	PopAll ;backup
	pop bp ;backup
	ret
endp second
	
;=============================================================================================================================================	

;Gets the color of the chosen pixel
x equ [word ptr bp + 6] ; x of the pixel
y equ [word ptr bp + 4] ; y of the pixel

proc getPixel
	push bp ;backup
	mov bp, sp
	push dx ;backup
	push cx ;backup

	mov ah, 0Dh
	mov cx, x ; 0 <= x <= 319
	mov dx, y ; 0 <= y <= 199
	int 10h ; interrupt to get the color of the pixel

	pop cx ;backup
	pop dx ;backup
	pop bp ;backup
	ret 4
endp getPixel ; al = Color of the pixel

;=============================================================================================================================================