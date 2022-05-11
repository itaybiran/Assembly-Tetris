		
;active mouse
proc activeMouse
	push ax ;backup
	mov ax, 1
	int 33h
	pop ax ;backup
	ret
endp activeMouse
	
;=============================================================================================================================================	
		
;reset mouse
proc mouse
	push ax ;backup
	mov ax, 0
	int 33h
	pop ax ;backup
	ret
endp mouse
	
;=============================================================================================================================================	
			
;Gets mouse status
proc mouseStatus
	push ax ;backup
	mov ax, 3h
	int 33h ; Interrupt to get the mouse status
	shr cx, 1 ; Fixes the x value to make it fits 200*320 screen
	mov [mouse_x], cx ; Stores X of mouse in a variable
	mov [mouse_y], dx ; Stores Y of mouse in a variable
	pop ax ;backup
	ret
endp mouseStatus 
;bx = left button is pressed - bx = 1, right button is pressed - bx = 2, both of them are pressed - bx = 3

;=============================================================================================================================================

width_ equ [bp+10] ; width of button
hight_ equ [bp+8] ; hieght of button
y equ [bp+6] ; y of button
x equ [bp+4] ; ; x of button

; Gets a button and checks if it was pressed		
proc check_mouse_status
	push bp ;backup
	mov bp,sp
	PushAll ;backup

	mov [check_pressed],0 ;reset - the mouse wasn't pressed yet
	call mouseStatus ; checks mouse status
	cmp bx,1 ; if right button of the mouse was clicked
	je next_1 ;start checking if it was on our button
	jmp RetTime_Mouse ;else, exit the proc
		
	next_1: 
	;checks if the y of the mouse is bigger than the y of the right top corner of the button
		mov ax, y
		cmp [mouse_y],ax
		jg next_2
		jmp RetTime_Mouse
		
	next_2:
	;checks if the y of the mouse is smaller than the y of the edge of the button
		mov ax, y
		add ax, hight_
		cmp [mouse_y],ax
		jl next_3
		jmp RetTime_Mouse
		
	next_3:
	;checks if the x of the mouse is bigger than the x of the right top corner of the button
		mov ax,x
		cmp [mouse_x],ax
		jg next_4
		jmp RetTime_Mouse
		
	next_4:
	;checks if the x of the mouse is smaller than the x of the edge of the button
		mov ax,x
		add ax,width_
		cmp [mouse_x],ax
		jl next_5
		jmp RetTime_Mouse
		
	next_5:
	;if the program got to here, it means the button was pressed
		mov [check_pressed],1 ;means the button was pressed
		
	RetTime_Mouse:
		pop bp ;backup
		PopAll ;backup
	ret 8
endp check_mouse_status ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	
;=============================================================================================================================================	

; בודק אם נלחץ כפתור התלחץ פה בתחילת המשחק
proc ClickHere_Button
	push 51 ;רוחב הקוביה
	push 29 ; גובה הקוביה
	push 120 ; וואי הקוביה
	push 134 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp ClickHere_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed

;=============================================================================================================================================

; בודק אם נלחץ כפתור התחלת המשחק
proc Start_Button
	push 71 ;רוחב הקוביה
	push 26 ; גובה הקוביה
	push 27 ; וואי הקוביה
	push 116 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp Start_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	
;=============================================================================================================================================	
				
; בודק אם נלחץ כפתור ההוראות
proc Instruction_Button
	push 105 ;רוחב הקוביה
	push 16 ; גובה הקוביה
	push 70 ; וואי הקוביה
	push 100 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp Instruction_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	
;=============================================================================================================================================	
		
; בודק אם נלחץ כפתור הסבר המקלדת
proc KeyBoard_Button
	push 100 ;רוחב הקוביה
	push 33 ; גובה הקוביה
	push 105 ; וואי הקוביה
	push 103 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp KeyBoard_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	
;=============================================================================================================================================	
			
;בודק אם נלחץ כפתור היציאה
proc Quit_Button
	push 71 ;רוחב הקוביה
	push 27 ; גובה הקוביה
	push 154 ; וואי הקוביה
	push 117 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp Quit_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	
;=============================================================================================================================================

; בודק אם נלחץ כפתור החזרה לתפריט הראשי
proc Back_Button
	push 15 ;רוחב הקוביה
	push 17 ; גובה הקוביה
	push 178 ; וואי הקוביה
	push 3 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp Back_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	
;=============================================================================================================================================	
		
; בודק אם נלחץ כפתור המוד הקלאסי
proc Classic_Mood_Button
	push 67 ;רוחב הקוביה
	push 29 ; גובה הקוביה
	push 25 ; וואי הקוביה
	push 26 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp Classic_Mood_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	
;=============================================================================================================================================	
		
; בודק אם נלחץ כפתור מוד מהירות הצב
proc TurtleSpeed_Mood_Button
	push 67 ;רוחב הקוביה
	push 29 ; גובה הקוביה
	push 25 ; וואי הקוביה
	push 126 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp TurtleSpeed_Mood_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	
