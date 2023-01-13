;welcome
;rules and other information
;Enter (to continue ) 
;Esc	(to exit)

;Arslan Rasheed       20L-2090
;Hafiz Hamza Shahid   20L-1050

[org 0x0100]
	jmp start
	
arr1: db '                     -->>  W E L C O M E  <<--                       '
size1: dw 69

arr2: db ' Instructions: '
size2: dw 15

arr3_1: db ' 1) Use arrow keys for playing. '
size3_1: dw 32
arr3_2:	db ' 2) Get the cup and move to second level '
size3_2: dw 41

arr5_1: db ' { Enter } : '
size5_1: dw 13
arr5_2: db ' -> Press Enter to continue <- '
size5_2: dw 31

arr6_1: db ' { ESC } : '
size6_1: dw 11
arr6_2: db ' -> Press Esc to exit <- '
size6_2: dw 25

arr7: db '                   CREATED BY : ARSLAN and HAMZA                     '
size7: dw 69

arr8: db ' DANGER DAVE '
size8: dw 13

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
	

; subroutine to print horizontal lines
printhor: 	
			push bp
			mov bp, sp
			push es
			push ax
			push cx
			push di
			push bx
	
			mov ax, 0xb800
			mov es, ax ; point es to video base
			
			mov al, 80	;load al with columns
			mov bx,[bp + 8]  ;multiply with y position
			mov bh,0
			mul bl
			add ax,[bp+10]		;add x position
			shl ax,1			; turn into byte offset
			
			mov di, ax ; point di our required location
			mov cx, [bp+4] ; load length of horizontal line in cx
			mov ah, [bp+6] ; normal attribute fixed in ah
			mov al, 0x20	;printing space for rectangle
			
nexthor: 
			mov [es:di], ax ; show this char on screen
			add di, 2 ; move to next screen location
		loop nexthor ; repeat the operation cx times
		
		pop bx
		pop di
		pop cx
		pop ax
		pop es
		pop bp
		ret 8

;subroutine for printing vertical lines
printver: 	
			push bp
			mov bp, sp
			push es
			push ax
			push cx
			push di
			push bx
			
tworep:			
			mov ax, 0xb800
			mov es, ax ; point es to video base
			
			mov al, 80	;load al with columns
			mov bx,[bp + 8]  ;multiply with y position
			mov bh,0
			mul bl
			add ax,[bp+10]		;add x position
			shl ax,1			; turn into byte offset
			
			mov di, ax ; point di our required location
			mov cx, [bp+4] ; load length of vertical line in cx
			mov ah, [bp+6] ; normal attribute fixed in ah
			mov al, 0x20		;printin space for rectangle
			
nextver: 	
			mov [es:di], ax ; show this char on screen
			add di, 160 ; move to next screen location
		loop nextver ; repeat the operation cx times
		
		pop bx
		pop di
		pop cx
		pop ax
		pop es
		pop bp
		ret 8

	
;subroutine for printing welcome, continue , exit and other data
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
	
	mov al, 0x20
	mov [es:di], ax
	add di,2
	mov al, 0x01
	mov [es:di], ax
	add di,2
	mov [es:di], ax
	add di,2
	mov al, 0x20
	mov [es:di], ax
	
	pop di
	pop ax
	pop es
	pop bp
	
	ret 6
	
	

