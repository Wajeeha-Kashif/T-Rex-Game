; display a tick count while the left shift key is down 
[org 0x0100] 
jmp start 
seconds: dw 1758
timerflag: dw 0 
jumpflag:dw 0
oldkb: dd 0 
var: dw 0
jump:dw 0
start_game : dw 0
h1 :dw 0
h2:dw 0
h3: dw 0
h4 :dw 0
space_for2:dw 0
space_for_2_jump:dw 0
space_for3:dw 0
space_for4:dw 0
print_no :dw 0
message: db 'game over', 0
over :dw 0
space_for_3_jump:dw 0
space_for_4_jump:dw 0
; subroutine to print a number at top left of screen 
; takes the number to be printed as its parameter 
clrscr: 
 pusha
 pushf
 mov ax, 0xb800
 mov es, ax ; point es to video base
 xor di, di ; point di to top left column
 mov ax, 0x7720 ; space char in normal attribute
 mov cx, 2000 ; number of screen locations
 cld ; auto increment mode
 rep stosw ; clear the whole screen
 popf
 popa
 ret 

print_GAME_OVER:
push es
push di
push cx
push ax
push dx

mov di,1360
mov word[es:di],0x7447
add di,2
mov word[es:di],0x7441
add di,2
mov word[es:di],0x744d
add di,2
mov word[es:di],0x7445
add di,2
mov word[es:di],0x7420
add di,2
mov word[es:di],0x744f
add di,2
mov word[es:di],0x7456
add di,2
mov word[es:di],0x7445
add di,2
mov word[es:di],0x7452
add di,2
mov word[es:di],0x7413

in al,61h ; get speaker status 
push ax       ; save status 
or al,00000011b   ; set lowest 2 bits 
out 61h,al     ; turn speaker on 
mov al,60          ; starting pitch
 L2: out 42h,al       ; timer port: pulses speaker 
 ; Create a delay loop between pitches.
 mov cx,100
 L3: push cx ; outer loop
 mov cx, 100h 
 L3a: ; inner loop
 loop L3a 
 pop cx
 loop L3
 sub al,1           ; raise pitch 
 jnz L2     ; play another note
 pop ax              ; get original status
 and al,11111100b    ; clear lowest 2 bits
 out 61h,al ; turn speaker off 
 pop dx
 pop ax
 pop cx
pop di
pop es
ret
 print_line:
 push es
 push dx
 push di
 push cx
 mov dx,0x702a
 mov cx,80
 mov di,1760
 line:
 mov [es:di],dx
 add di,2
 loop line
 pop cx
 pop di
 pop dx
 pop es
 ret

print_score:
push es
push di
mov di,122
 mov word  [es:di],0x7153
 add di,2
  mov word  [es:di],0x7143
 add di,2
  mov word  [es:di],0x714f
 add di,2
  mov word  [es:di],0x7152
 add di,2
 mov word  [es:di],0x7145
 mov word  [es:136],0x717c
  mov word  [es:296],0x712d
 mov word[es:298],0x712d
 mov word  [es:300],0x712d
 mov word  [es:302],0x712d
  mov word  [es:304],0x712d
 mov word [es:144],0x717c
pop di
pop es
ret

printnum: push bp 
mov bp, sp 
push es 
push ax 
push bx 
push cx 
push dx 
push di 
mov ax, 0xb800 
mov es, ax ; point es to video base 
mov ax, [bp+4] ; load number in ax 
mov bx, 10 ; use base 10 for division 
mov cx, 0 ; initialize count of digits 
nextdigit: mov dx, 0 ; zero upper half of dividend 
div bx ; divide by 10 
add dl, 0x30 ; convert digit into ascii value 
push dx ; save ascii value on stack 
inc cx ; increment count of values 
cmp ax, 0 ; is the quotient zero 
jnz nextdigit ; if no divide it again 
mov di, 140 ; point di to 70th column 
nextpos: pop dx ; remove a digit from the stack 
mov dh, 0x71 ; use normal attribute 
mov [es:di], dx ; print char on screen 
add di, 2 ; move to next screen location 
loop nextpos ; repeat for all digits on stack 
pop di 
pop dx 
pop cx 
pop bx 
pop ax 
pop es
pop bp
ret 2

print_char:
push di
push dx
mov dh,0x7c
mov dl,01h
mov [es:di],dx

pop dx
pop di
ret

print_dino:
push di
push dx
mov dh,0x74
mov dl,01h
mov [es:di],dx
mov dh,0x74
mov dl,13h
add di,160
mov [es:di],dx
pop dx
pop di
ret
print_space_dino:
push di