;=============================================================================================================================================	
		
; בודק אם נלחץ כפתור מוד הסופר קשה
proc SuperHard_Mood_Button
	push 67 ;רוחב הקוביה
	push 29 ; גובה הקוביה
	push 25 ; וואי הקוביה
	push 226 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp SuperHard_Mood_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	
;=============================================================================================================================================	
		
; בודק אם נלחץ כפתור מוד הספיידרמן
proc Spiderman_Mood_Button
	push 67 ;רוחב הקוביה
	push 29 ; גובה הקוביה
	push 85 ; וואי הקוביה
	push 26 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp Spiderman_Mood_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	
;=============================================================================================================================================	
			
; בודק אם נלחץ כפתור מוד קוביית האחד על אחד
proc OneByOne_Mood_Button
	push 67 ;רוחב הקוביה
	push 29 ; גובה הקוביה
	push 85 ; וואי הקוביה
	push 126 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp OneByOne_Mood_Button
	
;=============================================================================================================================================	
		
; בודק אם נלחץ כפתור מוד הלוח המשוגע
proc CrazyBoard_Mood_Button
	push 67 ;רוחב הקוביה
	push 29 ; גובה הקוביה
	push 85 ; וואי הקוביה
	push 226 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp CrazyBoard_Mood_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	
;=============================================================================================================================================	

; בודק אם נלחץ כפתור מוד הבלי סיבובים
proc NoRorations_Mood_Button
	push 67 ;רוחב הקוביה
	push 29 ; גובה הקוביה
	push 145 ; וואי הקוביה
	push 26 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp NoRorations_Mood_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	
;=============================================================================================================================================	
	
; בודק אם נלחץ כפתור המוד הישראלי
proc Israel_Mood_Button
	push 67 ;רוחב הקוביה
	push 29 ; גובה הקוביה
	push 145 ; וואי הקוביה
	push 126 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp Israel_Mood_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed

;=============================================================================================================================================

; בודק אם נלחץ כפתור המוד הלוח הקטן
proc TinyBoard_Mood_Button
	push 67 ;רוחב הקוביה
	push 29 ; גובה הקוביה
	push 145 ; וואי הקוביה
	push 226 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp TinyBoard_Mood_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed

;=============================================================================================================================================

;בודק אם נלחץ כפתור שחוזר למצב בחירת המוד בתום המשחק אחרי שהשחקן נפסל
proc again_Button
	push 34 ;רוחב הקוביה
	push 24 ; גובה הקוביה
	push 147 ; וואי הקוביה
	push 165 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp again_Button ;check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed

;=============================================================================================================================================

;בודק אם נלחץ כפתור החרה לסמך בחירת המודים בתום המשחק אחרי שהשחקן נפסל
proc BackToSetMod_Button
	push 34 ;רוחב הקוביה
	push 24 ; גובה הקוביה
	push 147 ; וואי הקוביה
	push 117 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp BackToSetMod_Button ;check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed

;=============================================================================================================================================

; בודק אם נלחץ כפתור אישור היציאה מהמשחק
proc yes_button
	push 55 ;רוחב הקוביה
	push 23 ; גובה הקוביה
	push 128 ; וואי הקוביה
	push 190 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp yes_button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed

;=============================================================================================================================================

; בודק אם נלחץ כפתור הביטול של יציאה מהמשחק
proc Cancel_Button
	push 97 ;רוחב הקוביה
	push 23 ; גובה הקוביה
	push 128 ; וואי הקוביה
	push 72 ; איקס הקוביה
	call check_mouse_status ;Gets a button and checks if it was pressed	
	ret
endp Cancel_Button ; check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed

;=============================================================================================================================================

;בודק אם נלחץ כפתור החזרה לתפריט הראשי ממסך השימוש במקלדת
proc BackCheck
	BackcheckLoop:
	push 24
	push 23
	push 169
	push 7
	call check_mouse_status  ;Gets a button and checks if it was pressed	
	;check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	cmp [check_pressed], 1
	je GoBack ;אם כן חוזר לתפריט
	jmp BackcheckLoop ; אם לא ממשיך לבדוק אם נלחץ כפתור החזרה
	GoBack:
	ret
endp BackCheck

;=============================================================================================================================================

;בודק אם נלחץ כפתור החזרה לתפריט הראשי ממסך ההסבר
proc BackCheckHowToPlay
	BackcheckLoopHowToPlay:
	push 16
	push 18
	push 8
	push 8
	call check_mouse_status ;Gets a button and checks if it was pressed	
	;check_pressed = 0 - wasn't pressed   |  check_pressed =1 was pressed
	cmp [check_pressed], 1
	je GoBackHowToPlay ;אם כן חוזר לתפריט
	jmp BackcheckLoopHowToPlay ; אם לא ממשיך לבדוק אם נלחץ כפתור החזרה
	GoBackHowToPlay:
	ret
endp BackCheckHowToPlay

;=============================================================================================================================================