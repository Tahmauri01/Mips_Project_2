.data
SpaceInput: .space 1002     #max amount of characters plus newline and null
null_msg: .asciiz "NULL"    #NULL message for printing
semicolon: .asciiz ";"      #Colon for separating

.text
.globl main

main:

    li $t0, 32  #Hardcoded N, stored into $t0
    li $t1, 10  #stores 10 into $t1

    sub $t2, $t0, $t1   #M = N - 10

    li $t3, 0x61 #stores 'a' into $t3
    add $t4, $t3, $t2 #$t4 = 'a' + M
    addi $t4, $t4, -1 #cap for lowercase, $t4 = 'a' + M - 1

    li $t5, 0x41 #stores 'A' int $t5
    add $t6, $t5, $t2 #$t6 = 'A" + M