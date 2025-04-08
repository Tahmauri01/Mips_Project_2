.data
SpaceInput: .space 1002     #max amount of characters plus newline and null
null_msg: .asciiz "NULL"    #NULL message for printing
semicolon: .asciiz ";"      #Colon for separating

.text
.globl main

main:

    li $t0, 32 #Hardcoded N, stored into $t0
    li $t1, 10 #stores 10 into $t1

    sub $t2, $t0, $t1 #M = N - 10

    li $t3, 0x61 #stores 'a' into $t3
    add $t4, $t3, $t2 #$t4 = 'a' + M
    addi $t4, $t4, -1 #cap for lowercase, $t4 = 'a' + M - 1

    li $t5, 0x41 #stores 'A' int $t5
    add $t6, $t5, $t2 #$t6 = 'A" + M
    addi $t6, $t6, -1 #$cap for uppercase, t6 = 'A' + M - 1

    li $v0, 8 #reading string command for the input
    la $a0, SpaceInput #loads max amount of characters for the input
    li $a1, 1002 #max amount of characters
    syscall #calls input

    la $t7, SpaceInput #loads input into $t7

remove_newline:
    lb $t0, 0($t7) #loads first byte from input into $t0
    beqz $t0, end_remove #checks for the end of the string
    li $t8, 0x0A #loads newline character into $t8
    beq $t0, $t8, replace_null #returns NULL if byte is equal to newline character
    addi $t7, $t7, 1 #adds 1 to byte to keep program going
    j remove_newline #jumps to same function

replace_null:
    sb $zero, 0($t7) #replaces newline with NULL

end_remove:
    li $t2, 0 #sets $t2 to 0 for an offset value
    li $s0, 0 #sets $s0 to 0 to check if output has printed to put semicolon

get_substrings:
    beq $t2, 1000, exit #if 1000 characters read then exits

    la $t7, SpaceInput #loads input into $t7
    add $t7, $t7, $t2 #adds offset to input
    lb $t8, 0($t7) #loads first byte into $t8

    beqz $t8, exit #if first byte null, input is done

    la $a0, SpaceInput #loads input into $a0
    add $a0, $a0, $t2 #adds input to offset
    jal get_substring_value #jumps to get_substring_value function

    li $t4, 0x7FFFFFFF #loads 7FFFFFFF into $t4
    beq $v0, $t4, print_null #checks if input is equal to 7FFFFFFF
    