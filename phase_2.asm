;Phase 2

;Arslan Rasheed       20L-2090
;Hafiz Hamza Shahid   20L-1050

[org 0x0100]
	jmp start
	
arr1:	db '    ----->     SCORE:            LEVEL  01  DAVE            <-----              '
size1:	dw	80

arr2: dw 0,0,0,0

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
	
;subroutine for printing data
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
		
;emoji subroutine
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
	
;bricks subroutine vertical
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

;subroutine of the door	
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

;diamond subroutine 	
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
	
;man subroutine
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
	

	;mov al, 0x93    ;print o(cap)
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

;cup subroutine
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

;ball subroutine
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
	
;score updating subroutines
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

	
;main fucntion
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
		mov ax, 10			;x-axis			
		push ax 			 
		mov ax, 21			;y-axis
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
		
	
	mov ax,0x4c00
	int 21h
	