.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
 li t0 1
 blt a2 t0 E1    # if a2 < 1
 blt a3 t0 E2    # if a3 < 1 || a4 < 1
 blt a4 t0 E2
 
li t5 0
li t0 0   # iterator for array1
li t1 0   # iterator for array2
li t2 0   # sum of dot
Loop:
 beq t5 a2 Done
 
 # load array1[k1] && array2[k2]
 slli t3 t0 2  # t3 = 4*k
 add t3 t3 a0  # t3 = &array1[k1]
 lw t3 0(t3)   # t3 = array1[k1]
 
 slli t4 t1 2
 add t4 t4 a1
 lw t4 0(t4)
 
 mul t3 t3 t4  # t3 = array1[k1] * array2[k2]
 add t2 t2 t3  # sum += t3
 
 add t0 t0 a3
 add t1 t1 a4
 addi t5 t5 1
 j Loop
 
E1:
  li a0 36
  j exit
E2:
  li a0 37
  j exit
  
  
 Done:
  mv a0 t2
  ret



