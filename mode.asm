
color equ [word ptr bp +4] ;color
; מצייר את הריבוע האמצעי העליון של המסך שמשתנה בין מוד למוד
proc Draw_Middle_Oblong
	push bp ;backup
	mov bp, sp
	
	push 59 ; x
	push 0 ; y
	push 101 ; length
	push 14 ; width
	push color ;color
	call drawOblong ; מצייר את הריבוע האמצעי העליון של המסך
	
	pop bp ;backup
	ret 2
endp  Draw_Middle_Oblong
		
;=============================================================================================================================================	

;מגריל מספר אקראי בין 1 ל8 כדי לבחור איזה קוביה תשחק במוד בו יש גם קוביה של אחד על אחד
;#
proc TheNextCubeToPlay_OneByOne
; generate a rand no using the system time
	RANDSTART8:
		mov AH, 00h ; interrupts to get system time        
		int 1AH ; CX:DX now hold number of clock ticks since midnight      

		mov  ax, dx
		xor  dx, dx
		mov bl, 17
		mul bl
		mov cx, ax
		mov cx, 8  
		div cx ; here dx contains the remainder of the division - from 0 to 7
		inc dl ; dx = a random num from 1 to 8
	ret
endp TheNextCubeToPlay_OneByOne ; dl = מספר הקוביה האקראי שהוגרל
	
;=============================================================================================================================================
			
cube equ [word ptr bp + 4] ;ספרת העשרות מייצגת את הקוביה וספרת היחידות מייצגת את מצב הקוביה

; מגדיר את קוביה 8 במקרה והיא נבחרה
proc SetCube8
	push bp ;backup
	mov bp, sp
	
	cmp cube, 81
	je Cube8_Pos1
	jmp TheEnd8

	Cube8_Pos1: ;Set cube 8 pos 1
		call Set_Cube8_Pos1
	jmp TheEnd8

	TheEnd8:
		pop bp ;backup
	ret 2
endp SetCube8
		
;=============================================================================================================================================
	
;change the color of the cube to red or blue randomly
proc changeToRedOrBlue
	call TheNextPositionToPlay2 ;מגריל מספר אקראי מ1 עד 2
	cmp dl, 2
	je Red
	Blue:
		mov [colorBlock], 0C8h ;blue - color of blocks
	jmp ColorWasSetted
	Red:
		mov [colorBlock], 0Fh ;red - color of blocks
	ColorWasSetted:
	ret
endp changeToRedOrBlue	
	
;=============================================================================================================================================	
			
;change the color of the cube to white or blue randomly
proc changeToWhiteOrBlue
	call TheNextPositionToPlay2 ;מגריל מספר אקראי מ1 עד 2
	cmp dl, 2
	je White_
	Blue_:
		mov [colorBlock], 0FCh ;blue - color of blocks
	jmp ColorWasSetted
	White_:
		mov [colorBlock], 0F6h ;white - color of blocks
	ColorWasSetted_:
	ret
endp changeToWhiteOrBlue

;=============================================================================================================================================	

;מצייר מלבן אפור בחלקו התחתון של הלוח שגורם ללוח להיראות כאילו הוא התכווץ- מיועד למוד הלוח הקטן
proc MakeTheBoardSmaller
		push 59
		push 157
		push 101
		push 40
		push 7h
		call drawOblong ; מצייר מלבן אפור כדי לחסות חלק מהלוח
		
		push 60 ; נקודת התחלה של הקו
		push 100 ; אורך הקו
		push 158 ; שיעור הוואי של הקו
		push 0 ; צבע הקו
		call drawSmallLineY ; מצייר קו אופקי

		push 60 ; נקודת התחלה של הקו
		push 100 ; אורך הקו
		push 159 ; שיעור הוואי של הקו
		push 0 ; צבע הקו
		call drawSmallLineY ; מצייר קו אופקי
	ret
endp MakeTheBoardSmaller

