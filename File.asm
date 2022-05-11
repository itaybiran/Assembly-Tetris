
;Open file to write and read
proc OpenFileToWriteAndRead 
	pop ax ;pop the ip address
	pop dx ;offset file
	push ax ;push the ip address
	mov ah, 3Dh
	mov al,2
	int 21h
	jc OpenFiletoWARerror
	mov [filehandle], ax
	ret
	
	OpenFiletoWARerror:
		call textMod
		mov dx, offset ErrorMsg
		mov ah, 9h
		int 21h
	ret
endp OpenFileToWriteAndRead

;=============================================================================================================================================

numbyte equ [bp+6] ;amount of bytes to write
offsetVallibel equ [bp+4] ;offset of the vat to write

;Write message to file
proc WriteToFile 
	push bp ;backup
	mov bp,sp
	pushAll ;backup
	
	mov ah,40h
	mov bx,[filehandle]
	mov cx,numbyte ;how many bytes it is
	mov dx,offsetVallibel ;what i want to copy to the file
	int 21h
	
	popAll ;backup
	pop bp ;backup
	ret 4
endp WriteToFile

;=============================================================================================================================================

;Read from file
proc ReadFile 
	pop ax
	pop dx ;number of bytes to read
	pop cx	;offset variable you want to put the the text you read
	push ax
	
	mov ah,3Fh
	mov bx,[filehandle]
	int 21h
	ret
endp ReadFile

;=============================================================================================================================================

;move the cursor in the file
proc moveCursor 
	pop ax ;saves ip
	pop dx ;number of bytes to move the cursor (relative to the begining of the file)
	push ax
	
	mov ah,42h
	mov al,0
	mov bx,[filehandle]
	mov cx,0
	int 21h
	ret
endp moveCursor

;=============================================================================================================================================

;saves the user's high score in a txt file
proc saveHighScore

	;open the file:
		push offset filename_HighScore
		call OpenFileToWriteAndRead ;open the txt file
	
	;sets digits to write in the txt file:
	
	;thousands:	
		xor ax,ax ;zeroing ax
		mov ax,[best] ;change ax to high score
		call setThousandsOfScore ;sets the thousands digit in dl
		mov [first_digit],dl ;saves the first digit of the high score
		
	;hundrerds:
		xor ax,ax ;zeroing ax
		mov ax,[best] ;change ax to high score
		call setHundredsOfScore ;sets the hundrerds digit in dl
		mov [second_digit],dl ;saves the second digit of the high score

	;tens:
		xor ax,ax ;zeroing ax
		mov ax,[best] ;change ax to high score
		call setTensOfScore ;sets the tens digit in dl
		mov [third_digit],dl ;saves the third digit of the high score
		
	;oneness:	
		xor ax,ax ;zeroing ax
		mov ax,[best] ;change ax to high score
		call setOnenessOfScore ;sets the oneness digit in dl
		mov [fourth_digit],dl ;saves the fourth digit of the high score

	;writes digits in the txt file:	
	
	;thousands:	
		push 12
		call moveCursor ;set cursor's place to 12 bytes after the start of the file
		push 1 ;write 1 byte to file
		push offset first_digit ;copy first digit of the high score to file
		call WriteToFile ;write to the file
		
	;hundrerds:
		push 13
		call moveCursor ;set cursor's place to 13 bytes after the start of the file
		push 1 ;write 1 byte to file
		push offset second_digit ;copy second digit of the high score to file
		call WriteToFile ;write to the file
		
	;tens:
		push 14
		call moveCursor ;set cursor's place to 14 bytes after the start of the file
		push 1 ;write 1 byte to file
		push offset third_digit ;copy third digit of the high score to file
		call WriteToFile ;write to the file
		
	;oneness:	
		push 15
		call moveCursor ;set cursor's place to 15 bytes after the start of the file
		push 1 ;write 1 byte to file
		push offset fourth_digit ;copy fourth digit of the high score to file
		call WriteToFile ;write to the file
		
		call CloseFile ;close the file
	ret
endp saveHighScore

;=============================================================================================================================================

;sets the high score of the user to the high score in the txt file
proc setHighScore
	
	;open the file:
		push offset filename_HighScore
		call OpenFileToWriteAndRead ;open the dat file
		
	;Sets thousands:	
		push 12
		call moveCursor ;set cursor's place to 1 bytes after the start of the file
		
		push 1 ;read 1 byte from file
		push offset first_digit ;setting first digit of the high score from file
		call ReadFile ;read from file

		sub [first_digit],30h ;coverting char to number
		
		xor ax,ax ;zeroing ax
		add ax,[word ptr first_digit] ;change ax to thousands of high score
		mov bl,10 ;change bl's value to 10
		mul bl ;multiplying ax by 10
		mov bl,100 ;change bl's value to 100
		mul bl ;multiplying ax by 100
		
		add [best],ax ;adding ax (thousands) to the high score
		
	;Sets hundrerds:
		push 13
		call moveCursor ;set cursor's place to 13 bytes after the start of the file
		
		push 1 ;read 1 byte from file
		push offset second_digit ;setting second digit of the high score from file
		call ReadFile ;read from file
		
		sub [second_digit],30h ;coverting char to number
		
		xor ax,ax ;zeroing ax
		mov ax,[word ptr second_digit] ;change ax to hundrerds of high score
		mov bl,100 ;change bl's value to 100
		mul bl ;multiplying ax by 100
		
		add [best],ax ;adding ax (hundrerds) to the high score
		
	;Sets tens:
		push 14
		call moveCursor ;set cursor's place to 14 bytes after the start of the file
		
		push 1 ;read 1 byte from file
		push offset third_digit ;setting third digit of the high score from file
		call ReadFile ;read from file
		
		sub [third_digit],30h ;coverting char to number
		
		xor ax,ax ;zeroing ax
		mov ax,[word ptr third_digit] ;change ax to tens of high score
		mov bl,10 ;change bl's value to 10
		mul bl ;multiplying ax by 10
		
		add [best],ax ;adding ax (tens) to the high score
			
	;Sets oneness:	
		push 15
		call moveCursor ;set cursor's place to 15 bytes after the start of the file
		
		push 1 ;read 1 byte from file
		push offset fourth_digit ;setting fourth digit of the high score from file
		call ReadFile ;read from file
		
		sub [fourth_digit],30h ;coverting char to number
		
		xor ax,ax ;zeroing ax
		mov ax,[word ptr fourth_digit] ;change ax to oneness of high score
		
		add [best],ax ;adding ax (oneness) to the high score
		
		call CloseFile ;close the file
	ret
endp setHighScore

;=============================================================================================================================================