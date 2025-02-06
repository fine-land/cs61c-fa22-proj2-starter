.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

#  t0 = fread(filepath, readonly);
#  if t0 == -1, return 27
addi sp sp -16
sw a0 0(sp) # now a0(filename) not be needed, but for venus checker.
sw a1 4(sp)
sw a2 8(sp)
sw ra 12(sp)

li a1 0   # read only
jal fopen
li t0 -1
beq a0 t0 FopenError # if a0 == -1
mv t0 a0 # keep fd in t0

# fread(fd, buffer, maxbytes)
lw a1 4(sp)  # row address
li a2 4  # four bytes

# call convention fd
addi sp sp -4
sw t0 0(sp)

jal fread

li t0 4
bne a0 t0 FreadError

# fread(fd, col, 4)
lw t0 0(sp)
mv a0 t0
lw a1 12(sp)
li a2 4

jal fread

li t0 4
bne a0 t0 FreadError

# malloc(row*col)

lw a0 8(sp)
lw a0 0(a0) # row
lw a1 12(sp)
lw a1 0(a1) # col
mul a0 a0 a1 # num of mat
slli a0 a0 2 # a0*4, bytes
# call convention, size of mat
addi sp sp -4
sw a0 0(sp)

jal malloc

beq a0 zero MallocError

# fread all elements
mv a1 a0    # buffer from malloc
sw a1 8(sp) # sw return value
lw a0 4(sp) # fd
lw a2 0(sp)  # size to read

jal fread

lw a1 0(sp)
bne a0 a1 FreadError
lw a0 4(sp)  # fd

jal fclose

bne a0 zero FcloseError
lw a0 8(sp)

# call convention
lw ra 20(sp)
addi sp sp 24

ret

MallocError:
li a0 26
j exit

FopenError:
li a0 27
j exit

FcloseError:
li a0 28 
j exit

FreadError:
li a0 29
j exit

