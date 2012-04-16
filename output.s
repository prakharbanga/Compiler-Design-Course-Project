	.data
newline: .asciiz "\n"
var___2: .word 0
var___1: .word 0
	.text
main:
	addi $sp, -4
	li $t0, 9
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___1
	addi $sp, 4
	addi $sp, -4
	li $t0, 8
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___2
	addi $sp, 4
codegen_label1:
	addi $sp, -4
	lw $t0, var___1
	sw $t0, ($sp)
	addi $sp, -4
	li $t0, 0
	sw $t0, ($sp)
	lw $t1, ($sp)
	add $sp, 4
	lw $t0, ($sp)
	add $sp, 4
	sub $t0, $t0, $t1
	bltz $t0, codegen_label2
label_1:
	li $v0, 1
	lw $a0, var___1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	addi $sp, -4
	lw $t0, var___1
	sw $t0, ($sp)
	addi $sp, -4
	li $t0, 1
	sw $t0, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	sub$t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___1
	addi $sp, 4
	j codegen_label1
codegen_label2:
	li $v0, 10
	syscall

