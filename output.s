	.data
newline: .asciiz "\n"
var___1: .word 0
var___2: .word 0
var___3: .word 0
var___4: .word 0
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
	addi $sp, -4
	li $t0, 100
	sw $t0, ($sp)
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___2
	addi $sp, -4
	li $t0, 55
	sw $t0, ($sp)
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___3
	j label_1
codegen_label1:
	addi $sp, 4
	li $v0, 1
	lw $a0, var___1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 10
	syscall
label_1:
	li $v0, 1
	lw $a0, var___2
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 1
	lw $a0, var___3
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	la $t0, codegen_label2
	addi $sp, -4
	sw $t0, ($sp)
		addi $sp, -4
	lw $t0, var___2
	sw $t0, ($sp)
		addi $sp, -4
	lw $t0, var___3
	sw $t0, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	add$t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___4
	j label_2
codegen_label2:
	addi $sp, 4
	addi $sp, -4
	li $t0, 0
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0
label_2:
	li $v0, 1
	lw $a0, var___4
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	addi $sp, -4
	lw $t0, var___4
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0

