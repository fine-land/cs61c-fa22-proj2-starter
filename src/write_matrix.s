.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

addi sp sp -28
sw a0 0(sp)
sw a1 4(sp)
sw a2 8(sp)
sw a3 12(sp)
sw ra 16(sp)
sw s0 24(sp)

li a1 1 # read only
jal fopen  # fopen(filename, flag)
li a1 -1
beq a0 a1 FopenError
sw a0 20(sp) # sw fd

# fwrite(fd, buffer, num bytes) write row && col
addi a1 sp 8
li a2 2
li a3 4

jal fwrite

li a1 2
bne a0 a1 FwriteError

# fwrite all elements
lw a0 20(sp)
lw a1 4(sp)
lw a2 8(sp)
lw a3 12(sp)
mul a2 a2 a3
mv s0 a2 # save total items
li a3 4

jal fwrite

bne a0 s0 FwriteError

lw a0 20(sp) # load fd
jal fclose
bne a0 zero FcloseError


lw ra 16(sp)
lw s0 24(sp)
addi sp sp 28

ret

FopenError:
li a0 27
j exit

FwriteError:
li a0 30
j exit

FcloseError:
li a0 28
j exit
