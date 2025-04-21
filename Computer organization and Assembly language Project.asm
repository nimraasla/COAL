Include irvine32.inc
Include macros.inc
.386
.model flat, stdcall
.stack 4096

ExitProcess PROTO, dwExitCode:DWORD

BUFFER_SIZE = 501
.data
	;---------------FILE HANDLING-------------
	buffer BYTE BUFFER_SIZE DUP(0)
	filename db "scores.txt", 0
	fileHandle HANDLE ?
	str1 BYTE "Cannot create file ", 0
    str3 BYTE "Enter name: ", 0
	stringLength DWORD ?
	score dd 0

	;---------------WALL ARRAY----------------
	xt1 db -1
	yt1 db -1
	t1 db "0"

	xt2 db -1
	yt2 db -1
	t2 db 0

	xt3 db -1
	yt3 db -1
	t3 db 0

	xf1 db -1
	yf1 db -1
	fruit1 db "="
	xf2 db -1
	yf2 db -1
	fruit2 db "="
	xf3 db -1
	yf3 db -1
	fruit3 db "="


	xfood1 db 5586 DUP (0)
	yfood1 db 5586 DUP (0)
	off1 dd 1

	a1 db 35
	a2 word 147

	xwall1 db 5586 DUP (0)
	ywall1 db 5586 DUP (0)
	off dword ?

	a db 1
	b db 2

	;--------------PACMAN-----------------
	pacman_color DD yellow
	pacman DD "C"
	xPos db ?
	yPos db ?
	inputChar db ?

	;-------------GHOSTS-----------------
	ghost1_color DD red
	ghost1 DD "G"
	xg1 db ?
	yg1 db ?

	ghost2_color DD magenta
	ghost2 DD "G"
	xg2 db ?
	yg2 db ?

	ghost3_color DD blue
	ghost3 DD "G"
	xg3 db ?
	yg3 db ?

	ghost4_color DD lightblue
	ghost4 DD "G"
	xg4 db ?
	yg4 db ?

	up db 1
	down db 1
	left db 1
	right db 1

	lev db 0

	g1 db 0
	g2 db 0
	g3 db 0
	g4 db 0

	level dword ?

.code
;-----------------------------;
;							  ;
;			MAIN CODE		  ;
;							  ;
;-----------------------------;
main PROC

	;welcome screen
	call welcome
	
	;Instruction window
	call instruction

	;name Input
	call nameplayer

	;level num
	call level_num

	;main game screen
	call mainGameScreen


	;start
	;call level1

	call game
	
	mov dl, 1
	mov dh, 36
	call Gotoxy
	 invoke ExitProcess, 0
main ENDP
;-----------------------------;
;							  ;
;		WELCOME SCREEN		  ;
;							  ;
;-----------------------------;
welcome PROC
	mov dl, 45																							  
	mov dh, 3																							  
	call Gotoxy
	mwrite "W E L C O M E"

	mov dl, 10
	mov dh, 5
	call Gotoxy
	mWrite "____________  ____________  ____________                   ____________"
	call crlf
	mov dl, 10
	mov dh, 6
	call Gotoxy
	mWrite "|          |  |          |  |          |   |\          /|  |          |  |\         |"
	call crlf
	mov dl, 10
	mov dh, 7
	call Gotoxy
	mWrite "|          |  |          |  |              | \        / |  |          |  | \        |"
	call crlf
	mov dl, 10
	mov dh, 8
	call Gotoxy
	mWrite "|          |  |          |  |              |  \      /  |  |          |  |  \       |"
	call crlf
	mov dl, 10
	mov dh, 9
	call Gotoxy
	mWrite "|          |  |          |  |              |   \    /   |  |          |  |   \      |"
	call crlf
	mov dl, 10
	mov dh, 10
	call Gotoxy
	mWrite "|__________|  |__________|  |              |    \  /    |  |__________|  |    \     |"
	call crlf
	mov dl, 10
	mov dh, 11
	call Gotoxy
	mWrite "|             |          |  |              |     \/     |  |          |  |     \    |"
	call crlf
	mov dl, 10
	mov dh, 12
	call Gotoxy
	mWrite "|             |          |  |              |            |  |          |  |      \   |"
	call crlf
	mov dl, 10
	mov dh, 13
	call Gotoxy
	mWrite "|             |          |  |              |            |  |          |  |       \  |"
	call crlf
	mov dl, 10
	mov dh, 14
	call Gotoxy
	mWrite "|             |          |  |              |            |  |          |  |        \ |"
	call crlf
	mov dl, 10
	mov dh, 15
	call Gotoxy
	mWrite "|             |          |  |__________|   |            |  |          |  |         \|"
	call crlf

	call waitmsg
	call clrscr
	ret
welcome ENDP




;-----------------------------;
;							  ;
;		NAME OF PLAYER		  ;
;							  ;
;-----------------------------;
instruction PROC
	mov eax, yellow
	call setTextColor
	mov dl, 71
	mov dh, 10
	call Gotoxy
	mWrite "PACMAN"
	;call crlf

	mov eax, white
	call setTextColor
	mov dl,71
	mov dh, 11
	call Gotoxy
	mWrite"RULES"

	mov eax, lightcyan
	call setTextColor
	mov dl,40
	mov dh, 11
	call Gotoxy
	mWrite"1. There is "
	mov eax, yellow
	call setTextColor
	mWrite "Pac-Man"
	mov eax, lightcyan
	call setTextColor
	mWrite" and"
	mov eax, magenta
	call setTextColor
	mWrite " 3 Ghosts"
	mov eax, lightcyan
	call setTextColor
	mWrite" in the maze at starting 2 levels"

	mov eax, lightcyan
	call setTextColor
	mov dl, 20
	mov dh, 12
	call Gotoxy
	mov eax, lightcyan
	call setTextColor
	mWrite "2. "
	mov eax, yellow
	call setTextColor
	mWrite " Pac-Man "
	mov eax, lightcyan
	call setTextColor
	mWrite "can go "
	mov eax, blue
	call setTextColor
	mWrite "any direction "
	mov eax, lightcyan
	call setTextColor
	mWrite "and "
	mov eax, blue
	call setTextColor
	mWrite "turn whenever "
	mov eax, lightcyan
	call setTextColor
	mWrite "they want as long as they stay within the lines of the maze"

	mov eax, lightcyan
	call setTextColor
	mov dl, 25
	mov dh, 13
	call Gotoxy
	mWrite "3. "
	mov eax, magenta
	call setTextColor
	mWrite "Ghosts "
	mov eax, lightcyan
	call setTextColor
	mWrite "can only "
	mov eax, blue
	call setTextColor
	mWrite "move forward"
	mov eax, lightcyan
	call setTextColor
	mWrite ", unless they reach a dead end (then, they can turn around)."

	mov eax, lightcyan
	call setTextColor
	mov dl, 60
	mov dh, 14
	call Gotoxy
	mWrite "4. "
	mov eax, yellow
	call setTextColor
	mWrite "Pac-man "
	mov eax, lightcyan
	call setTextColor
	mWrite "has only 3 lives."

	mov eax, white
	call setTextColor
	call crlf
	call waitmsg
	call clrscr
	ret
