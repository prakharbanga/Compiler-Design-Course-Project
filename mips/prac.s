   .text

main:

   li $t0, 51
   li $t1, 14
   mult $t0, $t1
   mflo $t2

l1:
   li $v0, 1
   move $a0, $t2
   syscall
   
