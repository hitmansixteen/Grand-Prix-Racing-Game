;Laraib Akhtar 21L-5294
;Abdul Aziz 21L-5380

[org 0x0100]
	jmp start

wheel1: db ' 0 ~O~ 0 ', 0
geartext: db 'G E A R', 0
speedtext: db 'S P E E D', 0
count: dw 0
oiltext: dw 'OIL',0
temptext: dw 'TEMP',0
timetext: db 'Time:0:00', 0
speednum: db '000', 0
seconds: dw 0
tick: dw 0
minutes: dw 0
oldisr1: dd 0
oldisr2: dd 0
cloudmove: dw 0
movecount: dw 0
turnflag: dw 0
rightm: dw 0
leftm: dw 0
welcometext: db 'Welcome to Grand Prix Racing Game!',0
playexit: dw 'P : Play            Esc : Exit',0
racecomplete: dw 0
crash: dw 0
racetracktext: db 'AUTODROMO NAZIONALE DI MONZA',0
qrstext: db 'Qualifying Results Sheet',0
postext: db 'Pos.',0
nametext: db 'Name',0
notext: db 'No.',0
timetextl: db 'Time',0 
donmatrelli: db 'Don Matrelli',0
travisdaye: db 'Travis Daye',0
caltyrone: db 'Cal Tyrone',0
peterkurtz: db 'Peter Kurtz',0
tsesakamoto: db 'Tse Sakamoto',0
abdulaziz: db 'Abdul Aziz',0
brunogourdo: db 'Bruno Gourdo',0
toniborlini: db 'Toni Borlini',0
vitogiuffre: db 'Vito Giuffre',0
nigellevvins: db 'Nigel Levins',0
youtext: db 'You                 #01',0
mtext: db '00m  s',0 
moveflag: dw 0
qualifiedtext: db 'Congratulations you have Qualified!',0
notqualifiedtext: db 'We are Sorry. You did not Make it',0
exittext: db 'Press Esc to exit',0

; Print Block-----------------------------------------
printblock:
    ;[bp+4] = y2 position
    ;[bp+6] = width
    ;[bp+8] = y1 position
    ;[bp+10] = x1 position 
    ;[bp+12] = color
	push bp
	mov bp,sp
	push es
	push ax
	push cx
	push dx
	push di
	
	mov ax,0xb800
	mov es,ax
    mov dl,0
    add dl,byte[bp+8];y1-position
    pb:
	    mov al,80
	    mul dl 
	    add ax, [bp+10] ; x1-position
	    shl ax,1
	    mov di,ax
	    mov ax,[bp+12] ; color
	    mov cx,[bp+6] ; width
	
	    cld
	    rep stosw

        add dl,1
        cmp dl, byte[bp+4] ; y2-position
        jne pb
	pop di
	pop dx
	pop cx
	pop ax
	pop es
	pop bp
	ret 10

; Print Text------------------------------------------
printtext:
    ;[bp+4] = message
    ;[bp+6] = color
    ;[bp+8] = starting y position
    ;[bp+10] = starting x position
	
	push bp
	mov bp,sp
	push es
	push ax
	push cx
	push si
	push di

	push ds
	pop es
	mov di,word[bp+4]
	mov cx,0xffff
	xor al,al
	repne scasb
	mov ax,0xffff
	sub ax,cx
	dec ax
	jz exit

	mov cx,ax
	mov ax,0xb800
	mov es,ax
	mov al,80
	mul byte [bp+8] ; y-pos
	add ax, [bp+10] ; x-pos
	shl ax,1
	mov di,ax
	mov si, word[bp+4] ; string
	mov ah, byte[bp+6] ; color

	cld
	nextchar:
		lodsb
		stosw
		loop nextchar
	
	exit:
		pop di
		pop si
		pop cx
		pop ax
		pop es
		pop bp
		ret 8

