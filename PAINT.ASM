.model small
.stack
.data
tub	db '			Paint by Simkin A.P.',13,10,
	db '			--------------------------------',13,10,
	db '			‘«Ґ¤гойЁ© жўҐв(+)',13,10,
	db '			ЏаҐ¤л¤гйЁ© жўҐв(-)',13,10,
	db '			ЋЁбвЁвм нЄа ­ (Backspace)',13,10,
	db '			‚ле®¤(Esc)',13,10,
	db '			ђҐ¦Ё¬ аЁб®ў ­Ёп(p)',13,10,
	db '			ђЁб®ў вм(‹Є¬)',13,10,
	db '			‹ бвЁЄ(ЏЄ¬)',13,10,
	db '			ђҐ¦Ё¬ зҐвлаҐегЈ®«м­ЁЄ®ў(s)',13,10,
	db '			Џ®«л© зҐвлаҐегЈ®«м­ЁЄ(‹Є¬)',13,10,
	db '			‡ Єа иҐ­­л© зҐвлаҐегЈ®«м­ЁЄ(ЏЄ¬)',13,10,
	db '			ђҐ¦Ё¬ § «ЁўЄЁ «Ё­Ё©(f)',13,10,
	db '			‡ «ЁўЄ  Ї® Ј®аЁ§®­в «Ё(‹Є¬)',13,10,
	db '			‡ «ЁўЄ  Ї® ўҐавЁЄ «Ё(ЏЄ¬)',13,10,
	db '			--------------------------------',13,10,
	db '			„«п ­ з «  ­ ¦¬ЁвҐ «оЎго Є« ўЁиг',13,10,
	db '$'
er_mes db 'Њлим ­Ґ гбв ­®ў«Ґ­ !',13,10,'$'
mes db 'Џа®Ја ¬¬  § ўҐаиЁ­ ',13,10,'$'
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
; Вывести квадрат цвета из переменной color, белая обводка, в правом верхнем углу
; Начальные координаты
which_color proc near	;near - расстояние(близко, тоесть в этом сегменте)
	mov cx,599	;Координата по x
	mov dx,11		;Координата по y
	mov al,color	;Цвет пикселя
	mov ah,0ch	;Функция для закрашивания точки
; Вывести квадрат цвета из переменной color
ntrw:
	inc dx		;Сдвинуть на 1 по y
	int 10h		;Закрасить
	cmp dx,40		;Пока y не=40
	jnz ntrw
	mov dx,11		;Возвращаем y назад
	inc cx		;Сдвинуть x на 1
	cmp cx,630	;Пока x не=630
	jnz ntrw
; Начальные координаты и белый цвет
	mov al,15		;Белый цвет
	mov cx,599	;Координата по x
	mov dx,10		;Координата по y
; Вертикальные линии
ntrw1:
	inc dx		;Сдвинуть y на 1
	int 10h		;Закрасить
	cmp dx,40		;Пока y не=40
	jnz ntrw1
	mov dx,10		;y=10
	add cx,31		;x=x+31
	cmp cx,630	;Если x=630, то переход
	jz ntrw1
	mov cx,599	;x=599
	mov dx,11		;y=11
; Горизонтальные линии
ntcl1:
	inc cx		;x+1
	int 10h		;Закрасить
	cmp cx,630	;Пока x не= 630 - переход
	jnz ntcl1
	add dx,29		;y=y+29
	mov cx,599	;x=599
	cmp dx,40		;Если y=40 - переход
	jz ntcl1
	ret
which_color endp
; Включить курсор
cursor_on proc near	;near - расстояние(близко, тоесть в этом сегменте)
	mov ax,01		;Включить курсор
	int 33h
	ret
cursor_on endp
; Выключить курсор
cursor_off proc near	;near - расстояние(близко, тоесть в этом сегменте)
	mov ax,2		;Отключить курсор
	int 33h
	ret
cursor_off endp
; Узнать состояние мыши и занести в переменные
mouse_stat proc near	;near - расстояние(близко, тоесть в этом сегменте)
	mov ax,3		;Получить информацию о положении курсора и состоянии клавиш мыши
	int 33h
	mov stat,bl	;Какая клавиша нажата
	mov x,cx		;Координата x
	mov y,dx		;Координата y
	ret