mov word[es:di],0x7720
add di,160
mov word[es:di],0x7720

pop di
ret
delay:
push cx
push ax
push bx
mov cx,0xffff
here: 
add ax,bx
loop here
pop bx
pop ax
pop cx
ret

space:
push di
mov word[es:di],0x7720
pop di
ret


print_hurdle1:
push si
push bx
mov bh,0x72
mov bl,0xb3
mov [es:si],bx
pop bx
pop si
ret

print_hurdle2:
push si
push bx
mov bh,0x72
mov bl,0xb3
mov [es:si],bx
pop bx
pop si
ret

print_hurdle3:
push si
push bx
mov bh,0x72
mov bl,0xb3
mov [es:si],bx
pop bx
pop si
ret

print_hurdle4:
push si
push bx
mov bh,0x72
mov bl,0xb3
mov [es:si],bx
pop bx
pop si
ret

space2:
push si
mov si,[space_for_2_jump]
mov word [es:si],0x7720
mov si,[space_for_3_jump]
mov word [es:si],0x7720
mov si,[space_for_4_jump]
mov word [es:si],0x7720
pop si
ret


jump_routine:
push bp
mov bp,sp
push ax
push es
push di
push bx
push cx
push si
mov ax,0xb800

mov es,ax




mov si,[bp+4]
l1:
;mov di,1600
mov di,1444
mov bh,0x72
mov bl,0xb3

forward:


cmp si,1600
;jle re_convert2
jle label_1
jmp label_2



label_1
jmp re_convert2
label_2:


inc word [cs:jumpflag] ; increment tick count 
push word [cs:jumpflag] 
call printnum

call space2
mov word [es:si],0x7720

;call space_for_hurdles
sub si,2
;call space
call print_space_dino
;sub di,160
sub di,320
;call print_char
call print_dino
 ;call delay
 ;call delay
;mov [es:si],bx
call print_hurdle1
;change yahan se
mov word[h1],si
mov word[h2],si
sub word[h1],40
mov word si,[h1]
cmp si,1600
jle re_convert7_move
re_convert7_back:
mov word[space_for2],si
call print_hurdle2
mov word si,[h2]
;change yahan se hurdle 3 ke liye
mov word [h3],si
sub word[h3],60
mov word si,[h3]
cmp si,1600
jle re_convert7_hurdle3
re_convert7_back_hurdle3:
mov word[space_for3],si
call print_hurdle3
mov word si,[h2]
;change yahan se hurdle 3 ke liye
mov word [h4],si
sub word[h4],100
mov word si,[h4]
cmp si,1600
jle re_convert7_hurdle4
re_convert7_back_hurdle4:
mov word[space_for4],si
call print_hurdle4
mov word si,[h2]
jmp move1
re_convert7_move
jmp re_convert7

move1:
call delay
call delay
call delay
call delay

mov si,[space_for2]
mov word [es:si],0x7720
mov si,[space_for3]
mov word [es:si],0x7720
mov si,[space_for4]
mov word [es:si],0x7720
mov si,[h2]

;cmp di,640
cmp di,484
jne forward
jmp back
gameover1:
jmp gameover2
re_convert7:
mov word [es:si],0x7720
mov cx,1600
sub cx,si
mov dx,1758
sub dx,cx
mov si,dx
;mov si,1758
jmp re_convert7_back
re_convert7_hurdle3:
mov word [es:si],0x7720
mov cx,1600
sub cx,si
mov dx,1758
sub dx,cx
mov si,dx
;mov si,1758
jmp re_convert7_back_hurdle3
re_convert7_hurdle4:
mov word [es:si],0x7720
mov cx,1600
sub cx,si
mov dx,1758
sub dx,cx
mov si,dx
;mov si,1758
jmp re_convert7_back_hurdle4

back:


cmp si,1600
jle re_convert3
jmp move_free



re_convert3:
;call space_for_hurdles
mov word [es:si],0x7720
mov si,1758
jmp back
move_free:
mov word [es:si],0x7720

inc word [cs:jumpflag] ; increment tick count 
  
 push word [cs:jumpflag] 
call printnum
;call space_for_hurdles
sub si,2
;call space
call print_space_dino
;add di,160
add di,320
call print_dino
; call delay
 ;call delay
;mov [es:si],bx
;call print_hurdles
call print_hurdle1



mov word[h1],si
mov word[h2],si
sub word[h1],40
mov word si,[h1]
cmp si,1600
jle re_convert8_move
re_convert8_back:
mov word[space_for2],si
call print_hurdle2
mov word si,[h2]

