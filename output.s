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
	addi $sp, 4
	la $t0, codegen_label2
	addi $sp, -4
	sw $t0, ($sp)
	j label_2
codegen_label2:
	addi $sp, 4
	la $t0, codegen_label3
	addi $sp, -4
	sw $t0, ($sp)
	j label_3
codegen_label3:
	addi $sp, 4
	la $t0, codegen_label4
	addi $sp, -4
	sw $t0, ($sp)
	j label_4
codegen_label4:
	addi $sp, 4
	la $t0, codegen_label5
	addi $sp, -4
	sw $t0, ($sp)
	j label_5
codegen_label5:
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
	la $t0, codegen_label6
	addi $sp, -4
	sw $t0, ($sp)
	j label_2
codegen_label6:
	addi $sp, 4
	la $t0, codegen_label7
	addi $sp, -4
	sw $t0, ($sp)
	j label_3
codegen_label7:
	addi $sp, 4
	la $t0, codegen_label8
	addi $sp, -4
	sw $t0, ($sp)
	j label_4
codegen_label8:
	addi $sp, 4
	la $t0, codegen_label9
	addi $sp, -4
	sw $t0, ($sp)
	j label_5
codegen_label9:
	addi $sp, 4
	addi $sp, -4
	li $t0, 10
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0
label_2:
	la $t0, codegen_label10
	addi $sp, -4
	sw $t0, ($sp)
	j label_3
codegen_label10:
	addi $sp, 4
	la $t0, codegen_label11
	addi $sp, -4
	sw $t0, ($sp)
	j label_4
codegen_label11:
	addi $sp, 4
	la $t0, codegen_label12
	addi $sp, -4
	sw $t0, ($sp)
	j label_5
codegen_label12:
	addi $sp, 4
	addi $sp, -4
	li $t0, 10
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0
label_3:
	la $t0, codegen_label13
	addi $sp, -4
	sw $t0, ($sp)
	j label_4
codegen_label13:
	addi $sp, 4
	la $t0, codegen_label14
	addi $sp, -4
	sw $t0, ($sp)
	j label_5
codegen_label14:
	addi $sp, 4
	addi $sp, -4
	li $t0, 10
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0
label_4:
	la $t0, codegen_label15
	addi $sp, -4
	sw $t0, ($sp)
	j label_5
codegen_label15:
	addi $sp, 4
	addi $sp, -4
	li $t0, 10
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0
label_5:
	addi $sp, -4
	li $t0, 10
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0