instruction ENDP






;-----------------------------;
;							  ;
;		NAME OF PLAYER		  ;
;							  ;
;-----------------------------;
nameplayer PROC
	; Create a new text file.
    mov edx,OFFSET filename
    call CreateOutputFile

    mov fileHandle, eax
   
    cmp eax, INVALID_HANDLE_VALUE   ;Check for errors.
    jne letsWriteToFile ; if error not found
   
  
    mov edx,OFFSET str1 ; display error
    ; display error
    call WriteString
    jmp quit
    
    letsWriteToFile:
    mov edx,OFFSET str3 ; Ask the user to input a string.
    call WriteString    
    
    mov ecx, BUFFER_SIZE
    mov edx, OFFSET buffer
    call ReadString ; Input a string
    
    mov stringLength, eax   ; counts chars entered
   mov esi, offset buffer
   mov bl, [esi]
   cmp bl, 0
   je letsWriteToFile
   je letsWriteToFile
    ; Write the buffer to the output file.
    mov eax, fileHandle
    mov edx, OFFSET buffer
    mov ecx, stringLength
    call WriteToFile
    ; save return value
    call CloseFile
    call Crlf
	call clrscr
    quit:
		ret
nameplayer ENDP

;-----------------------------;
;							  ;
;		MAIN GAME SCREEN	  ;
;							  ;
;-----------------------------;
mainGameScreen PROC
	mov off, 0
	mov dl, 0
	mov dh, 0
	;mov ax, 147
	mov cx, 0
	print:
		call Gotoxy
		cmp cx, a2
		jne h1
		mov a, 2
		mov cx, 0
		je h2
		h1:
			cmp a, 1
			jne h2 
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mov eax, lightcyan
			call SetTextColor
			mWrite "*"
			inc dl
			mov dh, 0
			inc cx
			jmp print
		h2:
			cmp b, 2
			jne h3
			mov a2, 183
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mov eax, lightcyan
			call SetTextColor
			mWrite "*"
			mov dl, 1
			inc cx
			inc dh
			cmp a2, cx
			jne print
			mov cx, 0
			mov b, 3
			mov dl, 147
			mov dh, 1
			call Gotoxy
			je h3
		h3:
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mov eax, lightcyan
			call SetTextColor
			mWrite "*"
			mov dl, 147
			inc dh
			cmp dh, 37
			je quit
			jne print
		quit:
			

	mov dl, 63
	mov dh, 15
	mov cx, 20
	top:
		cmp cx, 0
		je next
		call Gotoxy
		mov ebx, off
		mov [xwall1+ebx], dl
		mov [ywall1+ebx], dh
		inc off
		mWrite "*"
		inc dl
		LOOP top
	next:
		mov dl, 63
		mov dh, 16
		mov cx, 4
		top1:
			cmp cx, 0
			je next1
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			LOOP top1
	next1:
		mov dl, 64
		mov dh, 19
		mov cx, 19
		top2:
			cmp cx, 0
			je next2
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			LOOP top2
	next2:
		mov dl, 83
		mov dh, 19
		mov cx, 5
		top3:
			cmp cx, 0
			je next3
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			LOOP top3
	next3:
	cmp level, 1
	je lev1
	jne lev2
	lev1:
		call wall1
		ret
	lev2:
		cmp level, 2
		je lev22
		jne lev3
		lev22:
			call wall2
			ret
		lev3:
			call wall3
			ret
mainGameScreen ENDP

