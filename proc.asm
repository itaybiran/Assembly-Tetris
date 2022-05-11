
CODESEG

;=============================================================================================================================================	

;גיבוי רגיסטרים
macro PushAll 
	push ax ;backup
	push bx ;backup
	push cx ;backup
	push dx ;backup
	push di ;backup
	push si ;backup
endm PushAll
	
;=============================================================================================================================================	
		
;החזרת ערכי הרגיסטרים מגיבוי
macro PopAll 
	pop si ;backup
	pop di ;backup
	pop dx ;backup
	pop cx ;backup
	pop bx ;backup
	pop ax ;backup
endm PopAll
	
;=============================================================================================================================================	

;קולט תו מהבאפר
macro ToGetTav
	mov al, 0
	mov ah,01h
	int 16h 
endm ToGetTav
	
;=============================================================================================================================================

; Starts the Game!!!
proc Game
	call graphicMod ; משנה למצב גרפי
	call DrawTetrisTitle ; מצייר את מסך הפתיחה
	call setHighScore ;קובע את שיא השחקן לשיא שעשה בפעמים הקודמות
	call ClickHereToStart ;מחכה ללחיצה להתחלת המשחק ואז מתחיל אותו
	ret
endp Game

;=============================================================================================================================================

;פרוצדורה שמתחילה את המשחק עם מסך הפתיחה ומבקשת מהמשתמש ללחוץ על הכפתור כדי להתחיל ומחכה שהוא ילחץ עליו
proc ClickHereToStart
	
		call mouse ;מאתחל את העכבר
		call activeMouse ;מפעיל את העכבר
		
		call openSpeaker ; פותח את הספיקר
		call get_access_sound ; מאפשר גישה לשינוי של התווים שהספיקר משמיע
		call restart_milisecond ; מאפס את המילי שניות
	
		buttonPressedCheck_ClickHere:
		
			call readTime ; get system time
			
			cmp dl, [time_check] ;is the currunt time is equal to the privios one?
			je buttonPressedCheck_ClickHere ;if it is, check again
			
			mov [time_check],dl ;get currunt time
			
			call tetris_music ;תנגן מוזיקה
			call count_milisecond ;תעלה את המילישניות
			
			
			;Click Here button check:
			
			call ClickHere_Button
			cmp [check_pressed], 1 ;בודק אם נךחץ כפתור ההתחלה
			jne buttonPressedCheck_ClickHere
			call closeSpeaker
			call mouse
			call Menu_ ; אם כן מפעיל אותו
		ret
	ret
endp ClickHereToStart

;=============================================================================================================================================	
				
; מצייר את מסך התפריט הראשי ומחכה שילחץ כפתור כדי לפעול בהתאם				
proc Menu_
		call Loading ; מצייר את מסך הטעינה
		call DrawMenu ; מצייר את התפריט הראשי
		call mouse ;מאתחל את העכבר
		call activeMouse ;מפעיל את העכבר
		
		buttonPressedCheck:
			call Start_Button
			cmp [check_pressed], 1
			jne next1
			call Start_
			jmp exit
			
			next1:
				call Instruction_Button
				cmp [check_pressed], 1
				jne next2
				call Instructions_
			jmp exit
				
			next2:
				call KeyBoard_Button
				cmp [check_pressed], 1
				jne next3
				call KeyBoard_
			jmp exit
				
			next3:
				call Quit_Button
				cmp [check_pressed], 1
				jne next4
				call Quit_
			jmp exit
			
			next4:
		jmp buttonPressedCheck
	ret
endp Menu_
	
;=============================================================================================================================================	

; פרוצדורה שמופעלת כשהמשחק מתחיל ואחראית על המשחק עצמו
proc Start_
	call closeSpeaker ;סוגר את המיקרופון
	call mouse ;מכבה את העכבר
	call Loading ; מצייר את מסך הטעינה
	call DrawModesPage ; מצייר את מסך המודים
	call SetTheMood ;מקבל מהמשתמש את המוד שבו הוא רוצה לשחק ומתחיל את המשחק
	call PlayAgain ; בודק אם המששתמש רוצה לשחק שוב את המוד
	call Menu_
	ret
endp Start_
		
;=============================================================================================================================================	

; מפעיל את מסך ההוראות
proc Instructions_
	call closeSpeaker ;סוגר את המיקרופון
	call mouse ; מכבה את העכבר
	call DrawHowToPlay
	call mouse
	call activeMouse
	call BackCheckHowToPlay
	call mouse
	call menu_
	ret
endp Instructions_
	
;=============================================================================================================================================	

; מפעיל את מסך ההסבר על השימוש במקלדת במשחק
proc KeyBoard_
	call closeSpeaker ;סוגר את המיקרופון
	call mouse ; מכבה את העכבר
	call DrawKeyboardInfo ; מצייר את מסך ההסבר על השימוש במקלדת
	call activeMouse ; מפעיל את העכבר
	call BackCheck
	call mouse
	call Menu_
	ret
endp KeyBoard_
	
;=============================================================================================================================================	

; מתחיל יציאה מהמשחק
proc Quit_
	call closeSpeaker ;סוגר את המיקרופון
	call mouse
	call DrawQuit
	call YesOrCancel
	ret
endp Quit_
	
;=============================================================================================================================================	

; בודק אם המשתמש רוצה לצאת מהמשחק או לחזור לתפריט הראשי
proc YesOrCancel
	call mouse
	call activeMouse
	
	checkAgain:
		call Cancel_Button
		cmp [check_pressed], 1 ;בודק אם נלחץ כפתור הביטול
		jne nextButtonCheckYes
		call mouse
		call menu_ ; אם כן חוזר לתפריט הראשי
	ret
	nextButtonCheckYes:
		call yes_button
		cmp [check_pressed], 1 ;בודק אם נלחץ כפתור הביטול
		jne checkAgain
		call mouse
		call DrawEnd ;draw the end screen
		push cx
		mov cx, 4
		seconds_:
			call second
		loop seconds_
		pop cx
		call textMod
		call MessageInTheEnd
		call printString
		call saveHighScore ;saves the high score
		call escape
	ret
endp YesOrCancel

;=============================================================================================================================================

;מקבל את המוד שהשחקן רוצה לשחק ומתחיל את המשחק לפי המוד
proc SetTheMood
		call mouse ;מאתחל את העכבר
		call activeMouse ;מפעיל את העכבר
		
		buttonPressedCheck_Mood:
			
			;claasic mode check:
			call Classic_Mood_Button
			cmp [check_pressed], 1 ;בודק אם נבחר המוד הקלאסי
			jne nextButtonCheck1
			call Classic_Mood ; אם כן מפעיל אותו
			ret
			nextButtonCheck1:
			;Turtle speed mode check:
				call TurtleSpeed_Mood_Button
				cmp [check_pressed], 1 ;בודק אם נבחר מוד מהירות הצב
				jne nextButtonCheck2
				call TurtleSpeed_Mood ; אם כן מפעיל אותו
			ret
			nextButtonCheck2:
			;super hard mode check:
				call SuperHard_Mood_Button
				cmp [check_pressed], 1 ;בוחר אם נבחר מוד הסופר קשה
				jne nextButtonCheck3
				call SuperHard_Mood ; אם כן מפעיל אותו
			ret
			nextButtonCheck3:
			;Spiderman mode check:
				call Spiderman_Mood_Button
				cmp [check_pressed], 1 ;בודק אם נבחר מוד הספיידרמן
				jne nextButtonCheck4
				call Spiderman_Mood; אם כן מפעיל אותו
			ret
			nextButtonCheck4:
			;One by one mode check:
				call OneByOne_Mood_Button
				cmp [check_pressed], 1 ;בודק אם נבחר מוד הקוביה הקטנה
				jne nextButtonCheck5
				call OneByOne_Mood ; אם כן מפעיל אותו
			ret
			nextButtonCheck5:
			;Crazy Board check:
				call CrazyBoard_Mood_Button
				cmp [check_pressed], 1 ;בודק אם נבחר מוד הלוח המשוגע
				jne nextButtonCheck6
				call CrazyBoard_Mood ; אם כן מפעיל אותו
			ret
			nextButtonCheck6:
			;NoRorations mode check:
				call NoRorations_Mood_Button
				cmp [check_pressed], 1 ;בודק אם נבחר מוד בלי הסיבובים
				jne nextButtonCheck7
				call NoRorations_Mood ; אם כן מפעיל אותו
			ret
			nextButtonCheck7:
			;Israel mode check:
				call Israel_Mood_Button
				cmp [check_pressed], 1 ;בודק אם נבחר מוד ישראל
				jne nextButtonCheck8
				call Israel_Mood ; אם כן מפעיל אותו
			ret
			nextButtonCheck8:
			;TinyBoard mode check:
				call TinyBoard_Mood_Button
				cmp [check_pressed], 1 ;בודק אם נבחר מוד הלוח הפצפון
				jne nextButtonCheck9
				call TinyBoard_Mood ; אם כן מפעיל אותו
			ret
			nextButtonCheck9:
			;back button check:
				call Back_Button
				cmp [check_pressed], 1 ;בודק אם נבחר כפתור החזרה
				jne nextButtonCheck10
				call mouse
				call closeSpeaker
				call Menu_ ; אם כן מפעיל אותו
			ret
			nextButtonCheck10:
		jmp buttonPressedCheck_Mood
	ret