mov word [h3],si
sub word [h3],60
mov word si,[h3]
cmp si,1600
jle re_convert8_hurdle3_move
re_convert8_back_hurdle3:
mov word[space_for3],si
call print_hurdle3
mov word si,[h2]

mov word [h4],si
sub word[h4],100
mov word si,[h4]
cmp si,1600
jle re_convert8_hurdle4_move
re_convert8_back_hurdle4:
mov word[space_for4],si
call print_hurdle4
mov word si,[h2]
jmp move2
re_convert8_move:
jmp re_convert8
re_convert8_hurdle3_move:
jmp re_convert8_hurdle3
re_convert8_hurdle4_move:
jmp re_convert8_hurdle4
move2:
call delay
call delay
call delay
call delay
mov si,[space_for2]
mov word [es:si],0x7720
mov si,[space_for3]
mov word [es:si],0x7720
mov si,[space_for4]
mov word [es:si],0x7720
mov si,[h2]
;cmp di,1600
cmp di,1444
jne back

mov word[cs:seconds],si
jmp terminate

gameover2:
je gameover
re_convert2:
mov word [es:si],0x7720
;call space_for_hurdles
mov si,1758
; jmp forward
; re_convert3:
; ;call space_for_hurdles
; mov word [es:si],0x0720
; mov si,1758
; jmp back

re_convert8:
mov word [es:si],0x7720
mov cx,1600
sub cx,si
mov dx,1758
sub dx,cx
mov si,dx
jmp re_convert8_back
re_convert8_hurdle3:
mov word [es:si],0x7720
mov cx,1600
sub cx,si
mov dx,1758
sub dx,cx
mov si,dx
jmp re_convert8_back_hurdle3
re_convert8_hurdle4:
mov word [es:si],0x7720
mov cx,1600
sub cx,si
mov dx,1758
sub dx,cx
mov si,dx
jmp re_convert8_back_hurdle4

gameover:
;mov word [es:0],0x0741
terminate:


pop si
pop cx
pop bx
pop dx
pop es
pop ax
pop bp

ret 2



delay2:
push cx
push ax
push bx
mov cx,0xffff
here2: 
add ax,bx
loop here2
pop bx
pop ax
pop cx
ret


print_alph2:
push bp
mov bp,sp
push ax
push bx
push si
push es

mov ax,0xb800
mov es, ax
;mov di,1600
mov di,1604
mov word[es:1604],0x7413
mov word[es:1444],0x7401
;call print_dino
mov si,[bp+4]

mov bh,0x72
mov bl,0xb3

forward1:

mov word[over],di
add word[over],2

cmp si,di
je gameover7
cmp word[over],si
je gameover7
cmp word[space_for2],di
je gameover7
cmp word[space_for3],di
je gameover7
cmp word[space_for4],di
je gameover7
; cmp word[space_for2],di
; je gameover4
cmp si,1600
je re_convert
jmp move_free2

re_convert:
mov word [es:si],0x7720
;call space_for_hurdles
mov si,1758
jmp forward1

move_free2:

jmp no1
gameover7:
jmp gameover4
no1:
mov word [es:si],0x7720

;call space_for_hurdles
sub si,2
;mov [es:si],bx
call print_hurdle1
;call print_hurdles


mov word[h1],si
mov word[h2],si
sub word[h1],40
mov word si,[h1]
cmp si,1600
jle re_convert9_move
re_convert9_back:
mov word[space_for2],si
call print_hurdle2
mov word si,[h2]

mov word [h3],si
sub word [h3],60
mov word si,[h3]
cmp si,1600
jle re_convert9_hurdle3_jump_move
re_convert9_back_hurdle3:
mov word[space_for3],si
call print_hurdle3
mov word si,[h2]

mov word [h4],si
sub word[h4],100
mov word si,[h4]
cmp si,1600
jle re_convert9_hurdle4_move
re_convert9_back_hurdle4:
mov word[space_for4],si
call print_hurdle4
mov word si,[h2]
jmp move3
re_convert9_move:
jmp re_convert9
re_convert9_hurdle3_jump_move:
jmp re_convert9_hurdle3_jump
re_convert9_hurdle4_move:
jmp re_convert9_hurdle4

move3:
call delay2
call delay2
call delay2
call delay2
jmp no
gameover4:
jmp gameover5
no:
inc word [cs:jumpflag] ; increment tick count 
  ;inc word [cs:jumpflag]
 push word [cs:jumpflag] 
call printnum


in al,0x60
cmp al,0x39
jne l2

mov word[cs:timerflag],1
jmp leaveme
l2:


mov si,[space_for2]
mov word [es:si],0x7720
mov si,[space_for3]
mov word [es:si],0x7720
mov si,[space_for4]
mov word [es:si],0x7720
mov si,[h2]

