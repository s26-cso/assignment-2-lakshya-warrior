.section .rodata
    filename: .string "input.txt"
    mode: .string "r"
    outputyes: .string "Yes\n"
    outputno: .string "No\n"

.section .text
.globl main

main:
    addi sp, sp, -32 # store RA in stack
    sd s0, 24(sp)
    sd s1, 16(sp)
    sd ra, 8(sp)
    sd s2, 0(sp)

    la a0, filename
    la a1, mode 
    call fopen # fopen("input.txt", "r") 
    mv s0, a0 # gives file pointer

    li a1, 0
    li a2, 2 # SEEK_END = 2
    call fseek # fseek(fileptr, 0, SEEK_END)
    # goes to the last of the file

    mv a0, s0 # ftell(fileptr)
    call ftell # position if fileptr

    mv s1, a0  # length of string

    addi s2, x0, 0# left
    addi s1, s1, -1  #right ptr

loop:
    bge s2, s1, yes # left >= right its a palindrome

    mv a0, s0
    mv a1, s2
    li a2, 0
    call fseek # first argument is fileptr and second is the location from start(0)
    mv a0, s0
    call fgetc
    mv t0, a0 # left char

    mv a0, s0
    mv a1, s1
    li a2, 0 # SEEK SET
    call fseek # first argument is fileptr and second is the location
    mv a0, s0
    call fgetc
    mv t1, a0 # right char

    bne t0, t1, no # If not equal then not a palindrome
    addi s2, s2, 1 # leftptr++
    addi s1, s1, -1 #rightptr--;
    j loop

yes:
    la a0, outputyes
    call printf # print Yes
    ld s0, 24(sp)
    ld s1, 16(sp)
    ld ra, 8(sp)  
    ld s2, 0(sp)
    addi sp, sp, 32
    ret

no:
    la a0, outputno
    call printf # print No
    ld s0, 24(sp)
    ld s1, 16(sp)
    ld ra, 8(sp)  
    ld s2, 0(sp)
    addi sp, sp, 32
    ret