endp SetTheMood
	
;=============================================================================================================================================

;מוד בו המשחק במהירות הרגילה והקוביות בצבעים הרגילים
proc Classic_Mood
	mov [mode], 1
	call mouse ; מכבה את העכבר
	call closeSpeaker ; סוגר את הספיקר
	call Loading ; מפעיל את מסך הטעינה
	call closeSpeaker ; סוגר את הספיקר
	call clearkeyboardbuffer
	mov [Score], 0 	; מאפס את ניקוד השחקן
	mov [Speed], 100; מאפס את המהירות למהירות ממוצעת
	call initializeClock ;מאפס את השעון	
	call BoardDrawer ; מצייר את הלוח
	push 0F8h ;grey
	call Draw_Middle_Oblong ; מצייר את המלבן העליון באמצע המסך
	
	Classic: ; לולאת המשחק
		call Regular_Things ;כל הדברים הרגילים שמתרחשים בכל מוד, הגרלת קוביה אקראית, הורדה שלה, ובדיקה אם שורה הושלמה או לא
		call endGameCheck ; בודק אם המשתמש הפסיד וקוביה נגעה בחלקו העליון של הלוח
		cmp dx, 1 
	je End_Classic
	
	jmp Classic	; סיום לולאת המשחק
	
	End_Classic:
		call updateBest ; בודק אם המשתמש שבר את השיא שלו
	ret
endp Classic_Mood
	
;=============================================================================================================================================	
		
;מוד בו המשחק ממש ממש איטי
proc TurtleSpeed_Mood
	mov [mode], 2
	call mouse ; מכבה את העכבר
	call closeSpeaker ; סוגר את הספיקר
	call Loading ; מפעיל את מסך הטעינה
	call closeSpeaker ; סוגר את הספיקר
	call clearkeyboardbuffer
	mov [Score], 0 	; מאפס את ניקוד השחקן
	mov [Speed], 150; מאפס את המהירות למהירות האיטית ביותר
	call initializeClock ;מאפס את השעון	
	call BoardDrawer ; מצייר את הלוח
	push 31h ;green
	call Draw_Middle_Oblong ; מצייר את המלבן העליון באמצע המסך


	TurtleSpeed: ; לולאת המשחק
		call Regular_Things ;כל הדברים הרגילים שמתרחשים בכל מוד, הגרלת קוביה אקראית, הורדה שלה, ובדיקה אם שורה הושלמה או לא
		call endGameCheck  ; בודק אם המשתמש הפסיד וקוביה נגעה בחלקו העליון של הלוח
		cmp dx, 1 
	je End_TurtleSpeed
	
	jmp TurtleSpeed	; סיום לולאת המשחק
	
	End_TurtleSpeed:
		call updateBest ; בודק אם המשתמש שבר את השיא שלו
	ret
endp TurtleSpeed_Mood
	
;=============================================================================================================================================	
		
;מוד בו המשחק ממש ממש מהיר
proc SuperHard_Mood
	mov [mode], 3
	call mouse ; מכבה את העכבר
	call closeSpeaker ; סוגר את הספיקר
	call Loading ; מפעיל את מסך הטעינה
	call closeSpeaker ; סוגר את הספיקר
	call clearkeyboardbuffer
	mov [Score], 0 ; מאפס את ניקוד השחקן
	mov [Speed], 30	; מאפס את המהירות למהירות מהירה מאוד מאוד
	call initializeClock ;מאפס את השעון	
	call BoardDrawer ; מצייר את הלוח
	push 0Fh ;red
	call Draw_Middle_Oblong ; מצייר את המלבן העליון באמצע המסך


	SuperHard: ; לולאת המשחק
		call Regular_Things ;כל הדברים הרגילים שמתרחשים בכל מוד, הגרלת קוביה אקראית, הורדה שלה, ובדיקה אם שורה הושלמה או לא
		call endGameCheck  ; בודק אם המשתמש הפסיד וקוביה נגעה בחלקו העליון של הלוח
		cmp dx, 1 
	je End_SuperHard
	
	jmp SuperHard ; סיום לולאת המשחק
	
	End_SuperHard:
		call updateBest ; בודק אם המשתמש שבר את השיא שלו
	ret
endp SuperHard_Mood
	
;=============================================================================================================================================	
		
; מוד בו כל הקוביות בכחול אדום
proc Spiderman_Mood
	mov [mode], 4
	call mouse ; מכבה את העכבר
	call closeSpeaker ; סוגר את הספיקר
	call Loading ; מפעיל את מסך הטעינה
	call closeSpeaker ; סוגר את הספיקר
	call clearkeyboardbuffer
	mov [Score], 0 ; מאפס את ניקוד השחקן
	mov [Speed], 100; מאפס את המהירות למהירות ממוצעת
	call initializeClock ;מאפס את השעון	
	call BoardDrawer; מצייר את הלוח
	push 0C0h ; blue
	call Draw_Middle_Oblong ; מצייר את המלבן העליון באמצע המסך

	mov [Spiderman_check], 1 ; 	התחיל המשחק של ספיידרמן- סימון

	Spiderman:; לולאת המשחק
		call GetRandomCube ;מגריל קוביה אקראית
		call changeToRedOrBlue ;change the color of the cube to blue or red randomly
		call cube_Starts; קוביה יורדת ופועלת כמו שצריך עד שנעצרת בנחיתה על משטח
		call destroyLinesCheck  ;בודק אם המשתמש השלים שורה ופועל בהתאם
		call endGameCheck  ; בודק אם המשתמש הפסיד וקוביה נגעה בחלקו העליון של הלוח
		cmp dx, 1 
	je End_Spiderman
	
	jmp Spiderman; סיום לולאת המשחק
	
	End_Spiderman:
		mov [Spiderman_check], 0;מגצר המשחק של הכחול אדום- ספיידרמן
		call updateBest ; בודק אם המשתמש שבר את השיא שלו
	ret
endp Spiderman_Mood
	
;=============================================================================================================================================	
		
;מוד בו קיימת קוביה של אחד על אחד
proc OneByOne_Mood
	mov [mode], 5
	call mouse ; מכבה את העכבר
	call closeSpeaker ; סוגר את הספיקר
	call Loading ; מפעיל את מסך הטעינה
	call closeSpeaker ; סוגר את הספיקר
	call clearkeyboardbuffer
	mov [Score], 0 	; מאפס את ניקוד השחקן
	mov [Speed], 90 ; מאפס את המהירות למהירות מהירה יחסית
	call initializeClock ;מאפס את השעון
	call BoardDrawer ; מצייר את הלוח
	push 0FBh ;yellow
	call Draw_Middle_Oblong; מצייר את המלבן העליון באמצע המסך

	mov [OneByOne_check], 1; התחיל המוד של הקוביה האחת

	OneByOne__: ; לולאת המשחק
		call Regular_Things;כל הדברים הרגילים שמתרחשים בכל מוד, הגרלת קוביה אקראית, הורדה שלה, ובדיקה אם שורה הושלמה או לא
		call endGameCheck; בודק אם המשתמש הפסיד וקוביה נגעה בחלקו העליון של הלוח
		cmp dx, 1 
		je End_OneByOne
	jmp OneByOne__; סיום לולאת המשחק
	
	End_OneByOne:
		mov [OneByOne_check], 0 ; נגמר המוד של הקוביה האחת
		call updateBest ; בודק אם המשתמש שבר את השיא שלו
	ret
