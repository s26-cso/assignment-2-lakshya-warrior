.section .data
    output: .string "%d "
    out: .string "%d\n"

.section .text
.globl main

main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    sd s1, 24(sp)
    sd s2, 16(sp)
    sd s3, 8(sp)
    sd s4, 0(sp)

    mv s0, a1 # command line input
    addi s1, a0, -1 # number of numbers inputed

    slli t0, s1, 2  
    mv a0, t0
    call malloc
    mv s2, a0 # arr

    mv a0, t0
    call malloc
    mv s3, a0 # result

    mv a0, t0
    call malloc
    mv s4, a0 # stack   

    addi s5, x0, 0 # i=0
convert: # convert all to int
    beq s5, s1, start
    addi t1, s5, 1      
    slli t1, t1, 3 # pointer
    add t1, s0, t1 #location of i+1th number
    ld a0, 0(t1) # Load string of number
    
    call atoi # Convert number from str to int
    
    slli t1, s5, 2
    add t1, s2, t1
    sw a0, 0(t1) # arr[i] = number (int)
    
    addi s5, s5, 1 # i++
    j convert

start:
    addi s6, x0, 0 # size of stack = 0
    addi s5, s1, -1 # i = n - 1

loop:
    bltz s5, return
    
    slli t1, s5, 2
    add t1, s2, t1
    lw t2, 0(t1) # Load = arr[i]

    whileloop:
        beqz  s6, stack_empty
        
        addi t3, s6, -1  # top index in stack array
        slli t3, t3, 2
        add t3, s4, t3
        lw t4, 0(t3) # t4 = stack.top() (this is an index)
        
        # Load arr[stack.top()]
        slli t5, t4, 2
        add t5, s2, t5
        lw t6, 0(t5)      # t6 = arr[stack.top()]
        
        # Check condition: if arr[top] > current, we found the next greater
        bgt t6, t2, stack_not_empty 
        
        addi s6, s6, -1     # stack.pop()
        j whileloop

stack_empty:
# t0 has the next value to be put in result arr
    addi t0, x0, -1 # put -1 in result
    j push

stack_not_empty:
    addi t3, s6, -1 # result[i] = stack.top()
    slli t3, t3, 2
    add t3, s4, t3
    lw t0, 0(t3)      # Get index from top of stack

push:
    slli t1, s5, 2
    add t1, s3, t1
    sw t0, 0(t1)      # result[i] = t0
    
    slli t1, s6, 2
    add t1, s4, t1
    sw s5, 0(t1)      # stack[s6] = i
    addi s6, s6, 1      # increment stack size
    
    addi s5, s5, -1     # i--
    j loop

return:
    addi s5, x0, 0          # i = 0
    addi s1, s1, -1
printresults:
    beq s5, s1, exit
    
    la a0, output
    slli t1, s5, 2
    add t1, s3, t1
    lw a1, 0(t1)      # Load result[i]
    call printf
    
    addi s5, s5, 1
    j printresults

exit:
    la a0, out
    slli t1, s5, 2
    add t1, s3, t1
    lw a1, 0(t1)      # Load result[i]
    call printf
    addi s5, s5, 1
    
    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    ld s4, 0(sp)
    addi sp, sp, 48    
    ret
