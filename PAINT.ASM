.model small
.stack
.data
tub	db '			Paint by Simkin A.P.',13,10,
	db '			--------------------------------',13,10,
	db '			������騩 梥�(+)',13,10,
	db '			�।��騩 梥�(-)',13,10,
	db '			������ ��࠭�(Backspace)',13,10,
	db '			��室(Esc)',13,10,
	db '			����� �ᮢ����(p)',13,10,
	db '			��ᮢ���(���)',13,10,
	db '			���⨪(���)',13,10,
	db '			����� �����㣮�쭨���(s)',13,10,
	db '			���� �����㣮�쭨�(���)',13,10,
	db '			����襭�� �����㣮�쭨�(���)',13,10,
	db '			����� ������� �����(f)',13,10,
	db '			������� �� ��ਧ��⠫�(���)',13,10,
	db '			������� �� ���⨪���(���)',13,10,
	db '			--------------------------------',13,10,
	db '			��� ��砫� ������ ���� �������',13,10,
	db '$'
er_mes db '���� �� ��⠭������!',13,10,'$'
mes db '�ணࠬ�� �����設�',13,10,'$'
x dw 0
y dw 0
x1 dw 0
y1 dw 0
x2 dw 0
y2 dw 0
color db 1
stat db 1
ncr db 0
zlcol db 0
grcol db 0
zal_cr dw 16 dup(0ffffh)
	dw 0e000h,8000h,8000h,0180h
	dw 0660h,0810h,1008h,1818h
	dw 1e78h,1ff8h,1ff8h,1ff8h
	dw 1ff8h,0ff0h,07e0h,03c0h
sqr_cr dw 16 dup(0ffffh)
	dw 0e000h,8000h,8000h,1ff8h
	dw 1008h,1008h,1008h,1008h
	dw 1008h,1008h,1008h,1008h
	dw 1ff8h,0000h,0000h,0000h
pen_cr dw 16 dup(0ffffh)
	dw 0e000h,9000h,8800h,4400h
	dw 2200h,1100h,0880h,0440h
	dw 0220h,0110h,0088h,0044h
	dw 002eh,001Fh,000Eh,0004h
.code
.386
jmp main
; ������� ������� ����� �� ���������� color, ����� �������, � ������ ������� ����
; ��������� ����������
which_color proc near	;near - ����������(������, ������ � ���� ��������)
	mov cx,599	;���������� �� x
	mov dx,11		;���������� �� y
	mov al,color	;���� �������
	mov ah,0ch	;������� ��� ������������ �����
; ������� ������� ����� �� ���������� color
ntrw:
	inc dx		;�������� �� 1 �� y
	int 10h		;���������
	cmp dx,40		;���� y ��=40
	jnz ntrw
	mov dx,11		;���������� y �����
	inc cx		;�������� x �� 1
	cmp cx,630	;���� x ��=630
	jnz ntrw
; ��������� ���������� � ����� ����
	mov al,15		;����� ����
	mov cx,599	;���������� �� x
	mov dx,10		;���������� �� y
; ������������ �����
ntrw1:
	inc dx		;�������� y �� 1
	int 10h		;���������
	cmp dx,40		;���� y ��=40
	jnz ntrw1
	mov dx,10		;y=10
	add cx,31		;x=x+31
	cmp cx,630	;���� x=630, �� �������
	jz ntrw1
	mov cx,599	;x=599
	mov dx,11		;y=11
; �������������� �����
ntcl1:
	inc cx		;x+1
	int 10h		;���������
	cmp cx,630	;���� x ��= 630 - �������
	jnz ntcl1
	add dx,29		;y=y+29
	mov cx,599	;x=599
	cmp dx,40		;���� y=40 - �������
	jz ntcl1
	ret
which_color endp
; �������� ������
cursor_on proc near	;near - ����������(������, ������ � ���� ��������)
	mov ax,01		;�������� ������
	int 33h
	ret
cursor_on endp
; ��������� ������
cursor_off proc near	;near - ����������(������, ������ � ���� ��������)
	mov ax,2		;��������� ������
	int 33h
	ret
cursor_off endp
; ������ ��������� ���� � ������� � ����������
mouse_stat proc near	;near - ����������(������, ������ � ���� ��������)
	mov ax,3		;�������� ���������� � ��������� ������� � ��������� ������ ����
	int 33h
	mov stat,bl	;����� ������� ������
	mov x,cx		;���������� x
	mov y,dx		;���������� y
	ret