;start of main
start:	
		call clrscr		;clear the whole screen first
		
		;printing big rectangle (1st horizontal line) here
		mov ax, 5					
		push ax 			; push x-axis
		mov ax, 2						
		push ax; 			push y-axis 
		mov ax, 0x70
		push ax				;red color of rectangle
		mov ax, 70
		push ax				;length of line on stack
		call printhor
		
		
		;printing big rectangle (1st vertical line) here
		mov ax, 5					
		push ax 			; push x-axis
		mov ax, 2						
		push ax 			;push y-axis
		mov ax, 0x70
		push ax				;red color of rectangle
		mov ax, 22
		push ax				;length of line on stack
		call printver
		
		;printing big rectangle (2nd horizontal line) here
		mov ax, 5					
		push ax 			; push x-axis
		mov ax, 24						
		push ax; 			push y-axis 
		mov ax, 0x70
		push ax				;red color of rectangle
		mov ax, 70
		push ax				;length of line on stack
		call printhor
		
		
		;printing big rectangle (2nd svertical line) here
		mov ax, 75					
		push ax 			; push x-axis
		mov ax, 2						
		push ax 			;push y-axis
		mov ax, 0x70
		push ax				;red color of rectangle
		mov ax, 23
		push ax				;length of line on stack
		call printver
		
		
		;emoji print left side
		mov ax, 0xCB
		push ax				; push attribute on stack
		mov ax, 28
		push ax 			; push x-axis 
		mov ax, 4
		push ax				; push y-axis 
		call emoji
		
		;emoji print right side
		mov ax, 0xCB
		push ax				; push attribute on stack
		mov ax, 45
		push ax 			; push x-axis 
		mov ax, 4
		push ax				; push y-axis 
		call emoji
		
		;remaing print of Danger Dave word
		mov ax, 0x6B
		push ax				; push attribute on stack
		mov ax, 32
		push ax 			; push x-axis 
		mov ax, 4
		push ax				; push y-axis 
		mov ax, arr8
		push ax				;pushing address of 'danger dave'
		mov ax, [size8]
		push ax				;push size of the word
		call print_data
		
		
		;remaing print of welcome word
		mov ax, 0xEE
		push ax				; push attribute on stack
		mov ax, 6
		push ax 			; push x-axis 
		mov ax, 7
		push ax				; push y-axis 
		mov ax, arr1
		push ax				;pushing address of 'welcome'
		mov ax, [size1]
		push ax				;push size of the word
		call print_data
		
		;print of Instructions word
		mov ax, 0x5F
		push ax				; push attribute on stack
		mov ax, 9
		push ax 			; push x-axis 
		mov ax, 10
		push ax				; push y-axis
		mov ax, arr2
		push ax				;pushing address of 'elcome'
		mov ax, [size2]
		push ax				;push size of the word
		call print_data
		
		
		;print of Instructions details part 1
		mov ax, 0x74
		push ax				; push attribute on stack
		mov ax, 9
		push ax 			; push x-axis 
		mov ax, 12
		push ax				; push y-axis 
		mov ax, arr3_1
		push ax				;pushing address of arr3
		mov ax, [size3_1]
		push ax				;push size of the word
		call print_data
		
		;print of Instructions details part 2
		mov ax, 0x74
		push ax				; push attribute on stack
		mov ax, 9
		push ax 			; push x-axis 
		mov ax, 13
		push ax				; push y-axis 
		mov ax, arr3_2
		push ax				;pushing address of arr3
		mov ax, [size3_2]
		push ax				;push size of the word
		call print_data
		
		
		;print of continue word
		mov ax, 0x1A
		push ax				; push attribute on stack
		mov ax, 10
		push ax 			; push x-axis 
		mov ax, 17
		push ax				; push y-axis 
		mov ax, arr5_1
		push ax				;pushing address of 'continue'
		mov ax, [size5_1]
		push ax				;push size of the word
		call print_data
		
		;print of continue details
		mov ax, 0x1A
		push ax				; push attribute on stack
		mov ax, 40
		push ax 			; push x-axis 
		mov ax, 17
		push ax				; push y-axis 
		mov ax, arr5_2
		push ax				;pushing address of 'continue'
		mov ax, [size5_2]
		push ax				;push size of the word
		call print_data
		
		
		;print of exit word
		mov ax, 0x4D
		push ax				; push attribute on stack
		mov ax, 10
		push ax 			; push x-axis 
		mov ax, 19
		push ax				; push y-axis 
		mov ax, arr6_1
		push ax				;pushing address of 'exit'
		mov ax, [size6_1]
		push ax				;push size of the word
		call print_data
		
		;print of exit word details
		mov ax, 0x4D
		push ax				; push attribute on stack
		mov ax, 40
		push ax 			; push x-axis 
		mov ax, 19
		push ax				; push y-axis 
		mov ax, arr6_2
		push ax				;pushing address of 'exit'
		mov ax, [size6_2]
		push ax				;push size of the word
		call print_data
		
		
		;print of developer details
		mov ax, 0xAE
		push ax				; push attribute on stack
		mov ax, 6
		push ax 			; push x-axis 
		mov ax, 22
		push ax				; push y-axis 
		mov ax, arr7
		push ax				;pushing address of 'developer data'
		mov ax, [size7]
		push ax				;push size of the word
		call print_data
		
		
	mov ax, 0x4c00 ; terminate program
	int 0x21