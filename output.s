	.data
var___1: .word 0
	.text
main:
addi $sp, -4
li $t0, 5
sw $t0, ($sp)
addi $sp, -4
li $t0, 6
sw $t0, ($sp)
lw $t0, ($sp)
lw $t1, 4($sp)
add$t0, $t1, $t0
addi $sp, 4
sw $t0, ($sp)
addi $sp, -4
li $t0, 7
sw $t0, ($sp)
lw $t0, ($sp)
lw $t1, 4($sp)
add$t0, $t1, $t0
addi $sp, 4
sw $t0, ($sp)
lw $t0, ($sp)
sw $t0, var___1
addi $sp, 4

li $v0, 1
lw $a0, var___1
syscall
