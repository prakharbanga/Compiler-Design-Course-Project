	.data
var___3:	.word	6   # b
var___2:	.word	100 # a
var___4:	.word	20  # c
	.text
label_1:



lw $t0, var___3

move $t1, $t0
lw $t0, var___4
move $t2, $t0
add $t0, $t1, $t2

sw $t0, var___2