;---------------------------------;
;								  ;
;			WALLS(lev3)			  ;
;								  ;
;---------------------------------;
wall3 PROC
	mov dl, 60
	mov dh, 8
	mov cx, 27
	;HORIZONTAL OF UPPER T
	print:
		cmp cx, 0
		je next1
		call Gotoxy
		mov ebx, off
		mov [xwall1+ebx], dl
		mov [ywall1+ebx], dh
		inc off
		mWrite "*"
		inc dh
		call Gotoxy
		mov ebx, off
		mov [xwall1+ebx], dl
		mov [ywall1+ebx], dh
		inc off
		mWrite "*"
		dec dh
		inc dl
		LOOP print
	;VERTICAL OF UPPER T
	next1:
		mov dl, 73
		mov dh, 9
		mov cx, 4
		print1:
			cmp cx, 0
			je next2
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print1
	;MIDDLE UPPER VERTICAL WALL
	next2:
		mov cx, 5
		mov dl, 73
		mov dh, 1
		print2:
			cmp cx, 0
			je next3
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print2
	;EXTREME LEFT TOP WALL
	next3:
		mov dl, 8
		mov dh, 3
		mov cx, 20
		print3:
			cmp cx, 0
			je next4
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print3
	;NEIGHBOUR OF EXTREME LEFT TOP WALL
	next4:
		mov dl, 37
		mov dh, 3
		mov cx, 30
		print4:
			cmp cx, 0
			je next5
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print4
	;NEIGHBOUR HORIZONTAL OF EXTREME RIGHT HORIZONTAL WALL
	next5:
		mov dl, 81
		mov dh, 3
		mov cx, 30
		print5:
			cmp cx, 0
			je next6
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print5
	;EXTREME RIGHT HORIZONTAL WALL
	next6:
		mov dl, 120
		mov dh, 3
		mov cx, 20
		print6:
			cmp cx, 0
			je next7
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print6
	;DOWN NEIGHBOUR OF EXTREME TOP LEFT
	next7:
		mov dl, 6
		mov dh, 8
		mov cx, 24
		print7:
			cmp cx, 0
			je next8
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print7
	;DOWN NEIGHBOUR OF EXTREME TOP RIGHT
	next8:
		mov dl, 118
		mov dh, 8
		mov cx, 24
		print8:
			cmp cx, 0
			je next9
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print8
	;NEIGHBOUR OF DOWN NEIGHBOUR OF EXTREME TOP LEFT
	next9:
		mov dl, 37
		mov dh, 8
		mov cx, 8
		print9:
			cmp cx, 0
			je next10
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print9
	next10:
		mov dl, 39
		mov dh, 11
		mov cx, 20
		print10:
			cmp cx, 0
			je next11
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print10
	next11:
		mov dl, 109
		mov dh, 8
		mov cx, 8
		print11:
			cmp cx, 0
			je next12
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print11
	next12:
		mov dl, 88
		mov dh, 11
		mov cx, 23
		print12:
			cmp cx, 0
			je next13
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print12
	next13:







	mov dl, 60
	mov dh, 23
	mov cx, 27
	;HORIZONTAL OF LOWER T
	printx:
		cmp cx, 0
		je next14
		call Gotoxy
		mov ebx, off
		mov [xwall1+ebx], dl
		mov [ywall1+ebx], dh
		inc off
		mWrite "*"
		inc dh
		call Gotoxy
		mov ebx, off
		mov [xwall1+ebx], dl
		mov [ywall1+ebx], dh
		inc off
		mWrite "*"
		dec dh
		inc dl
		LOOP printx
	;VERTICAL OF UPPER T
	next14:
		mov dl, 73
		mov dh, 25
		mov cx, 4
		print14:
			cmp cx, 0
			je next15
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print14
	;MIDDLE UPPER VERTICAL WALL
	next15:
		mov cx, 7
		mov dl, 73
		mov dh, 31
		print15:
			cmp cx, 0
			je next16
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print15
	;EXTREME LEFT BOTTOM WALL
	next16:
		mov dl, 8
		mov dh, 32
		mov cx, 59
		print16:
			cmp cx, 0
			je next17
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print16
	;EXTREME RIGHT BOTTOM WALL
	next17:
		mov dl, 81
		mov dh, 32
		mov cx, 59
		print17:
			cmp cx, 0
			je next18
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print17
	next18:
		mov dl, 55
		mov dh, 26
		mov cx, 6
		print18:
			cmp cx, 0
			je next19
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print18
	next19:
		mov dl, 89
		mov dh, 26
		mov cx, 6
		print19:
			cmp cx, 0
			je next20
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print19
	next20:
		mov dl, 119
		mov dh, 26
		mov cx, 28
		print20:
			cmp cx, 0
			je next21
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print20
	next21:
		mov dl, 1
		mov dh, 26
		mov cx, 28
		print21:
			cmp cx, 0
			je next22
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print21
	next22:
		mov dl, 44
		mov dh, 22
		mov cx, 8
		print22:
			cmp cx, 0
			je next23
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print22
	next23:
		mov dl, 104
		mov dh, 22
		mov cx, 8
		print23:
			cmp cx, 0
			je next24
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print23
	next24:
		mov dl, 24
		mov dh, 22
		mov cx, 22
		print24:
			cmp cx, 0
			je next25
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print24
	next25:
		mov dl, 106
		mov dh, 22
		mov cx, 22
		print25:
			cmp cx, 0
			je next26
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print25
	next26:
		mov dl, 8
		mov dh, 12
		mov cx, 12
		print26:
			cmp cx, 0
			je next27
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print26
	next27:
		mov dl, 139
		mov dh, 12
		mov cx, 12
		print27:
			cmp cx, 0
			je next28
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print27
	next28:
		mov dl, 10
		mov dh, 12
		mov cx, 15
		print28:
			cmp cx, 0
			je next29
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print28
	next29:
		mov dl, 10
		mov dh, 18
		mov cx, 15
		print29:
			cmp cx, 0
			je next30
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print29
	next30:
		mov dl, 124
		mov dh, 12
		mov cx, 15
		print30:
			cmp cx, 0
			je next31
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print30
	next31:
		mov dl, 124
		mov dh, 18
		mov cx, 15
		print31:
			cmp cx, 0
			je FOOODS
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print31

	;FOOOOOOOOOODS
	FOOODS:
		mov off1, 1
		mov dl, 64
		mov dh, 16
		next32:
			cmp dh, 19
			je FOODS
			cmp dl, 83
			je next33
			mov ebx, off
			call Gotoxy
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			inc dl
			jmp next32
		next33:
			mov dl, 64
			inc dh
			jmp next32
	FOODS:
		mov off, 1
		mov dl, 2
		mov dh, 1
		mov cx, 146
		FOOD1:
			cmp cx, 0
			je quit3
			mov ebx, off
			mov al, [xwall1+ebx]
			mov ah, [ywall1+ebx]
			cmp al, 0
			je printt
			cmp al, dl
			jne FOOD3
			je FOOD4
				FOOD3:
					inc off
					jmp FOOD1
			FOOD4:
				cmp ah, dh
				je FOOD5
				jne FOOD3
				FOOD5:
					inc dl
					mov off, 1
					LOOP FOOD1
			printt:
				call Gotoxy
				mov eax, green
				call SetTextColor
				mov ebx, off1
				mov [xfood1+ebx], dl
				mov [yfood1+ebx], dh
				inc off1
				mWrite "`"
				inc dl
				mov off, 1
				LOOP FOOD1

	quit3:
		mov cx, 146
		inc dh
		mov dl, 2
		mov off, 1
		dec a1
		cmp a1, 0
		je quit4
		jmp FOOD1
	quit4:
		mov dl, 30
		mov dh, 12
		mov xt1, dl
		mov yt1, dh
		call Gotoxy 
		mov eax, brown
		call setTextColor
		mWrite "0"

		mov dl, 120
		mov dh, 15
		mov xt2, dl
		mov yt2, dh
		call Gotoxy 
		mov eax, brown
		call setTextColor
		mWrite "0"

		mov dl, 30
		mov dh, 20
		mov xt3, dl
		mov yt3, dh
		call Gotoxy 
		mov eax, brown
		call setTextColor
		mWrite "0"

		mov lev, 1
		call level1
		ret
wall3 ENDP




