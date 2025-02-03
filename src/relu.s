.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:   # use tx reg first

ebreak
  li t0 1
  blt a1 t0 Error
  
  addi t0 t0 -1
 Loop:
  beq t0 a1 Done

  slli t1 t0 2   # t1 = k*4
  addi t0 t0 1
  add t2 a0 t1   # t2 = &array[k]
  lw t1 0(t2)    # t1 = array[k]
  blt zero t1 Nt
  sw zero 0(t2) 
 Nt:
  j Loop

Error:
  li a0 36
  j exit

Done:
  ret