endp OneByOne_Mood
	
;=============================================================================================================================================	
		
;מוד בו קוביות נמצאות על המסך כמכשולים באופן רנדומלי
proc CrazyBoard_Mood
	mov [mode], 6
	call mouse ; מכבה את העכבר
	call closeSpeaker ; סוגר את הספיקר
	call Loading ; מפעיל את מסך הטעינה
	
	call clearkeyboardbuffer
	mov [Score], 0 ; מאפס את ניקוד השחקן
	mov [Speed], 130 ; מאפס את המהירות למהירות איטית
	call initializeClock ;מאפס את השעון
	call BoardDrawer ; מצייר את הלוח
	push 9h ;blue grey
	call Draw_Middle_Oblong ; מצייר את המלבן העליון באמצע המסך
	call drawCrazyBoard
	call clearkeyboardbuffer

	CrazyBoard__: ; לולאת המשחק
		call Regular_Things ;כל הדברים הרגילים שמתרחשים בכל מוד, הגרלת קוביה אקראית, הורדה שלה, ובדיקה אם שורה הושלמה או לא
		call endGameCheck ; בודק אם המשתמש הפסיד וקוביה נגעה בחלקו העליון של הלוח
		cmp dx, 1 
		je End_CrazyBoard
	jmp CrazyBoard__ ; סיום לולאת המשחק
	
	End_CrazyBoard:
		call updateBest ; בודק אם המשתמש שבר את השיא שלו
	ret
endp CrazyBoard_Mood
	
;=============================================================================================================================================	
	
; מוד בו השחקן לא יכול לסובב את הקוביות שלו
proc NoRorations_Mood
	mov [mode], 7
	call mouse ; מכבה את העכבר
	call closeSpeaker ; סוגר את הספיקר
	call Loading ; מפעיל את מסך הטעינה
	call closeSpeaker ; סוגר את הספיקר
	call clearkeyboardbuffer
	mov [Score], 0 ; מאפס את ניקוד השחקן
	mov [Speed], 100 ; מאפס את המהירות למהירות ממוצעת
	call initializeClock ;מאפס את השעון	
	call BoardDrawer ; מצייר את הלוח
	push 0FEh ;cyan
	call Draw_Middle_Oblong ; מצייר את המלבן העליון באמצע המסך
	mov [NoRorations_check], 1 ; התחיל המשחק ללא הסיבובים

	NoRorations: ; לולאת המשחק
		call Regular_Things ;כל הדברים הרגילים שמתרחשים בכל מוד, הגרלת קוביה אקראית, הורדה שלה, ובדיקה אם שורה הושלמה או לא
		call endGameCheck ; בודק אם המשתמש הפסיד וקוביה נגעה בחלקו העליון של הלוח
		cmp dx, 1 
		je End_NoRorations
	jmp NoRorations ; סיום לולאת המשחק
	
	End_NoRorations:
		mov [NoRorations_check], 0 ; נגמר המשחק ללא הסיבובים
		call updateBest ; בודק אם המשתמש שבר את השיא שלו
	ret
endp NoRorations_Mood
	
;=============================================================================================================================================	
	
; מוד בו כל הקוביות בכחול לבן- ישראל
proc Israel_Mood
	mov [mode], 8
	call mouse ; מכבה את העכבר
	call closeSpeaker ; סוגר את הספיקר
	call Loading ; מפעיל את מסך הטעינה
	call closeSpeaker ; סוגר את הספיקר
	call clearkeyboardbuffer
	mov [Score], 0 ; מאפס את ניקוד השחקן
	mov [Speed], 80 ; מאפס את המהירות למהירות מהירה
	call initializeClock ;מאפס את השעון	
	call BoardDrawer 										; מצייר את הלוח
	push 0FFh ;white
	call Draw_Middle_Oblong 								; מצייר את המלבן העליון באמצע המסך
	mov [Israel_check], 1 							; התחיל המשחק של השחור לבן

	Israel: ; לולאת המשחק
		call GetRandomCube ;מגריל קוביה אקראית
		call changeToWhiteOrBlue ;change the color of the cube to blue or white randomly
		call cube_Starts ; קוביה יורדת ופועלת כמו שצריך עד שנעצרת בנחיתה על משטח
		call destroyLinesCheck ; בודק אם המשתמש השלים שורה ופועל בהתאם
		call endGameCheck ; בודק אם המשתמש הפסיד וקוביה נגעה בחלקו העליון של הלוח
		cmp dx, 1 
		je End_Israel
	jmp Israel ; סיום לולאת המשחק
	
	End_Israel:
		mov [Israel_check], 0 ; נגמר המשחק של ישראל
		call updateBest ; בודק אם המשתמש שבר את השיא שלו
	ret
endp Israel_Mood

;=============================================================================================================================================		
	
; מוד בו הלוח קטן מן הרגיל
proc TinyBoard_Mood
	mov [mode], 9
	call mouse ; מכבה את העכבר
	call closeSpeaker ; סוגר את הספיקר
	call Loading ; מפעיל את מסך הטעינה
	call closeSpeaker ; סוגר את הספיקר
	call clearkeyboardbuffer
	mov [Score], 0 ; מאפס את ניקוד השחקן
	mov [Speed], 100 ; מאפס את המהירות למהירות ממוצעת
	call initializeClock ;מאפס את השעון	
	call BoardDrawer ; מצייר את הלוח
	push 027h ;orange
	call Draw_Middle_Oblong ; מצייר את המלבן העליון באמצע המסך
	call MakeTheBoardSmaller ;מקטין את הלוח
	call printTetrisTinyBoard ;כותב את המילה טטריס בתחתית המסך
	
	TinyBoard: ; לולאת המשחק
		call Regular_Things ;כל הדברים הרגילים שמתרחשים בכל מוד, הגרלת קוביה אקראית, הורדה שלה, ובדיקה אם שורה הושלמה או לא
		call endGameCheck ; בודק אם המשתמש הפסיד וקוביה נגעה בחלקו העליון של הלוח
		cmp dx, 1 
		je End_TinyBoard
	jmp TinyBoard ; סיום לולאת המשחק
	
	End_TinyBoard:
		call updateBest ; בודק אם המשתמש שבר את השיא שלו
	ret
endp TinyBoard_Mood

;=============================================================================================================================================	
		
; פרוצדורה שעושה את כל הדברים הרגילים שמתרחשים בכל מוד, הגרלת קוביה אקראית, הורדה שלה, ובדיקה אם שורה הושלמה או לא
proc Regular_Things
	call GetRandomCube ;מגריל קוביה אקראית
	call cube_Starts ; קוביה יורדת ופועלת כמו שצריך עד שנעצרת בנחיתה על משטח
	call destroyLinesCheck ; בודק אם המשתמש השלים שורה ופועל בהתאם
	ret
endp Regular_Things

;=============================================================================================================================================		
		