;---------------------------------;
;								  ;
;			WALLS(lev2)			  ;
;								  ;
;---------------------------------;
wall2 PROC
	mov dl, 60
	mov dh, 8
	mov cx, 27
	;HORIZONTAL OF UPPER T
	print:
		cmp cx, 0
		je next1
		call Gotoxy
		mov ebx, off
		mov [xwall1+ebx], dl
		mov [ywall1+ebx], dh
		inc off
		mWrite "*"
		inc dh
		call Gotoxy
		mov ebx, off
		mov [xwall1+ebx], dl
		mov [ywall1+ebx], dh
		inc off
		mWrite "*"
		dec dh
		inc dl
		LOOP print
	;VERTICAL OF UPPER T
	next1:
		mov dl, 73
		mov dh, 9
		mov cx, 4
		print1:
			cmp cx, 0
			je next2
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print1
	;MIDDLE UPPER VERTICAL WALL
	next2:
		mov cx, 5
		mov dl, 73
		mov dh, 1
		print2:
			cmp cx, 0
			je next3
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print2
	;NEIGHBOUR OF EXTREME LEFT TOP WALL
	next3:
		mov dl, 37
		mov dh, 3
		mov cx, 30
		print4:
			cmp cx, 0
			je next5
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print4
	;NEIGHBOUR HORIZONTAL OF EXTREME RIGHT HORIZONTAL WALL
	next5:
		mov dl, 81
		mov dh, 3
		mov cx, 30
		print5:
			cmp cx, 0
			je next6
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print5
	;DOWN NEIGHBOUR OF EXTREME TOP LEFT
	next6:
		mov dl, 6
		mov dh, 8
		mov cx, 24
		print7:
			cmp cx, 0
			je next8
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print7
	;DOWN NEIGHBOUR OF EXTREME TOP RIGHT
	next8:
		mov dl, 118
		mov dh, 8
		mov cx, 24
		print8:
			cmp cx, 0
			je next9
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print8
	;;LEFT T OF UPPER T VERTICAL LINE
	next9:
		mov dl, 37
		mov dh, 8
		mov cx, 8
		print9:
			cmp cx, 0
			je next10
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print9
	;;LEFT T OF UPPER T, HORIZONTAL LINE
	next10:
		mov dl, 39
		mov dh, 11
		mov cx, 20
		print10:
			cmp cx, 0
			je next11
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print10
	next11:
		mov dl, 109
		mov dh, 8
		mov cx, 8
		print11:
			cmp cx, 0
			je next12
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print11
	next12:
		mov dl, 88
		mov dh, 11
		mov cx, 23
		print12:
			cmp cx, 0
			je next13
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print12
	






	next13:
	mov dl, 60
	mov dh, 23
	mov cx, 27
	;HORIZONTAL OF LOWER T
	printx:
		cmp cx, 0
		je next14
		call Gotoxy
		mov ebx, off
		mov [xwall1+ebx], dl
		mov [ywall1+ebx], dh
		inc off
		mWrite "*"
		inc dh
		call Gotoxy
		mov ebx, off
		mov [xwall1+ebx], dl
		mov [ywall1+ebx], dh
		inc off
		mWrite "*"
		dec dh
		inc dl
		LOOP printx
	;VERTICAL OF UPPER T
	next14:
		mov dl, 73
		mov dh, 25
		mov cx, 4
		print14:
			cmp cx, 0
			je next15
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print14
	;MIDDLE UPPER VERTICAL WALL
	next15:
		mov cx, 7
		mov dl, 73
		mov dh, 31
		print15:
			cmp cx, 0
			je next16
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print15
	;EXTREME LEFT BOTTOM WALL
	next16:
		mov dl, 8
		mov dh, 32
		mov cx, 59
		print16:
			cmp cx, 0
			je next17
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print16
	;EXTREME RIGHT BOTTOM WALL
	next17:
		mov dl, 81
		mov dh, 32
		mov cx, 59
		print17:
			cmp cx, 0
			je next18
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print17
	;;VETICAL LINE OF LOWER LEFT HORIZONTAL LINE
	next18:
		mov dl, 55
		mov dh, 26
		mov cx, 6
		print18:
			cmp cx, 0
			je next19
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print18
	;;VETICAL LINE OF LOWER RIGHT HORIZONTAL LINE
	next19:
		mov dl, 89
		mov dh, 26
		mov cx, 6
		print19:
			cmp cx, 0
			je next20
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print19
	;;BORDER TOUCH RIGHT HORIZONTAL LINE
	next20:
		mov dl, 119
		mov dh, 26
		mov cx, 28
		print20:
			cmp cx, 0
			je next21
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print20
	;;BORDER TOUCH LEFT HORIZONTAL LINE
	next21:
		mov dl, 1
		mov dh, 26
		mov cx, 28
		print21:
			cmp cx, 0
			je next22
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print21
	
	;;VERTICAL OF LEFT F
	next22:
		mov dl, 8
		mov dh, 12
		mov cx, 12
		print26:
			cmp cx, 0
			je next27
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print26
	;;VERICAL OF RIGHT F
	next27:
		mov dl, 139
		mov dh, 12
		mov cx, 12
		print27:
			cmp cx, 0
			je next28
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print27
	
	next28:
		mov dl, 10
		mov dh, 18
		mov cx, 15
		print29:
			cmp cx, 0
			je next30
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print29
	next30:
		mov dl, 124
		mov dh, 18
		mov cx, 15
		print31:
			cmp cx, 0
			je FOOODS
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print31

	;FOOOOOOOOOODS
	FOOODS:
		mov off1, 1
		mov dl, 64
		mov dh, 16
		next32:
			cmp dh, 19
			je FOODS
			cmp dl, 83
			je next33
			mov ebx, off
			call Gotoxy
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			inc dl
			jmp next32
		next33:
			mov dl, 64
			inc dh
			jmp next32
	FOODS:
		mov off, 1
		mov dl, 2
		mov dh, 1
		mov cx, 146
		FOOD1:
			cmp cx, 0
			je quit3
			mov ebx, off
			mov al, [xwall1+ebx]
			mov ah, [ywall1+ebx]
			cmp al, 0
			je printt
			cmp al, dl
			jne FOOD3
			je FOOD4
				FOOD3:
					inc off
					jmp FOOD1
			FOOD4:
				cmp ah, dh
				je FOOD5
				jne FOOD3
				FOOD5:
					inc dl
					mov off, 1
					LOOP FOOD1
			printt:
				call Gotoxy
				mov eax, green
				call SetTextColor
				mov ebx, off1
				mov [xfood1+ebx], dl
				mov [yfood1+ebx], dh
				inc off1
				mWrite "`"
				inc dl
				mov off, 1
				LOOP FOOD1

	quit3:
		mov cx, 146
		inc dh
		mov dl, 2
		mov off, 1
		dec a1
		cmp a1, 0
		je quit4
		jmp FOOD1
	quit4:
		mov dl,2
		mov dh, 10
		mov xf1, dl
		mov yf1, dh
		call Gotoxy
		mov eax, brown
		call setTextColor
		mWrite "="

		mov dl,75
		mov dh, 10
		mov xf2, dl
		mov yf2, dh
		call Gotoxy
		mov eax, brown
		call setTextColor
		mWrite "="

		mov dl,140
		mov dh, 30
		mov xf3, dl
		mov yf3, dh
		call Gotoxy
		mov eax, brown
		call setTextColor
		mWrite "="

		mov lev, 1
		call level1
		ret
wall2 ENDP




;---------------------------------;
;								  ;
;			WALLS(lev1)			  ;
;								  ;
;---------------------------------;
wall1 PROC
	mov dl, 60
	mov dh, 8
	mov cx, 27
	;HORIZONTAL OF UPPER T
	print:
		cmp cx, 0
		je next1
		call Gotoxy
		mov ebx, off
		mov [xwall1+ebx], dl
		mov [ywall1+ebx], dh
		inc off
		mWrite "*"
		inc dh
		call Gotoxy
		mov ebx, off
		mov [xwall1+ebx], dl
		mov [ywall1+ebx], dh
		inc off
		mWrite "*"
		dec dh
		inc dl
		LOOP print
	;VERTICAL OF UPPER T
	next1:
		mov dl, 73
		mov dh, 9
		mov cx, 4
		print1:
			cmp cx, 0
			je next2
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print1
	;MIDDLE UPPER VERTICAL WALL
	next2:
		mov cx, 5
		mov dl, 73
		mov dh, 1
		print2:
			cmp cx, 0
			je next4
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print2
	
	;NEIGHBOUR OF EXTREME LEFT TOP WALL
	next4:
		mov dl, 37
		mov dh, 3
		mov cx, 30
		print4:
			cmp cx, 0
			je next5
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print4
	;NEIGHBOUR HORIZONTAL OF EXTREME RIGHT HORIZONTAL WALL
	next5:
		mov dl, 81
		mov dh, 3
		mov cx, 30
		print5:
			cmp cx, 0
			je next6
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print5
	;DOWN NEIGHBOUR OF EXTREME TOP LEFT
	next6:
		mov dl, 6
		mov dh, 8
		mov cx, 24
		print7:
			cmp cx, 0
			je next8
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print7
	;DOWN NEIGHBOUR OF EXTREME TOP RIGHT
	next8:
		mov dl, 118
		mov dh, 8
		mov cx, 24
		print8:
			cmp cx, 0
			je next9
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print8
	;NEIGHBOUR OF DOWN NEIGHBOUR OF EXTREME TOP LEFT
	next9:
		mov dl, 37
		mov dh, 14
		mov cx, 8
		print9:
			cmp cx, 0
			je next10
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print9
	;;RIGHT T OF UPPER T, VERTICAL LINE
	next10:
		mov dl, 109
		mov dh, 14
		mov cx, 8
		print11:
			cmp cx, 0
			je next13
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print11
	
	






	next13:
	mov dl, 60
	mov dh, 23
	mov cx, 27
	;HORIZONTAL OF LOWER T
	printx:
		cmp cx, 0
		je next14
		call Gotoxy
		mov ebx, off
		mov [xwall1+ebx], dl
		mov [ywall1+ebx], dh
		inc off
		mWrite "*"
		inc dh
		call Gotoxy
		mov ebx, off
		mov [xwall1+ebx], dl
		mov [ywall1+ebx], dh
		inc off
		mWrite "*"
		dec dh
		inc dl
		LOOP printx
	;VERTICAL OF LOWER T
	next14:
		mov dl, 73
		mov dh, 25
		mov cx, 4
		print14:
			cmp cx, 0
			je next15
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print14
	;MIDDLE LOWER VERTICAL WALL
	next15:
		mov cx, 7
		mov dl, 73
		mov dh, 31
		print15:
			cmp cx, 0
			je next16
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dl
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dl
			inc dh
			LOOP print15
	;EXTREME LEFT BOTTOM WALL
	next16:
		mov dl, 8
		mov dh, 32
		mov cx, 59
		print16:
			cmp cx, 0
			je next17
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print16
	;EXTREME RIGHT BOTTOM WALL
	next17:
		mov dl, 81
		mov dh, 32
		mov cx, 59
		print17:
			cmp cx, 0
			je next18
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print17
	
	;;LOWER EXTREME RIGHT HORIZONTAL LINE 
	next18:
		mov dl, 119
		mov dh, 26
		mov cx, 28
		print20:
			cmp cx, 0
			je next21
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print20
	;;BOUNDARY TOUCH EXTREME LEFT LOWER HORIZONTAL WALL
	next21:
		mov dl, 1
		mov dh, 26
		mov cx, 28
		print21:
			cmp cx, 0
			je FOOODS
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			inc dh
			call Gotoxy
			mov ebx, off
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			mWrite "*"
			dec dh
			inc dl
			LOOP print21
	
	
	
	
	
	

	;FOOOOOOOOOODS
	FOOODS:
		mov off1, 1
		mov dl, 64
		mov dh, 16
		next32:
			cmp dh, 19
			je FOODS
			cmp dl, 83
			je next33
			mov ebx, off
			call Gotoxy
			mov [xwall1+ebx], dl
			mov [ywall1+ebx], dh
			inc off
			inc dl
			jmp next32
		next33:
			mov dl, 64
			inc dh
			jmp next32
	FOODS:
		mov off, 1
		mov dl, 2
		mov dh, 1
		mov cx, 146
		FOOD1:
			cmp cx, 0
			je quit3
			mov ebx, off
			mov al, [xwall1+ebx]
			mov ah, [ywall1+ebx]
			cmp al, 0
			je printt
			cmp al, dl
			jne FOOD3
			je FOOD4
				FOOD3:
					inc off
					jmp FOOD1
			FOOD4:
				cmp ah, dh
				je FOOD5
				jne FOOD3
				FOOD5:
					inc dl
					mov off, 1
					LOOP FOOD1
			printt:
				call Gotoxy
				mov eax, green
				call SetTextColor
				mov ebx, off1
				mov [ebx+xfood1], dl
				mov [ebx+yfood1], dh
				inc off1
				mWrite "`"
				inc dl
				mov off, 1
				LOOP FOOD1

	quit3:
		mov cx, 146
		inc dh
		mov dl, 2
		mov off, 1
		dec a1
		cmp a1, 0
		je quit4
		jmp FOOD1
	quit4:
		mov lev, 1
		call level1
		ret
wall1 ENDP
;-----------------------------;
;							  ;
;			LEVEL1			  ;
;							  ;
;-----------------------------;
level1 PROC
	mov eax, ghost1_color
	call SetTextColor
	mov dl, 72
	mov dh, 17
	mov xg1, 72
	mov yg1, 17
	call Gotoxy
	mov edx, offset ghost1
	call WriteString

	cmp level, 3
	je next
	jne next_1
	next:
	mov eax, ghost2_color
	call SetTextColor
	mov dl, 73
	mov dh, 16
	mov xg2, 73
	mov yg2, 16
	call Gotoxy
	mov edx, offset ghost2
	call WriteString

	mov eax, ghost4_color
	call SetTextColor
	mov dl, 73
	mov dh, 18
	mov xg4, 73
	mov yg4, 18
	call Gotoxy
	mov edx, offset ghost4
	call WriteString

	next_1:
	mov eax, ghost3_color
	call SetTextColor
	mov dl, 74
	mov dh, 17
	mov xg3, 74
	mov yg3, 17
	call Gotoxy
	mov edx, offset ghost3
	call WriteString

	mov eax, pacman_color
	call SetTextColor
	mov dl, 73
	mov dh, 22
	mov xPos, 73
	mov ypos, 22
	call Gotoxy
	mov edx, offset pacman
	call WriteString
	ret
level1 ENDP


;-----------------------------;
;							  ;
;			LEVEL2			  ;
;							  ;
;-----------------------------;





;-----------------------------;
;							  ;
;			LEVEL3			  ;
;							  ;
;-----------------------------;




;-----------------------------;
;							  ;
;			GAMELOOP		  ;
;							  ;
;-----------------------------;
game PROC
;;INITIAL		OF		GHOST1
	mov dl, xg1
	mov dh, yg1
	mov ecx, 10
	l1:
		mov dl,xg1
		mov dh,yg1
		call Gotoxy
		mov al," "
		call WriteChar
		dec xg1
		mov dl,xg1
		mov dh,yg1
		call Gotoxy
		mov eax, ghost1_color
		call setTextColor
		mov al,"G"
		call WriteChar

		; start delay
		mov bp, 4369
		mov si, 4369
		delay2:
		dec bp
		nop
		jnz delay2
		dec si
		cmp si,0    
		jnz delay2
		; end delay

		LOOP l1


;;INITIAL		OF		GHOST2
cmp level, 3
	je next1
	jne next_2
	next1:
	mov dl, xg2
	mov dh, yg2
	mov ecx, 2
	l2:
		mov dl,xg2
		mov dh,yg2
		call Gotoxy
		mov al," "
		call WriteChar
		dec yg2
		mov dl,xg2
		mov dh,yg2
		call Gotoxy
		mov eax, ghost2_color
		call setTextColor
		mov al,"G"
		call WriteChar

		; start delay
		mov bp, 4369
		mov si, 4369
		delay3:
		dec bp
		nop
		jnz delay3
		dec si
		cmp si,0    
		jnz delay3
		; end delay

		LOOP l2


	mov dl, xg4
	mov dh, yg4
	mov ecx, 2
	l_3:
		mov dl,xg4
		mov dh,yg4
		call Gotoxy
		mov al," "
		call WriteChar
		inc yg4
		mov dl,xg4
		mov dh,yg4
		call Gotoxy
		mov eax, ghost4_color
		call setTextColor
		mov al,"G"
		call WriteChar

		; start delay
		mov bp, 4369
		mov si, 4369
		delay_4:
		dec bp
		nop
		jnz delay_4
		dec si
		cmp si,0    
		jnz delay_4
		; end delay

		LOOP l_3

;;INITIAL		OF		GHOST3
	next_2:
	mov dl, xg3
	mov dh, yg3
	mov ecx, 10
	l3:
		mov dl,xg3
		mov dh,yg3
		call Gotoxy
		mov al," "
		call WriteChar
		inc xg3
		mov dl,xg3
		mov dh,yg3
		call Gotoxy
		mov eax, ghost3_color
		call setTextColor
		mov al,"G"
		call WriteChar

		; start delay
		mov bp, 4369
		mov si, 4369
		delay4:
		dec bp
		nop
		jnz delay4
		dec si
		cmp si,0    
		jnz delay4
		; end delay

		LOOP l3



