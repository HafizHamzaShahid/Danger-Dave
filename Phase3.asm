;Phase 2

;Arslan Rasheed       20L-2090
;Hafiz Hamza Shahid   20L-1050

[org 0x0100]
	jmp main
	
arr1:	db '    ----->     SCORE:            LEVEL  01  DAVE            <-----              '
size1:	dw	80

;score maintaining
arr2: dw 0,0,0,0

;mainting x-axis,y-axis on global veriable
		;x,y
axis: dw 10,21

;storing default segment and offset address
oldisr: dd 0


;arrow key flags
upkeyflag: dw 0
downkeyflag: dw 0
rightkeyflag: dw 0
leftkeyflag: dw 0

exitflag: dw 0
trophyflag:	dw 0

;winning message after getting trophy
winmsg: db '   ----->     Move To the Blue door for Finishing this level     <-----   '
winsize: dw 74

;--------------------------------------------------Clear Subroutine---------------------------------------------;
; subroutine to clear the screen
clrscr: push es
		push ax
		push di
		mov ax, 0xb800
		mov es, ax ; point es to video base
		mov di, 0 ; point di to top left column
		
nextloc: 	mov word [es:di], 0x0720 ; clear next char on screen
			add di, 2 ; move to next screen location
			cmp di, 4000 ; has the whole screen cleared
			jne nextloc ; if no clear next position
		pop di
		pop ax
		pop es
	ret
;------------------------------------------Printing subroutine-------------------------------------------;	
print_data:
		push bp
		mov bp,sp
		push es
		push si
		push di
		push ax
		push bx
		push cx
		
		mov ax,0xb800		;pointing es to video base
		mov es, ax	
		
		mov al,80 	
		mul	byte[bp + 8]		;multiply y-axis
		add ax, [bp + 10]	;add x-axis
		shl ax,1 			;turn into byte offset
		
		mov di, ax			;pointing di to particular location
		mov si,[bp+6]		;pointing si to data
		mov cx,[bp + 4]		;pointing cx to length of data
		mov ah,[bp + 12]	;copying attribute to ah
print_data_rep:
		mov al,[si]
		mov [es:di],ax
		add di,2
		add si,1
		loop print_data_rep		
		
		pop cx
		pop bx
		pop ax
		pop di
		pop si
		pop es
		pop bp		
		ret 10
;----------------------------------------------------emoji subroutine----------------------------------------;		
emoji:	
	push bp
	mov bp,sp
	push es
	push ax
	push di
	
	mov ax,0xb800		;pointing es to video base
	mov es, ax
			
	mov ah,0		
	mov al,80 	
	mul	byte[bp + 4]		;multiply y-axis
	add ax, [bp + 6]		;add x-axis
	shl ax,1
	mov di, ax				;assigning counted value to di for video memory

	mov ah, [bp + 8]
	
	mov al, 0x20				;space
	mov [es:di], ax
	add di,2
	mov al, 0x03				;heart emoji
	mov [es:di], ax
	add di,2
	mov al, 0x20				;space
	mov [es:di], ax
	add di,2
	mov al, 0x02				;smile emoji
	mov [es:di], ax
	add di,2
	mov al, 0x20				;space
	mov [es:di], ax
	add di,2
	mov al, 0x03				;heart emoji
	mov [es:di], ax
	add di,2
	mov al, 0x20				;space
	mov [es:di], ax
	add di,2
	mov al, 0x02				;smile emoji
	mov [es:di], ax
	add di,2
	mov al, 0x20				;space
	mov [es:di], ax
	add di,2
	mov al, 0x03				;heart emoji
	mov [es:di], ax
	add di,2
	mov al, 0x20				;space
	mov [es:di], ax
	add di,2
	
	pop di
	pop ax
	pop es
	pop bp
	ret 6
;----------------------------------------------------Printing bricks------------------------------------------;	
bricksver:	
			push bp
			mov bp, sp
			push es
			push ax
			push di
			push bx
			push cx
			push dx
	
			mov ax, 0xb800
			mov es, ax 				; point es to video base
			
			mov al, 80				;load al with columns
			mov bx,[bp + 8]  		;multiply with y position
			mov bh,0
			mul bl
			add ax,[bp+10]			;add x position
			shl ax,1				; turn into byte offset
			
			mov di, ax 				; point di our required location
			mov ah, [bp+6] 			; normal attribute fixed in ah
			mov cx, [bp+4]			;get length
			mov al, 0xB3			;copying character
			mov dx, di				;saving location
			
v_b_l1:		;vertival brick length 1
			mov [es:di], ax ; 		show this char on screen
			add di, 160 			; move to next screen location
			loop v_b_l1
			
			mov di,dx
			add di,2
			mov cx, [bp+4]			;get length
			mov al, 0xB0			;copying character
			mov dx, di				;saving location
			
v_b_l2:		;second loop
			mov [es:di], ax ; 		show this char on screen
			add di,2
			mov [es:di], ax ; 		show this char on screen
			add di, 158 				; move to next screen location
			loop v_b_l2
			
			mov di,dx
			add di,4
			mov cx, [bp+4]			;get length
			mov al, 0xB3			;copying character
			mov dx, di				;saving location

v_b_l3:		;third loop
			mov [es:di], ax ; 		show this char on screen
			add di, 160 			; move to next screen location
			loop v_b_l3
		
		pop dx
		pop cx
		pop bx
		pop di
		pop ax
		pop es
		pop bp
		ret 8
;--------------------------------------------------------------;
;bricks subroutine horizontal
brickshor:	
			push bp
			mov bp, sp
			push es
			push ax
			push di
			push bx
			push cx
	
			mov ax, 0xb800
			mov es, ax 				; point es to video base
			
			mov al, 80				;load al with columns
			mov bx,[bp + 8]  		;multiply with y position
			mov bh,0
			mul bl
			add ax,[bp+10]			;add x position
			shl ax,1				; turn into byte offset
			
			mov di, ax 				; point di our required location
			mov ah, [bp+6] 			; normal attribute fixed in ah
			
			mov cx,[bp + 4]			;get length of the bricks
			mov al, 0xF0			;copying character
			