; פרוצדורה שמגרילה קוביה אקראית ואחראית על התזוזה שלה ימינה שמאלה למטה וסיבובים מהרגע שהקוביה נוצרה ועד שנחתה על משטח
proc cube_Starts
			push [addX] ; כמה להוסיף לערך האיקס של הקוביה כדי שהיא לא תיגע בקצה מצד שמאל
			push [rangeX] ; 10 = 150, 9 = 140, 8 = 130, 7 = 120, 6 = 110, 5 = 100, 4 = 90, 3 = 80, 2 = 70
			call getCubeStartingPointX ;מחזיר ערך איקס שהקוביה יכולה לצאת ממנו

		cube_:
			; קובע את ההגדרות של הקוביה שתיווצר
			mov ax, [Xstart]	
			mov [xCube], ax	; X of the cube: 60/70/80/90/100/110/120/130/140/150
			mov ax, [startingY]
			mov [yCube], ax ;17/27/37
			
			call CreateCheck ;בודק אם הקוביה יכולה להיווצר במקום הספציפי שבו היא תוכננה
			cmp dx, 0 ;אם הקוביה יכולה להיווצר ולא תעלה על קוביה אחרת
			je CreateAndmoveCube ; אז המשך את המשחק כרגיל
			;else...
			call drawAllCubes ; draw the cube
		ret ; אחרת סיים את המשחק
			
			CreateAndmoveCube:
				call drawAllCubes ; draw the cube
				
			moveCube: ; move down the cube
				call BoardClock ; מדפיס את הזמן של השעון
				call UpdateInternalClock ;מעדכן את השעון
				call printScore	; מדפיס את ניקוד השחקן
				call printBest	; מדפיס את שיא השחקן	
				call printMode	; מדפיס את המוד בו השחקן משחק
				call printTetris ;מדפיס את המילה טטריס	
				mov [touchingCheck], 0			
				mov [SaveIt], dl ; dx מגבה את 
				
				call Movment_Cube ; מזיז את הקוביה לצדדים לפי קלט
				
				cmp [touchingCheck], 1
				je stopMovingCube_
				
				;:קטע קוד שאחראי לבדוק מתי עברה שנייה				
				
				mov dl,  [SaveIt] ;  מוציא את די איקס מגיבוי
				call readTime ;בודק את הזמן
			
				mov [newMiliseconds], dl
				
				cmp dl, [miliSeconds]
				jb add100_
				jmp fine_
				
				add100_:
					add dl, 100 ; מוסיף 100 למאיות השנייה כדי שתרגיל החיסור יתבצע כהלכה
				fine_:
					sub dl, [miliSeconds]
					xor dh, dh
					sub [timer], dx
					sub [RotateTimer], dx
			
					mov dl, [newMiliseconds]
					mov [miliSeconds], dl
					cmp [timer], 0
			jge moveCube

			SecondPast_:
				call Movment_Cube ; מזיז את הקוביה לצדדים לפי קלט
				call clearkeyboardbuffer ;מנקה את הבאפר
				
				call MoveDown ; מוריד את הקוביה משבצת

				cmp dx, 1 ; אם היא כן נגעה
				je stopMovingCube_ ; אז תפסיק להניע את הקוביה
					
				cmp [touchingCheck], 1 ; בודק אם הקוביה כבר נחתה על משהו
				je YesItTouched_ ;אם הקוביה נגעה
				
					
				YesItTouched_:
					mov ax, [Speed]
					mov [timer], ax; מאפס את הטיימר
					
			jmp moveCube ; אם היא לא נגעה המשך להניע אותה
					
			stopMovingCube_: ; הפסק להניע את הקוביה
				mov ax, [Speed]
				mov [timer], ax ; מאפס את הטיימר
				call clearkeyboardbuffer ;מנקה את הבאפר
				call drawAllCubes ; draw the cube
	ret
endp cube_Starts
	
;=============================================================================================================================================		

; מגריל מספר אקראי שישמש כערך איקס לקוביה שזה עתה יוצאת
addToX equ [word ptr bp + 6] ; כמה להוסיף לערך האיקס של הקוביה כדי שהיא לא תיגע בקצה מצד שמאל
range equ [byte ptr bp + 4]; 10 = 150, 9 = 140, 8 = 130, 7 = 120, 6 = 110, 5 = 100, 4 = 90, 3 = 80, 2 = 70
proc getCubeStartingPointX
		push bp ;backup
		mov bp, sp 
		PushAll ;backup
		
		mov [Xstart],0
		mov ah, 2ch
		int 21h ;get clock millisecs and put it in dl
		xor dh,dh
		mov al, 17
		mul dl				;
		mov ax,dx
		
		mov bl, range
		div bl ;divid the random number with 6 and put the reminder in ah
		
		mov bl, ah
		mov al, 10
		mul bl
	
		mov [Xstart], ax
		add [Xstart], 60
		mov ax, addToX
		add [Xstart], ax
		PopAll ;backup
		pop bp ;backup
	ret 4
endp getCubeStartingPointX
	
;=============================================================================================================================================	
		
; מגריל קוביה ומצב קוביה באופן רנדומלי לחלוטין
proc GetRandomCube
	cmp [OneByOne_check], 1
	jne regular
	onebyone: ; במוד הקוביה של אחת על אחת יש 8 קוביות מוגרלות במקום 7
		call TheNextCubeToPlay_OneByOne ; dl = מספר הקוביה האקראי שהוגרל
	jmp everygame
	regular:
		call TheNextCubeToPlay ; dl = מספר הקוביה האקראי שהוגרל
	everygame:
		mov [NumOfCube], dl ;מעבירים את מספר הקוביה למשתנה שאמור להכיל את מספר הקוביה
		mov [position], 1 ; מגדירים את מצב הקוביה ל1 לצורך בדיקה עתידית
		call Calculate_Cube_Num ;מחשב את המספר של הקוביה
		push [CUBEfinal] ; דוחף את הקוביה במצב שלה. ספרת היחידות זה מהצב וספרת העשרות זה מספר הקוביה
		call SetCube ;קובע את מצב הקוביה לקוביה אקראית במצב אחד
		cmp [NumOfStates], 1 ;בודק את מספר המצבים שיש לקוביה כדי לשנות את מהצב למספר רנדומלי
		je calculate ;אם שווה לקוביה אחת שיש לה רק מצב אחד אין צורך להגריל מספר רנדומלי
		cmp [NumOfStates], 4 ;בודק את מספר המצבים שיש לקוביה כדי לשנות את מהצב למספר רנדומלי
		jne TwoStates ; אם יש לקוביה שתי מצבים ולא ארבע אז קופץ להגרלת שני מצבים
		FourStates: ;ארבע מצבים
			call TheNextPositionToPlay4 ; מגריל מספר אקראי בין 1 ל4
			jmp SetBeforeCalculate ; קופץ לחישוב הקוביה שנבחרה
		TwoStates: ;שני מצבים
			call TheNextPositionToPlay2 ; מגריל מספר בין 1 ל2
		SetBeforeCalculate:
			mov [position], dl
			calculate:
				call Calculate_Cube_Num ;מחשב את המספר של הקוביה
				push [CUBEfinal] ; דוחף את הקוביה במצב שלה. ספרת היחידות זה מהצב וספרת העשרות זה מספר הקוביה
				call SetCube
				push [CUBEfinal] ; דוחף את הקוביה במצב שלה. ספרת היחידות זה מהצב וספרת העשרות זה מספר הקוביה
				call SetCube8 ; במקרה ועכשיו אנחנו במוד הקוביה האחץ, והיא הקוביה שיצאה, זאת הפעולה שתאפס אותה
	ret
endp GetRandomCube
	
;=============================================================================================================================================	

; מגריל מספר אקראי בין 1 ל7 שימש למספר הקוביה שתיבחר
proc TheNextCubeToPlay 
	; generate a rand no using the system time
	RANDSTART7:
		MOV AH, 00h  ; interrupts to get system time        
		INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

		mov  ax, dx
		xor  dx, dx
		mov bl, 17
		mul bl
		mov cx, ax
		mov  cx, 7   
		div  cx       ; here dx contains the remainder of the division - from 0 to 7
		inc dl
	ret
endp TheNextCubeToPlay ; dl = מספר הקוביה האקראי שהוגרל
	
;=============================================================================================================================================	
		
; מגריל מספר בין 1 ל2 עבור קוביות בעלות שני מצבים
proc TheNextPositionToPlay2
	; generate a rand no using the system time
	RANDSTART2:
		MOV AH, 00h  ; interrupts to get system time        
		INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

		mov  ax, dx
		xor  dx, dx
		mov bl, 17
		mul bl
		mov cx, ax
		mov  cx, 2  
		div  cx       ; here dx contains the remainder of the division - from 0 to 2
		inc dl
	ret