; printnum--------------------------------------------
printnum:
	; [bp+4] = number 
	; [bp+6] = y-pos
	; [bp+8] = x-pos
	; [bp+10]= color

	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di

	mov ax, 0xb800
	mov es, ax
	mov bx, 10
	mov cx, 0
	mov al,80
	mul byte [bp+6] ; y-pos
	add ax, [bp+8] ; x-pos
	shl ax,1
	mov di,ax
	
	mov ax, [bp+4] ; number
	nextdigit:	
		mov dx, 0
		div bx
		add dl, 0x30
		push dx
		inc cx
		cmp ax, 0
		jnz nextdigit


	nextpos:	
		pop dx
		mov dh, byte[bp+10] ; color
		mov [es:di], dx
		add di, 2
		loop nextpos

		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp
		ret 8

; Clearing Screen-------------------------------------                                     
clrscr:
	push 0x0720 ; color
	push 0 ; x1
	push 0 ; y1
	push 80 ; width
	push 25 ; y2
	call printblock

    ret

; Sky-------------------------------------------------
sky:
	push 0x0bdb ; color
	push 0 ; x1
	push 0 ; y1
	push 80 ; width
    push 8 ; y2
	call printblock

	ret

; Race Lights-----------------------------------------
racelights:
	;black background
	push 0x0720 ; color	
	push 0 ; x1	
	push 0 ; y1
	push 4 ; width
    push 7 ; y2
	call printblock
	;red light
	mov cx,0
	rl1:
		push  0x08db; color
		push 1 ; x1
		mov ax,1 ; y1
		add ax,cx
		push ax
		push 2 ; width
    	mov ax,2 ; y2
		add ax,cx
		push ax
		call printblock	
		add cx,2
		cmp cx, 6
		jne rl1


	ret


; Grass-----------------------------------------------    
grass:
	mov cx,0
	gr1:
		push 0x2ab0 ; color
		push 0 ; x1
		mov ax,8 ; y1
		add ax,cx
		push ax
		mov ax, 25 ; width
		sub ax,cx
		push ax
    	mov ax,9 ; y2
		add ax,cx
		push ax
		call printblock

		push 0x0fdb ; color
		mov ax,25 ; x1
		sub ax,cx
		push ax
		mov ax,8 ; y1
		add ax,cx
		push ax
		push 1 ; width
    	mov ax,9 ; y2
		add ax,cx
		push ax
		call printblock

		add cx,1
		cmp cx,8
		jne gr1
	mov cx,0
	gr2:
		push 0x2ab0 ; color
		mov ax,55 ; x1
		add ax,cx
		push ax
		mov ax,8 ; y1
		add ax,cx
		push ax
		mov ax, 25 ; width
		sub ax,cx
		push ax
    	mov ax,9 ; y2
		add ax,cx
		push ax
		call printblock

		push 0x0fdb ; color
		mov ax,55 ; x1
		add ax,cx
		push ax
		mov ax,8 ; y1
		add ax,cx
		push ax
		push 1 ; width
    	mov ax,9 ; y2
		add ax,cx
		push ax
		call printblock

		add cx,1
		cmp cx,8
		jne gr2

	ret

; Road------------------------------------------------   
road:
	push 0x08db ; color
	push 0 ; x1
	push 8 ; y1
	push  80 ; width
    push 16 ; y2
	call printblock
	
	push 0x0fdb ; color
	push 39 ; x1
	push 8 ; y1
	push 1 ; width
	push 16 ; y2
	call printblock
	push 0x08db ; color
	push 39 ; x1
	mov ax,8
	push ax ; y1
	push 1 ; width
	mov ax, 10
    push ax ; y2
	call printblock

	ret
; gearfire--------------------------------------------
gear: 
	push 0x07db ; color
	push 70 ; x1
	push 19 ; y1
	push  10 ; width
    push 25 ; y2
	call printblock

	mov cx,0
	gf1:
		push 0x08db ; color
		mov ax,72 ; x1
		add ax,cx
		push ax
		push 20 ; y1
		push  1 ; width
    	push 24 ; y2
		call printblock
		add cx,3
		cmp cx,9
		jne gf1

	push 0x08db ; color
	push 73 ; x1
	push 22 ; y1
	push  6 ; width
    push 23 ; y2
	call printblock

	push 0x0720 ; color
	push 70 ; x1
	push 19 ; y1
	push  4 ; width
    push 21 ; y2
	call printblock

	push 72 ; x-position
	push 24 ; y-position
	push 0x7e ; color
	push  geartext ; text
	call printtext

	ret
