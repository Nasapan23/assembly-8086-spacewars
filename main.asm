org 100h      ; Start of the program

; Initial setup
mov ah, 2      ; BIOS function to set cursor position
mov bh, 0      ; Page number
mov dh, 10     ; Initial row (y-coordinate)
mov dl, 40     ; Initial column (x-coordinate)
int 10h        ; Set initial cursor position

mov al, '*'    ; Character to display

main_loop:
    mov ah, 1   ; BIOS function to check for a key press
    int 16h     ; Check for key press
    jz main_loop ; If no key is pressed, keep looping

    mov ah, 0   ; BIOS function to get the key
    int 16h     ; Wait for key press

    cmp ah, 48h ; Up arrow key
    je move_up
    cmp ah, 50h ; Down arrow key
    je move_down
    cmp ah, 4Bh ; Left arrow key
    je move_left
    cmp ah, 4Dh ; Right arrow key
    je move_right
    jmp main_loop ; If not an arrow key, ignore and loop back

move_up:
    call clear_current_position
    dec dh      ; Move cursor up
    jmp draw

move_down:
    call clear_current_position
    inc dh      ; Move cursor down
    jmp draw

move_left:
    call clear_current_position
    dec dl      ; Move cursor left
    jmp draw

move_right:
    call clear_current_position
    inc dl      ; Move cursor right
    jmp draw

clear_current_position:
    push ax      ; Save AX
    push bx      ; Save BX
    push cx      ; Save CX

    mov ah, 2    ; Set cursor position
    mov bh, 0    ; Page number
    int 10h      ; Set cursor to current position

    mov ah, 0Eh  ; BIOS function to print a character
    mov al, ' '  ; Blank space to erase the character
    int 10h      ; Clear current position

    pop cx       ; Restore CX
    pop bx       ; Restore BX
    pop ax       ; Restore AX
    ret

draw:
    ; Ensure coordinates are within screen bounds
    cmp dl, 0
    jl reset
    cmp dl, 79
    jg reset
    cmp dh, 0
    jl reset
    cmp dh, 24
    jg reset

    mov ah, 2   ; Set cursor position
    mov bh, 0   ; Video page 0
    int 10h     ; Update cursor position

    mov ah, 0Eh ; Print character at new position
    mov al, '*' ; Character to draw
    int 10h     ; Display character

    jmp main_loop

reset:
    ; Reset to a valid position if out of bounds
    mov ah, 2
    mov bh, 0
    mov dh, 10  ; Default row
    mov dl, 40  ; Default column
    int 10h
    jmp main_loop
