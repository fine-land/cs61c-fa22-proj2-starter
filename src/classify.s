.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:

# call convention
addi sp sp -36
sw a0 0(sp)
sw a1 4(sp)
sw a2 8(sp)
sw s0 12(sp)
sw s1 16(sp)
sw s2 20(sp)
sw s3 24(sp)
sw s4 28(sp)
sw ra 32(sp)

li s0 5
bne a0 s0 ArgTooLess

# push m0,m1,input in stack
# sp+0, sp+4: m0 row, m0 col
# sp+8, sp+12: m1 row, m1 col
# sp+16, sp+20: input row, input col
addi sp sp -24

    # Read pretrained m0
lw a0 4(a1)  # load 0 pathname
addi a1 sp 0
addi a2 sp 4
jal read_matrix

mv s0 a0  # keep m0

    # Read pretrained m1
lw a1 28(sp)  # read origin a1
lw a0 8(a1)   # load m1 pathname
addi a1 sp 8   # a1 = &m1 row
addi a2 sp 12  # a2 = &m1 col

jal read_matrix

mv s1 a0 # keep m1

    # Read input matrix
lw a1 28(sp)  # read origin al
lw a0 12(a1)  # load input filename
addi a1 sp 16
addi a2 sp 20

jal read_matrix

mv s2 a0  # keep input

    # Compute h = matmul(m0, input)
# malloc for h
lw a0 0(sp)  # m0 row
lw a1 20(sp) # input col
mul a0 a0 a1
slli a0 a0 2 # bytes malloc

jal malloc

beq a0 zero MallocError
mv s3 a0   # keep &h in s3

mv a0 s0 # &m0
lw a1 0(sp) # m0 row
lw a2 4(sp) # m0 col
mv a3 s2 # &input
lw a4 16(sp) # input row
lw a5 20(sp) # input col
mv a6 s3
jal matmul

    # Compute h = relu(h)
mv a0 s3 # now a0 hold h
lw a1 0(sp) # m0 row
lw a5 20(sp) # input col
mul a1 a1 a5 # row*col,size of h

jal relu

    # Compute o = matmul(m1, h)
# malloc for o
lw a1 8(sp) # m1 row
lw a2 20(sp) # h col, just input col
mul a1 a1 a2
slli a0 a1 2 # bytes malloc

jal malloc

beq a0 zero MallocError

mv s4 a0     # keep &o in s4
mv a0 s1     # a0 = &m1
lw a1 8(sp)  # m1 row
lw a2 12(sp) # m1 col
mv a3 s3     # a3 = &h
lw a4 12(sp) # h row
lw a5 20(sp) # h col
mv a6 s4     # a6 = &o

jal matmul
    # Write output matrix o
lw a0 28(sp)  # read origin a1
lw a0 16(a0) # filename of output
mv a1 s4 # now a1 hold o
lw a2 8(sp) # m1 row
lw a3 20(sp) # input col

jal write_matrix

    # Compute and return argmax(o)
mv a0 s4
lw a1 8(sp)
lw a2 20(sp)
mul a1 a1 a2

jal argmax

    # If enabled, print argmax(o) and newline
mv s1 a0
lw a1 32(sp) # origin a2, print flag, 0:print;1:not
bne a1 zero Nx
mv a0 s1

jal print_int

li a0 '\n'

jal print_char

Nx:

mv a0 s1

# call convention
addi sp sp 24
lw s0 12(sp)
lw s1 16(sp)
lw s2 20(sp)
lw s3 24(sp)
lw s4 28(sp)
lw ra 32(sp)
addi sp sp 36

jr ra

ArgTooLess:
li a0 31
j exit

MallocError:
li a0 26
j exit