;;GAME		LOOP
	gameLoop:
		mov off, 1
		call ReadChar
		mov inputChar,al
		cmp inputChar,"w"
		je moveUp

		cmp inputChar,"s"
		je moveDown

		cmp inputChar,"a"
		je moveLeft

		cmp inputChar,"d"
		je moveRight

		cmp inputChar,"p"
		je pause_1
		
		pause_1:
			call game_pause

		moveUp: 
			mov ebx, off
			mov al, [ebx+xwall1]
			cmp al, 0
			je quit
			mov ah, [ebx+ywall1+1]
			inc ah
			cmp al, xPos
			je next1_cmp
			jne next
			next1_cmp:
				cmp ah, yPos
				je del
				jne next
				del:
					jmp quit1
			next:
				inc off
				jmp moveUp
			quit:
				mov cl, xPos
				cmp cl, xf1
				je a3
				jne a3_
				a3:
					mov cl, yPos
					dec cl
					cmp cl, yf1
					je a3__
					jne a3_
					a3__:
						mov xf1, -1
						mov yf1, -1
						add score, 4
				a3_:
					mov cl, xPos
					cmp xf2, cl
					je b__1
					jne b_1
					b__1:
						mov cl, yPos
						dec cl
						cmp yf2, cl
						je b1___
						jne b_1
						b1___:
							mov xf2, -1
							mov yf2, -1
							add score, 4
				b_1:
					mov cl, xPos
					cmp xf3, cl
					je c__1
					jne c_1
					c__1:
						mov cl, yPos
						dec cl
						cmp yf3, cl
						je c1___
						jne c_1
						c1___:
							mov xf3, -1
							mov yf3, -1
							add score, 4
				c_1:
					mov cl, xPos
				cmp cl, xt1
				je o3
				jne o3_
				o3:
					mov cl, yPos
					dec cl
					cmp cl, yt1
					je o3__
					jne o3_
					o3__:
						call drawPlayer1
						mov xPos, 121
						mov yPos, 15
						call drawPlayer1
				o3_:
					mov cl, xPos
					cmp xt2, cl
					je m__1
					jne m_1
					m__1:
						mov cl, yPos
						dec cl
						cmp yt2, cl
						je m1___
						jne m_1
						m1___:
						call drawPlayer1
							mov xPos, 31
							mov yPos, 20
							call drawPlayer1
				m_1:
					mov cl, xPos
					cmp xt3, cl
					je n__1
					jne n_1
					n__1:
						mov cl, yPos
						dec cl
						cmp yt3, cl
						je n1___
						jne n_1
						n1___:
						call drawPlayer1
							mov xPos, 31
							mov yPos, 12
							call drawPlayer1
				n_1:
				call UpdatePlayer
				dec yPos
				mov off, 1
				call DrawPlayer
				jmp quit1

		moveDown:
			mov ebx, off
			mov al, [ebx+xwall1]
			cmp al, 0
			je quit2
			mov ah, [ebx+ywall1]
			dec ah
			cmp yPos, 35
			je del2
			cmp al, xPos
			je next2_cmp
			jne next2
			next2_cmp:
				cmp ah, yPos
				je del2
				jne next2
				del2:
					jmp quit1
			next2:
				inc off
				jmp moveDown
			quit2:
				mov cl, xPos
				cmp cl, xf1
				je d2
				jne d1_
				d2:
					mov cl, yPos
					inc cl
					cmp cl, yf1
					je d2__
					jne d1_
					d2__:
						mov xf1, -1
						mov yf1, -1
						add score, 4
				d1_:
					mov cl, xPos
					cmp xf2, cl
					je e__1
					jne e_1
					e__1:
						mov cl, yPos
						inc cl
						cmp yf2, cl
						je e1___
						jne e_1
						e1___:
							mov xf2, -1
							mov yf2, -1
							add score, 4
				e_1:
					mov cl, xPos
					cmp xf3, cl
					je f__1
					jne f_1
					f__1:
						mov cl, yPos
						inc cl
						cmp yf3, cl
						je f1___
						jne f_1
						f1___:
							mov xf3, -1
							mov yf3, -1
							add score, 4
				f_1:
					mov cl, xPos
				cmp cl, xt1
				je p3
				jne p3_
				p3:
					mov cl, yPos
					inc cl
					cmp cl, yt1
					je p3__
					jne p3_
					p3__:
					call drawPlayer1
						mov xPos, 121
						mov yPos, 15
						call drawPlayer1
				p3_:
					mov cl, xPos
					cmp xt2, cl
					je q__1
					jne q_1
					q__1:
						mov cl, yPos
						inc cl
						cmp yt2, cl
						je q1___
						jne q_1
						q1___:
						call drawPlayer1
							mov xPos, 31
							mov yPos, 20
							call drawPlayer1
				q_1:
					mov cl, xPos
					cmp xt3, cl
					je r__1
					jne r_1
					r__1:
						mov cl, yPos
						inc cl
						cmp yt3, cl
						je r1___
						jne r_1
						r1___:
						call drawPlayer1
							mov xPos, 31
							mov yPos, 12
							call drawPlayer1
				r_1:

				call UpdatePlayer
				inc yPos
				mov off, 1
				call DrawPlayer
				jmp quit1

		moveLeft:
			mov ebx, off
			mov al, [ebx+xwall1]
			cmp al, 0
			je quit3
			inc al
			mov ah, [ebx+ywall1]
			cmp al, xPos
			je next3_cmp
			jne next3
			next3_cmp:
				cmp ah, yPos
				je del3
				jne next3
				del3:
					jmp quit1
			next3:
				inc off
				jmp moveLeft
			quit3:
				mov cl, xPos
				dec cl
				cmp xf1, cl
				je g_1
				jne g1_
				g_1:
					mov cl, yPos
					cmp yf1, cl
					je g1__
					jne g1_
					g1__:
						mov xf1, -1
						mov yf1, -1
						add score, 4
				g1_:
					mov cl, xPos
					dec cl
					cmp xf2, cl
					je h__1
					jne h_1
					h__1:
						mov cl, yPos
						cmp yf2, cl
						je h1___
						jne h_1
						h1___:
							mov xf2, -1
							mov yf2, -1
							add score, 4
				h_1:
					mov cl, xPos
					dec cl
					cmp xf3, cl
					je i__1
					jne i_1
					i__1:
						mov cl, yPos
						cmp yf3, cl
						je i1___
						jne i_1
						i1___:

							mov xf3, -1
							mov yf3, -1
							add score, 4
				i_1:
					mov cl, xPos
					dec cl
				cmp cl, xt1
				je s3
				jne s3_
				s3:
					mov cl, yPos
					cmp cl, yt1
					je s3__
					jne s3_
					s3__:
					call drawPlayer1
						mov xPos, 121
						mov yPos, 15
						call drawPlayer1
				s3_:
					mov cl, xPos
					dec cl
					cmp xt2, cl
					je t__1
					jne t_1
					t__1:
						mov cl, yPos
						cmp yt2, cl
						je t1___
						jne t_1
						t1___:
						call drawPlayer1
							mov xPos, 31
							mov yPos, 20
							call drawPlayer1
				t_1:
					mov cl, xPos
					dec cl
					cmp xt3, cl
					je u__1
					jne u_1
					u__1:
						mov cl, yPos
						cmp yt3, cl
						je u1___
						jne u_1
						u1___:
						call drawPlayer1
							mov xPos, 31
							mov yPos, 12
							call drawPlayer1
				u_1:

				call UpdatePlayer
				dec xPos
				mov off, 1
				call DrawPlayer
				jmp quit1

		moveRight:
			mov ebx, off
			mov al, [ebx+xwall1]
			cmp al, 0
			je quit4
			dec al
			mov ah, [ebx+ywall1]
			cmp al, xPos
			je next4_cmp
			jne next4
			next4_cmp:
				cmp ah, yPos
				je del4
				jne next4
				del4:
					jmp quit1
			next4:
				inc off
				jmp moveRight
			quit4:
				mov cl, xPos
				inc cl
				cmp xf1, cl
				je j
				jne j_
				j:
					mov cl, yPos
					cmp yf1, cl
					je j__
					jne j_
					j__:
						mov xf1, -1
						mov yf1, -1
						add score, 4
				j_:
					mov cl, xPos
					inc cl
					cmp xf2, cl
					je h
					jne h_
					h:
						mov cl, yPos
						cmp yf2, cl
						je h__
						jne h_
						h__:
							mov xf2, -1
							mov yf2, -1
							add score, 4
				h_:
					mov cl, xPos
					inc cl
					cmp xf3, cl
					je k
					jne k_
					k:
						mov cl, yPos
						cmp yf3, cl
						je k__
						jne k_
						k__:
							mov xf3, -1
							mov yf3, -1
							add score, 4
				k_:
					mov cl, xPos
					inc cl
				cmp cl, xt1
				je v3
				jne v3_
				v3:
					mov cl, yPos
					cmp cl, yt1
					je v3__
					jne v3_
					v3__:
					call drawPlayer1
						mov xPos, 121
						mov yPos, 15
						call drawPlayer1
				v3_:
					mov cl, xPos
					inc cl
					cmp xt2, cl
					je w__1
					jne w_1
					w__1:
						mov cl, yPos
						cmp yt2, cl
						je w1___
						jne w_1
						w1___:
						call drawPlayer1
							mov xPos, 31
							mov yPos, 20
							call drawPlayer1
				w_1:
					mov cl, xPos
					inc cl
					cmp xt3, cl
					je x__1
					jne x_1
					x__1:
						mov cl, yPos
						cmp yt3, cl
						je x1___
						jne x_1
						x1___:
							call drawPlayer1
							mov xPos, 31
							mov yPos, 12
							call drawPlayer1
				x_1:

				call UpdatePlayer
				inc xPos
				mov off, 1
				call DrawPlayer
				jmp quit1
	quit1:
		mov dl, 70
		mov dh, 16
		call Gotoxy
		mWrite "Score: "
		mov eax, score
		call WriteInt

		mov g1, 1
		call ghost_movement
		cmp up, 1
		je check1
		check1:
			
		cmp level, 3
		je next_1
		jne incre
		next_1:
		mov g1, 0
		mov g2, 1
		call ghost_movement

		mov g1, 0
		mov g2, 1
		mov g3, 0
		mov g4, 1
		call ghost_movement

		incre:
		mov g1, 0
		mov g2, 0
		mov g3, 1
		call ghost_movement

		jmp gameLoop
	ret