; Board-----------------------------------------------  
board:
	push 0x08db ; color
	push 0 ; x1
	push 16 ; y1
	push  80 ; width
    push 25 ; y2
	call printblock

	push 0x07db ; color
	push 0 ; x1
	push 16 ; y1
	push  80 ; width
    push 17 ; y2
	call printblock

	call wheel
	call gear
	call speed
	call oiltemp
	call mirror
	call timerbox
	call minimap

	push 0x0ea7 ; color
	push 39 ; x1
	push 17 ; y1
	push  1 ; width
    push 18 ; y2
	call printblock

	ret

; Wheel-----------------------------------------------    
wheel:
	mov cx,0
	wh1:
		push 0x0720 ; color
		mov ax,35 ; x1
		shl cx,2
		sub ax,cx
		push ax
		shr cx,2
		mov ax,17 ; y1
		add ax,cx
		push ax
		push  5 ; width
    	mov ax,18 ; y2
		add ax,cx
		push ax
		call printblock

		push 0x0720 ; color
		mov ax,40 ; x1
		shl cx,2
		add ax,cx
		push ax
		shr cx,2
		mov ax,17 ; y1
		add ax,cx
		push ax
		push  5 ; width
    	mov ax,18 ; y2
		add ax,cx
		push ax
		call printblock

		add cx,1
		cmp cx,3
		jne wh1

	mov cx,0
	wh2:
		push 0x0720 ; color
		mov ax,27 ; x1
		sub ax,cx
		push ax
		mov ax,20 ; y1
		add ax,cx
		push ax
		push 1 ; width
    	mov ax,22 ; y2
		add ax,cx
		push ax
		call printblock

		push 0x0720 ; color
		mov ax,52 ; x1
		add ax,cx
		push ax
		mov ax,20 ; y1
		add ax,cx
		push ax
		push  1 ; width
    	mov ax,22 ; y2
		add ax,cx
		push ax
		call printblock

		add cx,1
		cmp cx,3
		jne wh2

	push 0x00db ; color
	push 25 ; x1
	push 24 ; y1
	push 30 ; width
    push 25 ; y2
	call printblock
	 
	push 35 ; x-position
	push 24 ; y-position
	push 0x70 ; color
	push  wheel1 ; text
	call printtext

	ret

; Stadium---------------------------------------------
stadium:

	push 0x4cfe ; color
	push 20 ; x1
	push 5 ; y1
	push  40 ; width
    push 7 ; y2
	call printblock
	
	push 0x07f4 ; color
	push 21 ; x1
	push 6 ; y1
	push  38 ; width
    push 7 ; y2
	call printblock

	mov cx,0
	stad:
		push 0x4cfe ; color
		mov ax,27 ; x1
		add ax,cx
		push ax
		push 4 ; y1
		push  1 ; width
    	push 5 ; y2
		call printblock
		add cx,5
		cmp cx,30
		jne stad

	push 0x4cfe ; color
	push 5 ; x1
	push 7 ; y1
	push  70 ; width
    push 8 ; y2
	call printblock

	ret
; Speed-----------------------------------------------
speed:
	push 35 ; x-position
	push 23 ; y-position
	push 0x07 ; color
	push  speedtext ; text
	call printtext
	push 38 ; x-position
	push 22 ; y-position
	push 0x47 ; color
	push  speednum ; text
	call printtext
	ret
; Delay-----------------------------------------------
delay:
	push bp
	mov bp,sp
	push cx
	push ax
	mov al, byte [bp+4]
	d1:
		mov cx, 0xffff
		d2:
			loop d2
		sub ax,1
		cmp ax,0
		jne d1
	pop ax
	pop cx
	pop bp
	ret 2
; Initialize------------------------------------------
initialize:
	call clrscr
	call sky
	call road
	call grass
	call board
	push 0
	call clouds
	call stadium
	call racelights
	push 18
	push 9
	call bush
	push 59
	push 9
	call bush

	ret
; Traffic Lights loop---------------------------------
trafficlight_loop:
	push 40
	call delay

	push 0x0cdb ; color
	push 1 ; x1
	push 1 ; y1
	push  2 ; width
    push 2 ; y2
	call printblock 
	push 40 ; delay amount
	call delay

	push 0x0edb ; color
	push 1 ; x1
	push 3 ; y1
	push  2 ; width
    push 4 ; y2
	call printblock
	push 40
	call delay

	push 0x0adb ; color
	push 1 ; x1
	push 5 ; y1
	push  2 ; width
    push 6 ; y2
	call printblock
	push 40
	call delay
	ret
; Clouds----------------------------------------------
clouds:
	push bp
	mov bp,sp
	push ax

	push 0x0fdb ; color
	mov ax,10
	add ax,[bp+4]
	push ax ; x1
	push 2 ; y1
	push  10 ; width
    push 3 ; y2
	call printblock
	push 0x0fdb ; color
	mov ax, 12
	add ax,[bp+4]
	push ax ; x1
	push 1 ; y1
	push  7 ; width
    push 4 ; y2
	call printblock
	pop ax
	pop bp
	ret 2
; bush------------------------------------------------
bush:
	push bp
	mov bp,sp
	push ax

	push 0x02db ; color
	mov ax,[bp+6] ; x1
	push ax
	mov ax, [bp+4] ; y1
	push ax
	push 3 ; width
	mov ax, [bp+4] ; y2
	add ax,1
	push ax
	call printblock
	push 0x02db ; color
	mov ax,[bp+6] ; x1
	add ax,1	
	push ax
	mov ax, [bp+4] ; y1
	sub ax,1
	push ax
	push 1 ; width
	mov ax, [bp+4] ; y2
	push ax
	call printblock

	pop ax
	pop bp
	ret 4
; oiltemp---------------------------------------------
oiltemp:

	push 0x00db ; color
	push 59 ; x1
	push 18 ; y1
	push  5 ; width
    push 21 ; y2
	call printblock

	push 0x00db ; color
	push 59 ; x1
	push 22 ; y1
	push  5 ; width
    push 25 ; y2
	call printblock

	push 0x06db ; color
	push 59 ; x1
	push 19 ; y1
	push  5 ; width
    push 21 ; y2
	call printblock

	push 0x02db ; color
	push 59 ; x1
	push 23 ; y1
	push  5 ; width
    push 25 ; y2
	call printblock

	

	push 60 ; x-position
	push 18 ; y-position
	push 0x07 ; color
	push  oiltext ; text
	call printtext
	push 60 ; x-position
	push 22 ; y-position
	push 0x07 ; color
	push  temptext ; text
	call printtext
	ret
; mirror----------------------------------------------
mirror:
	push 0x07db ; color
	push 0 ; x1
	push 17 ; y1
	push  9 ; width
    push 20 ; y2
	call printblock
	push 0x2ab0 ; color
	push 0 ; x1
	push 17 ; y1
	push  3 ; width
    push 19 ; y2
	call printblock
	push 0x0fdb ; color
	push 3 ; x1
	push 17 ; y1
	push  1 ; width
    push 19 ; y2
	call printblock
	push 0x08db ; color
	push 4 ; x1
	push 17 ; y1
	push  4 ; width
    push  19; y2
	call printblock
	push 0x0fdb ; color
	push 6 ; x1
	push 18 ; y1
	push  1 ; width
    push 19 ; y2
	call printblock
	ret
; timerbox--------------------------------------------
timerbox:
	push 0x4020 ; color
	push 0 ; x1
	push 20 ; y1
	push  9 ; width
    push 24 ; y2
	call printblock
	push 0 ; x-position
	push 23 ; y-position
	push 0x47 ; color
	push  timetext ; text
	call printtext
	ret
; cloudloop-------------------------------------------
cloudloop:
	call sky
	call racelights
	push word[cs:seconds]
	call clouds
	cmp word[cs:turnflag],0
	jne cl1
	call stadium
	jmp cl4
	cl1: cmp word[cs:turnflag],1
	jne cl2
	call tree
	jmp cl4
	cl2: cmp word[cs:turnflag],2
	jne cl3
	call sun
	jmp cl4
	cl3: cmp word[cs:turnflag],3
	jne cl4
	call buildings
	cl4: ret
