; Author: Apertx
; Compile A72 assembler

mov ax,11h
int 10h
mov ax,0a000h
mov es,ax

mov cx,38462
mov dx,mikuv
call file_load

mov si,dx
mov dx,0
mov bx,0
call bmp_draw
mov dx,48
mov bx,240
call bmp_draw

;call buf_swap

mov cx,800h
mov dx,font
call file_load

mov si,dx
mov di,miku
mov dx,56
mov bx,472
mov cx,12
met1:
call font_print
sub bx,8
loop met1

mov al,' '
mov dx,56
mov bx,376
mov cx,24
met2:
call font_putc
inc dx
loop met2

exit:
;call buf_swap
xor ah,ah
int 16h
dec ah
jnz exit
mov al,3
int 10h
int 20h

; CX: File size
; DX: Pointer to buffer with path
;
file_load:
 push ax
 push bx
 mov ax,3d00h
 int 21h
 mov bx,ax
 mov ah,3fh
 int 21h
 mov ah,3eh
 int 21h
 pop bx
 pop ax
ret

; AL: Symbol code
; DX: X position
; BX: Y position
; SI: Pointer to font
;
font_putc:
 push ax
 push cx
 push dx
 push si
 push di
 mov ah,8
 mul ah
 add si,ax
 mov di,dx
 mov ax,80
 mul bx
 add di,ax
 mov cx,8
 _font_putc:
  movsb
  add di,79
 loop _font_putc
 pop di
 pop si
 pop dx
 pop cx
 pop ax
ret

; DI: Pointer to string ends 0
; DX: X position
; BX: Y position
;
font_print:
 push ax
 push bx
 push dx
 push di
 _font_print:
  mov al,[di]
  test al,al
  jz _font_print_end
  call font_putc
  inc di
  inc dx
  cmp dx,80
  jne _font_print_nonl
  add bx,8
  xor dx,dx
  _font_print_nonl:
 jmp _font_print
 _font_print_end:
 pop di
 pop dx
 pop bx
 pop ax
ret

; DX: X position
; BX: Y position
; SI: Pointer to bmp
;
bmp_draw:
 push ax
 push bx
 push cx
 push dx
 push si
 push di
 add si,3eh
 mov di,dx
 mov cx,dx
 mov ax,[si-28h]
 add ax,bx
 mov dx,80
 mul dx
 add di,ax
 mov ax,[si-28h]
 mov dx,[si-2ch]
 shr dx,1
 shr dx,1
 shr dx,1
 xor bx,bx
 add cx,dx
 sub cx,80
 jle _bmp_draw
 mov bx,cx
 sub dx,cx
 _bmp_draw:
  mov cx,dx
  rep movsb
  add si,bx
  sub di,dx
  sub di,80
  dec ax
 jnz _bmp_draw
 pop di
 pop si
 pop dx
 pop cx
 pop bx
 pop ax
ret

buf_swap:
 push ax
 push dx
 mov ax,es
 xor ax,960h
 mov es,ax
 mov dx,3d4h
 mov al,2ch
 inc dx
 in al,dx
 xor al,96h
 out dx,al
 pop dx
 pop ax
ret

miku db ' Hatsune Miku by Apertx ',0
font db 'BIOS.FNT',0
mikuv db 'MIKUM.BMP',0