;=============================================================================================================================================

; מצייר את הלוח במוד הקוביה המשוגעת- מספר 1
proc drawCrazyBoard1
		mov [yCube], 137
		mov [xCube], 90
		
		push 74 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה

		mov [yCube], 97
		mov [xCube], 90
		
		push 63 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה

		mov [yCube], 67
		mov [xCube], 110
		
		push 52 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה
	
		mov [yCube], 177
		mov [xCube], 120
		
		push 42 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה
	
		mov [yCube], 167
		mov [xCube], 140
		
		push 11 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה
	ret
endp drawCrazyBoard1

;=============================================================================================================================================

; מצייר את הלוח במוד הקוביה השוגעת - מספר 2
proc drawCrazyBoard2
		mov [yCube], 177
		mov [xCube], 80
		
		push 42 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה
	
		mov [yCube], 157
		mov [xCube], 130
		
		push 11 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה
		
		mov [yCube], 97
		mov [xCube], 130
		
		push 34 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה

		mov [yCube], 147
		mov [xCube], 80
		
		push 21 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה
		
		mov [yCube], 127
		mov [xCube], 140
		
		push 72 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה
	ret
endp drawCrazyBoard2

;=============================================================================================================================================

; מצייר את הלוח במוד הקוביה המשוגעת - מספר 3
proc drawCrazyBoard3
		mov [yCube], 147
		mov [xCube], 90
		
		push 52 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה

		mov [yCube], 137
		mov [xCube], 120
		
		push 33 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה
		
		mov [yCube], 177
		mov [xCube], 70
		
		push 11 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה

		mov [yCube], 157
		mov [xCube], 150
		
		push 22 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה
		
		mov [yCube], 127
		mov [xCube], 130
		
		push 62 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה
	ret
endp drawCrazyBoard3

;=============================================================================================================================================

; מצייר את הלוח במוד הקוביה המשוגעת - מספר 4
proc drawCrazyBoard4
		mov [yCube], 127
		mov [xCube], 80
		
		push 43 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה

		mov [yCube], 157
		mov [xCube], 130
		
		push 31 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה
		
		mov [yCube], 177
		mov [xCube], 60
		
		push 11 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה

		mov [yCube], 117
		mov [xCube], 60
		
		push 22 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה
		
		mov [yCube], 147
		mov [xCube], 80
		
		push 74 ;מספר הקוביה
		call SetCube ; מגדיר את הקוביה לפי המספר שנדחף
		mov [colorBlock], 9 ;color of block
		call drawAllCubes ; מצייר את הקוביה במיקום ובנתונים שנבחרו בצבע כחול בהיר
		call second ; מחכה שנייה
	ret
endp drawCrazyBoard4

;=============================================================================================================================================

;פרוצדורה שמציירת את הלוח המשוגע באופן כמעט רנדומלי, כלומר, בוחרת בין ארבע אפשרויות באופן רנדומלי
proc drawCrazyBoard
	call TheNextPositionToPlay4 ; מגריל מספר אקראי בין 1 ל4 ושם אותו בדי אל
	cmp dl, 1
	je draw1
	cmp dl, 2
	je draw2
	cmp dl, 3
	je draw3
	cmp dl, 4
	je draw4
	jmp drawRet
	draw1:
		call drawCrazyBoard1 ; מצייר את מצב 1 של הלוח המשוגע
	jmp drawRet
	draw2:
		call drawCrazyBoard2 ; מצייר את מצב 2 של הלוח המשוגע
	jmp drawRet
	draw3:
		call drawCrazyBoard3 ; מצייר את מצב 3 של הלוח המשוגע
	jmp drawRet
	draw4:
		call drawCrazyBoard4 ; מצייר את מצב 4 של הלוח המשוגע
	jmp drawRet

	drawRet:
	ret
endp drawCrazyBoard

;=============================================================================================================================================