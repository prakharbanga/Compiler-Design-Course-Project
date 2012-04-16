	.data
newline: .asciiz "\n"
var___1: .word 0
	.text
main:
	addi $sp, -4
	li $t0, 5
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___1
	addi $sp, 4
	la $t0, codegen_label1
	addi $sp, -4
	sw $t0, ($sp)
	j label_1
codegen_label1:
	li $v0, 1
	lw $a0, var___1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
label_1:
	addi $sp, -4
	li $t0, 5
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0

