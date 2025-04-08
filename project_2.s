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

    