h_b_l1:		;horizontal brick loop 1
			mov [es:di], ax ; 		show this char on screen
			add di, 2			; move to next screen location
			loop h_b_l1
			
			mov cx,[bp + 4]			;get length of the bricks
			mov al, 0xB0			;copying character
			
h_b_l2:		;loop 2
			mov [es:di], ax ; 		show this char on screen
			add di, 2 				; move to next screen location
			loop h_b_l2
			
			mov cx,[bp + 4]			;get length of the bricks
			mov al, 0xF0			;copying character
			
h_b_l3:     ;loop 3
			mov [es:di], ax ; 		show this char on screen
			add di, 2 				; move to next screen location
			loop h_b_l3
		
		pop cx
		pop bx
		pop di
		pop ax
		pop es
		pop bp
		ret 8
;--------------------------------------------------------------;
;just middle line of the horizontal brick subroutine		
bricks_hor_middle_line:
			push bp
			mov bp, sp
			push es
			push ax
			push di
			push bx
			push cx
	
			mov ax, 0xb800
			mov es, ax 				; point es to video base
			
			mov al, 80				;load al with columns
			mov bx,[bp + 8]  		;multiply with y position
			mov bh,0
			mul bl
			add ax,[bp+10]			;add x position
			shl ax,1				; turn into byte offset
			
			mov di, ax 				; point di our required location
			mov ah, [bp+6] 			; normal attribute fixed in ah
			
			mov cx,[bp + 4]			;get length of the bricks
			mov al, 0xB0			;copying character
			
h_b_m_l1:		;horizontal brick middle line loop 1
			mov [es:di], ax ; 		show this char on screen
			add di, 2 				; move to next screen location
			loop h_b_m_l1	
		
		pop cx
		pop bx
		pop di
		pop ax
		pop es
		pop bp
		ret 8
		
;------------------------------------------------------door subroutine----------------------------------------;	
door:
			push bp
			mov bp, sp
			push es
			push ax
			push di
			push bx
			push cx
	
			mov ax, 0xb800
			mov es, ax 				; point es to video base
			
			mov al, 80				;load al with columns
			mov bx,[bp + 8]  		;multiply with y position
			mov bh,0
			mul bl
			add ax,[bp+10]			;add x position
			shl ax,1				; turn into byte offset
			
			mov di, ax 				; point di our required location
			mov ah, [bp+6] 			; normal attribute fixed in ah
			mov cx, [bp+4]			;get length
			mov al, 0xB0			;copying character
			
d_l1:		;door first loop
			mov [es:di], ax ; 		show this char on screen
			add di,2
			mov [es:di], ax ; 		show this char on screen
			add di,2
			mov [es:di], ax ; 		show this char on screen
			add di, 156 				; move to next screen location
			loop d_l1
			
		sub di,316
		mov ah,0x0E
		mov al,0x07
		mov [es:di], ax ;placing handle of the door
		
		pop cx
		pop bx
		pop di
		pop ax
		pop es
		pop bp
		ret 8

;----------------------------------------------------diamond subroutine-------------------------------------------;	
diamond:	
	push bp
	mov bp,sp
	push es
	push ax
	push di
	
	mov ax,0xb800		;pointing es to video base
	mov es, ax
			
	mov ah,0		
	mov al,80 	
	mul	byte[bp + 4]		;multiply y-axis
	add ax, [bp + 6]		;add x-axis
	shl ax,1
	mov di, ax				;assigning counted value to di for video memory

	mov ah, [bp + 8]
	
	mov al, 0x04
	mov [es:di], ax
	add di,2
	mov [es:di], ax
	
	pop di
	pop ax
	pop es
	pop bp	
	ret 6

;-----------------------------------------------Man subroutine----------------------------------------;	
man:	
	push bp
	mov bp,sp
	push es
	push ax
	push di
	
	mov ax,0xb800		;pointing es to video base
	mov es, ax
			
	mov ah,0		
	mov al,80 	
	mul	byte[bp + 4]		;multiply y-axis
	add ax, [bp + 6]		;add x-axis
	shl ax,1
	mov di, ax				;assigning counted value to di for video memory

	mov ah, [bp + 8]

	mov al, 0x02
	mov [es:di], ax
	add di,158
	mov al, 0x2F    ;print /
	mov [es:di], ax
	add di,2
	mov ah, 0xCB
	mov al, 0x03    ;print central body
	mov [es:di], ax
	add di,2
	mov ah, [bp + 8]
	mov al, 0x5C       ;print (\)
	mov [es:di], ax
	add di,158
	sub di,2
	mov al, 0x2F      ;print /
	mov [es:di], ax
	add di,2
	mov al, 0x20      ;print space
	mov [es:di], ax
	add di,2
	mov al, 0x5C       ;print (\)
	mov [es:di], ax
	
	pop di
	pop ax
	pop es
	pop bp	
	ret 6

;---------------------------------------------------cup subroutine-------------------------------------------;
cup:
	push bp
	mov bp,sp
	push es
	push ax
	push di
	
	mov ax,0xb800		;pointing es to video base
	mov es, ax
				
	mov al,80 	
	mul	byte[bp + 4]		;multiply y-axis
	add ax, [bp + 6]		;add x-axis
	shl ax,1
	mov di, ax				;assigning counted value to di for video memory

	mov ah, [bp + 8]
	
	mov al, 0x06
	mov [es:di], ax
    add di,2
	mov [es:di], ax
		
	pop di
	pop ax
	pop es
	pop bp
	ret 6

