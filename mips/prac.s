   .data
label: .asciiz "l2"
   .text

main:
l1:   j l2

      li $v0, 1
      li $a0, 50
      syscall

l2:   li $v0, 1
      li $a0, 25
      syscall
      j l1

