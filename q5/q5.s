.section .data
    filename: .string "input.txt"
    buffer: .space 1024
    outputyes: .string "Yes\n"
    outputno: .string "No\n"

.section .text
.globl main

main:
    addi sp, sp, -16 # store RA in stack
    sd ra, 8(sp)

    la a0, filename
    li a1, 0
    call open # first argument is filename, mode (read only => 0)
    
    mv s0, a0

    mv a0, s0 # puting all the text into buffer
    la a1, buffer
    li a2, 1024
    call read
       
    mv s1, a0           # length of string

    la t0, buffer      
    add t1, t0, s1      # Address after the last char
    addi t1, t1, -1     # End pointer (right)

loop:
    bge t0, t1, yes # left > right its a palindrome
    lbu t2, 0(t0)       # left
    lbu t3, 0(t1)       # right 
    bne t2, t3, no # If not equal then not a palindrome
    addi t0, t0, 1
    addi t1, t1, -1
    j loop

yes:
    la a0, outputyes
    call printf # print Yes
    ld ra, 8(sp)  
    addi sp, sp, 16
    ret

no:
    la a0, outputno
    call printf # print No
    ld ra, 8(sp)  
    addi sp, sp, 16
    ret
