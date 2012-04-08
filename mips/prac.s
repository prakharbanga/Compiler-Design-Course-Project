   .data

   .text

main:
   li $t0, 1
   add $t1, $t0, 2

   li $v0, 1
   move $a0, $t1
   syscall