; roadloop--------------------------------------------
roadloop:
	push bp
	mov bp,sp
	push ax
	push dx
	push bx

	mov bx,40
	mov ax,word[movecount]
	cmp word[turnflag],0
	jne tf1
	push 0x0fdb ; color
	div bl
	xor dx,dx
	mov dl,al
	add dx,17
	push dx ; x1
	push 18 ; y1
	push  1 ; width
    push 19 ; y2
	call printblock
	jmp tf4
	tf1: ; minimap
		cmp word[turnflag],1
		jne tf2
		push 0x0fdb ; color
		push 22 ; x1
		div bl
		xor dx,dx
		mov dl,al
		add dx,18
		push dx ; y1
		push  1 ; width
		add dx,1
		push dx ; y2
		call printblock
		jmp tf4
	tf2:
		cmp word[turnflag],2
		jne tf3
		push 0x0fdb ; color
		div bl
		xor dx,dx
		mov dl,21
		sub dl,al
		push dx ; x1
		push 22 ; y1
		push  1 ; width
		push 23 ; y2
		call printblock
		jmp tf4
	tf3:
		cmp word[turnflag],3
		jne tf4
		push 0x0fdb ; color
		
		push 16 ; x1
		div bl
		xor dx,dx
		mov dl,22
		sub dl,al
		push dx ; y1
		push  1 ; width
		add dx,1
		push dx ; y2
		call printblock
	


	tf4: inc word [movecount]
	cmp word [movecount], 200
	jne l1
	call rightturn
	mov word[movecount],0
	inc word[turnflag]
	


	l1:
		cmp word [movecount], 20
		jne l5
		call clearbar
		l5: mov ax,word [bp+4]
		mov dl,3
		div dl
		xor dx,dx
		mov dl,al

		;road
		push 0x08db ; color
		push 30 ; x1
		push 8 ; y1
		push 20 ; width
		push 16 ; y2
		call printblock

		;white line
		push 0x0fdb ; color
		mov ax,39
		add ax,word[rightm]
		sub ax,word[leftm]
		push ax ; x1
		push 8 ; y1
		push 1 ; width
		push 16 ; y2
		call printblock

		; road banane ka harba
		push 0x08db ; color
		mov ax,39
		add ax,word[rightm]
		sub ax,word[leftm]
		push ax ; x1
		mov ax,8
		add ax,dx
		push ax ; y1
		push 1 ; width
		mov ax, 10
		add ax,dx
		push ax ; y2
		call printblock

		;bush
		call grass
		mov ax, 18
		sub ax,dx
		push ax
		mov ax, 9
		add ax,dx
		push ax
		call bush

		mov ax, 59
		add ax,dx
		push ax
		mov ax, 9
		add ax,dx
		push ax
		call bush

	pop bx
	pop dx
	pop ax 
	pop bp
	ret 2
; timer-----------------------------------------------
timer:
	pusha
	
	push cs
	pop ds

	

	inc word [cs:tick]; increment tick count 
	cmp word[cs:tick],19
	je ti3
	jmp exit1
	ti3:
		mov word[cs:tick],0
		call cloudloop
		inc word[cs:seconds]
		cmp word[cs:seconds],10
		jb ti1
		push 0x47
		push 7
		push 23
		mov ax, word[cs:seconds]
		push ax
		call printnum 
		jmp ti2
	ti1:
		push 0x47
		push 8
		push 23
		mov ax, word[cs:seconds]
		push ax
		call printnum 
	ti2:
		cmp word[cs:seconds],60
		jne exit1
		mov word[cs:seconds],0
		inc word[cs:minutes]
		push 0x47
		push 7
		push 23
		mov ax, word[cs:seconds]
		push ax
		call printnum
		push 0x47
		push 5
		push 23
		mov ax, word[cs:minutes]
		push ax
		call printnum 

	

	

	exit1:
		popa 
		jmp far [cs:oldisr2]  