;-------------------------------------------------------ball subroutine-------------------------------------------;
ball:
	push bp
	mov bp,sp
	push es
	push ax
	push di
	
	mov ax,0xb800		;pointing es to video base
	mov es, ax
				
	mov al,80 	
	mul	byte[bp + 4]		;multiply y-axis
	add ax, [bp + 6]		;add x-axis
	shl ax,1
	mov di, ax				;assigning counted value to di for video memory

	mov ah, [bp + 8]
	
	mov al, 0x07
	mov [es:di], ax
	add di,2
	mov [es:di], ax
	
	pop di
	pop ax
	pop es
	pop bp
	ret 6

;------------------------------------------------------lifes subroutine-------------------------------------------;
lifes:
	push bp
	mov bp,sp
	push es
	push ax
	push di
	
	mov ax,0xb800		;pointing es to video base
	mov es, ax
				
	mov al,80 	
	mul	byte[bp + 4]		;multiply y-axis
	add ax, [bp + 6]		;add x-axis
	shl ax,1
	mov di, ax				;assigning counted value to di for video memory

	mov ah, [bp + 8]
	
	mov al, 0x02
	mov [es:di], ax
	add di,4
	mov [es:di], ax
	add di,4
	mov [es:di], ax
	
	pop di
	pop ax
	pop es
	pop bp
	ret 6

;-----------------------------------------------score subroutine-------------------------------------------;	
score:
	push bp
	mov bp,sp
	push es
	push ax
	push di
	
	mov ax,0xb800		;pointing es to video base
	mov es, ax
				
	mov al,80 	
	mul	byte[bp + 4]		;multiply y-axis
	add ax, [bp + 6]		;add x-axis
	shl ax,1
	mov di, ax				;assigning counted value to di for video memory

	mov ah, [bp + 8]
	
	mov al, [arr2]
	add al,48
	mov [es:di], ax
	add di,4
	mov al, [arr2 + 2]
	add al,48
	mov [es:di], ax
	add di,4
	mov al, [arr2 + 4]
	add al,48
	mov [es:di], ax
	add di,4
	mov al, [arr2 + 6]
	add al,48
	mov [es:di], ax	
	
	pop di
	pop ax
	pop es
	pop bp
	ret 6
	
;------------------------------------blackBackground subroutine behind man-----------------------------------------;	
blackBackground:
	push bp
	mov bp,sp
	push es
	push ax
	push di
	
	mov ax,0xb800		;pointing es to video base
	mov es, ax
				
	mov al,80 	
	mul	byte[bp + 4]		;multiply y-axis
	add ax, [bp + 6]		;add x-axis
	shl ax,1
	mov di, ax				;assigning counted value to di for video memory

	mov ah, [bp + 8]
	
	mov al, 0x20
	mov [es:di], ax
	add di,158
	mov [es:di], ax
	add di,2
	mov [es:di], ax
	add di,2
	mov [es:di], ax
	add di,156
	mov [es:di], ax
	add di,2
	mov [es:di], ax
	add di,2
	mov [es:di], ax
	
	pop di
	pop ax
	pop es
	pop bp
	
	ret 6
	
	;---------------------------------------dummy main for phase 2--------------------------------------------;