mouse_stat endp
; ��������� ������� 2X3 ����� �� ���������� color � ������� �������
paint_pixel proc near	;near - ����������(������, ������ � ���� ��������)
	call cursor_off
	mov ah,0Ch	;������� ��� ������������ �����
	mov al,color	;����
	mov dx,y		;������ y
	mov cx,x		;������ x
	int 10h		;���������
	dec cx		;x-1
	int 10h		;���������
	inc dx		;y+1
	int 10h		;���������
	inc cx		;x+1
	int 10h		;���������
	inc dx		;y+1
	int 10h		;���������
	dec cx		;x-1
	int 10h		;���������
	call cursor_on
	ret
paint_pixel endp
; ������
eraser proc near	;near - ����������(������, ������ � ���� ��������)
	mov dh,color	;���������� ����� ����� ����
	push dx
	mov color,0	;������ ����
; ��������� ������� ���
pr:
	call mouse_stat
	mov bl,stat
	and bl,2
	cmp bl,2		;���� �� ����� ��� - ����������
	jne npr
	call paint_pixel
; ��� ��������� ���, ���������� ������ ����
npr:
	pop dx
	mov color,dh	; ���������� ����, ������� ����������
	ret
eraser endp
; ���������, x1 - ������ x2, y1 - ������ y2
; ���������, x1 ������ x2? ���� ������ �� ����������, ����� ������ �������
sortxy proc near	;near - ����������(������, ������ � ���� ��������)
	mov cx,x1		;cx=x1
	mov dx,x2		;dx=x2
	cmp cx,dx		;���� x1<x2 - �������
	jb below1
	mov x1,dx		;����� x1=x2
	mov x2,cx		;x2=x1
; ���������, y1 ������ y2? ���� ������ �� ����������, ����� ������ �������
below1:
	mov cx,y1		;cx=y1
	mov dx,y2		;dx=y2
	cmp cx,dx		;���� y1<y2 - �������
	jb below2	
	mov y1,dx		;����� y1=y2
	mov y2,cx		;y2=y1
below2:
	ret
sortxy endp
; ����� �����������������
; ������������� ������ (�����) � ���������� ��� � ����������.
ncurs:
	mov ncr,0		;���������� ����� �������
	mov ax,9		;�������� ����� �������
	xor bx,bx		;����� ������� �����-��������� ������������ ������� (�� -16 �� 16)
	xor cx,cx		;����� ������ �����-��������� (�� -16 �� 16)
	lea dx,pen_cr	;ES:DX - ��������� �� ����������� �������
	int 33h
	jmp ekey
; ������������� ������ (�������) � ���������� ��� � ����������.
sqr:
	mov ncr,1		;���������� ����� �������
	mov ax,9		;�������� ����� �������
	xor bx,bx		;����� ������� �����-��������� ������������ ������� (�� -16 �� 16)
	xor cx,cx		;����� ������ �����-��������� (�� -16 �� 16)
	lea dx,sqr_cr	;ES:DX - ��������� �� ����������� �������
	int 33h
; ���������, ����� ������� ������
prs:
	mov ah,01h	;�������� ��������� ����������
	int 16h
	jz ekey1
	mov ah,0h		;������ ����� ����������
	int 16h
	cmp al,2bh	; ������ +
	jne clp2
	call clp
clp2:
	cmp al,66h	; ������ f
	je zlln
	cmp al,2dh	; ������ -
	jne clm2
	call clm
clm2:
	cmp al,1bh	; ������� esc
	je ex
	cmp al,8h		; ������� BackSpace
	jne clrscr2
	call clrscr
clrscr2:
	cmp al,70h	; ������ p
	je ncurs
; ��������� ������� ��� ��� ��� � ��������� ��������� ������� � x1, y1
ekey1:
	call mouse_stat
	mov bl,stat
	and bl,2
	cmp bl,2		;���� ����� ��� - �������
	je rprst
	mov bl,stat
	and bl,1		
	cmp bl,1		;���� �� ����� ��� - �������
	jne prs
;���������� ��������� ��������� �������
	mov cx,x		;cx=x
	mov x1,cx		;x1=x
	mov dx,y		;dx=y
	mov y1,dx		;y1=y
; ��������� ����� ������� ��� � ��������� ��������� ������� � x2, y2
unprs:
	call mouse_stat
	and bl,1		
	cmp bl,1		;���� ����� ��� - �������
	je unprs
	call cursor_off