mouse_stat endp
; Закрасить пиксели 2X3 цвета из переменной color в позиции курсора
paint_pixel proc near	;near - расстояние(близко, тоесть в этом сегменте)
	call cursor_off
	mov ah,0Ch	;Функция для закрашивания точки
	mov al,color	;Цвет
	mov dx,y		;Задать y
	mov cx,x		;Задать x
	int 10h		;Закрасить
	dec cx		;x-1
	int 10h		;Закрасить
	inc dx		;y+1
	int 10h		;Закрасить
	inc cx		;x+1
	int 10h		;Закрасить
	inc dx		;y+1
	int 10h		;Закрасить
	dec cx		;x-1
	int 10h		;Закрасить
	call cursor_on
	ret
paint_pixel endp
; Ластик
eraser proc near	;near - расстояние(близко, тоесть в этом сегменте)
	mov dh,color	;Запоминаем какой стоит цвет
	push dx
	mov color,0	;Черный цвет
; Фиксируем нажатие Пкм
pr:
	call mouse_stat
	mov bl,stat
	and bl,2
	cmp bl,2		;Если не нажат Пкм - пропускаем
	jne npr
	call paint_pixel
; Как отпустили Пкм, возвращаем старый цвет
npr:
	pop dx
	mov color,dh	; Возвращаем цвет, который запоминали
	ret
eraser endp
; Сортируем, x1 - меньше x2, y1 - меньше y2
; Проверяем, x1 меньше x2? Если меньше то пропускаем, иначе меняем местами
sortxy proc near	;near - расстояние(близко, тоесть в этом сегменте)
	mov cx,x1		;cx=x1
	mov dx,x2		;dx=x2
	cmp cx,dx		;Если x1<x2 - переход
	jb below1
	mov x1,dx		;Иначе x1=x2
	mov x2,cx		;x2=x1
; Проверяем, y1 меньше y2? Если меньше то пропускаем, иначе меняем местами
below1:
	mov cx,y1		;cx=y1
	mov dx,y2		;dx=y2
	cmp cx,dx		;Если y1<y2 - переход
	jb below2	
	mov y1,dx		;Иначе y1=y2
	mov y2,cx		;y2=y1
below2:
	ret
sortxy endp
; Режим четырехугольников
; Устанавливаем курсор (ручка) и запоминаем это в переменную.
ncurs:
	mov ncr,0		;Запоминаем номер курсора
	mov ax,9		;Изменить форму курсора
	xor bx,bx		;Номер позиции точки-указателя графического курсора (от -16 до 16)
	xor cx,cx		;Номер строки точки-указателя (от -16 до 16)
	lea dx,pen_cr	;ES:DX - указатель на изображение курсора
	int 33h
	jmp ekey
; Устанавливаем курсор (квадрат) и запоминаем это в переменную.
sqr:
	mov ncr,1		;Запоминаем номер курсора
	mov ax,9		;Изменить форму курсора
	xor bx,bx		;Номер позиции точки-указателя графического курсора (от -16 до 16)
	xor cx,cx		;Номер строки точки-указателя (от -16 до 16)
	lea dx,sqr_cr	;ES:DX - указатель на изображение курсора
	int 33h
; Проверяем, какая клавиша нажата
prs:
	mov ah,01h	;Получить состояние клавиатуры
	int 16h
	jz ekey1
	mov ah,0h		;Читать буфер клавиатуры
	int 16h
	cmp al,2bh	; Символ +
	jne clp2
	call clp
clp2:
	cmp al,66h	; Символ f
	je zlln
	cmp al,2dh	; Символ -
	jne clm2
	call clm
clm2:
	cmp al,1bh	; Клавиша esc
	je ex
	cmp al,8h		; Клавиша BackSpace
	jne clrscr2
	call clrscr
clrscr2:
	cmp al,70h	; Символ p
	je ncurs
; Фиксируем нажатие Пкм или Лкм и сохраняем положение курсора в x1, y1
ekey1:
	call mouse_stat
	mov bl,stat
	and bl,2
	cmp bl,2		;Если нажат Пкм - переход
	je rprst
	mov bl,stat
	and bl,1		
	cmp bl,1		;Если не нажат Лкм - переход
	jne prs
;Запоминаем начальное положение курсора
	mov cx,x		;cx=x
	mov x1,cx		;x1=x
	mov dx,y		;dx=y
	mov y1,dx		;y1=y
; Фиксируем конец нажатие Лкм и сохраняем положение курсора в x2, y2
unprs:
	call mouse_stat
	and bl,1		
	cmp bl,1		;Если нажат Лкм - переход
	je unprs
	call cursor_off
;Запоминаем конечное положение курсора
	mov cx,x		;cx=x
	mov x2,cx		;x2=x
	mov dx,y		;dx=y
	mov y2,dx		;y2=y
	call sortxy
