.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
#   a0 (int*) is a pointer to the input integer
# Returns:
#   None
# =================================================================
abs:
 ebreak
 lw t0 0(a0)
 blt zero t0 done
 
 sub t0 x0 t0 
 
 done:
  sw t0 0(a0)
  ret