start:
		call clrscr		;clear the whole screen first
		
		;print of First line data
		mov ax, 0x0A
		push ax				; push attribute on stack
		mov ax, 0
		push ax 			; push x-axis 
		mov ax, 1
		push ax				; push y-axis 
		mov ax, arr1
		push ax				;pushing address of arr3
		mov ax, [size1]
		push ax				;push size of the word
		call print_data
		
		;emoji print left side
		mov ax, 0x6E
		push ax				; push attribute on stack
		mov ax, 10
		push ax 			; push x-axis 
		mov ax, 2
		push ax				; push y-axis 
		call emoji
		
		mov ax, 0x6E
		push ax				; push attribute on stack
		mov ax, 35
		push ax 			; push x-axis 
		mov ax, 2
		push ax				; push y-axis 
		call emoji
		
		mov ax, 0x6E
		push ax				; push attribute on stack
		mov ax, 59
		push ax 			; push x-axis 
		mov ax, 2
		push ax				; push y-axis 
		call emoji
		
		;printing brick (horizontal) line
		mov ax, 0					
		push ax 			; push x-axis
		mov ax, 3		
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color
		mov ax, 80			;length of the bricks
		push ax
		call brickshor
		
		;printing brick (vertical) line
		mov ax, 0					
		push ax 			; push x-axis
		mov ax, 5						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,20			;vertical length
		push ax
		call bricksver
		
		;printing brick (vertical) line
		mov ax, 76					
		push ax 			; push x-axis
		mov ax, 5						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,20			;vertical length
		push ax
		call bricksver
		
		;printing brick (horizontal) (middle line) line
		mov ax, 0					
		push ax 			; push x-axis
		mov ax, 24		
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color
		mov ax, 80			;length of the bricks
		push ax
		call bricks_hor_middle_line
		
		;small floating bricks (first 4 bricks) -->first row
		mov ax, 11					
		push ax 			; push x-axis
		mov ax, 9						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;2nd brick
		mov ax, 29					
		push ax 			; push x-axis
		mov ax, 9						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;3rd brick
		mov ax, 47					
		push ax 			; push x-axis
		mov ax, 9						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;4th brick
		mov ax, 65					
		push ax 			; push x-axis
		mov ax, 9						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		
		;small floating bricks (second 5 bricks) -->second row
		mov ax, 4					
		push ax 			; push x-axis
		mov ax, 14						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;6th brick
		mov ax, 20					
		push ax 			; push x-axis
		mov ax, 14						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;7th brick
		mov ax, 38					
		push ax 			; push x-axis
		mov ax, 14						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;8th brick
		mov ax, 56					
		push ax 			; push x-axis
		mov ax, 14						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;9th brick
		mov ax, 72					
		push ax 			; push x-axis
		mov ax, 14						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		
		;last row of floating bricks
		mov ax, 15					
		push ax 			; push x-axis
		mov ax, 19						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;11th brick
		mov ax, 19					
		push ax 			; push x-axis
		mov ax, 19						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;12th brick
		mov ax, 23					
		push ax 			; push x-axis
		mov ax, 19						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;13th brick
		mov ax, 27					
		push ax 			; push x-axis
		mov ax, 19						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;14th brick
		mov ax, 31					
		push ax 			; push x-axis
		mov ax, 19						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;left wall of door side
		mov ax, 46					
		push ax 			; push x-axis
		mov ax, 19						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,5			;vertical length
		push ax
		call bricksver
		
		;last right side above the door(bricks)
		mov ax, 50					
		push ax 			; push x-axis
		mov ax, 19						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;16th brick
		mov ax, 54					
		push ax 			; push x-axis
		mov ax, 19						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;17th brick
		mov ax, 58					
		push ax 			; push x-axis
		mov ax, 19						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;18th brick
		mov ax, 62					
		push ax 			; push x-axis
		mov ax, 19						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;19th brick
		mov ax, 66					
		push ax 			; push x-axis
		mov ax, 19						
		push ax; 			push y-axis 
		mov ax, 0x47
		push ax				;red color 
		mov ax,2			;vertical length
		push ax
		call bricksver
		
		;destination door printing
		mov ax, 50					
		push ax 			; push x-axis
		mov ax, 21						
		push ax; 			push y-axis 
		mov ax, 0x11
		push ax				;attribute
		mov ax,3			;vertical length
		push ax
		call door
		
		;arrival door printing
		mov ax, 4					
		push ax 			; push x-axis
		mov ax, 21						
		push ax; 			push y-axis 
		mov ax, 0x77
		push ax				;attribute
		mov ax,3			;vertical length
		push ax
		call door
		
		;printing of the diamonds	(1st diamond)
		mov ax, 0x0B
		push ax				; push attribute on stack
		mov ax, 12			;x-axis
		push ax 			
		mov ax, 7			;y-axis
		push ax				
		call diamond
		
		;second diamond
		mov ax, 0x0B
		push ax				; push attribute on stack
		mov ax, 30			;x-axis
		push ax 			
		mov ax, 7			;y-axis
		push ax				
		call diamond
		
		;third diamond
		mov ax, 0x0B
		push ax				; push attribute on stack
		mov ax, 66			;x-axis
		push ax 			
		mov ax, 7			;y-axis
		push ax				
		call diamond
		
		;4th diamond
		mov ax, 0x0B
		push ax				; push attribute on stack
		mov ax, 5			;x-axis
		push ax 			
		mov ax, 12			;y-axis
		push ax				
		call diamond
		
		;5th diamond
		mov ax, 0x0B
		push ax				; push attribute on stack
		mov ax, 21			;x-axis
		push ax 			
		mov ax, 12			;y-axis
		push ax				
		call diamond
		
		;6th diamond
		mov ax, 0x0B
		push ax				; push attribute on stack
		mov ax, 39			;x-axis
		push ax 			
		mov ax, 12			;y-axis
		push ax				
		call diamond
		
		;7th diamond
		mov ax, 0x0B
		push ax				; push attribute on stack
		mov ax, 57			;x-axis
		push ax 			
		mov ax, 12			;y-axis
		push ax				
		call diamond
		
		;8th diamond
		mov ax, 0x0B
		push ax				; push attribute on stack
		mov ax, 73			;x-axis
		push ax 			
		mov ax, 12			;y-axis
		push ax				
		call diamond
		
		;9th diamond
		mov ax, 0x0B
		push ax				; push attribute on stack
		mov ax, 5			;x-axis
		push ax 			
		mov ax, 17			;y-axis
		push ax				
		call diamond
		
		;10th diamond
		mov ax, 0x0B
		push ax				; push attribute on stack
		mov ax, 32			;x-axis
		push ax 			
		mov ax, 17			;y-axis
		push ax				
		call diamond
		
		;Red diamond
		mov ax, 0x04
		push ax				; push attribute on stack
		mov ax, 73			;x-axis
		push ax 			
		mov ax, 6			;y-axis
		push ax				
		call diamond
		
		;placement of man in the game
		mov ax, 0x0A
		push ax				; push attribute on stack
		mov ax, [axis]			;x-axis			
		push ax 			 
		mov ax, [axis+2]			;y-axis
		push ax				 
		call man
		
		;placement of cup
		mov ax, 0x8A
		push ax				; push attribute on stack
		mov ax, 48			;x-axis
		push ax 			
		mov ax, 7			;y-axis
		push ax				
		call cup
		
		;Ball Printing
		mov ax, 0x05
		push ax				; push attribute on stack
		mov ax, 5			;x-axis
		push ax 			
		mov ax, 6			;y-axis
		push ax				
		call ball
		
		;lifes Printing
		mov ax, 0x0B
		push ax				; push attribute on stack
		mov ax, 52			;x-axis
		push ax 			
		mov ax, 1			;y-axis
		push ax				
		call lifes
		
		;score updating
		mov ax, 0x0B
		push ax
		mov ax, 23			;push x-axis
		push ax
		mov ax, 1			;push y-axis
		push ax
		call score
		ret
		
;-----------------------------------------------score updating subroutine-----------------------------------------;		
;updating of score on the collection of the objects (diamonds / trophies)
scoreUpdatingroutine:
		push bp
		mov bp,sp
		push es
		push ax
		push bx
		push dx
		push si
		push di
		
		mov si,[bp+6]			;storing x-axis
		mov di, [bp+4]			;storing y-axis
		
		mov dx,[leftkeyflag]			;left check
		cmp dx,1
		je near leftSideDiamondCheck
		
		mov dx,[rightkeyflag]			;right check
		cmp dx,1
		je near righSideDiamondCheck
		
		mov dx,[upkeyflag]				;up check
		cmp dx,1
		je near upSideDiamondCheck
		
		mov dx,[downkeyflag]			;down check
		cmp dx,1
		je near downSideDiamondCheck
		jne near ScoreUpdateExit
		
