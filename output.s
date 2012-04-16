	.data
newline: .asciiz "\n"
var___2: .word 0
var___1: .word 0
var___10: .word 0
var___9: .word 0
var___4: .word 0
var___3: .word 0
var___8: .word 0
var___7: .word 0
var___6: .word 0
var___5: .word 0
	.text
main:
	addi $sp, -4
	li $t0, 5
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___1
	addi $sp, 4
	addi $sp, -4
	li $t0, 105
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___2
	addi $sp, 4
	lw $t0, var___2
	addi $sp, -4
	sw $t0, ($sp)
	lw $t0, var___1
	addi $sp, -4
	sw $t0, ($sp)
	la $t0, codegen_label1
	addi $sp, -4
	sw $t0, ($sp)
	j label_1
codegen_label1:
	addi $sp, 4
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___1
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___2
	li $v0, 1
	lw $a0, var___1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 1
	lw $a0, var___2
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 10
	syscall
label_1:
	addi $sp, -4
	li $t0, 10
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___3
	addi $sp, 4
	addi $sp, -4
	li $t0, 110
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___4
	addi $sp, 4
	lw $t0, var___4
	addi $sp, -4
	sw $t0, ($sp)
	lw $t0, var___3
	addi $sp, -4
	sw $t0, ($sp)
	la $t0, codegen_label2
	addi $sp, -4
	sw $t0, ($sp)
	j label_2
codegen_label2:
	addi $sp, 4
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___3
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___4
	li $v0, 1
	lw $a0, var___3
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 1
	lw $a0, var___4
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
label_2:
	addi $sp, -4
	li $t0, 15
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___5
	addi $sp, 4
	addi $sp, -4
	li $t0, 115
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___6
	addi $sp, 4
	lw $t0, var___6
	addi $sp, -4
	sw $t0, ($sp)
	lw $t0, var___5
	addi $sp, -4
	sw $t0, ($sp)
	la $t0, codegen_label3
	addi $sp, -4
	sw $t0, ($sp)
	j label_3
codegen_label3:
	addi $sp, 4
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___5
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___6
	li $v0, 1
	lw $a0, var___5
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 1
	lw $a0, var___6
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
label_3:
	addi $sp, -4
	li $t0, 20
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___7
	addi $sp, 4
	addi $sp, -4
	li $t0, 120
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___8
	addi $sp, 4
	lw $t0, var___8
	addi $sp, -4
	sw $t0, ($sp)
	lw $t0, var___7
	addi $sp, -4
	sw $t0, ($sp)
	la $t0, codegen_label4
	addi $sp, -4
	sw $t0, ($sp)
	j label_4
codegen_label4:
	addi $sp, 4
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___7
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___8
	li $v0, 1
	lw $a0, var___7
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 1
	lw $a0, var___8
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
label_4:
	addi $sp, -4
	li $t0, 25
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___9
	addi $sp, 4
	addi $sp, -4
	li $t0, 125
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___10
	addi $sp, 4
	li $v0, 1
	lw $a0, var___9
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 1
	lw $a0, var___10
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