game ENDP

UpdatePlayer1 PROC
	mov dl,xPos
	mov dh,yPos
	call Gotoxy
	mov eax, brown
	call setTextColor
	mov al,"0"
	call WriteChar
	ret
UpdatePlayer1 ENDP

DrawPlayer1 PROC
	; draw player at (xPos,yPos):
	mov dl,xPos
	mov dh,yPos
	call Gotoxy
	mov eax, pacman_color
	call setTextColor
	mov al," "
	call WriteChar
	ret
DrawPlayer1 ENDP

UpdatePlayer PROC
	mov dl,xPos
	mov dh,yPos
	call Gotoxy
	mov al," "
	call WriteChar
	ret
UpdatePlayer ENDP

DrawPlayer PROC
	; draw player at (xPos,yPos):
	mov dl,xPos
	mov dh,yPos
	call Gotoxy
	mov eax, pacman_color
	call setTextColor
	mov al,"C"
	call WriteChar
	mov off1, 1
	mov cl, xPos
	mov ch, yPos
	next1:
		mov ebx, off1
		cmp [ebx+xfood1], 0
		je quit
		mov al, [ebx+xfood1]
		mov ah, [ebx+yfood1]
		cmp al, cl
		je next_cmp
		jne not_n_cmp
		next_cmp:
			cmp ah, ch
			je incre
			jne not_n_cmp
			incre:
				mov [ebx+xfood1], -1
				mov [ebx+yfood1], -1
				inc score
		not_n_cmp:
			inc off1
			jmp next1
	quit:

	ret
DrawPlayer ENDP

UpdateG1 PROC
	mov dl,xg1
	mov dh,yg1
	call Gotoxy
	mov eax, green
	call setTextColor
	mov al,"`"
	call WriteChar
	ret
UpdateG1 ENDP

DrawG1 PROC
	; draw player at (xPos,yPos):
	mov dl,xg1
	mov dh,yg1
	call Gotoxy
	mov al, "G"
	call WriteChar
	ret
DrawG1 ENDP

UpdateG2 PROC
	mov dl,xg2
	mov dh,yg2
	call Gotoxy
	mov eax, green
	call setTextColor
	mov al,"`"
	call WriteChar
	ret
UpdateG2 ENDP

DrawG2 PROC
	; draw player at (xPos,yPos):
	mov dl,xg2
	mov dh,yg2
	call Gotoxy
	mov al, "G"
	call WriteChar
	ret
DrawG2 ENDP

UpdateG3 PROC
	mov dl,xg3
	mov dh,yg3
	call Gotoxy
	mov eax, green
	call setTextColor
	mov al,"`"
	call WriteChar
	ret
UpdateG3 ENDP

DrawG3 PROC
	; draw player at (xPos,yPos):
	mov dl,xg3
	mov dh,yg3
	call Gotoxy
	mov al, "G"
	call WriteChar
	ret
DrawG3 ENDP

ghost_movement PROC
	
    ret
ghost_movement ENDP

level_num PROC
	mov dl, 68
	mov dh, 7
	call Gotoxy
	mWrite "LEVEL 1"

	mov dl, 68
	mov dh, 10
	call Gotoxy
	mWrite "LEVEL 2"

	mov dl, 68
	mov dh, 13
	call Gotoxy
	mWrite "LEVEL 3"

	mov dl, 3
	mov dh, 15
	call Gotoxy
	mWrite "Eenter Level: "
	call readInt
	mov level, eax

	call crlf
	call waitmsg
	call clrscr
	ret
level_num ENDP

game_pause PROC
	
	ret
game_pause ENDP
END main