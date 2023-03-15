.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Joc de cultura generala",0
area_width EQU 640
area_height EQU 480
area DD 0

counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20
zece DD 10
click DD 0
contor DD 0
spatiu DD 0
spatiu2 DD 0

button1_x equ 258
button1_y equ 265
button_size equ 100

button2_x equ 23
button2_y equ 158
button3_y equ 215
button4_y equ 272
button2_size equ 30

button3_x equ 480
button5_y equ 360

symbol_width EQU 10
symbol_height EQU 20
dolar_width EQU 16
dolar_height EQU 41
include digits.inc
include letters.inc
include dolar.inc

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, '$'
	jz make_dolar
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	jmp draw_text
	
make_dolar:
	lea esi, dolar
	mov ecx, dolar_height
	
bucla_dolar_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, dolar_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, dolar_width
bucla_dolar_coloane:
	mov eax, [esi]
	mov [edi], eax
	add esi, 4
	add edi, 4
	loop bucla_dolar_coloane
	pop ecx
	loop bucla_dolar_linii
	
	jmp make_text_final
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
	
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FF9999h
	
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	
make_text_final:
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp
	
; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click_start
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
background:
	mov eax,0
	add eax, area
	mov ecx, area_height*area_width
culoare:
	mov dword ptr[eax], 0FF9999h
	add eax, 4
loop culoare
	;jmp afisare_litere
	
line_horizontal macro x,y,len,color
local bucla_line
	mov eax,y
	mov ebx,area_width
	mul ebx
	add eax,x
	shl eax,2
	add eax, area
	mov ecx,len
	bucla_line:
	mov dword ptr[eax], color
	add eax,4
	loop bucla_line
endm

line_vertical macro x,y,len,color
local bucla_line
	mov eax,y
	mov ebx,area_width
	mul ebx
	add eax,x
	shl eax,2
	add eax, area
	mov ecx,len
	bucla_line:
	mov dword ptr[eax], color
	add eax,area_width*4
	loop bucla_line
endm

afisare_litere:
mov ecx,13
eticheta:
	make_text_macro '$', area, zece, 430 ;afisez dolari pe marginea de jos
	add zece, 50
loop eticheta
	make_text_macro 'T', area, 240, 180
	make_text_macro 'R', area, 250, 180
	make_text_macro 'I', area, 260, 180
	make_text_macro 'V', area, 270, 180
	make_text_macro 'I', area, 280, 180
	make_text_macro 'A', area, 290, 180
	
	make_text_macro 'G', area, 320, 180
	make_text_macro 'A', area, 330, 180
	make_text_macro 'M', area, 340, 180
	make_text_macro 'E', area, 350, 180
	
	make_text_macro 'S', area, 280, 310
	make_text_macro 'T', area, 290, 310
	make_text_macro 'A', area, 300, 310
	make_text_macro 'R', area, 310, 310
	make_text_macro 'T', area, 320, 310
	
	line_horizontal button1_x, button1_y, button_size, 0
	line_horizontal button1_x, button1_y + button_size, button_size, 0
	line_vertical button1_x, button1_y, button_size, 0
	line_vertical button1_x + button_size, button1_y, button_size, 0
	
evt_click_start:
	cmp click, 0
	je click_start
	cmp click, 1
	je evt_click_unu
	cmp click, 2
	je evt_click_next1
	cmp click, 3
	je evt_click_doi
	cmp click, 4
	je evt_click_next2
	cmp click, 5
	je evt_click_trei
	cmp click, 6
	je evt_click_next3
	cmp click, 7
	je evt_click_patru
	cmp click, 8
	je evt_click_next4
	cmp click, 9
	je evt_click_cinci
	cmp click, 10
	je evt_click_next5
	jmp button_fail
	
evt_timer:
	;inc counter		
	;jmp final_draw	
	
button_fail:
	jmp final_draw
	
click_start:
	mov eax, [ebp+arg2]
	cmp eax, button1_x
	jl button_fail
	cmp eax, button1_x + button_size
	jg button_fail
	mov eax, [ebp+arg3]
	cmp eax, button1_y
	jl button_fail
	cmp eax, button1_y + button_size
	jg button_fail
	;s-a dat click in buton
	mov spatiu, 240
	mov spatiu2, 280
	mov ecx, 12
	bucla_space:
	make_text_macro ' ', area, spatiu, 180
	make_text_macro ' ', area, spatiu2, 310
	add spatiu, 10
	add spatiu2, 10
	loop bucla_space
	line_horizontal button1_x, button1_y, button_size, 0FF9999h
	line_horizontal button1_x, button1_y + button_size, button_size, 0FF9999h
	line_vertical button1_x, button1_y, button_size, 0FF9999h
	line_vertical button1_x + button_size, button1_y, button_size, 0FF9999h
	jmp prima_intrebare
	