leftSideDiamondCheck:
		;first row of diamonds check
		sub si,2
		add di,1
		
		;condition 1 
		mov ax,0xb800
		mov es,ax
		
		mov ah,0
		mov al,80
		mov bx,di
		mul bl
		add ax,si
		shl ax,1
		mov di,ax
		
		;trophy condition
		mov ah,0x8A
		mov al,0x06
		mov bx,[es:di]
		cmp ax,bx
		jne lSDC
		add word[arr2 + 2],1
		add word[trophyflag],1
		jmp kusaf_1
		
lSDC:
		;condition 1
		mov ah,0x0B
		mov al,0x04
		
		mov bx,[es:di]
		
		cmp ax,bx
		je near keyupdatescoreandflag
		
		;leg condition check
		add di,160
		mov bx,[es:di]
		cmp ax,bx
		je near keyupdatescoreandflag
		
		;head condition check
		sub di,320
		add di,2
		mov bx,[es:di]
		cmp ax,bx
		je near keyupdatescoreandflag
		
		mov ah,0x04			;red diamond check
		cmp ax,bx
		jne near lSDC1
		add word[arr2 + 4],5
		jmp kusaf_1
lSDC1:	
		mov ah,0x05			;ball check
		mov al,0x07
		cmp ax,bx
		jne near ScoreUpdateExit
		add word[arr2 + 4], 2
		jmp kusaf_1
		
righSideDiamondCheck:
		add si,2
		add di,1
		
		;condition 1
		mov ax,0xb800
		mov es,ax
		
		mov ah,0
		mov al,80
		mov bx,di
		mul bl
		add ax,si
		shl ax,1
		mov di,ax
		
		;trophy condition
		mov ah,0x8A
		mov al,0x06
		mov bx,[es:di]
		cmp ax,bx
		jne rSDC1
		add word[arr2 + 2],1
		add word[trophyflag],1
		jmp kusaf_1

rSDC1:		
		;condition 1
		mov ah,0x0B
		mov al,0x04
		
		mov bx,[es:di]
		
		cmp ax,bx
		je near keyupdatescoreandflag
		
		;legs condition
		add di,160
		mov bx,[es:di]
		cmp ax,bx
		je near keyupdatescoreandflag
		
		;head condition check
		sub di,322
		mov bx,[es:di]
		cmp ax,bx
		je near keyupdatescoreandflag
		
		mov ah,0x04				;red diamond
		cmp ax,bx
		jne near ScoreUpdateExit
		add word[arr2 + 4],5
		jmp kusaf_1
		
upSideDiamondCheck:
		sub di,1
		
		mov ax,0xb800
		mov es,ax
		
		mov ah,0
		mov al,80
		mov bx,di
		mul bl
		add ax,si
		shl ax,1
		mov di,ax
		
		mov ah,0x0B
		mov al,0x04
		mov bx,[es:di]
		cmp ax,bx
		je near keyupdatescoreandflag
		
		mov ah,0x04			;red diamond
		cmp ax,bx
		jne uSDC
		add word[arr2 + 4],5
		jmp kusaf_1

uSDC:		
		mov ah,0x05			;ball condition
		mov al,0x07
		cmp ax,bx
		jne near ScoreUpdateExit
		add word[arr2 + 4], 2
		jmp kusaf_1
			
downSideDiamondCheck:
		add di,3
		
		mov ax,0xb800
		mov es,ax
		
		mov ah,0
		mov al,80
		mov bx,di
		mul bl
		add ax,si
		shl ax,1
		mov di,ax
		
		mov ah,0x0B
		mov al,0x04
		
		mov bx,[es:di]
		
		cmp ax,bx
		je near keyupdatescoreandflag
		
		add di,2
		mov bx,[es:di]
		cmp ax,bx
		je near keyupdatescoreandflag
		
		sub di,4
		mov bx,[es:di]
		cmp ax,bx
		jne ScoreUpdateExit
		
keyupdatescoreandflag:
		add word[arr2 + 4], 1
kusaf_1:
		mov dx,[arr2 + 4]
		mov bx,[arr2 + 2]
		mov ax,[arr2]
		
		cmp dx,9
		jna ScoreUpdateExit
		
		sub dx,10
		mov word[arr2 + 4],dx
		add bx,1
		mov word[arr2 + 2],bx
		
		cmp bx,9
		jna ScoreUpdateExit
		
		sub bx,10
		mov word[arr2 + 2],bx
		add ax,1
		mov word[arr2 ],ax

ScoreUpdateExit:
		
		mov ax, 0x0B
		push ax
		mov ax, 23			;push x-axis
		push ax
		mov ax, 1			;push y-axis
		push ax
		call score
		
		mov word[leftkeyflag],0
		mov word[rightkeyflag],0
		mov word[upkeyflag],0
		mov word[downkeyflag],0
		
		mov dx,[trophyflag]
		cmp dx,2
		jne SUE
		;printing message of destination door for completion of game
		mov ax, 0x1B
		push ax				; push attribute on stack
		mov ax, 3
		push ax 			; push x-axis 
		mov ax, 4
		push ax				; push y-axis 
		mov ax, winmsg
		push ax				;pushing address of arr3
		mov ax, [winsize]
		push ax				;push size of the word
		call print_data
		
SUE:		
		pop di
		pop si
		pop dx
		pop bx
		pop ax
		pop es
		pop bp
		ret
