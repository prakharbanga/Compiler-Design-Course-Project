   .text

main:

   li $t0, 5
   li $t1, 1
   sge $t2, $t0, $t1

l1:
   li $v0, 1
   move $a0, $t2
   syscall
   