; Заносим начальное положение курсора, цвет, номер функции
	mov cx,x1		;Заносим начальную координату x
	mov dx,y1		;Заносим начальную координату y
	mov ah,0ch	;Функция для закрашивания точки
	mov al,color	;Задаем цвет
; Рисуем левую линию
l1:
	int 10h		;Закрасить
	inc dx		;y+1
	cmp dx,y2		;Пока y не= y2 - переход
	jnz l1		
	mov cx,x2		;x=x2
	mov dx,y1		;y=y1
	inc y2		;y2+1
; Рисуем правую линию
r1:
	int 10h		;Закрасить
	inc dx		;y+1
	cmp dx,y2		;Пока y не= y2 - переход
	jnz r1
	dec y2		;Конечный y
	mov cx,x1		;x=x1
	mov dx,y1		;y=y1
; Рисуем нижнюю линию
d1:
	int 10h		;Закрасить
	inc cx		;x+1
	cmp cx,x2		;Пока x не= x2 - переход
	jnz d1
	mov cx,x1
	mov dx,y2
; Рисуем верхнюю линию и к концу режима
u1:
	int 10h		;Закрасить
	inc cx		;x+1
	cmp cx,x2		;Пока x не= x2 - переход
	jnz u1
	jmp endsqr
; Заносим начальные координаты в переменные x1, y1
rprst:
	mov cx,x		;cx=x
	mov x1,cx		;x1=x
	mov dx,y		;dx=y
	mov y1,dx		;y1=y
; Фиксируем конец нажатие Пкм и сохраняем положение курсора в x2, y2
unprs1:
	call mouse_stat
	and bl,2
	cmp bl,2		;Если Пкм нажат - переход
	je unprs1
	call cursor_off
	mov cx,x		;cx=x
	mov x2,cx		;x=x2
	mov dx,y		;dx=y
	mov y2,dx		;y=y2
	call sortxy
; Заносим начальное положение курсора, цвет, номер функции
	mov cx,x1		;cx=x1
	mov dx,y1		;dx=y1
	mov ah,0ch	;Функция для закрашивания точки
	mov al,color	;Задаем цвет
; Рисуем четырёхугольник
vrline:
	int 10h		;Закрасить
	inc dx		;y+1
	cmp dx,y2		;Пока y не= y2 - переход
	jnz vrline
	inc cx		;x+1
	mov dx,y1		;dx=y1
	cmp cx,x2		;Пока x не= x2 - переход
	jnz vrline	
endsqr:
	call cursor_on
	jmp prs		; В начало режима
; Очистка экрана (переустановка видеорежима, указатель цвета, установка рисунка курсора)
clrscr proc near	;near - расстояние(близко, тоесть в этом сегменте)
	call cursor_off
	mov ax,10h	;Видео режим 640X350, 16 цветов, Тип графика
	int 10h
	call which_color
	mov ax,9		;Изменить форму курсора
	xor bx,bx		;Номер позиции точки-указателя графического курсора (от -16 до 16)
	xor cx,cx		;Номер строки точки-указателя (от -16 до 16)
	push ds		
	pop es		;ES:DX - указатель на растровое изображение курсора
; Если 2, то курсор (заливка)
	cmp ncr,2		;Если переменная = 2 - переход
	je zlcr
; Если не 0, то курсор (квадрат)
	cmp ncr,0		;Если переменная не= 0 - переход
	jne sqrcr
; Если 0, то курсор (ручка)
	lea dx,pen_cr	;Заносим адрес переменной с картинкой(ручка)
	jmp pncr
zlcr:
	lea dx,zal_cr	;Заносим адрес переменной с картинкой(заливка)
	jmp pncr
sqrcr:
	lea dx,sqr_cr	;Заносим адрес переменной с картинкой(квадрат)
pncr:
	int 33h
	call cursor_on
	ret
clrscr endp
; Переменная color+1, Если color=15, то color=0
clp proc near
	cmp color,15	;Если цвет не= 15 - переход
	jne nprp		
	mov color,0	;Иначе обнуляем
nprp:
	inc color		;Цвет+1
	call which_color	; Обновляем цвет указателя
	ret
clp endp
; Переменная color-1, Если color=0, то color=16
clm proc near
	cmp color,1	;Если цвет не= 1 - переход
	jne nprm
	mov color,16	;Цвет=16
nprm:
	dec color		;Цвет-1
	call which_color
	ret
