   .text

main:

   la $t0, l1
   sw $t0, ($sp)
   lw $t0, ($sp)
   jr $t0

   li $v0, 1
   li $a0, 999
   syscall

l1:
   li $v0, 1
   li $a0, 57
   syscall