prima_intrebare:
	inc click 
;afisam valoarea counter-ului curent (mii, sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	mov ecx, 4
	mov zece, 10
	scor:
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, zece, 10
	add zece, 10
	loop scor
	make_text_macro 'C', area, 50, 75
	make_text_macro 'A', area, 60, 75
	make_text_macro 'T', area, 70, 75
	make_text_macro 'E', area, 80, 75
	
	make_text_macro 'O', area, 100, 75
	make_text_macro 'C', area, 110, 75
	make_text_macro 'E', area, 120, 75
	make_text_macro 'A', area, 130, 75
	make_text_macro 'N', area, 140, 75
	make_text_macro 'E', area, 150, 75
	
	make_text_macro 'S', area, 170, 75
	make_text_macro 'U', area, 180, 75
	make_text_macro 'N', area, 190, 75
	make_text_macro 'T', area, 200, 75
	
	make_text_macro 'P', area, 220, 75
	make_text_macro 'E', area, 230, 75
	
	make_text_macro 'G', area, 250, 75
	make_text_macro 'L', area, 260, 75
	make_text_macro 'O', area, 270, 75
	make_text_macro 'B', area, 280, 75
	make_text_macro 'Z', area, 290, 75
	
	line_horizontal button2_x, button2_y, button2_size, 0
	line_horizontal button2_x, button2_y + button2_size, button2_size, 0
	line_vertical button2_x, button2_y, button2_size, 0
	line_vertical button2_x + button2_size, button2_y, button2_size, 0
	make_text_macro '4', area, 64, 162
	
	line_horizontal button2_x, button3_y, button2_size, 0
	line_horizontal button2_x, button3_y + button2_size, button2_size, 0
	line_vertical button2_x, button3_y, button2_size, 0
	line_vertical button2_x + button2_size, button3_y, button2_size, 0
	make_text_macro '5', area, 64, 219
	
	line_horizontal button2_x, button4_y, button2_size, 0
	line_horizontal button2_x, button4_y + button2_size, button2_size, 0
	line_vertical button2_x, button4_y, button2_size, 0
	line_vertical button2_x + button2_size, button4_y, button2_size, 0
	make_text_macro '6', area, 64, 276
	
	line_horizontal button3_x, button5_y, button_size, 0
	line_horizontal button3_x, button5_y + button2_size, button_size, 0
	line_vertical button3_x, button5_y, button2_size, 0
	line_vertical button3_x + button_size, button5_y, button2_size, 0
	make_text_macro 'N', area, 506, 365
	make_text_macro 'E', area, 516, 365
	make_text_macro 'X', area, 526, 365
	make_text_macro 'T', area, 536, 365
	jmp evt_click_start
	
evt_click_unu:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl evt_click_fail1
	cmp eax, button2_x + button2_size
	jg evt_click_fail1
	mov eax, [ebp+arg3]
	cmp eax, button3_y
	jl evt_click_fail1
	cmp eax, button3_y + button2_size
	jg evt_click_fail1
	make_text_macro 'O', area, 100, 219
	make_text_macro 'K', area, 110, 219
	make_text_macro 'W', area, 34, 219
	inc contor
	mov edx, 0
	div ebx
	add edx, '2'
	make_text_macro edx, area, 20, 10
	inc click
	jmp evt_click_start

evt_click_fail1:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl evt_click_fail2
	cmp eax, button2_x + button2_size
	jg evt_click_fail2
	mov eax, [ebp+arg3]
	cmp eax, button2_y
	jl evt_click_fail2
	cmp eax, button2_y + button2_size
	jg evt_click_fail2
	make_text_macro 'N', area, 100, 162
	make_text_macro 'U', area, 110, 162
	make_text_macro 'X', area, 34, 162
	inc click
	jmp evt_click_start
	
evt_click_fail2:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl button_fail2
	cmp eax, button2_x + button2_size
	jg button_fail2
	mov eax, [ebp+arg3]
	cmp eax, button4_y
	jl button_fail2
	cmp eax, button4_y + button2_size
	jg button_fail2
	make_text_macro 'N', area, 100, 276
	make_text_macro 'U', area, 110, 276
	make_text_macro 'X', area, 34, 276
	inc click
	jmp evt_click_start
	
evt_click_next1:	
	mov eax, [ebp+arg2]
	cmp eax, button3_x
	jl button_fail2
	cmp eax, button3_x + button_size
	jg button_fail2
	mov eax, [ebp+arg3]
	cmp eax, button5_y
	jl button_fail2
	cmp eax, button5_y + button2_size
	jg button_fail2
	
	mov spatiu, 100
	mov ecx,2
	bucla2:
	make_text_macro ' ', area, spatiu, 162
	make_text_macro ' ', area, spatiu, 219
	make_text_macro ' ', area, spatiu, 276
	add spatiu, 10
	loop bucla2 
	make_text_macro ' ', area, 34, 219
	make_text_macro ' ', area, 34, 162 
	make_text_macro ' ', area, 34, 276
	make_text_macro ' ', area, 130, 75
	make_text_macro ' ', area, 170, 75
	make_text_macro ' ', area, 200, 75
	make_text_macro ' ', area, 280, 75
	make_text_macro ' ', area, 290, 75
	 jmp doua_intrebare
	
 doua_intrebare:
 inc click
;afisam valoarea counter-ului curent (mii, sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	mov ecx, 4
	mov zece, 10
	scor1:
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, zece, 10
	add zece, 10
	loop scor1
	cmp contor, 1
	je scrie2
	jmp next
	scrie2:
	make_text_macro '2', area, 20, 10
	next:
	make_text_macro 'C', area, 50, 75
	make_text_macro 'A', area, 60, 75
	make_text_macro 'T', area, 70, 75
	make_text_macro 'I', area, 80, 75
	
	make_text_macro 'A', area, 100, 75
	make_text_macro 'N', area, 110, 75
	make_text_macro 'I', area, 120, 75
	
	make_text_macro 'A', area, 140, 75
	make_text_macro 'R', area, 150, 75
	make_text_macro 'E', area, 160, 75
	
	make_text_macro 'U', area, 180, 75
	make_text_macro 'N', area, 190, 75
	
	make_text_macro 'D', area, 210, 75
	make_text_macro 'E', area, 220, 75
	make_text_macro 'C', area, 230, 75
	make_text_macro 'E', area, 240, 75
	make_text_macro 'N', area, 250, 75
	make_text_macro 'I', area, 260, 75
	make_text_macro 'U', area, 270, 75
	make_text_macro 'Z', area, 280, 75
	
	make_text_macro '1', area, 64, 162
	make_text_macro '0', area, 74, 162
	make_text_macro '1', area, 64, 219
	make_text_macro '0', area, 74, 219
	make_text_macro '0', area, 84, 219
	make_text_macro '1', area, 64, 276
	make_text_macro '0', area, 74, 276
	make_text_macro '0', area, 84, 276
	make_text_macro '0', area, 94, 276
	jmp evt_click_start
	
evt_click_doi:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl evt_click_fail3
	cmp eax, button2_x + button2_size
	jg evt_click_fail3
	mov eax, [ebp+arg3]
	cmp eax, button2_y
	jl evt_click_fail3
	cmp eax, button2_y + button2_size
	jg evt_click_fail3
	make_text_macro 'O', area, 100, 162
	make_text_macro 'K', area, 110, 162
	make_text_macro 'W', area, 34, 162
	inc contor
	cmp contor, 1
	je scrie2_1
	jmp next1_1
	scrie2_1:
	make_text_macro '2', area, 20, 10
	next1_1:
	cmp contor, 2
	je scrie4_1
	jmp next1
	scrie4_1:
	make_text_macro '4', area, 20, 10
	next1:
	inc click
	jmp evt_click_start
	
evt_click_fail3:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl evt_click_fail4
	cmp eax, button2_x + button2_size
	jg evt_click_fail4
	mov eax, [ebp+arg3]
	cmp eax, button3_y
	jl evt_click_fail4
	cmp eax, button3_y + button2_size
	jg evt_click_fail4
	make_text_macro 'N', area, 100, 219
	make_text_macro 'U', area, 110, 219
	make_text_macro 'X', area, 34, 219
	inc click
	jmp evt_click_start

evt_click_fail4:	
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl button_fail2
	cmp eax, button2_x + button2_size
	jg button_fail2
	mov eax, [ebp+arg3]
	cmp eax, button4_y
	jl button_fail2
	cmp eax, button4_y + button2_size
	jg button_fail2
	make_text_macro 'N', area, 130, 276
	make_text_macro 'U', area, 140, 276
	make_text_macro 'X', area, 34, 276
	inc click
	jmp evt_click_start

evt_click_next2:	
	mov eax, [ebp+arg2]
	cmp eax, button3_x
	jl button_fail2
	cmp eax, button3_x + button_size
	jg button_fail2
	mov eax, [ebp+arg3]
	cmp eax, button5_y
	jl button_fail2
	cmp eax, button5_y + button2_size
	jg button_fail2
	make_text_macro ' ', area, 100, 162
	make_text_macro ' ', area, 110, 162
	make_text_macro ' ', area, 100, 219
	make_text_macro ' ', area, 110, 219
	make_text_macro ' ', area, 130, 276
	make_text_macro ' ', area, 140, 276
	make_text_macro ' ', area, 34, 162
	make_text_macro ' ', area, 34, 219
	make_text_macro ' ', area, 34, 276
	mov ecx, 22
	mov spatiu, 70
	bucli1:
	make_text_macro ' ', area, spatiu, 75
	add spatiu, 10
	loop bucli1
	make_text_macro ' ', area, 94, 276
	 jmp treia_intrebare
	
treia_intrebare:
 inc click
;afisam valoarea counter-ului curent (mii, sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	mov ecx, 4
	mov zece, 10
	scor2:
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, zece, 10
	add zece, 10
	loop scor2
	cmp contor, 1
	je scrie2_3
	jmp continua2_1
	scrie2_3:
	make_text_macro '2', area, 20, 10
	continua2_1:
	cmp contor, 2
	je scrie4_3
	jmp continua2
	scrie4_3:
	make_text_macro '4', area, 20, 10
	
	continua2:
	make_text_macro 'C', area, 50, 75
	make_text_macro 'E', area, 60, 75
	
	make_text_macro 'E', area, 80, 75
	make_text_macro 'S', area, 90, 75
	make_text_macro 'T', area, 100, 75
	make_text_macro 'E', area, 110, 75
	
	make_text_macro 'H', area, 130, 75
	make_text_macro '2', area, 140, 75
	make_text_macro 'O', area, 150, 75
	make_text_macro 'Z', area, 160, 75
	
	make_text_macro 'O', area, 64, 162
	make_text_macro 'X', area, 74, 162
	make_text_macro 'I', area, 84, 162
	make_text_macro 'G', area, 94, 162
	make_text_macro 'E', area, 104, 162
	make_text_macro 'N', area, 114, 162
	
	make_text_macro 'A', area, 64, 219
	make_text_macro 'L', area, 74, 219
	make_text_macro 'C', area, 84, 219
	make_text_macro 'O', area, 94, 219
	make_text_macro 'O', area, 104, 219
	make_text_macro 'L', area, 114, 219
	
	make_text_macro 'A', area, 64, 276
	make_text_macro 'P', area, 74, 276
	make_text_macro 'A', area, 84, 276
	jmp evt_click_start	

evt_click_trei:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl evt_click_fail5
	cmp eax, button2_x + button2_size
	jg evt_click_fail5
	mov eax, [ebp+arg3]
	cmp eax, button2_y
	jl evt_click_fail5
	cmp eax, button2_y + button2_size
	jg evt_click_fail5
	make_text_macro 'N', area, 140, 162
	make_text_macro 'U', area, 150, 162
	make_text_macro 'X', area, 34, 162
	inc click
	jmp evt_click_start
	
evt_click_fail5:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl evt_click_fail6
	cmp eax, button2_x + button2_size
	jg evt_click_fail6
	mov eax, [ebp+arg3]
	cmp eax, button3_y
	jl evt_click_fail6
	cmp eax, button3_y + button2_size
	jg evt_click_fail6
	make_text_macro 'N', area, 140, 219
	make_text_macro 'U', area, 150, 219
	make_text_macro 'X', area, 34, 219
	inc click
	jmp evt_click_start
	
evt_click_fail6:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl button_fail2
	cmp eax, button2_x + button2_size
	jg button_fail2
	mov eax, [ebp+arg3]
	cmp eax, button4_y
	jl button_fail2
	cmp eax, button4_y + button2_size
	jg button_fail2
	make_text_macro 'O', area, 140, 276
	make_text_macro 'K', area, 150, 276
	make_text_macro 'W', area, 34, 276
	inc contor
	cmp contor, 1
	je scrie2_2
	jmp treci_peste
	scrie2_2:
	make_text_macro '2', area, 20, 10
	treci_peste:
	cmp contor, 2
	je scrie4_2
	jg scrie6_2
	jmp treci_peste1
	scrie4_2:
	make_text_macro '4', area, 20, 10
	jmp treci_peste1
	scrie6_2:
	make_text_macro '6', area, 20, 10
	treci_peste1:
	inc click
	jmp evt_click_start	
	
evt_click_next3:	
	mov eax, [ebp+arg2]
	cmp eax, button3_x
	jl button_fail2
	cmp eax, button3_x + button_size
	jg button_fail2
	mov eax, [ebp+arg3]
	cmp eax, button5_y
	jl button_fail2
	cmp eax, button5_y + button2_size
	jg button_fail2
	make_text_macro ' ', area, 140, 162
	make_text_macro ' ', area, 150, 162
	make_text_macro ' ', area, 140, 219
	make_text_macro ' ', area, 150, 219
	make_text_macro ' ', area, 140, 276
	make_text_macro ' ', area, 150, 276
	make_text_macro ' ', area, 160, 75
	make_text_macro ' ', area, 34, 162
	make_text_macro ' ', area, 34, 219
	make_text_macro ' ', area, 34, 276
	mov ecx, 12
	mov spatiu, 50
	mov spatiu2, 64
	bucli:
	make_text_macro ' ', area, spatiu, 75
	make_text_macro ' ', area, spatiu2, 162
	make_text_macro ' ', area, spatiu2, 219
	make_text_macro ' ', area, spatiu2, 276
	add spatiu, 10
	add spatiu2, 10
	loop bucli
	 jmp patra_intrebare	
	
patra_intrebare:
 inc click
;afisam valoarea counter-ului curent (mii, sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	mov ecx, 4
	mov zece, 10
	scor3:
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, zece, 10
	add zece, 10
	loop scor3
	cmp contor, 1
	je pune_2
	jmp sari
	pune_2:
	make_text_macro '2', area, 20, 10
	sari:
	cmp contor, 2
	je pune_4
	jg pune_6
	jmp continua
	pune_4:
	make_text_macro '4', area, 20, 10
	jmp continua
	pune_6:
	make_text_macro '6', area, 20, 10
	continua:
	make_text_macro 'C', area, 50, 75
	make_text_macro 'A', area, 60, 75
	make_text_macro 'T', area, 70, 75
	make_text_macro 'E', area, 80, 75
	
	make_text_macro 'I', area, 100, 75
	make_text_macro 'N', area, 110, 75
	make_text_macro 'I', area, 120, 75
	make_text_macro 'M', area, 130, 75
	make_text_macro 'I', area, 140, 75
	
	make_text_macro 'A', area, 160, 75
	make_text_macro 'R', area, 170, 75
	make_text_macro 'E', area, 180, 75
	
	make_text_macro 'O', area, 200, 75
	
	make_text_macro 'C', area, 220, 75
	make_text_macro 'A', area, 230, 75
	make_text_macro 'R', area, 240, 75
	make_text_macro 'A', area, 250, 75
	make_text_macro 'C', area, 260, 75
	make_text_macro 'A', area, 270, 75
	make_text_macro 'T', area, 280, 75
	make_text_macro 'I', area, 290, 75
	make_text_macro 'T', area, 300, 75
	make_text_macro 'A', area, 310, 75
	make_text_macro 'Z', area, 320, 75
	
	make_text_macro '6', area, 64, 162
	make_text_macro '5', area, 64, 219
	make_text_macro '3', area, 64, 276
	jmp evt_click_start		

evt_click_patru:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl evt_click_fail7
	cmp eax, button2_x + button2_size
	jg evt_click_fail7
	mov eax, [ebp+arg3]
	cmp eax, button2_y
	jl evt_click_fail7
	cmp eax, button2_y + button2_size
	jg evt_click_fail7
	make_text_macro 'N', area, 100, 162
	make_text_macro 'U', area, 110, 162
	make_text_macro 'X', area, 34, 162
	inc click
	jmp evt_click_start	
	
evt_click_fail7:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl evt_click_fail8
	cmp eax, button2_x + button2_size
	jg evt_click_fail8
	mov eax, [ebp+arg3]
	cmp eax, button3_y
	jl evt_click_fail8
	cmp eax, button3_y + button2_size
	jg evt_click_fail8
	make_text_macro 'N', area, 100, 219
	make_text_macro 'U', area, 110, 219
	make_text_macro 'X', area, 34, 219
	inc click
	jmp evt_click_start	

evt_click_fail8:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl button_fail2
	cmp eax, button2_x + button2_size
	jg button_fail2
	mov eax, [ebp+arg3]
	cmp eax, button4_y
	jl button_fail2
	cmp eax, button4_y + button2_size
	jg button_fail2
	make_text_macro 'O', area, 100, 276
	make_text_macro 'K', area, 110, 276
	make_text_macro 'W', area, 34, 276
	inc contor
	cmp contor,1
	je sarila2
	jmp continua3
	sarila2:
	make_text_macro '2', area, 20, 10
	continua3:
	cmp contor,2 
	je sarila4
	jmp continua4
	sarila4:
	make_text_macro '4', area, 20, 10
	continua4:
	cmp contor,3
	je sarila6
	jg sarila8
	jmp continua5
	sarila6:
	make_text_macro '6', area, 20, 10
	jmp continua5
	sarila8:
	make_text_macro '8', area, 20, 10
	continua5:
	inc click
	jmp evt_click_start		
	
evt_click_next4:	
	mov eax, [ebp+arg2]
	cmp eax, button3_x
	jl button_fail2
	cmp eax, button3_x + button_size
	jg button_fail2
	mov eax, [ebp+arg3]
	cmp eax, button5_y
	jl button_fail2
	cmp eax, button5_y + button2_size
	jg button_fail2
	make_text_macro ' ', area, 100, 162
	make_text_macro ' ', area, 110, 162
	make_text_macro ' ', area, 100, 219
	make_text_macro ' ', area, 110, 219
	make_text_macro ' ', area, 100, 276
	make_text_macro ' ', area, 110, 276
	make_text_macro ' ', area, 34, 162
	make_text_macro ' ', area, 34, 219
	make_text_macro ' ', area, 34, 276
	mov ecx, 28
	mov spatiu, 50
	buclisoara:
	make_text_macro ' ', area, spatiu, 75
	add spatiu,10
	loop buclisoara
	make_text_macro ' ', area, 64, 162
	make_text_macro ' ', area, 64, 219
	make_text_macro ' ', area, 64, 276
	 jmp cincia_intrebare	
	
cincia_intrebare:
 inc click
;afisam valoarea counter-ului curent (mii, sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	mov ecx, 4
	mov zece, 10
	scor4:
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, zece, 10
	add zece, 10
	loop scor4
	
	cmp contor,1
	je sarila2_1
	jmp continua3_1
	sarila2_1:
	make_text_macro '2', area, 20, 10
	continua3_1:
	cmp contor,2 
	je sarila4_1
	jmp continua4_1
	sarila4_1:
	make_text_macro '4', area, 20, 10
	continua4_1:
	cmp contor,3
	je sarila6_1
	jg sarila8_1
	jmp continua5_1
	sarila6_1:
	make_text_macro '6', area, 20, 10
	jmp continua5_1
	sarila8_1:
	make_text_macro '8', area, 20, 10
	continua5_1:
	make_text_macro 'F', area, 496, 365
	make_text_macro 'I', area, 506, 365
	make_text_macro 'N', area, 516, 365
	make_text_macro 'I', area, 526, 365
	make_text_macro 'S', area, 536, 365
	make_text_macro 'H', area, 546, 365
	
	make_text_macro 'C', area, 50, 75
	make_text_macro 'I', area, 60, 75
	make_text_macro 'N', area, 70, 75
	make_text_macro 'E', area, 80, 75
	
	make_text_macro 'A', area, 100, 75
	
	make_text_macro 'I', area, 120, 75
	make_text_macro 'N', area, 130, 75
	make_text_macro 'V', area, 140, 75
	make_text_macro 'E', area, 150, 75
	make_text_macro 'T', area, 160, 75
	make_text_macro 'A', area, 170, 75
	make_text_macro 'T', area, 180, 75
	
	make_text_macro 'B', area, 200, 75
	make_text_macro 'E', area, 210, 75
	make_text_macro 'C', area, 220, 75
	make_text_macro 'U', area, 230, 75
	make_text_macro 'L', area, 240, 75
	make_text_macro 'Z', area, 250, 75
	
	make_text_macro 'V', area, 64, 162
	make_text_macro 'U', area, 74, 162
	make_text_macro 'I', area, 84, 162
	make_text_macro 'A', area, 94, 162
	
	make_text_macro 'E', area, 64, 219
	make_text_macro 'D', area, 74, 219
	make_text_macro 'I', area, 84, 219
	make_text_macro 'S', area, 94, 219
	make_text_macro 'O', area, 104, 219
	make_text_macro 'N', area, 114, 219
	
	make_text_macro 'P', area, 64, 276
	make_text_macro 'A', area, 74, 276
	make_text_macro 'S', area, 84, 276
	make_text_macro 'T', area, 94, 276
	make_text_macro 'E', area, 104, 276
	make_text_macro 'U', area, 114, 276
	make_text_macro 'R', area, 124, 276
	jmp evt_click_start	
	
evt_click_cinci:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl evt_click_fail9
	cmp eax, button2_x + button2_size
	jg evt_click_fail9
	mov eax, [ebp+arg3]
	cmp eax, button2_y
	jl evt_click_fail9
	cmp eax, button2_y + button2_size
	jg evt_click_fail9
	make_text_macro 'N', area, 140, 162
	make_text_macro 'U', area, 150, 162
	make_text_macro 'X', area, 34, 162
	inc click
	jmp evt_click_start	
	
evt_click_fail9:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl evt_click_fail10
	cmp eax, button2_x + button2_size
	jg evt_click_fail10
	mov eax, [ebp+arg3]
	cmp eax, button3_y
	jl evt_click_fail10
	cmp eax, button3_y + button2_size
	jg evt_click_fail10
	make_text_macro 'O', area, 140, 219
	make_text_macro 'K', area, 150, 219
	make_text_macro 'W', area, 34, 219
	inc contor
	cmp contor,1
	je sarila2_2
	jmp continua3_2
	sarila2_2:
	make_text_macro '2', area, 20, 10
	continua3_2:
	cmp contor,2 
	je sarila4_2
	jmp continua4_2
	sarila4_2:
	make_text_macro '4', area, 20, 10
	continua4_2:
	cmp contor,3
	je sarila6_2
	jmp continua6_2
	sarila6_2:
	make_text_macro '6', area, 20, 10
	continua6_2:
	cmp contor,4
	je sarila8_2
	jg sarila10
	jmp continua5_2
	sarila8_2:
	make_text_macro '8', area, 20, 10
	jmp continua5_2
	sarila10:
	make_text_macro '0', area, 20, 10
	make_text_macro '1', area, 10, 10
	continua5_2:
	inc click
	jmp evt_click_start		

evt_click_fail10:
	mov eax, [ebp+arg2]
	cmp eax, button2_x
	jl button_fail2
	cmp eax, button2_x + button2_size
	jg button_fail2
	mov eax, [ebp+arg3]
	cmp eax, button4_y
	jl button_fail2
	cmp eax, button4_y + button2_size
	jg button_fail2
	make_text_macro 'N', area, 140, 276
	make_text_macro 'U', area, 150, 276
	make_text_macro 'X', area, 34, 276
	inc click
	jmp evt_click_start	
	
evt_click_next5:	
	mov eax, [ebp+arg2]
	cmp eax, button3_x
	jl button_fail2
	cmp eax, button3_x + button_size
	jg button_fail2
	mov eax, [ebp+arg3]
	cmp eax, button5_y
	jl button_fail2
	cmp eax, button5_y + button2_size
	jg button_fail2
	make_text_macro ' ', area, 10, 10
	make_text_macro ' ', area, 20, 10
	make_text_macro ' ', area, 30, 10
	make_text_macro ' ', area, 40, 10
	
	make_text_macro ' ', area, 140, 162
	make_text_macro ' ', area, 150, 162
	make_text_macro ' ', area, 140, 219
	make_text_macro ' ', area, 150, 219
	make_text_macro ' ', area, 140, 276
	make_text_macro ' ', area, 150, 276
	make_text_macro ' ', area, 34, 162
	make_text_macro ' ', area, 34, 219
	make_text_macro ' ', area, 34, 276
	mov ecx, 21
	mov spatiu, 50
	buclicica:
	make_text_macro ' ', area, spatiu, 75
	add spatiu, 10
	loop buclicica
	mov ecx, 7
	mov spatiu, 64
	mov spatiu2, 496
	buclicica2:
	make_text_macro ' ', area, spatiu, 162
	make_text_macro ' ', area, spatiu, 219
	make_text_macro ' ', area, spatiu, 276
	make_text_macro ' ', area, spatiu2, 365
	add spatiu, 10
	add spatiu2, 10
	loop buclicica2
	line_horizontal button2_x, button4_y, button2_size, 0FF9999h
	line_horizontal button2_x, button4_y + button2_size, button2_size, 0FF9999h
	line_vertical button2_x, button4_y, button2_size, 0FF9999h
	line_vertical button2_x + button2_size, button4_y, button2_size, 0FF9999h
	
	line_horizontal button3_x, button5_y, button_size, 0FF9999h
	line_horizontal button3_x, button5_y + button2_size, button_size, 0FF9999h
	line_vertical button3_x, button5_y, button2_size, 0FF9999h
	line_vertical button3_x + button_size, button5_y, button2_size, 0FF9999h
	
	line_horizontal button2_x, button2_y, button2_size, 0FF9999h
	line_horizontal button2_x, button2_y + button2_size, button2_size, 0FF9999h
	line_vertical button2_x, button2_y, button2_size, 0FF9999h
	line_vertical button2_x + button2_size, button2_y, button2_size, 0FF9999h
	
	line_horizontal button2_x, button3_y, button2_size, 0FF9999h
	line_horizontal button2_x, button3_y + button2_size, button2_size, 0FF9999h
	line_vertical button2_x, button3_y, button2_size, 0FF9999h
	line_vertical button2_x + button2_size, button3_y, button2_size, 0FF9999h
	 jmp final_intrebare		
	
final_intrebare:
	cmp contor, 1
	jl mesaj_fail
	jge mesaj1
	jmp button_fail2
	mesaj_fail:
	make_text_macro 'I', area, 140, 190
	make_text_macro 'M', area, 150, 190
	make_text_macro 'I', area, 160, 190
	
	make_text_macro 'P', area, 180, 190
	make_text_macro 'A', area, 190, 190
	make_text_macro 'R', area, 200, 190
	make_text_macro 'E', area, 210, 190
	
	make_text_macro 'R', area, 230, 190
	make_text_macro 'A', area, 240, 190
	make_text_macro 'U', area, 250, 190
	
	make_text_macro 'N', area, 140, 210
	make_text_macro 'U', area, 150, 210
	
	make_text_macro 'A', area, 170, 210
	make_text_macro 'I', area, 180, 210
	
	make_text_macro 'C', area, 200, 210
	make_text_macro 'A', area, 210, 210
	make_text_macro 'S', area, 220, 210
	make_text_macro 'T', area, 230, 210
	make_text_macro 'I', area, 240, 210
	make_text_macro 'G', area, 250, 210
	make_text_macro 'A', area, 260, 210
	make_text_macro 'T', area, 270, 210
	jmp button_fail2
	mesaj1:
	make_text_macro 'F', area, 170, 190
	make_text_macro 'E', area, 180, 190
	make_text_macro 'L', area, 190, 190
	make_text_macro 'I', area, 200, 190
	make_text_macro 'C', area, 210, 190
	make_text_macro 'I', area, 220, 190
	make_text_macro 'T', area, 230, 190
	make_text_macro 'A', area, 240, 190
	make_text_macro 'R', area, 250, 190
	make_text_macro 'I', area, 260, 190

	make_text_macro 'A', area, 170, 210
	make_text_macro 'I', area, 180, 210
	
	make_text_macro 'C', area, 200, 210
	make_text_macro 'A', area, 210, 210
	make_text_macro 'S', area, 220, 210
	make_text_macro 'T', area, 230, 210
	make_text_macro 'I', area, 240, 210
	make_text_macro 'G', area, 250, 210
	make_text_macro 'A', area, 260, 210
	make_text_macro 'T', area, 270, 210
	make_text_macro '0', area, 310, 210
	make_text_macro '0', area, 320, 210
	make_text_macro '$', area, 330, 200
	cmp contor, 1
	je dolari2
	jmp verifica2
	dolari2:
	make_text_macro '2', area, 300, 210
	verifica2:
	cmp contor, 2
	je dolari4
	jmp verifica3
	dolari4:
	make_text_macro '4', area, 300, 210
	verifica3:
	cmp contor, 3
	je dolari6
	jmp verifica4
	dolari6:
	make_text_macro '6', area, 300, 210
	verifica4:
	cmp contor, 4
	je dolari8
	jmp verifica5
	dolari8:
	make_text_macro '8', area, 300, 210
	verifica5:
	cmp contor, 5
	je dolari10
	jmp button_fail2
	dolari10:
	make_text_macro '0', area, 300, 210
	make_text_macro '1', area, 290, 210
	
button_fail2:	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	push 0
	call exit
end start