
;dl -מדפיס את התו שב
proc printTav
	mov ah, 2h
	int 21h
	ret
endp printTav

;=============================================================================================================================================================

;מדפיס את התו שבדי אל בצבע שבבי אל
proc printSmartTav
	mov al, dl
	mov bh, 1
	mov cx, 1
	mov ah, 09h
	int 10h
	ret
endp printSmartTav

;=============================================================================================================================================================

;dx -מדפיס מחרוזת שנגמרת ב$ והאופסט שלה ב 
proc printString
	mov ah, 9h
	int 21h
	ret
endp printString

;=============================================================================================================================================================

;Set cursor position
proc setCursor ; dh = y, dl = x
	mov bh, 0
	mov ah, 2
	int 10h
	ret
endp setCursor

;=============================================================================================================================================================

;מדפיס את ניקוד השחקן
proc printScore
		pushAll ;backup
	;:מדפיס הודעת ניקוד	
		mov dh, 6 ;y
		mov dl, 25 ;x
		call setCursor ;Set cursor position
		mov dx, offset TopMessage
		call printString
	
	;Prints thousands:
		mov dh, 6 ;y
		mov dl, 31 ;x
		call setCursor ;Set cursor position
	
		mov ax, [Score]
		call setThousandsOfScore
		mov bl, 0F0h ;cyan
		call  printSmartTav ;printTav
		
	;Prints hundreds:
		mov dh, 6 ;y
		mov dl, 32 ;x
		call setCursor ;Set cursor position
	
		mov ax, [Score]
		call setHundredsOfScore
		mov bl, 0F0h ;cyan
		call  printSmartTav ;printTav
	
	;Prints tens:
		mov dh, 6 ;y
		mov dl, 33 ;x
		call setCursor ;Set cursor position
	
		mov ax, [Score]
		call setTensOfScore
		mov bl, 0F0h ;cyan
		call  printSmartTav ;printTav
	
	;Prints oneness:
		mov dh, 6 ;y
		mov dl, 34 ;x
		call setCursor ;Set cursor position
	
		mov ax, [Score]
		call setOnenessOfScore
		mov bl, 0F0h ;cyan
		call printSmartTav ;printTav
	
		popAll ;backup
	ret
endp printScore

;=============================================================================================================================================================

;מדפיס את שיא השחקן
proc printBest
		pushAll ;backup
		
		mov dh, 9 ;y
		mov dl, 25 ;x
		call setCursor ;Set cursor position
		mov dx, offset BestMessage
		call printString
	
	;Prints thousands:
		mov dh, 9 ;y
		mov dl, 30 ;x
		call setCursor ;Set cursor position

		mov ax, [Best]
		call setThousandsOfScore
		mov bl, 0FBh ;yellow
		call  printSmartTav;printTav
	
	;Prints hundreds:
		mov dh, 9 ;y
		mov dl, 31 ;x
		call setCursor ;Set cursor position
	
		mov ax, [Best]
		call setHundredsOfScore
		mov bl, 0FBh ;yellow
		call  printSmartTav;printTav
	
	;Prints tens:
		mov dh, 9 ;y
		mov dl, 32 ;x
		call setCursor ;Set cursor position
		
		mov ax, [Best]
		call setTensOfScore
		mov bl, 0FBh ;yellow
		call  printSmartTav;printTav
	
	;Prints oneness:
		mov dh, 9 ;y
		mov dl, 33 ;x
		call setCursor ;Set cursor position
	
		mov ax, [Best]
		call setOnenessOfScore
		mov bl, 0FBh ;yellow
		call printSmartTav;printTav
	
		popAll ;backup
	ret
endp printBest

;=============================================================================================================================================================

; בודק אם המשתמש שבר את השיא שלו
proc updateBest
	mov ax, [Score]
	cmp ax, [best]
	jng NotupdateHighScore ; בודק אם הניקוד יותר גבוה מהשיא ואם כן מחליף את השיא בניקוד
	mov [best], ax
	NotupdateHighScore:
	ret
endp updateBest
	
