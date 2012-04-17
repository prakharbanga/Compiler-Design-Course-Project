	.data
newline: .asciiz "\n"
var___2: .word 0
var___1: .word 0
	.text
main:
	la $t0, codegen_label1
	addi $sp, -4
	sw $t0, ($sp)
	addi $sp, -4
	li $t0, 10
	sw $t0, ($sp)
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___1
	j label_1
codegen_label1:
	addi $sp, 4
	li $v0, 10
	syscall
label_1:
	addi $sp, -4
	li $t0, 7
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___2
	addi $sp, 4
	addi $sp, -4
	lw $t0, var___1
	sw $t0, ($sp)
	addi $sp, -4
	li $t0, 5
	sw $t0, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	sgt $t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t0, ($sp)
	add $sp, 4
	beq $t0, $zero, label_3
label_2:
	lw $t0, var___2
	addi $sp, -4
	sw $t0, ($sp)
	lw $t0, var___1
	addi $sp, -4
	sw $t0, ($sp)
	la $t0, codegen_label3
	addi $sp, -4
	sw $t0, ($sp)
	addi $sp, -4
	li $t0, 0
	sw $t0, ($sp)
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___1
	j label_1
codegen_label3:
	addi $sp, 4
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___1
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___2
	j codegen_label2
label_3:
	addi $sp, -4
	li $t0, 100
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___2
	addi $sp, 4
codegen_label2:
	li $v0, 1
	lw $a0, var___2
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	addi $sp, -4
	li $t0, 0
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0