endp TheNextPositionToPlay2 ; dl = מספר הקוביה האקראי שהוגרל
	
;=============================================================================================================================================
	
; מגריל מספר אקראי בין 1 ל4 למצב הקוביה עבור קוביות בעלות ארבעה מצבים
proc TheNextPositionToPlay4
	; generate a rand no using the system time
	RANDSTART4:
		MOV AH, 00h  ; interrupts to get system time        
		INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

		mov  ax, dx
		xor  dx, dx
		mov bl, 17
		mul bl
		mov cx, ax
		mov  cx, 4  
		div  cx       ; here dx contains the remainder of the division - from 0 to 4
		inc dl
	ret
endp TheNextPositionToPlay4 ; dl = מספר הקוביה האקראי שהוגרל
	
;=============================================================================================================================================

; מכפיל את מספר הקוביה בעשר ומוסיף לזה את מספר הקוביה, את זה מכניס לתוך משתנה בשם קוביה
proc Calculate_Cube_Num
	xor ax, ax
	mov al, [NumOfCube]

	mov bl, 10
	mul bl

	add al, [position]
	mov [CUBEfinal], ax
	ret
endp Calculate_Cube_Num ;ספרת היחידות- מצב הקוביה, ספרת העשרות- סוג הקוביה
	
;=============================================================================================================================================

cube equ [word ptr bp + 4] ;ספרת העשרות מייצגת את הקוביה וספרת היחידות מייצגת את מצב הקוביה
;פרוצדורה שמקבלת  קוביה ומאתחלת את ערכיה בהתאם לקוביה שנבחרה
proc SetCube
	push bp ;backup
	mov bp, sp

	; ##
	; ##:
	cmp cube, 11
	je Cube1_Pos1
	
	; ####:
	cmp cube, 21
	je Cube2_Pos1
	cmp cube, 22
	je Cube2_Pos2
	cmp cube, 23
	je Cube2_Pos3
	cmp cube, 24
	je Cube2_Pos4

	;  #
	; ###:
	cmp cube, 31
	je Cube3_Pos1
	cmp cube, 32
	je Cube3_Pos2
	cmp cube, 33
	je Cube3_Pos3
	cmp cube, 34
	je Cube3_Pos4

	; ##
	;  ##:
	cmp cube, 41
	je Cube4_Pos1
	cmp cube, 42
	je Cube4_Pos2

	;  ##
	; ##:
	cmp cube, 51
	je Cube5_Pos1
	cmp cube, 52
	je Cube5_Pos2

	;   #
	; ###:
	cmp cube, 61
	je Cube6_Pos1
	cmp cube, 62
	je Cube6_Pos2
	cmp cube, 63
	je Cube6_Pos3
	cmp cube, 64
	je Cube6_Pos4

	; #
	; ###:
	cmp cube, 71
	je Cube7_Pos1
	cmp cube, 72
	je Cube7_Pos2
	cmp cube, 73
	je Cube7_Pos3
	cmp cube, 74
	je Cube7_Pos4

	
	Cube1_Pos1: ;Set cube 1 pos 1
		call Set_Cube1_Pos1
	jmp TheEnd
	
	Cube2_Pos1: ;Set cube 2 pos 1
		call Set_Cube2_Pos1
	jmp TheEnd
	
	Cube2_Pos2: ;Set cube 2 pos 2
		call Set_Cube2_Pos2
	jmp TheEnd
	
	Cube2_Pos3: ;Set cube 2 pos 3
		call Set_Cube2_Pos3
	jmp TheEnd
	
	Cube2_Pos4: ;Set cube 2 pos 4
		call Set_Cube2_Pos4
	jmp TheEnd

	Cube3_Pos1: ;Set cube 3 pos 1
		call Set_Cube3_Pos1
	jmp TheEnd
	
	Cube3_Pos2: ;Set cube 3 pos 2
		call Set_Cube3_Pos2
	jmp TheEnd
	
	Cube3_Pos3: ;Set cube 3 pos 3
		call Set_Cube3_Pos3
	jmp TheEnd
	
	Cube3_Pos4: ;Set cube 3 pos 4
		call Set_Cube3_Pos4
	jmp TheEnd
	
	Cube4_Pos1: ;Set cube 4 pos 1
		call Set_Cube4_Pos1
	jmp TheEnd
	
	Cube4_Pos2: ;Set cube 4 pos 2
		call Set_Cube4_Pos2
	jmp TheEnd
	
	Cube5_Pos1: ;Set cube 5 pos 1
		call Set_Cube5_Pos1
	jmp TheEnd
	
	Cube5_Pos2: ;Set cube 5 pos 2
		call Set_Cube5_Pos2
	jmp TheEnd
	
	Cube6_Pos1: ;Set cube 6 pos 1
		call Set_Cube6_Pos1
	jmp TheEnd
	
	Cube6_Pos2: ;Set cube 6 pos 2
		call Set_Cube6_Pos2
	jmp TheEnd
	
	Cube6_Pos3: ;Set cube 6 pos 3
		call Set_Cube6_Pos3
	jmp TheEnd
	
	Cube6_Pos4: ;Set cube 6 pos 4
		call Set_Cube6_Pos4
	jmp TheEnd
	
	Cube7_Pos1: ;Set cube 7 pos 1
		call Set_Cube7_Pos1
	jmp TheEnd
	
	Cube7_Pos2: ;Set cube 7 pos 2
		call Set_Cube7_Pos2
	jmp TheEnd

	Cube7_Pos3: ;Set cube 7 pos 3
		call Set_Cube7_Pos3
	jmp TheEnd

	Cube7_Pos4: ;Set cube 7 pos 4
		call Set_Cube7_Pos4
	jmp TheEnd

	TheEnd:
	pop bp ;backup
	
	ret 2
endp SetCube
	
;=============================================================================================================================================	

; פרוצדורה שאחראית להזיז את הקוביה לפי קלט המשתמש
proc Movment_Cube

	xor ax, ax
	ToGetTav ; לוקח את התו אחרון שנמצא בבאפר

	cmp ah, 4dh ;right
	je key

	cmp ah, 4bh ;left
	je key
	
	cmp ah, 50h ;down
	je key
	
	cmp ah, 48h ;up
	je key

	cmp al, 'd' ;right
	je key

	cmp al, 'a' ;left
	je key
	
	cmp al,'s' ;down
	je key
	
	cmp al,'w' ;up
	je key

	ret

	key:
		mov ah,00h
		int 16h

		mov [k],ah ; arrows checking

		cmp [k], 4dh ;right
		je right
		
		cmp [k], 4bh ;left
		je left
		
		cmp [k], 50h ;down
		je down
		
		cmp [k], 48h ;up
		je rotate
	
		mov [k],al ; letters checking
		
		cmp [k], 'd' ;right
		je right
		
		cmp [k], 'a' ;left
		je left
		
		cmp [k],'s' ;down
		je down
		
		cmp [k],'w' ;up
		je rotate
	
	 ; פועל בתהאם לתו שקיבלנו
	
	right: ; right
		call MoveRight
	ret

	left: ; left
		call MoveLeft
	ret
		
	down: ; down
		call MoveDown
	ret
		
	rotate: ; switch position / rotate cube
		call RotateCube
	ret	
	ret
endp Movment_Cube
	
;=============================================================================================================================================	