; tree------------------------------------------------
tree:
	push 0x2020 ; color
	push 59 ; x1
	push 3 ; y1
	push  6 ; width
    push 4 ; y2
	call printblock
	
	push 0x2020 ; color
	push 57 ; x1
	push 4 ; y1
	push  10 ; width
    push 5 ; y2
	call printblock
	push 0x6020 ; color
	push 61 ; x1
	push 5 ; y1
	push  2 ; width
    push 8 ; y2
	call printblock

	push 0x2020 ; color
	push 19 ; x1
	push 3 ; y1
	push  6 ; width
    push 4 ; y2
	call printblock
	
	push 0x2020 ; color
	push 17 ; x1
	push 4 ; y1
	push  10 ; width
    push 5 ; y2
	call printblock
	push 0x6020 ; color
	push 21 ; x1
	push 5 ; y1
	push  2 ; width
    push 8 ; y2
	call printblock

 	ret
; Interrupt hook--------------------------------------
hook:
	push es
	push ax

	xor ax, ax 
	mov es, ax 
	cli 
	mov word [es:8*4], timer 
	mov [es:8*4+2], cs 
	mov word [es:9*4], kbisr
	mov [es:9*4+2], cs 
	sti 

	pop ax
	pop es
	ret
; Main Menu-------------------------------------------
mainmenu:
	call clrscr

	push 0x19b0 ; color
	push 0 ; x1
	push 0 ; y1
	push 80 ; width
	push 8 ; y2
	call printblock

	push 0x19b0 ; color
	push 0 ; x1
	push 17 ; y1
	push 80 ; width
	push 25 ; y2
	call printblock

	push 25 ; x-position
	push 12 ; y-position
	push 0x0f ; color
	push  welcometext ; text
	call printtext

	push 27 ; x-position
	push 14 ; y-position
	push 0x0f ; color
	push  playexit ; text
	call printtext
	ret
; Unhook Interrupts-----------------------------------
unhook:
	call clrscr
	mov ax, [oldisr1]
	mov bx, [oldisr1+2]
	cli
	mov [es:9*4], ax
	mov [es:9*4+2], bx
	sti
	mov ax, [oldisr2]
	mov bx, [oldisr2+2]
	cli
	mov [es:8*4], ax
	mov [es:8*4+2], bx
	sti
	ret
; KeyBoard Interrupt Service Routine------------------
kbisr:
	push ax
	push es
	push di
	push cx
	push bx
	push dx
	push si

	push cs
	pop ds

 	mov ax, 0xb800 
	mov es, ax 

	mov ax,word[rightm]
	sub ax,word[leftm]
	cmp ax,-9
	jg cp1
	dec word[leftm]
	mov word[cs:moveflag],0
	jmp exit_check
	cp1: cmp ax,10
	jl kb1
	dec word[rightm]
	mov word[cs:moveflag],0
	jmp exit_check
	kb1:
		in al, 0x60 
		cmp al, 0x48 
		jne nextcmp0
		mov word[cs:moveflag],1
	nextcmp0:
		cmp word[cs:moveflag],0
		jne nextcmp
		call clearbar
		jmp exit_check
	nextcmp:
		cmp al, 77
		jne nextcmp2
		inc word[cs:leftm]
		call rightturn
	nextcmp2:
		cmp al,75
		jne nextcmp3
		inc word[cs:rightm]
		call leftturn
	nextcmp3:
		cmp al,80
		jne nextcmp4
		mov word[cs:moveflag],0
	nextcmp4:
		cmp al,0xcd
		jne nextcmp5
		call clearbar
	nextcmp5:
		cmp al,0xcb
		jne nextcmp6
		call clearbar
	nextcmp6:
		cmp word[cs:moveflag],1
		jne exit_check
		push word[cs:tick]
		call roadloop
	

	exit_check:
	cmp word[cs:turnflag],4
	jne nomatch
	mov word[racecomplete],1

	nomatch: 
		pop si
		pop dx
		pop bx
		pop cx
		pop di
		pop es
		pop ax
 		jmp far [cs:oldisr1] 
	

; Sun Background--------------------------------------
sun:
	push 0x0edb ; color
	push 58 ; x1
	push 1 ; y1
	push  5 ; width
    push 4 ; y2
	call printblock
	ret
