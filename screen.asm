
; פרוצדורה שמקבלת תמונה ומדפיסה אותה למסך במצב גרפי
proc Splash
	call OpenFile ; Open file 
	call ReadHeader ; Read BMP file header, 54 bytes
	call ReadPalette ; Read BMP file color palette, 256 colors * 4 bytes (400h) 
	call CopyPal ;copy palette
	call CopyBitmap ; copy the bitmap
	call CloseFile ; Closes the file
	ret 
endp Splash
	
;=============================================================================================================================================	

;Open file 
proc OpenFile 
	mov ah, 3Dh 
	xor al, al 
	mov dx, [filenamee]
	int 21h 
	jc openerror 
	mov  [filehandle], ax 
	ret 
	openerror: 
		mov dx, offset ErrorMsg 
		mov ah, 9h 
		int 21h 
	ret  
endp OpenFile 
	
;=============================================================================================================================================	

;Read BMP file header, 54 bytes 	
proc ReadHeader  
	mov ah, 3fh 
	mov bx, [filehandle] 
	mov cx, 54 
	mov dx, offset Header 
	int 21h                      
	ret 
endp ReadHeader  

;=============================================================================================================================================	

;Read BMP file color palette, 256 colors * 4 bytes (400h) 
proc ReadPalette 
	mov ah, 3fh 
	mov cx, 400h                           
	mov dx, offset Palette 
	int 21h                      
	ret 
endp ReadPalette 
	
;=============================================================================================================================================	

;copy palette
proc CopyPal  
	; Copy the colors palette to the video memory  
	; The number of the first color should be sent to port 3C8h 
	; The palette is sent to port 3C9h 
	mov si, offset Palette        
	mov cx, 256               
	mov dx, 3C8h 
	mov al, 0                     
	; Copy starting color to port 3C8h 
	out dx,al 
	; Copy palette itself to port 3C9h  
	inc dx                       
	PalLoop: 
		; Note: Colors in a BMP file are saved as BGR values rather than RGB. 
		mov ax, [si+2]             ; Get red value. 
		shr al, 2                     ; Max. is 255, but video palette maximal 
		; value is 63.  Therefore dividing by 4. 
		out dx, al ; Send it. 
		mov al, [si+1] ; Get green value. 
		shr al, 2 
		out dx, al ; Send it. 
		mov al, [si] ; Get blue value. 
		shr al, 2 
		out dx, al ; Send it. 
		add si, 4 ; Point to next color. 
		; (There is a null chr. after every color.) 
	loop PalLoop 
	ret 
endp CopyPal  
	
;=============================================================================================================================================	

; copy the bitmap
proc CopyBitmap 
	; BMP graphics are saved upside-down. 
	; Read the graphic line by line (200 lines in VGA format), 
	; displaying the lines from bottom to top.  
	mov ax, 0A000h 
	mov es, ax 
	mov cx, 200 
	
	PrintBMPLoop: 
		push cx  ;backup
		; di = cx*320, point to the correct screen line 
		mov di, cx                    
		shl cx, 6                     
		shl di, 8                     
		add di, cx 
		; Read one line 
		mov ah, 3fh 
		mov cx, 320 
		mov dx, offset ScrLine 
		int 21h                      
		; Copy one line into video memory 
		cld ; Clear direction flag, for movsb 
		mov cx, 320 
		mov si, offset ScrLine 

		rep movsb ; Copy line to the screen  
		;rep movsb is same as the following code: 
		;mov es:di, ds:si 
		;inc si 
		;inc di 
		;dec cx 
		;loop until cx=0      
		pop cx  ;backup
	loop PrintBMPLoop
	ret 
endp CopyBitmap 
	
;=============================================================================================================================================	

; Closes the file
proc CloseFile
	mov ah,3Eh 
	mov bx, [filehandle] 
	int 21h 
	ret
endp CloseFile
	
;=============================================================================================================================================	

;Draws The tetris title screen
proc DrawTetrisTitle
	lea bx, [TetrisTitle]
	mov [filenamee],bx
	call Splash
	ret
endp DrawTetrisTitle
	
;=============================================================================================================================================	
		
;Draws The keyboard information screen
proc DrawKeyboardInfo
	lea bx, [KeyBoardInfo]
	mov [filenamee],bx
	call Splash
	ret
endp  DrawKeyboardInfo
	
;=============================================================================================================================================	

;Draws The how to play screen
proc DrawHowToPlay
	lea bx, [instructions]
	mov [filenamee],bx
	call Splash
	ret
endp DrawHowToPlay
	
;=============================================================================================================================================	

;Draws The modes set screen
proc DrawModesPage
	lea bx, [ModesPage]
	mov [filenamee],bx
	call Splash
	ret
endp DrawModesPage
	
;=============================================================================================================================================	
		
;Draws The menu screen
proc DrawMenu
	lea bx, [Menu]
	mov [filenamee],bx
	call Splash
	ret
endp DrawMenu
	
;=============================================================================================================================================

;Draws The exit screen
proc DrawQuit
	lea bx, [quitScreen]
	mov [filenamee],bx
	call Splash
	ret
endp DrawQuit

;=============================================================================================================================================	

;Draws The Bye Bye screen
proc DrawEnd
	lea bx, [endScreen]
	mov [filenamee],bx
	call Splash
	ret
endp DrawEnd

;=============================================================================================================================================			

;Draws The Game over screen
proc DrawGameOver
	lea bx, [GameOverScreen]
	mov [filenamee],bx
	call Splash
	ret
endp DrawGameOver

;=============================================================================================================================================

;Draws The Loading screen - number 1
proc DrawLoading1
	push cx ;backup
	lea bx, [Loading1]
	mov [filenamee],bx
	call Splash
	pop cx ;backup
	ret
endp DrawLoading1
	
;=============================================================================================================================================	

;Draws The Loading screen - number 2
proc DrawLoading2
	push cx ;backup
	lea bx, [Loading2]
	mov [filenamee],bx
	call Splash
	pop cx ;backup
	ret
endp DrawLoading2
	
;=============================================================================================================================================	

;Draws The Loading screen - number 3
proc DrawLoading3
	push cx ;backup
	lea bx, [Loading3]
	mov [filenamee],bx
	call Splash
	pop cx ;backup
	ret
endp DrawLoading3
	
;=============================================================================================================================================	
		
;פרוצדורה שמציירת את מסך הטעינה
proc Loading 
	call TheNextPositionToPlay2 ;מגריל מספר אקראי בין 1 ל2
	cmp dl, 2 ; לפעמים עושה טעינה קצרה ולפעמים ארוכה
	je ShortLoading
	call DrawLoading1 ; מצייר את מסך הטעינה הראשון
	call second ;מחכה שנייה
	call second ;מחכה שנייה
	ShortLoading:
		call DrawLoading2 ;מצייר את מסך הטעינה השני
		call second ;מחכה שנייה
		call second ;מחכה שנייה
		call DrawLoading3 ; מצייר את מסך הטעינה השלישי
		call second ;מחכה שנייה
		call clearkeyboardbuffer ; מנקה את הבאפר משטויות שנלחצו בזמן מסך ההמתנה
	ret
endp Loading

;=============================================================================================================================================	