;���������� �������� ��������� �������
	mov cx,x		;cx=x
	mov x2,cx		;x2=x
	mov dx,y		;dx=y
	mov y2,dx		;y2=y
	call sortxy
; ������� ��������� ��������� �������, ����, ����� �������
	mov cx,x1		;������� ��������� ���������� x
	mov dx,y1		;������� ��������� ���������� y
	mov ah,0ch	;������� ��� ������������ �����
	mov al,color	;������ ����
; ������ ����� �����
l1:
	int 10h		;���������
	inc dx		;y+1
	cmp dx,y2		;���� y ��= y2 - �������
	jnz l1		
	mov cx,x2		;x=x2
	mov dx,y1		;y=y1
	inc y2		;y2+1
; ������ ������ �����
r1:
	int 10h		;���������
	inc dx		;y+1
	cmp dx,y2		;���� y ��= y2 - �������
	jnz r1
	dec y2		;�������� y
	mov cx,x1		;x=x1
	mov dx,y1		;y=y1
; ������ ������ �����
d1:
	int 10h		;���������
	inc cx		;x+1
	cmp cx,x2		;���� x ��= x2 - �������
	jnz d1
	mov cx,x1
	mov dx,y2
; ������ ������� ����� � � ����� ������
u1:
	int 10h		;���������
	inc cx		;x+1
	cmp cx,x2		;���� x ��= x2 - �������
	jnz u1
	jmp endsqr
; ������� ��������� ���������� � ���������� x1, y1
rprst:
	mov cx,x		;cx=x
	mov x1,cx		;x1=x
	mov dx,y		;dx=y
	mov y1,dx		;y1=y
; ��������� ����� ������� ��� � ��������� ��������� ������� � x2, y2
unprs1:
	call mouse_stat
	and bl,2
	cmp bl,2		;���� ��� ����� - �������
	je unprs1
	call cursor_off
	mov cx,x		;cx=x
	mov x2,cx		;x=x2
	mov dx,y		;dx=y
	mov y2,dx		;y=y2
	call sortxy
; ������� ��������� ��������� �������, ����, ����� �������
	mov cx,x1		;cx=x1
	mov dx,y1		;dx=y1
	mov ah,0ch	;������� ��� ������������ �����
	mov al,color	;������ ����
; ������ ��������������
vrline:
	int 10h		;���������
	inc dx		;y+1
	cmp dx,y2		;���� y ��= y2 - �������
	jnz vrline
	inc cx		;x+1
	mov dx,y1		;dx=y1
	cmp cx,x2		;���� x ��= x2 - �������
	jnz vrline	
endsqr:
	call cursor_on
	jmp prs		; � ������ ������
; ������� ������ (������������� �����������, ��������� �����, ��������� ������� �������)
clrscr proc near	;near - ����������(������, ������ � ���� ��������)
	call cursor_off
	mov ax,10h	;����� ����� 640X350, 16 ������, ��� �������
	int 10h
	call which_color
	mov ax,9		;�������� ����� �������
	xor bx,bx		;����� ������� �����-��������� ������������ ������� (�� -16 �� 16)
	xor cx,cx		;����� ������ �����-��������� (�� -16 �� 16)
	push ds		
	pop es		;ES:DX - ��������� �� ��������� ����������� �������
; ���� 2, �� ������ (�������)
	cmp ncr,2		;���� ���������� = 2 - �������
	je zlcr
; ���� �� 0, �� ������ (�������)
	cmp ncr,0		;���� ���������� ��= 0 - �������
	jne sqrcr
; ���� 0, �� ������ (�����)
	lea dx,pen_cr	;������� ����� ���������� � ���������(�����)
	jmp pncr
zlcr:
	lea dx,zal_cr	;������� ����� ���������� � ���������(�������)
	jmp pncr
sqrcr:
	lea dx,sqr_cr	;������� ����� ���������� � ���������(�������)
pncr:
	int 33h
	call cursor_on
	ret
clrscr endp
; ���������� color+1, ���� color=15, �� color=0
clp proc near
	cmp color,15	;���� ���� ��= 15 - �������
	jne nprp		
	mov color,0	;����� ��������
nprp:
	inc color		;����+1
	call which_color	; ��������� ���� ���������
	ret
clp endp
; ���������� color-1, ���� color=0, �� color=16
clm proc near
	cmp color,1	;���� ���� ��= 1 - �������
	jne nprm
	mov color,16	;����=16
nprm:
	dec color		;����-1
	call which_color
	ret