; Buildings-------------------------------------------
buildings:
	push ax
	push cx

	push 0x0cdb ; color
	push 30 ; x1
	push 3 ; y1
	push  20 ; width
    push 8 ; y2
	call printblock

	mov cx,0
	b1:
		push 0x4efe ; color
		mov ax,35
		add ax,cx
		push ax ; x1
		push 4 ; y1
		push  2 ; width
		push 5 ; y2
		call printblock
		push 0x4efe ; color
		mov ax,35
		add ax,cx
		push ax ; x1
		push 6 ; y1
		push  2 ; width
		push 7 ; y2
		call printblock
		add cx,4
		cmp cx,12
		jne b1

	push 0x0edb ; color
	push 18 ; x1
	push 1 ; y1
	push  5 ; width
    push 4 ; y2
	call printblock

	pop cx
	pop ax
	ret
; Saving Original Interrupts--------------------------
oldsave:
	xor ax, ax 
	mov es, ax 
	mov ax, [es:9*4] 
 	mov [oldisr1], ax 
 	mov ax, [es:9*4+2] 
 	mov [oldisr1+2], ax
	mov ax, [es:8*4] 
 	mov [oldisr2], ax 
 	mov ax, [es:8*4+2] 
 	mov [oldisr2+2], ax
	ret

; MiniMap---------------------------------------------
minimap:
	push 0x7fc4 ; color
	push 17 ; x1
	push 18 ; y1
	push  5 ; width
    push  19; y2
	call printblock

	push 0x7fc4 ; color
	push 17 ; x1
	push 22 ; y1
	push  5 ; width
    push  23; y2
	call printblock

	push 0x7fb3 ; color
	push 22 ; x1
	push 18 ; y1
	push  1 ; width
    push  23; y2
	call printblock

	push 0x7fb3 ; color
	push 16 ; x1
	push 18 ; y1
	push  1 ; width
    push  23; y2
	call printblock
	ret