;=============================================================================================================================================================

;מחזיר לדי אל את ספרת היחידות של איי איקס
proc setOnenessOfScore ;it uses the value in ax
	; חישוב:
	xor dx, dx
	mov bx, 10
	div bx
	;dx has ax's module 10
	add dl, '0' 
	ret
endp setOnenessOfScore

;=============================================================================================================================================================

;מחזיר לדי אל את ספרת העשרות של איי איקס
proc setTensOfScore ;it uses the value in ax
	; חישוב:
	xor dx, dx
	mov bx, 10
	div bx
	call setOnenessOfScore ;מחזיר לדי אל את ספרת היחידות של איי איקס
	ret
endp setTensOfScore

;=============================================================================================================================================================

;מחזיר לדי אל את ספרת המאות של איי איקס
proc setHundredsOfScore ;it uses the value in ax
	; חישוב:
	mov bl, 100
	div bl
	xor ah, ah
	mov bl, 10
	div bl 
	mov dl,ah 
	add dl, '0' 
	ret
endp setHundredsOfScore

;=============================================================================================================================================================

;מחזיר לדי אל את ספרת המאות של איי איקס
proc setThousandsOfScore ;it uses the value in ax
	; חישוב:
	mov bl, 100
	div bl
	xor ah, ah
	mov bl, 10
	div bl
	xor ah, ah
	mov bl, 10
	div bl 
	mov dl,ah 
	add dl, '0' 
	ret
endp setThousandsOfScore

;=============================================================================================================================================================

; פרוצדורה שבודקת אם עבר טיק מאז פעם קודמת שקראו לפרוצדורה ואם כן מעלה משתנה שסופר טיקים ב1
proc UpdateInternalClock
	pushAll ;backup
	xor dx,dx
		
	mov ah, 2Ch ;taking time from computer's clock
	int 21h ;in dl we have now the mili seconds
	
	cmp dl,[DLHolder] ;checking if time has passed
	jne UpdatingTime ; אם זמן עבר מעלים את המשתנה שמכיל את הטיקים באחד
	jmp EndUpdatingTime ; אחרת לא עושים כלום
		
	UpdatingTime:
		inc [InternalClock]	;InternalClock's units are 1/18 of a seconed
		mov [DLHolder],dl
	EndUpdatingTime:
		popAll ;backup
	ret
endp UpdateInternalClock
	
;=============================================================================================================================================================

