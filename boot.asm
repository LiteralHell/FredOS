	BITS 16
	
start:
	mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax

	;mov si, text_string1	; Put string position into SI
	;call print_string	; Call our string-printing routine
	;mov si, text_string2
	;call print_string
	call video_mode
	call create_pixel

	jmp $			; Jump here - infinite loop!


	text_string1 db '-=FredOS=-',0Ah,0Dh,0
	text_string2 db 'Work in Progress',0Ah,0Dh, 0


print_string:			; Routine: output string in SI to screen
	mov ah, 0Eh		; int 10h 'print char' function

video_mode:
	mov ax,13h		; sets the video mode
	int 10h         ; interrupt call 10h
	ret

create_pixel:
	mov ax,0A000h        
	mov es,ax             
	mov ax,32010          
	mov di,ax             
	mov dl,4             
	mov [es:di],dx        
	int 10h

.repeat:
	lodsb			; Get character from string
	cmp al, 0
	je .done		; If char is zero, end of string
	int 10h			; Otherwise, print it
	jmp .repeat

.done:
	ret


	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature
