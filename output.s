	.data
newline: .asciiz "\n"
var___2: .word 0
var___1: .word 0
	.text
main:
addi $sp, -4
li $t0, 5
sw $t0, ($sp)
lw $t0, ($sp)
sw $t0, var___1
addi $sp, 4
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
li $t0, 67
sw $t0, ($sp)
lw $t0, ($sp)
lw $t1, 4($sp)
add$t0, $t1, $t0
addi $sp, 4
sw $t0, ($sp)
addi $sp, -4
li $t0, 45
sw $t0, ($sp)
lw $t0, ($sp)
lw $t1, 4($sp)
sub$t0, $t1, $t0
addi $sp, 4
sw $t0, ($sp)
lw $t0, ($sp)
sw $t0, var___2
addi $sp, 4
li $v0, 1
lw $a0, var___2
syscall
li $v0, 4
la $a0, newline
syscall
addi $sp, -4
li $t0, 56
sw $t0, ($sp)
addi $sp, -4
li $t0, 27
sw $t0, ($sp)
addi $sp, -4
li $t0, 5
sw $t0, ($sp)
lw $t0, ($sp)
lw $t1, 4($sp)
add$t0, $t1, $t0
addi $sp, 4
sw $t0, ($sp)
lw $t0, ($sp)
lw $t1, 4($sp)
sub$t0, $t1, $t0
addi $sp, 4
sw $t0, ($sp)
lw $t0, ($sp)
sw $t0, var___2
addi $sp, 4
li $v0, 1
lw $a0, var___2
syscall
li $v0, 4
la $a0, newline
syscall