; מדפיס את הזמן שעבר מתחילת ריצת המשחק בתבנית ##:## בצירוף המילה זמן באנגלית
proc BoardClock
		pushAll ;backup
		
		;finding how much minutes and seconds have passed
		mov ax,[InternalClock] 
		mov bx,18 ;start by finding how much seconds have passed
		xor dx,dx	
		div bx ;dx:ax/bx =bigest posibble situation=> 0000 7fff / 12 ([2^15 -1]/18 = 1820)
		mov bl,60 ;minutes
		div bl ; find the minutes and seconds by dividing by 60
		mov [seconds],ah
		mov [minutes],al
		
		xor ax,ax
		mov al,[seconds]
		mov bl,10
		div bl ;find the 10s of seconds and left single seconds
		add al,'0' ;10s of seconds
		add ah,'0' ;left single seconds
		mov [clock+4],ah ;place of single seconds ##:#{#}
		mov [clock+3],al ;place of 10s seconds    ##:{#}#
		
		xor ax,ax
		mov al,[minutes]
		mov bl,10
		div bl ;find the 10s of minutes and left single minutes
		add al,'0' ;10s of minutes
		add ah,'0';left single minutes
		mov [clock+1],ah ;place of single minutes #{#}:##
		mov [clock],al	 ;place of 10s minutes    {#}#:##
		
		;prints the word "Time":
		mov dh, 12 ;y
		mov dl, 25 ;x
		call setCursor ;Set cursor position
		mov dx, offset TimeMessage
		call printString
		
		;prints the time in ##:## format:
		push 12
		push 30
		push 5d
		push 0ffh
		push offset Clock
		call printTheString
		
		popAll ;backup
	ret
endp BoardClock
		
;=============================================================================================================================================================
	
X equ [bp+12]
Y equ [bp+10]
leng equ [bp+8]
Color equ [bp+6]
offsetString equ [bp+4]
;פרוצדורה שמקבלת מחרוזת ומיקום עם ערכי איקס וואי, וגם צבע ומדפיסה את המחרוזת
proc printTheString
	push bp ;backup
	mov bp,sp 
	pushAll ;backup
	
	mov ax, ds ;write string
	mov es, ax     
	mov ah,13h
	mov al,01h ; attrib in bl, move cursor
	mov bl,Color ; attribute - white
	mov cx,leng	; length of string
	mov dh,X ; row to put string
	mov dl,Y ; column to put string
	mov bp,offsetString	; string offset
	int 10h ; call BIOS service
		
	popAll ;backup
	pop bp ;backup
		
	ret 10
endp printTheString

;=============================================================================================================================================================
	
;מאפס את השעון
proc initializeClock
	mov [clock],'0'	 ;place of 10s minutes   {0}#:##
	mov [clock+1],'0' ;place of single minutes #{0}:##
	mov [clock+3],'0' ;place of 10s seconds    ##:{0}#
	mov [clock+4],'0' ;place of single seconds ##:#{0}
	
	mov [DLHolder], 0 ;initialize
	mov [InternalClock], 0 ;initialize
	mov [seconds], 0 ;initialize
	mov [minutes], 0 ;initialize
	ret
endp initializeClock

;=============================================================================================================================================================

;מדפיס את שם המוד
proc printMode
	mov dh, 15 ;y
	mov dl, 25 ;x
	call setCursor ;Sets cursor position

	call setTheModeForPringting ; mov into dx the offset of the mode's name
	call printString ;prints the string
	ret
endp printMode

;=============================================================================================================================================================

; קובע את שם המוד כהכנה להדפסתו
proc setTheModeForPringting
	cmp [mode], 1
	je Classic1
	cmp [mode], 2 
	je TurtleSpeed2
	cmp [mode], 3
	je SuperHard3
	cmp [mode], 4
	je SpiderMan4
	cmp [mode], 5
	je OneByOne5
	cmp [mode], 6 
	je CrazyBoard6
	cmp [mode], 7
	je NoRotations7
	cmp [mode], 8
	je Israel8
	cmp [mode], 9
	je TinyBoard9
	jmp YouAllreadySettedTheMode
	
	Classic1:
		call classic_Print
	jmp YouAllreadySettedTheMode
	
	TurtleSpeed2:
		call TurtleSpeed_Print
	jmp YouAllreadySettedTheMode
	
	SuperHard3:
		call SuperHard_Print
	jmp YouAllreadySettedTheMode
	
	SpiderMan4:
		call SpiderMan_Print
	jmp YouAllreadySettedTheMode
	
	OneByOne5:
		call OneByOne_Print
	jmp YouAllreadySettedTheMode
	
	CrazyBoard6:
		call CrazyBoard_Print
	jmp YouAllreadySettedTheMode
	
	NoRotations7:
		call NoRotations_Print
	jmp YouAllreadySettedTheMode
	
	Israel8:
		call Israel_Print
	jmp YouAllreadySettedTheMode
	
	TinyBoard9:
		call TinyBoard_Print
		
	jmp YouAllreadySettedTheMode
	
	YouAllreadySettedTheMode:
	ret
endp setTheModeForPringting

;=============================================================================================================================================================

;קובע את המוד הקלאסי להדפסת שמו
proc classic_Print
	mov dx, offset classic_Message
	ret
endp classic_Print

;=============================================================================================================================================================

;קוב את המוד האיטי להדפסת שמו
proc TurtleSpeed_Print
	mov dx, offset TurtleSpeed_Message
	ret
endp TurtleSpeed_Print

;=============================================================================================================================================================

; קובע את המוד המהיר להדפסת שמו
proc SuperHard_Print
	mov dx, offset SuperHard_Message
	ret
endp SuperHard_Print

;=============================================================================================================================================================

; קובע את מוד ספיידרמן להדפסת שמו
proc SpiderMan_Print
	mov dx, offset SpiderMan_Message
	ret
endp SpiderMan_Print

;=============================================================================================================================================================

; קובע את המוד אחד על אחד להדפסת שמו
proc OneByOne_Print
	mov dx, offset OneByOne_Message
	ret
endp OneByOne_Print

;=============================================================================================================================================================

proc CrazyBoard_Print
	mov dx, offset CrazyBoard_Message
	ret
endp CrazyBoard_Print

;=============================================================================================================================================================

; קובע את המוד בלי הסיבובים להדפסת שמו
proc NoRotations_Print
	mov dx, offset NoRotations_Message
	ret
endp NoRotations_Print

;=============================================================================================================================================================

; קובע את מוד ישראל להדפסת שמו
proc Israel_Print
	mov dx, offset Israel_Message
	ret
endp Israel_Print

;=============================================================================================================================================================

; קובע את מוד הלוח הפצפון להדפסת שמו
proc TinyBoard_Print
	mov dx, offset TinyBoard_Message
	ret
endp TinyBoard_Print

;=============================================================================================================================================================	
				
; פעולה שמדפיסה את המילה טטריס מעל כל הניקוד ושיאי השחקן
proc printTetris
		push dx ;backup
		
		;T:
		mov dh, 3 ;y
		mov dl, 27 ;x
		call setCursor ;Set cursor position
		mov dl, 'T'
		mov bl, 0Fh ;red
		call  printSmartTav;printTav
			
		;E:
		mov dh, 3 ;y
		mov dl, 28 ;x
		call setCursor ;Set cursor position
		mov dl, 'E'
		mov bl, 03Ah ;green
		call  printSmartTav;printTav
		
		;T:
		mov dh, 3 ;y
		mov dl, 29 ;x
		call setCursor ;Set cursor position
		mov dl, 'T'
		mov bl, 027h ;orange
		call  printSmartTav;printTav
		
		;R:
		mov dh, 3 ;y
		mov dl, 30 ;x
		call setCursor ;Set cursor position
		mov dl, 'R'
		mov bl, 0CCh ;purple
		call  printSmartTav;printTav
		
		;I:
		mov dh, 3 ;y
		mov dl, 31 ;x
		call setCursor ;Set cursor position
		mov dl, 'I'
		mov bl, 0F1h ;cyan
		call  printSmartTav;printTav
		
		;S:
		mov dh, 3 ;y
		mov dl, 32 ;x
		call setCursor ;Set cursor position
		mov dl, 'S'
		mov bl, 0FBh ;yellow
		call  printSmartTav;printTav
		
		pop dx ;backup
	ret
endp printTetris

;=============================================================================================================================================================

; פעולה שמדפיסה את המילה טטריס באפור במוד הלוח הקטן
proc printTetrisTinyBoard
		push dx ;backup
		
		;T:
		mov dh, 22 ;y
		mov dl, 11 ;x
		call setCursor ;Set cursor position
		mov dl, 'T'
		mov bl, 0F7h;0Fh ;red
		call  printSmartTav;printTav
		
		;E:
		mov dh, 22 ;y
		mov dl, 12 ;x
		call setCursor ;Set cursor position
		mov dl, 'E'
		mov bl, 0F7h;03Ah ;green
		call  printSmartTav;printTav
		
		;T:
		mov dh, 22 ;y
		mov dl, 13 ;x
		call setCursor ;Set cursor position
		mov dl, 'T'
		mov bl, 0F7h;027h ;orange
		call  printSmartTav;printTav
		
		;R:
		mov dh, 22 ;y
		mov dl, 14 ;x
		call setCursor ;Set cursor position
		mov dl, 'R'
		mov bl, 0F7h;0CCh ;purple
		call  printSmartTav;printTav
		
		;I:		
		mov dh, 22 ;y
		mov dl, 15 ;x
		call setCursor ;Set cursor position
		mov dl, 'I'
		mov bl, 0F7h;0F1h ;cyan
		call  printSmartTav;printTav
			
		;S:	
		mov dh, 22 ;y
		mov dl, 16 ;x
		call setCursor ;Set cursor position
		mov dl, 'S'
		mov bl, 0F7h;0FBh ;yellow
		call  printSmartTav;printTav
		
		pop dx ;backup
	ret
endp printTetrisTinyBoard

;=============================================================================================================================================================

proc boardStats
	call boardStatsTetris ; פעולה שמדפיסה את המילה טטריס ברגע שאתה נפסל
	call boardStatsScore ; פעולה שמדפיסה את ניקוד השחקן ברגע שהוא נפסל
	call boardStatsBest ;מדפיס את שיא השחקן ברגע שהוא נפסל
	call boardStatsTime ;פרוצדורה שמדפיסה את הזמן שלקח המשחק ברגע שהמשתמש נפסל
	call boardStatsMode ; פרוצדורה שמדפיסה את המוד ששוחק ברגע שהשחקן נפסל
	ret
endp boardStats

;=============================================================================================================================================================
			
; פעולה שמדפיסה את המילה טטריס ברגע שאתה נפסל
proc boardStatsTetris
		push dx ;backup
		
		;T:
		mov dh, 7 ;y
		mov dl, 17 ;x
		call setCursor ;Set cursor position
		mov dl, 'T'
		mov bl, 0Fh ;red
		call  printSmartTav ;printTav
		
		;E:
		mov dh, 7 ;y
		mov dl, 18 ;x
		call setCursor ;Set cursor position
		mov dl, 'E'
		mov bl, 03Ah ;green
		call  printSmartTav ;printTav
		
		;T:
		mov dh, 7 ;y
		mov dl, 19 ;x
		call setCursor ;Set cursor position
		mov dl, 'T'
		mov bl, 027h ;orange
		call  printSmartTav ;printTav
		
		;R:
		mov dh, 7 ;y
		mov dl, 20 ;x
		call setCursor ;Set cursor position
		mov dl, 'R'
		mov bl, 0CCh ;purple
		call  printSmartTav ;printTav
		
		;I:
		mov dh, 7 ;y
		mov dl, 21 ;x
		call setCursor ;Set cursor position
		mov dl, 'I'
		mov bl, 0F1h ;cyan
		call  printSmartTav ;printTav
		
		;S:
		mov dh, 7 ;y
		mov dl, 22 ;x
		call setCursor ;Set cursor position
		mov dl, 'S'
		mov bl, 0FBh ;yellow
		call  printSmartTav ;printTav
		
		pop dx ;backup
	ret
endp boardStatsTetris

;=============================================================================================================================================================

; פעולה שמדפיסה את ניקוד השחקן ברגע שהוא נפסל
proc boardStatsScore
		pushAll ;backup
		
		mov dh, 9 ;y
		mov dl, 13 ;x
		call setCursor ;Set cursor position
		mov dx, offset TopMessage
		call printString
	
		mov dh, 9 ;y
		mov dl, 19 ;x
		call setCursor ;Set cursor position

		mov ax, [Score]
		call setThousandsOfScore ; מגדיר את ספרת האלפים
		mov bl, 0F0h ;cyan
		call printSmartTav ;printTav
	
		mov dh, 9 ;y
		mov dl, 20 ;x
		call setCursor ;Set cursor position
	
		mov ax, [Score]
		call setHundredsOfScore ; מגדיר את ספרת המאות
		mov bl, 0F0h ;cyan
		call printSmartTav ;printTav
	
		mov dh, 9 ;y
		mov dl, 21 ;x
		call setCursor ;Set cursor position
	
		mov ax, [Score]
		call setTensOfScore ; מגדיר את ספרת העשרות
		mov bl, 0F0h ;cyan
		call printSmartTav ;printTav
	
		mov dh, 9 ;y
		mov dl, 22 ;x
		call setCursor ;Set cursor position
	
		mov ax, [Score]
		call setOnenessOfScore ; מגדיר את ספרת היחידות
		mov bl, 0F0h ;cyan
		call printSmartTav ;printTav
	
		popAll ;backup
	ret
endp boardStatsScore

;=============================================================================================================================================================

;מדפיס את שיא השחקן ברגע שהוא נפסל
proc boardStatsBest
		pushAll ;backup
		
		mov dh, 11 ;y
		mov dl, 13 ;x
		call setCursor ;Set cursor position
		mov dx, offset BestMessage
		call printString
	
		mov dh, 11 ;y
		mov dl, 18 ;x
		call setCursor ;Set cursor position

		mov ax, [Best]
		call setThousandsOfScore ; מגדיר את ספרת האלפים
		mov bl, 0FBh ;yellow
		call  printSmartTav ;printTav
	
		mov dh, 11 ;y
		mov dl, 19 ;x
		call setCursor ;Set cursor position
	
		mov ax, [Best]
		call setHundredsOfScore ; מגדיר את ספרת המאות
		mov bl, 0FBh ;yellow
		call  printSmartTav ;printTav
	
	
		mov dh, 11 ;y
		mov dl, 20 ;x
		call setCursor ;Set cursor position
		
		mov ax, [Best]
		call setTensOfScore ; מגדיר את ספרת העשרות
		mov bl, 0FBh ;yellow
		call  printSmartTav ;printTav
	
		mov dh, 11 ;y
		mov dl, 21 ;x
		call setCursor ;Set cursor position
	
		mov ax, [Best]
		call setOnenessOfScore ; מגדיר את ספרת היחידות
		mov bl, 0FBh ;yellow
		call printSmartTav ;printTav
	
		popAll ;backup
	ret
endp boardStatsBest

;=============================================================================================================================================================

;פרוצדורה שמדפיסה את הזמן שלקח המשחק ברגע שהמשתמש נפסל
proc boardStatsTime
		pushAll ;backup
		
		;finding how much minutes and seconds have passed
		mov ax,[InternalClock] 
		mov bx,18 		;start by finding how much seconds have passed
		xor dx,dx	
		div bx  		;dx:ax/bx =bigest posibble situation=> 0000 7fff / 12 ([2^15 -1]/18 = 1820)
		mov bl,60		;minutes
		div bl
		mov [seconds],ah
		mov [minutes],al
		
		xor ax,ax
		mov al,[seconds]
		mov bl,10
		div bl
		add al,'0'  ;10s of seconds
		add ah,'0'	;left single seconds
		mov [clock+4],ah ;place of single seconds ##:#{#}
		mov [clock+3],al ;place of 10s seconds    ##:{#}#
		
		xor ax,ax
		mov al,[minutes]
		mov bl,10
		div bl
		add al,'0'  ;10s of minutes
		add ah,'0'	;left single minutes
		mov [clock+1],ah ;place of single minutes #{#}:##
		mov [clock],al	 ;place of 10s minutes    {#}#:##
		
		mov dh, 13 ;y
		mov dl, 13 ;x
		call setCursor ;Set cursor position
		mov dx, offset TimeMessage
		call printString
		
		push 13 ;y
		push 18 ;x
		push 5d
		push 0ffh
		push offset Clock 
		call printTheString ; prints the time in a ##:## format
		
		popAll ;backup
	ret
endp boardStatsTime

;=============================================================================================================================================================

; פרוצדורה שמדפיסה את המוד ששוחק ברגע שהשחקן נפסל
proc boardStatsMode
	mov dh, 15 ;y
	mov dl, 13 ;x
	call setCursor ;Set cursor position
	call setTheModeForPringting ; mov dx the offset of the mode's name
	call printString
	ret
endp boardStatsMode

;=============================================================================================================================================================

; פרוצדורה שמדפיסה הודעה בסיום המשחק, את שם יוצר הפרויקט שם המשחק ותאריך
proc MessageInTheEnd
	mov dx, offset endMessage
	ret
endp MessageInTheEnd

;=============================================================================================================================================