clm endp
; Заливка по горизонтали
horzal:
	mov ah,0dh	;Читать цвет точки
	int 10h
	cmp al,color	; Если цвет фона=цвету в color, то не закрашиваем
	jz skipdr
	mov zlcol,al	; Запоминаем цвет фона
	mov cx,x
	mov ah,0ch	;Функция для закрашивания точки
; Проверяем, цвет из color, цвет фона или другой
drl:
	cmp al,color	; Если цвет = color, то следующий пиксель
	jz nextdrl
	cmp al,zlcol	; Если цвет не= цвету фона, то рисуем налево
	jnz drr0
	mov ah,0ch	;Функция для закрашивания точки
	mov al,color	;Заносим цвет
	int 10h		;Закрасить
; Рисуем направо, пока не конец экрана
nextdrl:
	cmp cx,640	;Если x=640 - переход
	jz drr0
	inc cx		;x+1
	mov ah,0dh	;Читать цвет пикселя
	int 10h		;Закрасить
	jmp drl
; Заносим стартовую координату и переходим на следующий пиксель
drr0:
	mov cx,x		;cx=x
	jmp nextdrr
; Проверяем, цвет из color, цвет фона или другой
drr:
	cmp al,color	; Если цвет = color, то следующий пиксель
	jz nextdrr
	cmp al,zlcol	; Если цвет не= цвету фона, то рисуем налево
	jnz skipdr
	mov ah,0ch	;Функция для закрашивания точки
	mov al,color	;Заносим цвет
	int 10h		;Закрасить
; Рисуем налево, пока не конец экрана
nextdrr:
	cmp cx,0		;Если x=0 - переход
	jz skipdr
	dec cx		;x-1
	mov ah,0dh	;Читать цвет пикселя
	int 10h		;Закрасить
	jmp drr
skipdr:
	ret
; Заливка по вертикали
vrtzal:
	mov ah,0dh	;Читать цвет пикселя
	int 10h
	cmp al,color	; Если цвет фона=цвету в color, то не закрашиваем
	jz skipdr1
	mov zlcol,al	; Запоминаем цвет фона
	mov dx,y		;dx=y
	mov ah,0ch	;Функция для закрашивания точки
; Заливка вниз
drd:
	cmp al,color	; Если цвет = color, то следующий пиксель
	jz nextdrd
	cmp al,zlcol	; Если цвет не= цвету фона, то рисуем вверх
	jnz dru0
	mov ah,0ch	;Функция для закрашивания точки
	mov al,color	;Заношу цвет из color
	int 10h		;Закрасить
; Рисуем вниз, пока не конец экрана
nextdrd:
	cmp dx,350	;Если y=350 - переход
	jz dru0
	inc dx		;y+1
	mov ah,0dh	;Читать цвет точки
	int 10h
	jmp drd
; Заносим стартовую координату и переходим на следующий пиксель
dru0:
	mov dx,y		;dx=y
	jmp nextdru
; Заливка вверх
dru:
	cmp al,color	; Если цвет = color, то следующий пиксель
	jz nextdru
	cmp al,zlcol	; Если цвет не= цвету фона, то рисуем конец
	jnz skipdr1
	mov ah,0ch	;Функция для закрашивания точки
	mov al,color	;Заношу цвет из color
	int 10h		;Закрасить
; Рисуем вверх, пока не конец экрана
nextdru:
	cmp dx,0		;Если y=0 - переход
	jz skipdr1	
	dec dx		;y-1
	mov ah,0dh	;Читать цвет точки
	int 10h
	jmp dru
skipdr1:
	ret
; Меняем курсор (на ручку) и заносим в переменную его номер 
ncurs1:
	mov ncr,2		;Если переменная = 2 - переход
	mov ax,9		;Изменить форму курсора
	xor bx,bx		;Номер позиции точки-указателя графического курсора (от -16 до 16)
	xor cx,cx		;Номер строки точки-указателя (от -16 до 16)
	lea dx,pen_cr	;ES:DX - указатель на растровое изображение курсора
	int 33h
	jmp ekey
; Меняем курсор (на заливку) и заносим в переменную его номер 
zlln:
	mov ncr,2		;Если переменная = 2 - переход
	mov ax,9		;Изменить форму курсора
	xor bx,bx		;Номер позиции точки-указателя графического курсора (от -16 до 16)
	xor cx,cx		;Номер строки точки-указателя (от -16 до 16)
	lea dx,zal_cr	;ES:DX - указатель на растровое изображение курсора
	int 33h
