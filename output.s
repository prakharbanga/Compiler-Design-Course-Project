	.data
newline: .asciiz "\n"
var___2: .word 0
var___1: .word 0
var___3: .word 0
	.text
main:
	addi $sp, -4
	li $t0, 1
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___1
	addi $sp, 4
label_3:
	addi $sp, -4
	lw $t0, var___1
	sw $t0, ($sp)
	addi $sp, -4
	li $t0, 13
	sw $t0, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	slt $t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t0, ($sp)
	add $sp, 4
	beq $t0, $zero, label_4
label_2:
	lw $t0, var___2
	addi $sp, -4
	sw $t0, ($sp)
	lw $t0, var___1
	addi $sp, -4
	sw $t0, ($sp)
	la $t0, codegen_label1
	addi $sp, -4
	sw $t0, ($sp)
	addi $sp, -4
	lw $t0, var___1
	sw $t0, ($sp)
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___3
	j label_1
codegen_label1:
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___1
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___2
	addi $sp, -4
	sw $t1, ($sp)
	lw $t0, ($sp)
	sw $t0, var___2
	addi $sp, 4
	li $v0, 1
	lw $a0, var___2
	syscall
	li $v0, 4
	la $a0, newline
	syscall
label_5:
	addi $sp, -4
	lw $t0, var___1
	sw $t0, ($sp)
	addi $sp, -4
	li $t0, 1
	sw $t0, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	add $t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___1
	addi $sp, 4
	j label_3
label_4:
	li $v0, 10
	syscall
label_1:
	addi $sp, -4
	lw $t0, var___3
	sw $t0, ($sp)
	addi $sp, -4
	li $t0, 1
	sw $t0, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	seq $t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t0, ($sp)
	add $sp, 4
	beq $t0, $zero, label_7
label_6:
	addi $sp, -4
	li $t0, 1
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0
	j codegen_label2
label_7:
	addi $sp, -4
	lw $t0, var___3
	sw $t0, ($sp)
	lw $t0, var___3
	addi $sp, -4
	sw $t0, ($sp)
	la $t0, codegen_label3
	addi $sp, -4
	sw $t0, ($sp)
	addi $sp, -4
	lw $t0, var___3
	sw $t0, ($sp)
	addi $sp, -4
	li $t0, 1
	sw $t0, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	sub $t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___3
	j label_1
codegen_label3:
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___3
	addi $sp, -4
	sw $t1, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	mult $t1, $t0
	mflo $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0
codegen_label2:
	addi $sp, -4
	li $t0, 0
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0

