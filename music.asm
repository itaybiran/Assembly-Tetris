			
;פותח רמקול
proc openSpeaker
	in al, 61h
	or al, 00000011b
	out 61h, al
	ret
endp openSpeaker
	
;=============================================================================================================================================	

;סוגר רמקול
proc closeSpeaker
	in al, 61h
	and al, 11111100b
	out 61h, al
	ret
endp closeSpeaker
	
;=============================================================================================================================================	

; מאפשר גישה לשינוי הסאונד שיתנגן
proc get_access_sound
	mov al, 0B6h
	out 43h, al
	ret
endp get_access_sound
	
;=============================================================================================================================================	
		
;מנגן תו
proc g_4
	mov al, 0e3h
	out 42h, al ; Sending lower byte
	mov al, 0bh
	out 42h, al ; Sending upper byte
	ret
endp g_4
	
;=============================================================================================================================================	
		
;מנגן תו
proc a_4
	mov al, 098h
	out 42h, al ; Sending lower byte
	mov al, 0ah
	out 42h, al ; Sending upper byte
	ret
endp a_4
	
;=============================================================================================================================================	
	
;מנגן תו
proc b_4
	mov al, 06fh
	out 42h, al ; Sending lower byte
	mov al, 09h
	out 42h, al ; Sending upper byte
	ret
endp b_4
	
;=============================================================================================================================================	
		
;מנגן תו
proc c_5
	mov al, 0e9h
	out 42h, al ; Sending lower byte
	mov al, 08h
	out 42h, al ; Sending upper byte
	ret
endp c_5
	
;=============================================================================================================================================	
				
;מנגן תו
proc d_5
	mov al, 0f1h
	out 42h, al ; Sending lower byte
	mov al, 07h
	out 42h, al ; Sending upper byte
	ret
endp d_5
	
;=============================================================================================================================================	
		
;מנגן תו
proc e_5
	mov al, 012h
	out 42h, al ; Sending lower byte
	mov al, 07h
	out 42h, al ; Sending upper byte
	ret
endp e_5
	
;=============================================================================================================================================	
		
;מנגן תו
proc f_5
	mov al, 0adh
	out 42h, al ; Sending lower byte
	mov al, 06h
	out 42h, al ; Sending upper byte
	ret
endp f_5
	
;=============================================================================================================================================	
		
;מנגן תו
proc g_5
	mov al, 0f1h
	out 42h, al ; Sending lower byte
	mov al, 05h
	out 42h, al ; Sending upper byte
	ret
endp g_5
	
;=============================================================================================================================================	
			
;מנגן תו
proc a_5
	mov al, 04ch
	out 42h, al ; Sending lower byte
	mov al, 05h
	out 42h, al ; Sending upper byte
	ret
endp a_5
	
;=============================================================================================================================================	
		
; מעלה את המאיות שנייה באחד כדי שהמוזיקה תמשיך להתנגן
proc count_milisecond
	inc [counter_mili] ;increases the counter of the miliseconds
	ret
endp count_milisecond
	
;=============================================================================================================================================	
		
; מאפס את הטיקים שנספרו עד כה
proc restart_milisecond
	mov [counter_mili], 0 ;reset the tiks
	ret
endp restart_milisecond
	
;=============================================================================================================================================	
		
tick equ [word ptr bp+6] ;time
note equ [word ptr bp+4] ;sound

;פעולה שמקבלת את הטיק בו צריך להתנגן תו ואת התו ומשמיע אותו בהתאם
proc play_sound_by_note_and_time

	push bp ;backup
	mov bp,sp
	PushAll ;backup
	xor ax,ax
	mov ax, tick
	cmp [counter_mili],ax
	je play
	PopAll
	pop bp
	ret 4
	
	play:
	
		xor ax, ax
		mov ax, note
		
		cmp [former_note],ax
		je start_note_check
		cmp [former_note],9
		jl start_note_check
		call openSpeaker
		call get_access_sound
		
		start_note_check:
		
			xor ax,ax
			mov ax,note
			
			cmp ax,1
			jne check_b
			call a_4
			PopAll
			pop bp
			ret 4
		
			check_b:
			
				cmp ax,2
				jne check_c
				call b_4
				PopAll
				pop bp
				ret 4
				
			check_c:
			
				cmp ax,3
				jne check_d
				call c_5
				PopAll
				pop bp
				ret 4
				
			check_d:
			
				cmp ax,4
				jne check_e
				call d_5
				PopAll
				pop bp
				ret 4
				
			check_e:
			
				cmp ax,5
				jne check_f
				call e_5
				PopAll
				pop bp
				ret 4
				
			check_f:
			
				cmp ax,6
				jne check_g
				call f_5
				PopAll
				pop bp
				ret 4
				
			check_g:
			
				cmp ax,7
				jne check_a
				call g_5
				PopAll
				pop bp
				ret 4
				
			check_a:
			
				cmp ax,8
				jne check_break
				call a_5
				PopAll
				pop bp
				ret 4
				
			check_break:
		
				cmp ax,9
				jne check_reset_counter
				call closeSpeaker
				
		check_reset_counter:
			cmp ax,10
			jne exit_p
			mov [counter_mili],-1 ;עצירה של השמעת המוזיקה
		
		exit_p:
			xor ax,ax
			mov ax,note
			mov [former_note],ax
			PopAll ;backup
			pop bp ;backup
	ret 4
endp play_sound_by_note_and_time
	
;=============================================================================================================================================	
		
;מנגן את מוזיקת הרקע של המשחק טטריס לפי תווים וטיקים שמסמלים זמן
proc tetris_music

	push 0
	push 5
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 8
	push 2
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 12
	push 3
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 16
	push 4
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 24
	push 3
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 28
	push 2
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 32
	push 1
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 39
	push 9
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 40
	push 1
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 44
	push 3
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 48
	push 5
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 56
	push 4
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 60
	push 3
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 64
	push 2
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 76
	push 3
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 80
	push 4
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 88
	push 5
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 96
	push 3
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 104
	push 1
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 111
	push 9
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 112
	push 1
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 124
	push 9
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 128
	push 4
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 140
	push 6
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 144
	push 8
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 152
	push 7
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 156
	push 6
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 160
	push 5
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 172
	push 3
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 176
	push 5
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 184
	push 4
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 188
	push 3
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 192
	push 2
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 199
	push 9
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 200
	push 2
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 204
	push 3
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 208
	push 4
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 216
	push 5
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 224
	push 3
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 232
	push 1
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 239
	push 9
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 240
	push 1
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 252
	push 9
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	push 256
	push 10
	call play_sound_by_note_and_time ; Plays sound by note and time
	
	ret
endp tetris_music	

;=============================================================================================================================================		