; This program counts the number of key presses until ESC is pressed
; and displays the result in decimal format

.model small
.stack 100h
.data
  msg1 db "Counting key presses, press ESC to stop", 0Dh, 0Ah, "$"
  msg2 db "Counting key presses: ", "$"
  count dw 0 ; counter for key presses
.code       
  main proc
  mov ax, @data ; set data segment
  mov ds, ax

  ; print msg1
  lea dx, msg1
  mov ah, 09h
  int 21h

loop1:
  ; check if a key is pressed
  mov ah, 01h
  int 21h

  ; compare with ESC (1Bh)
  cmp al, 1Bh
  je exit ; if ESC, exit loop

  ; increment counter
  inc count

  jmp loop1 ; repeat loop

exit:
  ; print msg2
  mov ah,02
  mov bh,00
  mov dl,00
  mov dh,03
  int 10h  
  lea dx,msg2 
  mov ah, 09h
  int 21h 

  ; convert count to decimal string
  mov ax, count
  mov bx, 10 ; base of decimal system
  mov cx, 0 ; number of digits

convert:
  xor dx, dx ; clear dx for division
  div bx ; ax = dx:ax / bx (dx = remainder)
  
  ; convert remainder to ASCII code and push to stack
  add dl, '0'
  push dx

  inc cx ; increment number of digits

  cmp ax, 0 ; check if quotient is zero
  jne convert ; if not, repeat conversion

print:
  pop dx ; pop a digit from stack
  mov ah, 02h ; print character function
  int 21h

loop print ; repeat until stack is empty

; terminate program
mov ah,4ch 
int 21h 
end 
