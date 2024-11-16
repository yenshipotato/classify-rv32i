.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0            
    li t1, 0         

loop_start:
    bge t1, a2, loop_end
    # TODO: Add your own implementation

cal_index1:    
    mv t2, t1
    mv t3, a3
    li t4, 0
mul1:
    beq t3, zero, load_element1
    andi t5, t3, 1            
    beq t5, zero, loop1       
    add t4, t4, t2                
loop1:
    slli t2, t2, 1
    srli t3, t3, 1
    j mul1     
      
# t4 = t1 * a3

load_element1:
    slli t4, t4, 2 # t4 = t4 * 4
    add t4, a0, t4 # t4 = a0 + t4
    lw t2, 0(t4) #  t6 = *t4
    beq t2, zero, increment

cal_index2:
    mv t6, t1
    mv t3, a4
    li t4, 0
mul2:
    beq t3, zero, load_element2
    andi t5, t3, 1            
    beq t5, zero, loop2       
    add t4, t4, t6                
loop2:
    slli t6, t6, 1
    srli t3, t3, 1
    j mul2
          
# t4 = t1 * a4

load_element2:
    slli t4, t4, 2 # t4 = t4 * 4
    add t4, a1, t4 # t4 += a0 
    lw t3, 0(t4) # a6 = *t4
    beq t3, zero, increment

element_multiply:
    li t4, 0
mul3:
    beq t3, zero, update_sum
    andi t5, t3, 1            
    beq t5, zero, loop3    
    add t4, t4, t2                
loop3:
    slli t2, t2, 1
    srli t3, t3, 1
    j mul3   

update_sum:
    add t0, t0, t4

increment:
    addi t1, t1, 1
    j loop_start
    
loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit