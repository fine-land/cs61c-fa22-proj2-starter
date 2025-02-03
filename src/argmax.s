.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
  li t0 1
  blt a1 t0 Error # size < 1

  li t0 0x80000000  # t0 has min value, init to min
  li t1 0  # iterator for loop
  mv t2 a0 # address of ret index
Loop:
  beq t1 a1 Done
  slli t3 t1 2  # t3 == k*4
  add t2 a0 t3 # t2 == &array[k]
  lw t3 0(t2)  # t3 == array[k]
  bge t0 t3 Nt  # if t0 < array[k], then t0 = array[k],
  mv t0 t3
  mv t4 t1   # t4 is result index
 Nt:
  addi t1 t1 1
  j Loop
  
Error:
  li a0 36
  j exit
  
Done:
  mv a0 t4
  ret