; LeaderBoard-----------------------------------------
leaderboard:
	pusha
	call clrscr
	;red strip===========================
	push 0x4020 ; color
	push 0 ; x1
	push 0 ; y1
	push  80 ; width
    push 3 ; y2
	call printblock
	;autodromo nazionale di monza===============
	push 8 ; x-position
	push 2 ; y-position
	push 0x47 ; color
	push  racetracktext ; text
	call printtext
	;mexican flag==================================
	push 0x2020 ; color
	push 1 ; x1
	push 1 ; y1
	push  2 ; width
    push 3 ; y2
	call printblock
	push 0x0fdb ; color
	push 3 ; x1
	push 1 ; y1
	push  2 ; width
    push 3 ; y2
	call printblock
	push 0x0cdb ; color
	push 5 ; x1
	push 1 ; y1
	push  2 ; width
    push 3 ; y2
	call printblock
	;qualifying result sheet================
	push 25 ; x-position
	push 4 ; y-position
	push 0x0f ; color
	push  qrstext ; text
	call printtext
	;Pos Name No. Time==================
	push 2 ; x-position
	push 6 ; y-position
	push 0x07 ; color
	push  postext ; text
	call printtext
	push 25 ; x-position
	push 6 ; y-position
	push 0x07 ; color
	push  nametext ; text
	call printtext
	push 45 ; x-position
	push 6 ; y-position
	push 0x07 ; color
	push  notext ; text
	call printtext
	push 65 ; x-position
	push 6 ; y-position
	push 0x07 ; color
	push  timetextl ; text
	call printtext
	;1 2 3 4 5 6 7 8 9 10==================
	mov cx,1
	lb1:
		push 0x0f; color
		push 4; x-pos
		mov bx,cx
		add bx,7
		push bx; y-pos
		push cx; number
		call printnum 
		inc cx
		cmp cx,11
		jne lb1
	;Player Names====================
	push 25 ; x-position
	push 8 ; y-position
	push 0x0f ; color
	push  donmatrelli ; text
	call printtext
	push 25 ; x-position
	push 9 ; y-position
	push 0x0f ; color
	push  travisdaye ; text
	call printtext
	push 25 ; x-position
	push 10 ; y-position
	push 0x0f ; color
	push  caltyrone ; text
	call printtext
	push 25 ; x-position
	push 11 ; y-position
	push 0x0f ; color
	push  peterkurtz ; text
	call printtext
	push 25 ; x-position
	push 12 ; y-position
	push 0x0f ; color
	push  tsesakamoto ; text
	call printtext
	push 25 ; x-position
	push 13 ; y-position
	push 0x0f ; color
	push  abdulaziz ; text
	call printtext
	push 25 ; x-position
	push 14 ; y-position
	push 0x0f ; color
	push  brunogourdo ; text
	call printtext
	push 25 ; x-position
	push 15 ; y-position
	push 0x0f ; color
	push  toniborlini ; text
	call printtext
	push 25 ; x-position
	push 16 ; y-position
	push 0x0f ; color
	push  vitogiuffre ; text
	call printtext
	push 25 ; x-position
	push 17 ; y-position
	push 0x0f ; color
	push  nigellevvins ; text
	call printtext
	;# and m=================
	push 0x0f23 ; color
	push 45 ; x1
	push 8 ; y1
	push  1 ; width
    push 18 ; y2
	call printblock
	mov cx,0
	lb2:
		push 65 ; x-position
		mov ax,cx
		add ax,8
		push ax ; y-position
		push 0x0f ; color
		push  mtext ; text
		call printtext
		inc cx
		cmp cx,10
		jne lb2
	;time in seconds of players======================
	mov cx,0
	mov bx,10
	lb3:
		push 0x0f; color
		push 68; x-pos
		mov dx,cx
		add dx,8
		push dx; y-pos
		push bx; number
		call printnum 
		inc bx
		inc cx
		cmp cx,10
		jne lb3
	;no. # ========================================
	mov cx,0
	mov bx,53
	lb4:
		push 0x0f; color
		push 46; x-pos
		mov dx,cx
		add dx,8
		push dx; y-pos
		push bx; number
		call printnum 
		add bx,3
		inc cx
		cmp cx,10
		jne lb4
	;Declaring the winner==============================
	cmp word[racecomplete],1
	jne exit2
	cmp word[cs:minutes],0
	jne exit2
	cmp word[seconds],19
	ja exit2
	push 25 ; x-position
	mov ax,word[seconds]
	sub ax,10
	add ax,8
	push ax ; y-position
	push 0x0c ; color
	push  youtext; text
	call printtext
	push 25 ; x-position
	push 19 ; y-position
	push 0x0c ; color
	push  qualifiedtext ; text
	call printtext
	jmp exit3
	exit2: 
	push 25 ; x-position
	push 19 ; y-position
	push 0x0c ; color
	push  notqualifiedtext ; text
	call printtext
	
	
	exit3: 
	push 35 ; x-position
	push 21 ; y-position
	push 0x0f ; color
	push  exittext ; text
	call printtext
	popa
	ret
; Right Turn------------------------------------------
rightturn:
	push 0x0af8 ; color
	push 39 ; x1
	push 17 ; y1
	push  5 ; width
    push 18 ; y2
	call printblock
	ret
; Left Turn-------------------------------------------
leftturn:
	push 0x0af8 ; color
	push 35 ; x1
	push 17 ; y1
	push  5 ; width
    push  18; y2
	call printblock
	ret
; Clear Bar-------------------------------------------
clearbar:
	push 0x0020 ; color
	push 35 ; x1
	push 17 ; y1
	push  10 ; width
    push 18 ; y2
	call printblock
	ret
; Start-----------------------------------------------
start:
	call oldsave
	l4:
		call mainmenu
		mov ah,0
		int 0x16
		cmp al,112
		je l2
		cmp al,27
		je exit4
		jmp l4
	l2:
		call initialize
		call trafficlight_loop
		call hook
	l3:
		cmp word[racecomplete],1
		je exit4
		cmp word[crash],1
		je exit4
		mov ah,0
		int 0x16
		cmp al,27
		je exit4
		jmp l3
		
	exit4:
		call unhook
		call leaderboard
		
		exitloop:
			mov ah,0
			int 16h
			cmp al,27
			jne exitloop
		
		exit5: mov ax,0x4c00
		int 21h