clm endp
; ������� �� �����������
horzal:
	mov ah,0dh	;������ ���� �����
	int 10h
	cmp al,color	; ���� ���� ����=����� � color, �� �� �����������
	jz skipdr
	mov zlcol,al	; ���������� ���� ����
	mov cx,x
	mov ah,0ch	;������� ��� ������������ �����
; ���������, ���� �� color, ���� ���� ��� ������
drl:
	cmp al,color	; ���� ���� = color, �� ��������� �������
	jz nextdrl
	cmp al,zlcol	; ���� ���� ��= ����� ����, �� ������ ������
	jnz drr0
	mov ah,0ch	;������� ��� ������������ �����
	mov al,color	;������� ����
	int 10h		;���������
; ������ �������, ���� �� ����� ������
nextdrl:
	cmp cx,640	;���� x=640 - �������
	jz drr0
	inc cx		;x+1
	mov ah,0dh	;������ ���� �������
	int 10h		;���������
	jmp drl
; ������� ��������� ���������� � ��������� �� ��������� �������
drr0:
	mov cx,x		;cx=x
	jmp nextdrr
; ���������, ���� �� color, ���� ���� ��� ������
drr:
	cmp al,color	; ���� ���� = color, �� ��������� �������
	jz nextdrr
	cmp al,zlcol	; ���� ���� ��= ����� ����, �� ������ ������
	jnz skipdr
	mov ah,0ch	;������� ��� ������������ �����
	mov al,color	;������� ����
	int 10h		;���������
; ������ ������, ���� �� ����� ������
nextdrr:
	cmp cx,0		;���� x=0 - �������
	jz skipdr
	dec cx		;x-1
	mov ah,0dh	;������ ���� �������
	int 10h		;���������
	jmp drr
skipdr:
	ret
; ������� �� ���������
vrtzal:
	mov ah,0dh	;������ ���� �������
	int 10h
	cmp al,color	; ���� ���� ����=����� � color, �� �� �����������
	jz skipdr1
	mov zlcol,al	; ���������� ���� ����
	mov dx,y		;dx=y
	mov ah,0ch	;������� ��� ������������ �����
; ������� ����
drd:
	cmp al,color	; ���� ���� = color, �� ��������� �������
	jz nextdrd
	cmp al,zlcol	; ���� ���� ��= ����� ����, �� ������ �����
	jnz dru0
	mov ah,0ch	;������� ��� ������������ �����
	mov al,color	;������ ���� �� color
	int 10h		;���������
; ������ ����, ���� �� ����� ������
nextdrd:
	cmp dx,350	;���� y=350 - �������
	jz dru0
	inc dx		;y+1
	mov ah,0dh	;������ ���� �����
	int 10h
	jmp drd
; ������� ��������� ���������� � ��������� �� ��������� �������
dru0:
	mov dx,y		;dx=y
	jmp nextdru
; ������� �����
dru:
	cmp al,color	; ���� ���� = color, �� ��������� �������
	jz nextdru
	cmp al,zlcol	; ���� ���� ��= ����� ����, �� ������ �����
	jnz skipdr1
	mov ah,0ch	;������� ��� ������������ �����
	mov al,color	;������ ���� �� color
	int 10h		;���������
; ������ �����, ���� �� ����� ������
nextdru:
	cmp dx,0		;���� y=0 - �������
	jz skipdr1	
	dec dx		;y-1
	mov ah,0dh	;������ ���� �����
	int 10h
	jmp dru
skipdr1:
	ret
; ������ ������ (�� �����) � ������� � ���������� ��� ����� 
ncurs1:
	mov ncr,2		;���� ���������� = 2 - �������
	mov ax,9		;�������� ����� �������
	xor bx,bx		;����� ������� �����-��������� ������������ ������� (�� -16 �� 16)
	xor cx,cx		;����� ������ �����-��������� (�� -16 �� 16)
	lea dx,pen_cr	;ES:DX - ��������� �� ��������� ����������� �������
	int 33h
	jmp ekey
; ������ ������ (�� �������) � ������� � ���������� ��� ����� 
zlln:
	mov ncr,2		;���� ���������� = 2 - �������
	mov ax,9		;�������� ����� �������
	xor bx,bx		;����� ������� �����-��������� ������������ ������� (�� -16 �� 16)
	xor cx,cx		;����� ������ �����-��������� (�� -16 �� 16)
	lea dx,zal_cr	;ES:DX - ��������� �� ��������� ����������� �������
	int 33h