;מזיז את הקוביה לצד ימין תוך בדיקה אם הקוביה אכן יכולה לזוז, אם היא לא הקוביה לא תנוע
proc MoveRight
		cmp [touchingCheck], 1 ; בדיקה אם הקוביה נחתה על משהו
		jne DoNotRet_R
	ret
		DoNotRet_R:
			xor dx, dx

		;Part1
			push 1 ;right checking
			push [Right_AddToY1]  ; המספר שצריך להוסיף לוואי כדי להגיע לנקודת ההתחלה של הצלע שבודקים
			push [Right_sideLength1] ; אורך הצלע שבודקים
			push [Right_distance1] ; המרחק האופקי מראשית הקוביה שבודקים
			call cube_touched_Left_Or_Right ; בודק אם הקוביה נגעה במשהו מהצד
		
			cmp [Right_Parts], 1
			je TheCheck_Right
			
		;Part2
			push 1 ;right checking
			push [Right_AddToY2]  ; המספר שצריך להוסיף לוואי כדי להגיע לנקודת ההתחלה של הצלע שבודקים
			push [Right_sideLength2] ; אורך הצלע שבודקים
			push [Right_distance2] ; המרחק האופקי מראשית הקוביה שבודקים
			call cube_touched_Left_Or_Right ; בודק אם הקוביה נגעה במשהו מהצד
			
			cmp [Right_Parts], 2
			je TheCheck_Right
			
		;Part3
			push 1 ;right checking
			push [Right_AddToY3]  ; המספר שצריך להוסיף לוואי כדי להגיע לנקודת ההתחלה של הצלע שבודקים
			push [Right_sideLength3] ; אורך הצלע שבודקים
			push [Right_distance3] ; המרחק האופקי מראשית הקוביה שבודקים
			call cube_touched_Left_Or_Right ; בודק אם הקוביה נגעה במשהו מהצד
		
		TheCheck_Right:
			cmp dx, 1 ; בדיקה עם הקוביה נגעה במשהו מצד ימין
			jne NotRet_R
		ret
		NotRet_R:
			call drawAllCubes_BackGround ; מצייר את הרקע מחדש
			add [xCube], 10 ; מזיז את הקוביה ימינה
			call drawAllCubes ; מצייר את הקוביה מחדש
	ret
endp MoveRight
	
;=============================================================================================================================================	

;מזיז את הקוביה לצד שמאל תוך בדיקה אם הקוביה אכן יכולה לזוז, אם היא לא הקוביה לא תנוע
proc MoveLeft
		cmp [touchingCheck], 1 ; בדיקה אם הקוביה נחתה על משהו
		jne DoNotRet_L
	ret
		DoNotRet_L:
			xor dx, dx

		;Part1
			push 0 ;left checking
			push [Left_AddToY1]  ; המספר שצריך להוסיף לוואי כדי להגיע לנקודת ההתחלה של הצלע שבודקים
			push [Left_sideLength1] ; אורך הצלע שבודקים
			push [Left_distance1] ; המרחק האופקי מראשית הקוביה שבודקים
			call cube_touched_Left_Or_Right ; בודק אם הקוביה נגעה במשהו מהצד
			
			cmp [Left_Parts], 1
			je TheCheck_Left
			
		;Part2
			push 0 ;left checking
			push [Left_AddToY2]  ; המספר שצריך להוסיף לוואי כדי להגיע לנקודת ההתחלה של הצלע שבודקים
			push [Left_sideLength2] ; אורך הצלע שבודקים
			push [Left_distance2] ; המרחק האופקי מראשית הקוביה שבודקים
			call cube_touched_Left_Or_Right ; בודק אם הקוביה נגעה במשהו מהצד
			
			cmp [Left_Parts], 2
			je TheCheck_Left
			
		;Part3
			push 0 ;left checking
			push [Left_AddToY3]  ; המספר שצריך להוסיף לוואי כדי להגיע לנקודת ההתחלה של הצלע שבודקים
			push [Left_sideLength3] ; אורך הצלע שבודקים
			push [Left_distance3] ; המרחק האופקי מראשית הקוביה שבודקים
			call cube_touched_Left_Or_Right ; בודק אם הקוביה נגעה במשהו מהצד
			
		TheCheck_Left:
			cmp dx, 1 ; בדיקה עם הקוביה נגעה במשהו מצד ימין
			jne NotRet_L
		ret
		NotRet_L:
			call drawAllCubes_BackGround ; מצייר את הרקע מחדש
			sub [xCube], 10 ; מזיז את הקוביה ימינה
			call drawAllCubes ; מצייר את הקוביה מחדש
		
	ret
endp MoveLeft
	
;=============================================================================================================================================	

; מזיז את הקוביה למטה תוך בדיקה אם זה אפשרי, אם כן הקוביה תירד ואם לא היא לא תנוע		
proc MoveDown
	xor dx, dx
	
;part1:
	push [Floor_AddToX1] ; המספר שצריך להוסיף לאיקס כדי להגיע לנקודת ההתחלה של הצלע שבודקים
	push [Floor_sideLength1]  ; אורך הבסיס שבודקים
	push [Floor_distance1] ; המרחק האנכי מראשית הקוביה שבודקים
	call cube_Touched_Floor_Check
		
	cmp [Floor_Parts],1
	je TheCheck_Floor
	
;part2:	
	push [Floor_AddToX2] ; המספר שצריך להוסיף לאיקס כדי להגיע לנקודת ההתחלה של הצלע שבודקים
	push [Floor_sideLength2]  ; אורך הבסיס שבודקים
	push [Floor_distance2] ; המרחק האנכי מראשית הקוביה שבודקים
	call cube_Touched_Floor_Check
		
	cmp [Floor_Parts],2
	je TheCheck_Floor
	
;part3:
	push [Floor_AddToX3] ; המספר שצריך להוסיף לאיקס כדי להגיע לנקודת ההתחלה של הצלע שבודקים
	push [Floor_sideLength3]  ; אורך הבסיס שבודקים
	push [Floor_distance3] ; המרחק האנכי מראשית הקוביה שבודקים
	call cube_Touched_Floor_Check
	
	TheCheck_Floor:
		cmp dx, 1 ; אם היא כן נגעה
		je DoNotMove ; אל תרד למטה
		call moveDownCube ; פרוצדורה שמורידה את הקוביה למטה
	DoNotMove:
		mov [touchingCheck], dx 
	ret
endp MoveDown
	
;=============================================================================================================================================	

; פרוצדורה שמורידה את הקוביה למטה
proc moveDownCube
		call drawAllCubes_BackGround ; מצייר את הרקע מחדש
		add [yCube], 10 ; מזיז את הקוביה למטה
		call drawAllCubes ; מצייר את הקוביה מחדש
	ret
endp moveDownCube
	
;=============================================================================================================================================	

; בודק אם הקוביה מסוגלת להסתובב בלי לעלות על דברים אחרים ואם כן מסובב אותה
proc RotateCube
		cmp [NoRorations_check], 1 ;בודק אם המשתמש נמצא במוד בו אי אפשר להסתובב ואם כן לא מסובב את הקוביה
		je retTime
		
		call RotateCheck ; בודק אם הקוביה יכולה להסתובב
		cmp dx, 1
		je retTime ; אם לא מפסיק את הסיבוב

		cmp [RotateTimer], 0
		jge retTime
		mov [RotateTimer], 2 

		call drawALLCubes_BackGround
	
		inc [position]
		
		call FixPosition ;make sure that [position] equals to the next [position]
		call Calculate_Cube_Num ;מחשב את המספר של הקוביה
		push [CUBEfinal] ; דוחף את הקוביה במצב שלה. ספרת היחידות זה מהצב וספרת העשרות זה מספר הקוביה
		call SetCube
		
		cmp [Israel_check], 1 ;בודק אם המוד שהשחקן משחק בו הוא מוד ישראל או לא
		jne Next_Check1 ; אם לא לא משתנה דבר אך אחרת...
		call changeToWhiteOrBlue ;change the color of the cube to blue or white randomly
		
		Next_Check1:
			cmp [Spiderman_check], 1 ; בודק אם השחקן משחק במוד הספיידרמן
			jne StayInSameColor ; אם לא לא משתנה דבר אך אחרת...
			call changeToRedOrBlue ;change the color of the cube to red or blue randomly
		
		StayInSameColor:
			call drawALLCubes
		
		retTime:
	ret
endp RotateCube
	
;=============================================================================================================================================	

RightOrLeft equ [ word ptr bp + 10 ] ;1 - for right ||| 0 - for left
starting_Point equ [ word ptr bp + 8 ] ; המספר שצריך להוסיף לוואי כדי להגיע לנקודת ההתחלה של הצלע שבודקים
length_Side equ [ word ptr bp + 6 ] ; אורך הצלע שבודקים
disstance equ [ word ptr bp + 4 ] ; לצד שמאל תמיד מכניסים 0, לצד ימין מכניסים את רוחב הקוביה

; פרוצדורה שבודקת אם קוביה נגעה במשהו מצד ימין או שמאל
proc cube_touched_Left_Or_Right
	push bp ;backup
	mov bp, sp

	xor ax, ax ; מאפס
	xor bx, bx ; מאפס
	xor cx, cx ; מאפס
	
	mov ax, starting_Point
	add [yCube], ax
	
	mov cx, [yCube] ; מעביר לסי איקס את ערך הוואי של הקוביה
	
	add cx, length_Side ; מוסיף לכי איקס את אורך הצלע השמאלית או הימנית של הקוביה שבודקים
	dec cx ; מחסר מסי איקס אחד לצורך הבדיקה
	mov bx, [xCube] ; מעבירים לבי איקס את ערך האיקס של הקוביה
    
	add bx, disstance
	
	cmp RightOrLeft, 1
	je rightCheck
	
	leftCheck:
		dec bx	
	jmp checkEverySinglePixel
	
	rightCheck:
		inc bx

	checkEverySinglePixel:
		push bx
		push cx
		call getPixel ;בודק את צבע הפיקסל

		cmp al, 7h ;grey
		jne changeTo_Yes
		all_right:
			dec cx
			cmp cx, [yCube]
	jne checkEverySinglePixel
	jmp stopIt
	
	changeTo_Yes:
		cmp al, 0ffh;29 ;קובע צבע
		jne changeTo__Yes
	jmp all_right
	
	changeTo__Yes:
		mov dx, 1
		
	stopIt:
		xor ax, ax
		mov ax, starting_Point
		sub [yCube], ax
		pop bp ;backup
	ret 8
endp cube_touched_Left_Or_Right ; dx = 1 - yes \ dx = 0 - no
	
;=============================================================================================================================================	
		
starting_Point equ [ word ptr bp + 8 ] ; המספר שצריך להוסיף לאיקס כדי הגיע לנקודת ההתחלה של הצלע שבודקים
length_Side equ [ word ptr bp + 6 ] ; אורך בסיס הקוביה
hight equ [ word ptr bp + 4 ] ; גובה הקוביה

;פרוצדורה שבודקת אם הקוביה נחתה על משהו 
proc cube_Touched_Floor_Check
	push bp ;backup
	mov bp, sp
	
	xor ax, ax
	mov ax, starting_Point
	add [xCube], ax
	
	mov cx, length_Side
	add cx, [xCube]
    dec cx
	mov bx, [yCube]
	add bx, hight
	inc bx

	ThisIsLoop_:
		push cx
		push bx
		call getPixel
		
		cmp al, 7h
		jne addOneTouchingCheck_1_
		ok_:
			dec cx
			cmp cx, [xCube]
	jne ThisIsLoop_
	jmp stop_
	
	addOneTouchingCheck_1_:
		cmp al,0ffh;29 ;קובע צבע
		jne addOneTouchingCheck_2_
	jmp ok_
	
	addOneTouchingCheck_2_:
		mov dx, 1
		
	stop_:
		xor ax, ax
		mov ax, starting_Point
		sub [xCube], ax
		
		pop bp ;backup
	ret 6
endp cube_Touched_Floor_Check ; dx = 1 - yes \ dx = 0 - no
	
;=============================================================================================================================================	
	
; בודק אם הקוביה יכולה להסתובב במקום הספציפי שבו היא נמצאת
proc RotateCheck
		xor dx, dx

	;part 1:
		mov ax, [xRotate1]
		add ax, [xCube]
		mov bx, [yRotate1]
		add bx, [yCube]
		add ax, 2
		add bx, 2

		push ax
		push bx
		call getPixel
		
		cmp al, 7 ;check if the color is grey
		jne ItCantRotate ;if it isn't jump to another check
	;part 2:
		mov ax, [xRotate2]
		add ax, [xCube]
		mov bx, [yRotate2]
		add bx, [yCube]
		add ax, 2
		add bx, 2

		push ax
		push bx
		call getPixel
		
		cmp al, 7 ;check if the color is grey
		jne ItCantRotate ;if it isn't jump to another check
	;part 3:
		mov ax, [xRotate3]
		add ax, [xCube]
		mov bx, [yRotate3]
		add bx, [yCube]
		add ax, 2
		add bx, 2
		
		push ax
		push bx
		call getPixel
		
		cmp al, 7 ;check if the color is grey
		jne ItCantRotate ;if it isn't jump to another check
		
		jmp ItCanRotate
		
		ItCantRotate:
			mov dx, 1
			
		ItCanRotate:
	ret
endp RotateCheck ; dx = 1 - can't rotate   |  dx = 0 - can rotate
	
;=============================================================================================================================================

; בודק אם הקוביה שעתידה להיווצר יכולה להיווצר במיקום הספציפי שבו היא צריכה בלי לעלות על קוביות אחרות
proc CreateCheck
		xor dx, dx
		
	;part 1:
		mov ax, [xCube1]
		add ax, [xCube]
		mov bx, [yCube1]
		add bx, [yCube]
		add ax, 5
		add bx, 5

		push ax
		push bx
		call getPixel
		
		cmp al, 7 ;check if the color is grey
		jne ItCantCreate ;if it isn't jump to another check
	;part 2:
		mov ax, [xCube2]
		add ax, [xCube]
		mov bx, [yCube2]
		add bx, [yCube]
		add ax, 5
		add bx, 5

		push ax
		push bx
		call getPixel
		
		cmp al, 7 ;check if the color is grey
		jne ItCantCreate ;if it isn't jump to another check
	;part 3:
		mov ax, [xCube3]
		add ax, [xCube]
		mov bx, [yCube3]
		add bx, [yCube]
		add ax, 5
		add bx, 5
		
		push ax
		push bx
		call getPixel
		
		cmp al, 7 ;check if the color is grey
		jne ItCantCreate ;if it isn't jump to another check
	;part 4:
		mov ax, [xCube4]
		add ax, [xCube]
		mov bx, [yCube4]
		add bx, [yCube]
		add ax, 5
		add bx, 5

		push ax
		push bx
		call getPixel
		
		cmp al, 7 ;check if the color is grey
		jne ItCantCreate ;if it isn't jump to another check

		jmp ItCanCreate
		
		ItCantCreate:
			mov dx, 1
			
		ItCanCreate:
	ret
endp CreateCheck ; dx = 1 - can't create   |  dx = 0 - can create

;=============================================================================================================================================
		
; פעולה שמוודאת כי כאשר הקוביה מסתובבת היא הופכת להיות הקוביה במצב הבא ולא משהו אחר
proc FixPosition

	cmp [NumOfStates], 1
	je Reset1 ; מתקן קוביה בעלת מצב 1
	cmp [NumOfStates], 2
	je Reset2 ; מתקן קוביה בעלת 2 מצבים
	cmp [NumOfStates], 4
	je Reset4 ; מתקן קוביה בעת 4 מצבים

	jmp TimeToRet

	reset1:
		cmp [position], 2
		jne TimeToRet
		mov [position], 1
	jmp TimeToRet

	reset2:
		cmp [position], 3
		jne TimeToRet
		mov [position], 1
	jmp TimeToRet

	reset4:
		cmp [position], 5
		jne TimeToRet
		mov [position], 1

	TimeToRet:
	ret
endp FixPosition
	
;=============================================================================================================================================		

LineToCheck equ [word ptr bp + 6] ; השורה שבודקים
WhereToStartDestroy equ [word ptr bp + 4] ; מאיפה להתחיל להוריד את כולם שורה