;-;-;-;--;-;-;--;-;-;-;-;-;-;-;-;-;-;-;- Left key subroutine -;-;-;-;-;-;-;-;-;-;-;-;--;-;-;-;-;-;-;-;-;-;-;
;move left
leftkey:
		push ax
		push bx
		push cx
		push dx
		push si
		push di
		
		mov ax,[axis]		;x-axis
		mov bx,[axis+2]		;y-axis
		
		;winning condition check
		cmp ax,54
		jne movfurthercheck
		cmp bx,21
		jne movfurthercheck
		mov dx,[trophyflag]
		cmp dx,2
		jne movfurthercheck
		mov word[exitflag],1
		;je near escexit
		jmp near leftkeyexit

movfurthercheck:		
		mov si,[axis]		;stoing temp for checks
		mov di, [axis+2]
		
		cmp si,5			;1st left wall condition
		je near leftkeyexit
				
		;2nd row bricks condition
		cmp si,9
		je ldeepcheck1
		cmp si,25
		je ldeepcheck1
		cmp si,43
		je ldeepcheck1
		cmp si,61
		je ldeepcheck1
		jne near leftconditioncheck2

ldeepcheck1:
		cmp di,14				;check head collision
		je near leftkeyexit
		cmp di,15
		je near leftkeyexit
		add di,2				;check legs collision
		cmp di,14
		je near leftkeyexit
		cmp di,15
		je near leftkeyexit
		
;lastrowBricks check		
leftconditioncheck2:
		cmp si,36
		je ldeepcheck2
		cmp si,71
		je ldeepcheck2
		jne near leftconditioncheck3
		;jne movmanleft
		
ldeepcheck2:
		cmp di,19				;check head collision
		je near leftkeyexit
		cmp di,20
		je near leftkeyexit
		add di,2				;check legs collision
		cmp di,19
		je near leftkeyexit
		cmp di,20
		je near leftkeyexit
		jne near leftconditioncheck3
		
;door check
leftconditioncheck3:
		cmp si,8
		je ldeepcheck3
		jne near leftconditioncheck4
		
ldeepcheck3:
		cmp di,21				;check head collision
		je near leftkeyexit
		add di,2				;check legs collision
		cmp di,21
		je near leftkeyexit
		cmp di,22
		je near leftkeyexit
		cmp di,23
		je near leftkeyexit
		jne near leftconditioncheck4
			
;1st row bricks condition
leftconditioncheck4:
		cmp si,16
		je ldeepcheck4
		cmp si,34
		je ldeepcheck4
		cmp si,52
		je ldeepcheck4
		cmp si,70
		je ldeepcheck4
		jne near leftconditioncheck5
		
ldeepcheck4:
		cmp di,9				;check head collision
		je leftkeyexit
		cmp di,10
		je leftkeyexit
		add di,2				;check legs collision
		cmp di,9
		je leftkeyexit
		cmp di,10
		je leftkeyexit
		
;destination door condition
leftconditioncheck5:
		cmp si,54
		jne near movmanleft
		cmp di,21				;check head collision
		je leftkeyexit			
	
movmanleft:
		mov word[leftkeyflag],1					;making left flag one
		push ax
		push bx
		call scoreUpdatingroutine							;calling score updating routine
		pop bx
		pop ax
		
		mov cx, 0x07
		push cx	  		; push attribute on stack
		push ax 			
		push bx				
		call blackBackground
		
		sub ax,1			;adding 1 for left movement
		mov word[axis],ax
		
		mov cx, 0x0A
		push cx	  		; push attribute on stack
		push ax 			
		push bx				
		call man
		
leftkeyexit:
		pop di
		pop si
		pop dx
		pop cx
		pop bx
		pop ax	
		ret
;-;-;-;--;-;-;--;-;-;-;-;-;-;-;-;-;-;-;- right key subroutine -;-;-;-;-;-;-;-;-;-;-;-;--;-;-;-;-;-;-;-;-;-;-;		
;move right
rightkey:
		push ax
		push bx
		push cx
		push si
		push di	
		
		mov ax,[axis]		;x-axis
		mov bx,[axis+2]		;y-axis
		
		mov si,ax
		mov di,bx
		;right wall check
		cmp si,74
		je near rightkeyexit
		
		;right side of first row bricks check
		cmp si,9
		je rdeepcheck1
		cmp si,27
		je rdeepcheck1
		cmp si,45
		je rdeepcheck1
		cmp si,63
		je rdeepcheck1
		jne near rconditioncheck2
		
rdeepcheck1:
		cmp di,9				;check head collision
		je near rightkeyexit
		cmp di,10
		je near rightkeyexit
		add di,2				;check legs collision
		cmp di,9
		je near rightkeyexit
		cmp di,10
		je near rightkeyexit
		jne near rconditioncheck2
		
		;condition 2
rconditioncheck2:
		cmp si,18
		je rdeepcheck2
		cmp si,36
		je rdeepcheck2
		cmp si,54
		je rdeepcheck2
		cmp si,70
		je rdeepcheck2
		jne near rconditioncheck3
		
rdeepcheck2:
		cmp di,14				;check head collision
		je near rightkeyexit
		cmp di,15
		je near rightkeyexit
		add di,2				;check legs collision
		cmp di,14
		je near rightkeyexit
		cmp di,15
		je near rightkeyexit
		jne near rconditioncheck3
		
		;condition 3
rconditioncheck3:
		cmp si,13
		je rdeepcheck3
		jne near rconditioncheck4
		
rdeepcheck3:
		cmp di,19				;check head collision
		je rightkeyexit
		cmp di,20
		je rightkeyexit
		add di,2				;check legs collision
		cmp di,19
		je rightkeyexit
		cmp di,20
		je rightkeyexit
		
		;condition 4
rconditioncheck4:
		cmp si,44
		je rdeepcheck4
		jne near movmanright
		
rdeepcheck4:
		add di,2				;check legs collision
		cmp di,19
		je rightkeyexit
		cmp di,20
		je rightkeyexit
		cmp di,21
		je rightkeyexit
		cmp di,22
		je rightkeyexit
		cmp di,23
		je rightkeyexit
		jne near movmanright		
		
movmanright:
		mov word[rightkeyflag],1					;making right flag one for score updation
		push ax
		push bx
		call scoreUpdatingroutine							;calling score updating routine
		pop bx
		pop ax

		mov cx, 0x07
		push cx	  		; push attribute on stack
		push ax 			
		push bx				
		call blackBackground
		
		add ax,1			
		mov word[axis],ax
		
		mov cx, 0x0A
		push cx	  		; push attribute on stack
		push ax 			
		push bx				
		call man

rightkeyexit:		
		pop di
		pop si
		pop cx
		pop bx
		pop ax		
		ret
;-;-;-;--;-;-;--;-;-;-;-;-;-;-;-;-;-;-;- up key subroutine -;-;-;-;-;-;-;-;-;-;-;-;--;-;-;-;-;-;-;-;-;-;-;		
;move up
upkey:
		push ax
		push bx
		push cx
		push si
		push di
		
		mov ax,[axis]		;x-axis
		mov bx,[axis+2]		;y-axis
		mov si,ax
		mov di,bx		
		
		cmp di,6		;roof condition
		je near upkeyexit
		
		;condition 1 first row bricks
		cmp di,11
		jne near upconditioncheck2
		
		cmp si,10
		je near upkeyexit
		cmp si,11
		je near upkeyexit
		cmp si,12
		je near upkeyexit
		cmp si,13
		je near upkeyexit
		cmp si,14
		je near upkeyexit
		cmp si,15
		je near upkeyexit
		
		cmp si,28
		je near upkeyexit
		cmp si,29
		je near upkeyexit
		cmp si,30
		je near upkeyexit
		cmp si,31
		je near upkeyexit
		cmp si,32
		je near upkeyexit
		cmp si,33
		je near upkeyexit
		
		cmp si,46
		je near upkeyexit
		cmp si,47
		je near upkeyexit
		cmp si,48
		je near upkeyexit
		cmp si,49
		je near upkeyexit
		cmp si,50
		je near upkeyexit
		cmp si,51
		je near upkeyexit
		
		cmp si,64
		je near upkeyexit
		cmp si,65
		je near upkeyexit
		cmp si,66
		je near upkeyexit
		cmp si,67
		je near upkeyexit
		cmp si,68
		je near upkeyexit
		cmp si,69
		je near upkeyexit			
		
		;condition 2 second row bricks
upconditioncheck2:
		cmp di,16
		jne near upconditioncheck3
		
		cmp si,4
		je near upkeyexit
		cmp si,5
		je near upkeyexit
		cmp si,6
		je near upkeyexit
		cmp si,7
		je near upkeyexit
		cmp si,8
		je near upkeyexit
		
		cmp si,19
		je near upkeyexit
		cmp si,20
		je near upkeyexit
		cmp si,21
		je near upkeyexit
		cmp si,22
		je near upkeyexit
		cmp si,23
		je near upkeyexit
		cmp si,24
		je near upkeyexit
		
		cmp si,37
		je near upkeyexit
		cmp si,38
		je near upkeyexit
		cmp si,39
		je near upkeyexit
		cmp si,40
		je near upkeyexit
		cmp si,41
		je near upkeyexit
		cmp si,42
		je near upkeyexit
		
		cmp si,55
		je near upkeyexit
		cmp si,56
		je near upkeyexit
		cmp si,57
		je near upkeyexit
		cmp si,58
		je near upkeyexit
		cmp si,59
		je near upkeyexit
		cmp si,60
		je near upkeyexit		
		
		cmp si,71
		je near upkeyexit
		cmp si,72
		je near upkeyexit
		cmp si,73
		je near upkeyexit
		cmp si,74
		je near upkeyexit
		cmp si,75
		je near upkeyexit		
		
		;condition 3 third row of bricks
upconditioncheck3:
		cmp di,21
		jne near movmanup

		mov cx,14		
u_d_c_3_l_1:					;up deep check 3 loop 1		
		cmp si,cx
		je near upkeyexit
		add cx,1
		cmp cx,36
		jne u_d_c_3_l_1
		
		mov cx,50
		
u_d_c_3_l_2:					;up deep check 3 loop 2		
		cmp si,cx
		je near upkeyexit
		add cx,1
		cmp cx,71
		jne u_d_c_3_l_2		

movmanup:
		mov word[upkeyflag],1					;making up flag one 
		push ax
		push bx
		call scoreUpdatingroutine							;calling score updating routine
		pop bx
		pop ax
		
		mov cx, 0x07
		push cx	  		; push attribute on stack
		push ax 			
		push bx				
		call blackBackground
		
		sub bx,1			
		mov word[axis+2],bx
		
		mov cx, 0x0A
		push cx	  		; push attribute on stack
		push ax 			
		push bx				
		call man
		
upkeyexit:
		pop di
		pop si
		pop cx
		pop bx
		pop ax		
		ret
;-;-;-;--;-;-;--;-;-;-;-;-;-;-;-;-;-;-;- down key subroutine -;-;-;-;-;-;-;-;-;-;-;-;--;-;-;-;-;-;-;-;-;-;-;		
		