; ���������, ��� ������
zlln1:
	mov ah,01h	;�������� ��������� ����������
	int 16h
	jz skippr10	;���� ������ �� ������, ����� �������
	mov ah,0h		;������ ����� ����������
	int 16h
	cmp al,70h	; ������ = p
	je ncurs1
	cmp al,2bh	; ������ = +
	jne clp10
	call clp
clp10:
	cmp al,2dh	; ������ = -
	jne clm10
	call clm
clm10:
	cmp al,1bh	; ������� = esc
	je ex
	cmp al,8h		; ������� = BackSpace
	jne clrscr10
	call clrscr
clrscr10:
	cmp al,73h	; ������ = s
	je sqr
; ��������� ��������� ����
skippr10:
	call mouse_stat
	mov bl,stat
	and bl,1
	cmp bl,1		; ���
	je zal10
zal1:
	call mouse_stat
	mov bl,stat
	and bl,2
	cmp bl,2		; ���
	jne zlln1
	call cursor_off
	call vrtzal	; �������� ����� �� ���������
	call cursor_on
	jmp zlln
zal10:
	call cursor_off
	call horzal	; �������� ����� �� ���������
	call cursor_on
	jmp zlln
; ��������, ���������� �� ������� ����.
main:
	mov ax,@data
	mov ds,ax
	mov ax,0	;��������� ������� �������� ����(���������� ���)
	int 33h	
	cmp ax,0
	jne noter	;���� ������� ����, �� ���������, ����� ���
	jmp er
; ��������� ����� �������
noter:
	push ax
	mov ax,3		;����� ����� 80X25, 16 ������, ��� �����(������� ������)
	int 10h
	pop ax
	mov al, 0		;����� ����� 40x25, 16 ������, ��� �����
	mov ch, 1		;������ x
	mov cl, 1		;������ y
	mov dh, 17h	;����� x(23)
	mov dl, 4eh	;����� y(78)
	int 10h
; ������������ ������, ��� ������ �����
	mov ah, 2		;���������� ������� �������
	mov bh, 00	;��������
	mov dh, 03h	;������
	mov dl, 01h	;�������
	int 10h
	mov dx,offset tub	;������� ����� ��������� 
	mov ah,09h	;������� �����
	int 21h
	mov ah,0		; ������ ����� ����������
	int 16h
	cmp al,1bh	; ���� ����� esc, �� ����� �� ���������
	je ex
	mov ax,10h	;����� ����� 640X350, 16 ������, ��� �������
	int 10h
; ������������ ������� �������
	mov ax,9		;�������� ����� �������
	xor bx,bx		;����� ������� �����-��������� ������������ ������� (�� -16 �� 16)
	xor cx,cx		;����� ������ �����-��������� (�� -16 �� 16)
	push ds		
	pop es		;ES:DX - ��������� �� ����������� �������
	lea dx,pen_cr	;
	int 33h
	call which_color	;������� �������, ����������� ����
	call cursor_on		;�������� ������
; ��������, ��� ������
; �������� ����������
paint_cic:
	mov ah,01h	;�������� ��������� ����������
	int 16h
	jz ekey		;���� ������ �� ������, ����� �������
	mov ah,0h		;������ ����� ����������
	int 16h
	cmp al,2bh	; ������ +
	jne clp1
	call clp
clp1:
	cmp al,66h	; ������ f
	je zlln
	cmp al,2dh	; ������ -
	jne clm1
	call clm
clm1:
	cmp al,1bh	; ������� esc
	je ex
	cmp al,8h		; ������� BackSpace
	jne clrscr1
	call clrscr
clrscr1:
	cmp al,73h	; ������ s
	je sqr
; �������� ����
ekey:
	call mouse_stat
	mov bl,stat
	and bl,2
	cmp bl,2		; ���
	jne ntprs
	call eraser
ntprs:
	mov bl,stat
	and bl,1
	cmp bl,1		; ���
	jne paint_cic
	call paint_pixel
	jmp paint_cic	; ���� ������ �� ������, ����� ��������� �� �����
; ��������� � ���������� ���������
ex:
   call cursor_off
   lea dx,mes
    jmp exit
; ��������� �� ������
er:
	lea dx,er_mes
; ����� ���������, ������� � ��������� ����� 80X25 16 ������, ���������� ���������.
exit:
	mov ax,3		;����� ����� 80X25, 16 ������, ��� �����
	int 10h
	mov ah,9		;������� ������, ����� ������� �������� � dx
	int 21h
	mov ax,4c00h
	int 21h
end main