jmp forward1
mov word [es:si],0x7720
;call space_for_hurdles
; re_convert:
; mov word [es:si],0x0720
; ;call space_for_hurdles
; mov si,1758
; jmp forward1
re_convert9_hurdle3_jump:
jmp re_convert9_hurdle3
re_convert9:
; cmp si,1604
; je gameover5
; mov word[over],di
; add word[over],2
; cmp word[over],si
; je gameover5
mov word [es:si],0x7720
mov cx,1600
sub cx,si
mov dx,1758
sub dx,cx
mov si,dx
jmp re_convert9_back

re_convert9_hurdle3:
; cmp si,1604
; je gameover5
; mov word[over],di
; add word[over],2
; cmp word[over],si
; je gameover5
mov word [es:si],0x7720
mov cx,1600
sub cx,si
mov dx,1758
sub dx,cx
mov si,dx
jmp re_convert9_back_hurdle3

re_convert9_hurdle4:
; cmp si,1604
; je gameover5
; mov word[over],di
; add word[over],2
; cmp word[over],si
; je gameover5
mov word [es:si],0x7720
mov cx,1600
sub cx,si
mov dx,1758
sub dx,cx
mov si,dx
jmp re_convert9_back_hurdle4


gameover5:

;mov word[es:0],0x0747
;mov word[es:2],0x0741


jmp terminate_game
leaveme:
mov word [es:si],0x7720
;call space_for_hurdles
mov cx,[space_for2]
mov [space_for_2_jump],cx
mov cx,[space_for3]
mov [space_for_3_jump],cx
mov cx,[space_for4]
mov [space_for_4_jump],cx
mov [cs:seconds],si
leave_game:
pop es
pop si 
pop bx
pop ax
pop bp
ret 2




;;;;; COPY LINES 007-047 FROM EXAMPLE 9.7 (printnum) ;;;;; 
; keyboard interrupt service routine 
kbisr: push ax 
in al, 0x60 ; read char from keyboard port 
;cmp al, 0x2a ; has the left shift pressed 

cmp al, 0x39 

jne nextcmp ; no, try next comparison 
cmp word [cs:timerflag], 1; is the flag already set 
je exit ; yes, leave the ISR 
mov word [cs:timerflag], 1; set flag to start printing 
jmp exit ; leave the ISR 

nextcmp: ;cmp al, 0xaa ; has the left shift released 
;cmp al,0xb9
cmp al,0x1c
jne nomatch ; no, chain to old ISR 

mov word [cs:start_game], 1; reset flag to stop printing 
mov word [cs:print_no],1
jmp exit ; leave the interrupt routine 
nomatch: pop ax 
jmp far [cs:oldkb] ; call original ISR 
exit: mov al, 0x20 
out 0x20, al ; send EOI to PIC 
pop ax 
iret ; return from interrupt 

; timer interrupt service routine 

timer: push ax 
cmp word [cs:timerflag], 1 ; is the printing flag set 
;jne skipall ; no, leave the ISR 
jne start_the_game

 dec word [cs:seconds] ; increment tick count 
 dec word [cs:seconds]
 push word [cs:seconds] 
; call printnum ; print tick count 
; call print_alph2
call jump_routine
mov word [cs:timerflag], 0
start_the_game:

inc word [cs:jumpflag] ; increment tick count 
  ;inc word [cs:jumpflag]
 push word [cs:jumpflag] 
call printnum

mov word [jump],1
push word[cs:seconds]
call print_alph2
jmp timer
skipall:
call print_GAME_OVER
 mov al, 0x20 
out 0x20, al ; send EOI to PIC 
pop ax 
iret ; return from interrupt 

start:
call clrscr
call print_line
call print_score
 xor ax, ax 
mov es, ax ; point es to IVT base 
mov ax, [es:9*4] 
mov [oldkb], ax ; save offset of old routine 
mov ax, [es:9*4+2] 
mov [oldkb+2], ax ; save segment of old routine 
cli ; disable interrupts 
mov word [es:9*4], kbisr ; store offset at n*4 
mov [es:9*4+2], cs ; store segment at n*4+2 
mov word [es:8*4], timer ; store offset at n*4 
mov [es:8*4+2], cs ; store segment at n*4+ 
sti ; enable interrupts 

mov dx, start ; end of resident portion 
add dx, 15 ; round up to next para 
mov cl, 4 
shr dx, cl ; number of paras 
mov ax, 0x3100 ; terminate and stay resident 
int 0x21 
terminate_game:
call print_GAME_OVER
mov ax,0x4c00
int 21h