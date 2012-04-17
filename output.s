	.data
newline: .asciiz "\n"
var___8: .word 0
var___7: .word 0
var___9: .word 0
var___3: .word 0
var___4: .word 0
var___6: .word 0
var___5: .word 0
var___2: .word 0
var___1: .word 0
	.text
main:
	addi $sp, -4
	li $t0, 10
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___1
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
	addi $sp, -4
	li $t0, 5
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
	li $v0, 1
	lw $a0, var___1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 10
	syscall
label_1:
	addi $sp, -4
	li $t0, 0
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___4
	addi $sp, 4
codegen_label2:
	addi $sp, -4
	lw $t0, var___4
	sw $t0, ($sp)
	addi $sp, -4
	li $t0, 10
	sw $t0, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	slt$t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t0, ($sp)
	add $sp, 4
	beq $t0, $zero, codegen_label3
label_7:
	addi $sp, -4
	lw $t0, var___4
	sw $t0, ($sp)
	addi $sp, -4
	li $t0, 5
	sw $t0, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	seq$t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t0, ($sp)
	add $sp, 4
	beq $t0, $zero, label_9
label_8:
	li $v0, 1
	lw $a0, var___4
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	addi $sp, -4
	li $t0, 1
	sw $t0, ($sp)
	lw $t0, var___3
	addi $sp, -4
	sw $t0, ($sp)
	lw $t0, var___4
	addi $sp, -4
	sw $t0, ($sp)
	la $t0, codegen_label5
	addi $sp, -4
	sw $t0, ($sp)
	addi $sp, -4
	lw $t0, var___3
	sw $t0, ($sp)
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___5
	j label_2
codegen_label5:
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___4
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___3
	addi $sp, -4
	sw $t1, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	add$t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0
	j codegen_label4
label_9:
codegen_label4:
	addi $sp, -4
	lw $t0, var___4
	sw $t0, ($sp)
	addi $sp, -4
	li $t0, 1
	sw $t0, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	add$t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t0, ($sp)
	sw $t0, var___4
	addi $sp, 4
	j codegen_label2
codegen_label3:
	addi $sp, -4
	li $t0, 99
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0
label_2:
	addi $sp, -4
	li $t0, 2
	sw $t0, ($sp)
	lw $t0, var___5
	addi $sp, -4
	sw $t0, ($sp)
	la $t0, codegen_label6
	addi $sp, -4
	sw $t0, ($sp)
	addi $sp, -4
	lw $t0, var___5
	sw $t0, ($sp)
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___6
	j label_3
codegen_label6:
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___5
	addi $sp, -4
	sw $t1, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	add$t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0
label_3:
	addi $sp, -4
	li $t0, 3
	sw $t0, ($sp)
	lw $t0, var___6
	addi $sp, -4
	sw $t0, ($sp)
	la $t0, codegen_label7
	addi $sp, -4
	sw $t0, ($sp)
	addi $sp, -4
	lw $t0, var___6
	sw $t0, ($sp)
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___7
	j label_4
codegen_label7:
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___6
	addi $sp, -4
	sw $t1, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	add$t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0
label_4:
	addi $sp, -4
	li $t0, 4
	sw $t0, ($sp)
	lw $t0, var___7
	addi $sp, -4
	sw $t0, ($sp)
	la $t0, codegen_label8
	addi $sp, -4
	sw $t0, ($sp)
	addi $sp, -4
	lw $t0, var___7
	sw $t0, ($sp)
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___8
	j label_5
codegen_label8:
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___7
	addi $sp, -4
	sw $t1, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	add$t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0
label_5:
	addi $sp, -4
	li $t0, 5
	sw $t0, ($sp)
	lw $t0, var___8
	addi $sp, -4
	sw $t0, ($sp)
	la $t0, codegen_label9
	addi $sp, -4
	sw $t0, ($sp)
	addi $sp, -4
	lw $t0, var___8
	sw $t0, ($sp)
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___9
	j label_6
codegen_label9:
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	addi $sp, 4
	sw $t0, var___8
	addi $sp, -4
	sw $t1, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	add$t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0
label_6:
	addi $sp, -4
	li $t0, 6
	sw $t0, ($sp)
	addi $sp, -4
	lw $t0, var___9
	sw $t0, ($sp)
	lw $t0, ($sp)
	lw $t1, 4($sp)
	add$t0, $t1, $t0
	addi $sp, 4
	sw $t0, ($sp)
	lw $t1, ($sp)
	addi $sp, 4
	lw $t0, ($sp)
	sw $t1, ($sp)
	jr $t0