;move down
downkey:
		push ax
		push bx
		push cx
		push si
		push di
		
		mov ax,[axis]		;x-axis
		mov bx,[axis+2]		;y-axis
		mov si,ax
		mov di,bx	
		
		cmp di,21			;ground wall condition
		je near downkeyexit
		
		add di,2
		;condition 1 first row bricks
		cmp di,8
		jne near downconditioncheck2
		
		cmp si,10
		je near downkeyexit
		cmp si,11
		je near downkeyexit
		cmp si,12
		je near downkeyexit
		cmp si,13
		je near downkeyexit
		cmp si,14
		je near downkeyexit
		cmp si,15
		je near downkeyexit
		
		cmp si,28
		je near downkeyexit
		cmp si,29
		je near downkeyexit
		cmp si,30
		je near downkeyexit
		cmp si,31
		je near downkeyexit
		cmp si,32
		je near downkeyexit
		cmp si,33
		je near downkeyexit
		
		cmp si,46
		je near downkeyexit
		cmp si,47
		je near downkeyexit
		cmp si,48
		je near downkeyexit
		cmp si,49
		je near downkeyexit
		cmp si,50
		je near downkeyexit
		cmp si,51
		je near downkeyexit
		
		cmp si,64
		je near downkeyexit
		cmp si,65
		je near downkeyexit
		cmp si,66
		je near downkeyexit
		cmp si,67
		je near downkeyexit
		cmp si,68
		je near downkeyexit
		cmp si,69
		je near downkeyexit			
		
		;condition 2 second row bricks
downconditioncheck2:
		cmp di,13
		jne near downconditioncheck3
		
		cmp si,4
		je near downkeyexit
		cmp si,5
		je near downkeyexit
		cmp si,6
		je near downkeyexit
		cmp si,7
		je near downkeyexit
		cmp si,8
		je near downkeyexit
		
		cmp si,19
		je near downkeyexit
		cmp si,20
		je near downkeyexit
		cmp si,21
		je near downkeyexit
		cmp si,22
		je near downkeyexit
		cmp si,23
		je near downkeyexit
		cmp si,24
		je near downkeyexit
		
		cmp si,37
		je near downkeyexit
		cmp si,38
		je near downkeyexit
		cmp si,39
		je near downkeyexit
		cmp si,40
		je near downkeyexit
		cmp si,41
		je near downkeyexit
		cmp si,42
		je near downkeyexit
		
		cmp si,55
		je near downkeyexit
		cmp si,56
		je near downkeyexit
		cmp si,57
		je near downkeyexit
		cmp si,58
		je near downkeyexit
		cmp si,59
		je near downkeyexit
		cmp si,60
		je near downkeyexit
		
		
		cmp si,71
		je near downkeyexit
		cmp si,72
		je near downkeyexit
		cmp si,73
		je near downkeyexit
		cmp si,74
		je near downkeyexit
		cmp si,75
		je near downkeyexit		
		
		;condition 3 third row of bricks
downconditioncheck3:
		cmp di,18
		jne near downconditioncheck4

		mov cx,14		
d_d_c_3_l_1:					;down deep check 3 loop 1		
		cmp si,cx
		je near downkeyexit
		add cx,1
		cmp cx,36
		jne d_d_c_3_l_1
		
		mov cx,45
		
d_d_c_3_l_2:					;down deep check 3 loop 2		
		cmp si,cx
		je near downkeyexit
		add cx,1
		cmp cx,71
		jne d_d_c_3_l_2	

		;condition 4 above the left door
downconditioncheck4:
		cmp di,20
		jne near movmandown
		
		cmp si,4
		je near downkeyexit
		cmp si,5
		je near downkeyexit
		cmp si,6
		je near downkeyexit
		cmp si,7
		je near downkeyexit	

movmandown:	
		mov word[downkeyflag],1						;making down flag one
		push ax
		push bx
		call scoreUpdatingroutine							;calling score updating routine
		pop bx
		pop ax
		
		mov cx, 0x07
		push cx	  		; push attribute on stack
		push ax 			
		push bx				
		call blackBackground
		
		add bx,1			
		mov word[axis+2],bx
		
		mov cx, 0x0A
		push cx	  		; push attribute on stack
		push ax 			
		push bx				
		call man
		
downkeyexit:
		pop di
		pop si
		pop cx
		pop bx
		pop ax		
		ret

;__________________________________________________ Key board interupt________________________________________;

;keyboard interupt caller
;mainting up , down, left and right arrow conditions

kbisr: 		push ax
			push es
			
			mov ax, 0xb800
			mov es, ax		
			in al, 0x60
			
			cmp al,0x4b				;left arrow key scan
			jne nextcmp1		
			call leftkey
			jmp nomatch
			
nextcmp1:	cmp al, 0x4d			;right arrow key scan
			jne nextcmp2			
			call rightkey
			jmp nomatch
			
nextcmp2:	cmp al, 0x48			;up arrow key scan
			jne nextcmp3			
			mov cx,5
upjump:		call upkey
			loop upjump
			jmp nomatch
			
nextcmp3:	;cmp al,0xC8				;move downward when up key releases
;			je ddnk
			cmp al,0xCB
			je ddnk
			cmp al,0xCD
			;cmp al, 0x50			;down arrow key scan
			jne nomatch

ddnk:			
			mov cx,5
jumpdowm_l1:		
			call downkey
			loop jumpdowm_l1
			
nomatch:	;mov al,0x20
			;out 0x20,al
			pop es
			pop ax
			jmp far [cs: oldisr]
			;iret

;______________________________________________________Main____________________________________________________;
;original main 	
main:
	call start
	
		xor ax,ax
		mov es,ax
		
		mov ax,[es:9*4]
		mov [oldisr],ax
		mov ax,[es: 9*4+2]
		mov [oldisr+2],ax
		
		cli 
		mov word[es: 9*4], kbisr
		mov [es: 9*4+2],cs
		
		sti
		
;keyboard iterupt loop		
il1:		mov ah,0
		int 0x16
		
		mov dx,word[exitflag]
		cmp dx,1
		je escexit
		
		cmp al,27
		jne il1
		
escexit:		
		mov ax,[oldisr]
		mov bx,[oldisr + 2]
		cli
		mov [es:9*4],ax
		mov [es:9*4+2],bx
		sti

		mov ax,0x4c00
		int 0x21
	