; Проверяем, что нажато
zlln1:
	mov ah,01h	;Получить состояние клавиатуры
	int 16h
	jz skippr10	;Если ничего не нажато, тогда переход
	mov ah,0h		;Читать буфер клавиатуры
	int 16h
	cmp al,70h	; Символ = p
	je ncurs1
	cmp al,2bh	; Символ = +
	jne clp10
	call clp
clp10:
	cmp al,2dh	; Символ = -
	jne clm10
	call clm
clm10:
	cmp al,1bh	; Клавиша = esc
	je ex
	cmp al,8h		; Клавиша = BackSpace
	jne clrscr10
	call clrscr
clrscr10:
	cmp al,73h	; Символ = s
	je sqr
; Проверяем состояние мыши
skippr10:
	call mouse_stat
	mov bl,stat
	and bl,1
	cmp bl,1		; Лкм
	je zal10
zal1:
	call mouse_stat
	mov bl,stat
	and bl,2
	cmp bl,2		; Пкм
	jne zlln1
	call cursor_off
	call vrtzal	; Заливаем линию по вертикали
	call cursor_on
	jmp zlln
zal10:
	call cursor_off
	call horzal	; Заливаем линию по вертикали
	call cursor_on
	jmp zlln
; Проверяю, установлин ли драйвер мыши.
main:
	mov ax,@data
	mov ds,ax
	mov ax,0	;Проверить наличие драйвера мыши(параметров нет)
	int 33h	
	cmp ax,0
	jne noter	;Если драйвер есть, то переходим, иначе нет
	jmp er
; Устанавка видео режимов
noter:
	push ax
	mov ax,3		;Видео режим 80X25, 16 цветов, Тип Текст(Очистка экрана)
	int 10h
	pop ax
	mov al, 0		;Видео режим 40x25, 16 цветов, Тип Текст
	mov ch, 1		;Начало x
	mov cl, 1		;Начало y
	mov dh, 17h	;Конец x(23)
	mov dl, 4eh	;Конец y(78)
	int 10h
; Устанавливаю курсор, для вывода строк
	mov ah, 2		;Установить позицию курсора
	mov bh, 00	;Страница
	mov dh, 03h	;Строка
	mov dl, 01h	;Столбец
	int 10h
	mov dx,offset tub	;Заносим адрес выводимой 
	mov ah,09h	;Выводим текст
	int 21h
	mov ah,0		; Чистим буфер клавиатуры
	int 16h
	cmp al,1bh	; Если нажат esc, то выход из программы
	je ex
	mov ax,10h	;Видео режим 640X350, 16 цветов, Тип графика
	int 10h
; Устанавливаю рисунок курсора
	mov ax,9		;Изменить форму курсора
	xor bx,bx		;Номер позиции точки-указателя графического курсора (от -16 до 16)
	xor cx,cx		;Номер строки точки-указателя (от -16 до 16)
	push ds		
	pop es		;ES:DX - указатель на изображение курсора
	lea dx,pen_cr	;
	int 33h
	call which_color	;Вывести квадрат, указывающий цвет
	call cursor_on		;Включить курсор
; Проверка, что нажато
; Проверка клавиатуры
paint_cic:
	mov ah,01h	;Получить состояние клавиатуры
	int 16h
	jz ekey		;Если ничего не нажато, тогда переход
	mov ah,0h		;Читать буфер клавиатуры
	int 16h
	cmp al,2bh	; Символ +
	jne clp1
	call clp
clp1:
	cmp al,66h	; Символ f
	je zlln
	cmp al,2dh	; Символ -
	jne clm1
	call clm
clm1:
	cmp al,1bh	; Клавиша esc
	je ex
	cmp al,8h		; Клавиша BackSpace
	jne clrscr1
	call clrscr
clrscr1:
	cmp al,73h	; Символ s
	je sqr
; Проверка мыши
ekey:
	call mouse_stat
	mov bl,stat
	and bl,2
	cmp bl,2		; Пкм
	jne ntprs
	call eraser
ntprs:
	mov bl,stat
	and bl,1
	cmp bl,1		; Лкм
	jne paint_cic
	call paint_pixel
	jmp paint_cic	; Если ничего не нажато, тогда проверяем по новой
; Сообщение о завершении программы
ex:
   call cursor_off
   lea dx,mes
    jmp exit
; Сообщение об ошибке
er:
	lea dx,er_mes
; Вывод сообщения, переход в текстовый режим 80X25 16 цветов, завершение программы.
exit:
	mov ax,3		;Видео режим 80X25, 16 цветов, Тип Текст
	int 10h
	mov ah,9		;Вывести строку, адрес которой хранится в dx
	int 21h
	mov ax,4c00h
	int 21h
end main