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

button1_x equ 258
button1_y equ 265
button_size equ 100

button2_x equ 23
button2_y equ 158
button3_y equ 215
button4_y equ 272
button2_size equ 30

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
	mov dword ptr [edi], 0FFFFFFh
	
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
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
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
	make_text_macro '$', area, 34, 442

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
	make_text_macro ' ', area, 240, 180
	make_text_macro ' ', area, 250, 180
	make_text_macro ' ', area, 260, 180
	make_text_macro ' ', area, 270, 180
	make_text_macro ' ', area, 280, 180
	make_text_macro ' ', area, 290, 180
	
	make_text_macro ' ', area, 320, 180
	make_text_macro ' ', area, 330, 180
	make_text_macro ' ', area, 340, 180
	make_text_macro ' ', area, 350, 180
	
	make_text_macro ' ', area, 280, 310
	make_text_macro ' ', area, 290, 310
	make_text_macro ' ', area, 300, 310
	make_text_macro ' ', area, 310, 310
	make_text_macro ' ', area, 320, 310
	
	line_horizontal button1_x, button1_y, button_size, 0FFFFFFh
	line_horizontal button1_x, button1_y + button_size, button_size, 0FFFFFFh
	line_vertical button1_x, button1_y, button_size, 0FFFFFFh
	line_vertical button1_x + button_size, button1_y, button_size, 0FFFFFFh
	jmp prima_intrebare
	
button_fail:
	jmp final_draw
	
evt_timer:
	;inc counter	
	
	jmp final_draw
prima_intrebare:
;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 30, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 20, 10
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 10, 10
	
	;scriem un mesaj
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
	
	jmp evt_click_unu
evt_click_unu:
	mov eax, [ebp+arg2]
	cmp eax, button1_x
	jl button_fail2
	cmp eax, button2_x + button2_size
	jg button_fail2
	mov eax, [ebp+arg3]
	cmp eax, button3_y
	jl button_fail2
	cmp eax, button3_y + button2_size
	jg button_fail2
	;s-a dat click in buton	
	make_text_macro ' ', area, 50, 75
	make_text_macro ' ', area, 60, 75
	make_text_macro ' ', area, 70, 75
	make_text_macro ' ', area, 80, 75
	
	make_text_macro ' ', area, 100, 75
	make_text_macro ' ', area, 110, 75
	make_text_macro ' ', area, 120, 75
	make_text_macro ' ', area, 130, 75
	make_text_macro ' ', area, 140, 75
	make_text_macro ' ', area, 150, 75
	
	make_text_macro ' ', area, 170, 75
	make_text_macro ' ', area, 180, 75
	make_text_macro ' ', area, 190, 75
	make_text_macro ' ', area, 200, 75
	
	make_text_macro ' ', area, 220, 75
	make_text_macro ' ', area, 230, 75
	
	make_text_macro ' ', area, 250, 75
	make_text_macro ' ', area, 260, 75
	make_text_macro ' ', area, 270, 75
	make_text_macro ' ', area, 280, 75
	 jmp doua_intrebare
 doua_intrebare:
;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 30, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 20, 10
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 10, 10
	
	;scriem un mesaj
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
	
	make_text_macro '1', area, 64, 162
	make_text_macro '0', area, 74, 162
	make_text_macro '1', area, 64, 219
	make_text_macro '0', area, 74, 219
	make_text_macro '0', area, 84, 219
	make_text_macro '1', area, 64, 276
	make_text_macro '0', area, 74, 276
	make_text_macro '0', area, 84, 276
	make_text_macro '0', area, 94, 276
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
	
	;terminarea programului
	push 0
	call exit
end start
