.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
 li t0 1
 blt a1 t0 Error
 blt a2 t0 Error
 blt a4 t0 Error
 blt a5 t0 Error
 bne a2 a4 Error
 # d[i][j] = dot(t0 << 4 * a2, t1 << 2, a4*a5-t1, 1, a5)
 # d[i][j] = t0*16+t1*4
 li t0 -1  # row iterator, less a1
 li t1 0  # col iterator, less a5
 
 Loop_outer:
 addi t0 t0 1  # t0++
 mv t1 zero
 beq t0 a1 Done # t0 < a1, row of m0
 
 Loop_inner:
 beq t1 a5 Loop_outer # t1 < a5, col of m1
 mul t2 a2 t0 
 slli t2 t2 2  # t2 = a2*t0*4
 
 # call convention
 addi sp sp -40
 sw a0 0(sp)
 sw a1 4(sp)
 sw a2 8(sp)
 sw a3 12(sp)
 sw a4 16(sp)
 sw a5 20(sp)
 sw ra 24(sp)
 
 add a0 a0 t2 # a0 = addr1 arg0, a0
 slli a4 t1 2 
 add a1 a3 a4 # a1 = t1*4 + a3, m1[0][t1], arg1, a1
              # arg2, a2
 li a3 1      # arg3, a3
 mv a4 a5     # arg4, a4
 
 # call convention
 sw t0 28(sp)
 sw t1 32(sp)
 sw a6 36(sp)
 jal dot
 
 lw a1 4(sp)
 lw a2 8(sp)
 lw a3 12(sp)
 lw a4 16(sp)
 lw a5 20(sp)
 lw ra 24(sp)
 lw t0 28(sp)
 lw t1 32(sp)
 lw a6 36(sp)
 
mul t2 t0 a5 
add t2 t2 t1
slli t2 t2 2
add t2 t2 a6 # t2 = &d[i][j]
sw a0 0(t2)  # d[i][j] = dot

# call convention
lw a0 0(sp)
addi sp sp 40

addi t1 t1 1

j Loop_inner

 
Error:
 li a0 38 
 j exit

Done:
 ret
