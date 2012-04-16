   .text

main:

   li $t0, 0
   bgtz $t0, l1

   li $v0, 1
   li $a0, 99
   syscall

l1:
   li $v0, 1
   li $a0, 99
   syscall