; מקבל שורה ובודק האם המשתמש השלים את השורה הזאת ואם כן משמיד אותה ומוריד את כל שאר השורות בהתאם
proc destroyOneLine
	push bp ;backup
	mov bp, sp
	PushAll ; Backup

	L:
		mov dx, 0
		mov cx, 159
		
		;בודק אם שורה הושלמה או לא
		startCheckPixel:
			push cx
			push LineToCheck ;מסמל את איזו שורה לבדוק
			call getPixel
			
			cmp al, 7 ;check if the color is grey
			je endLine ; a line wasn't completed
			
			cmp cx, 61
			je Line
			dec cx
		loop startCheckPixel
		
		; אם התוכנית הגיעה לפה, סימן שהשורה הושלמה ולכן יש לפעול בהתאם
		;משמיד את השורה ומוריד את כולם משבצת
		Line:
				
			inc [LinesCounter] ; סופר את מספר השורות שהושלמו כרגע
			cmp [Speed], 14 ; בודק אם המהירות הגיע לשיאה ואם עוד לא אז מגביר אותה
			jbe DoNotDecSpeed
			dec [Speed]
			DoNotDecSpeed:
				mov dx, WhereToStartDestroy ; מסמל מאיזו קוביה להתחיל להוריד
			rows_2:	
				
				call openSpeaker ; מפעיל זמזום
				call g_4
				mov cx, 160
				; מוריד את כל הפיקסלים במסך שורה למטה: 
				columns_2:
					push cx
					push dx
					call getPixel
					
					add dx, 10
					
					push cx
					push dx
					xor ah, ah
					push ax
					call drawPixel
					
					sub dx, 10
					
					dec cx
					cmp cx, 59
				jne columns_2
				dec dx
				cmp dx, 17
			jne rows_2
			
		endLine:
			call closeSpeaker ; סוגר זמזום
			
	PopAll
	pop bp ;backup
	ret 4
endp destroyOneLine
	
;=============================================================================================================================================	
		
; בודק על כל אחת מהשורות אם היא הושלמה ואם אחת כן אז משמיד אותה ומוריד את כל שאר השורות בהתאם
proc destroyLinesCheck
	mov [LinesCounter], 0 ; מאפס את מונה השורות שהושלמו

	;L2:
	push 32
	push 27
	call destroyOneLine
	;L3:
	push 42
	push 37
	call destroyOneLine
	;L4:
	push 52
	push 47
	call destroyOneLine
	;L5:
	push 62
	push 57
	call destroyOneLine
	;L6:
	push 72
	push 67
	call destroyOneLine
	;L7:
	push 82
	push 77
	call destroyOneLine
	;L8:
	push 92
	push 87
	call destroyOneLine
	;L9:
	push 102
	push 97
	call destroyOneLine
	;L10:
	push 112
	push 107
	call destroyOneLine
	;L11:
	push 122
	push 117
	call destroyOneLine
	;L12:
	push 132
	push 127
	call destroyOneLine
	;L13:
	push 142
	push 137
	call destroyOneLine
	;L14:
	push 152
	push 147
	call destroyOneLine
	;L15:
	push 162
	push 157
	call destroyOneLine
	;L16:
	push 172
	push 167
	call destroyOneLine
	;L17:
	push 182
	push 177
	call destroyOneLine
	;L18:
	push 192
	push 187
	call destroyOneLine
			
	cmp [LinesCounter], 1
	je Add10 ;אם שורה אחת נשרפה עולה 10 נקודות
	cmp [LinesCounter], 2
	je Add30 ;אם שתי שורות נשרפו עולה 30 נקודות
	cmp [LinesCounter], 3
	je Add50 ;אם שלוש שורות נשרפו עולה 50 נקודות
	cmp [LinesCounter], 4
	je Add80 ;אם ארבע שורות נשרפו עולה 80 נקודות
	jmp Add0
			
			
	Add10:
		add [Score], 10
		jmp Add0
	Add30:
		add [Score], 30
		jmp Add0
	Add50:
		add [Score], 50
		jmp Add0
	Add80:
		add [Score], 80
					
	Add0:
		call updateBest ;update user's best Score
		call clearkeyboardbuffer ;מנקה את הבאפר למקרה והמשתמש לחץ על כפתורים בזמן התהליך של שריפת השורות והורדת שאר השורות
	ret		
endp destroyLinesCheck
	
;=============================================================================================================================================

;בודק אם המשתמש הפסיד והמשחק נגמר
proc endGameCheck
	mov dx, 0
	mov cx, 159
	
	startCheckPixel1:
		push cx
		push 19
		call getPixel
		
		cmp al, 7 ;check if the color is grey
		jne ItIsNotGrey ;if it isn't jump to another check
		continueChecking:
			cmp cx, 61
			je endLoop
	loop startCheckPixel1
	
	ItIsNotGrey:
		cmp al, 0ffh ;check if the color is white
		jne ItIsNotGreyOrWhite ;if it isn't the color is not board's color and we need to end the game
		jmp continueChecking
		
		jmp endLoop
		ItIsNotGreyOrWhite:
			mov dx, 1

	endLoop:
	ret
endp endGameCheck ; dx = 1 - Game over   |   dx = 0 - Everything Ok

;=============================================================================================================================================

;פעולה שאחראית לבדוק האם המשתמש שנפסל זה עתה רוצה לשחק שוב את אותו המוד או לשנות מוד
proc PlayAgain
		call DrawGameOver ; מצייר את מסך ההפסלות
		call boardStats ; מציג את הנתונים של המשחק
		call mouse ;מאתחל את העכבר
		call activeMouse ;מפעיל את העכבר
	
		buttonPressedCheck_:
			call again_Button ; בודק אם נלחץ הכפתור של משחק חוזר
			cmp [check_pressed], 1
			jne nextPlayAgain1
			call mouse ;מאתחל את העכבר
			call playThisModeAgain ; משחק את המוד הזה שוב
			call DrawGameOver ;מצייר את מסך המשחק נגמר
			call PlayAgain ; בודק אם המשתמש רוצה לשחק שוב או לא
			jmp exit
			
			nextPlayAgain1:
				call BackToSetMod_Button ; בודק אם נלחץ כפתור החזרה למסך המודים
				cmp [check_pressed], 1
				jne buttonPressedCheck_
				call mouse ;מאתחל את העכבר
				call Loading ; מצייר את מסך הטעינה
				call DrawModesPage ; מצייר את מסך המודים
				call SetTheMood ; מחכה לקבלת מוד מהמשתמש
				call PlayAgain ; בודק אם המשתמש רוצה לשחק שוב או לא
			jmp exit
	ret
endp PlayAgain
	
;=============================================================================================================================================	

;בודק איזה מוד שוחק מקדום ומפעיל אותו שוב
proc playThisModeAgain
	cmp [mode], 1
	je Classic1_
	cmp [mode], 2 
	je TurtleSpeed2_
	cmp [mode], 3
	je SuperHard3_
	cmp [mode], 4
	je SpiderMan4_
	cmp [mode], 5
	je OneByOne5_
	cmp [mode], 6 
	je CrazyBoard6_
	cmp [mode], 7
	je NoRotations7_
	cmp [mode], 8
	je Israel8_
	cmp [mode], 9
	je TinyBoard9_
	jmp endGame
	
	Classic1_:
		call Classic_Mood ; מפעיל את המוד הקלאסי
	jmp endGame
	
	TurtleSpeed2_:
		call TurtleSpeed_Mood ; מפעיל את המוד האיטי
	jmp endGame
	
	SuperHard3_:
		call SuperHard_Mood ; מפעיל את המוד הסופר קשה
	jmp endGame
	
	SpiderMan4_:
		call Spiderman_Mood ; מפעיל את מוד הספיידרמן
	jmp endGame
	
	OneByOne5_:
		call OneByOne_Mood ; מפעיל את מוד אחד על אחד
	jmp endGame
	
	CrazyBoard6_:
		call CrazyBoard_Mood ; מפעיל את מוד הלוח המשוגע
	jmp endGame
	
	NoRotations7_:
		call NoRorations_Mood ; מפעיל את מוד הבלי הסתובבות
	jmp endGame
	
	Israel8_:
		call Israel_Mood ; מפעיל את מוד הישראל
	jmp endGame
	
	TinyBoard9_:
		call TinyBoard_Mood ; מפעיל את מוד הלוח הקטן
		
	jmp endGame
	
	endGame:
	ret
endp playThisModeAgain

;=============================================================================================================================================