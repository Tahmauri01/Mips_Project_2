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

    beqz $s0, no_semicolon #if the first output, doesn't print a semicolon
    li $v0, 4 #function for printing a string
    la $a0, semicolon #if not first output, prints a semicolon
    syscall #calls command

no_semicolon:
    li $s0, 1 #count the output printed

    move $t9, $v0 #keeps $v0 result
    li $v0, 1 #command for printing an integer
    move $a0, $t9 #moves value of $t9 into $a0
    syscall #calls command

    addi $t2, $t2, 10 #moves 10 characters, to the next character
    j get_substrings #jumps to get_substrings function

print_null:
    beqz $s0, no_null_semicolon #Checks if the first output
    li $v0, 4 #command for printing
    la $a0, semicolon #loads semicolon for printing
    syscall #calls print command

no_null_semicolon:
    li $s0, 1 #count the output printed
    li $v0, 4 #command for printing
    la $a0, null_msg #prints NULL
    syscall #calls print command

    addi $t2, $t2, 10 #goes to next 10 characters
    j get_substrings #jumps to get_substrings command

exit:
    li $v0, 10 #command for exit
    syscall

get_substring_value:
    li $t5, 0 #character index
    li $s1, 0 #first half, G
    li $s2, 0 #second half, H
    li $s3, 0 #counts valid digits

get_character:
    bge $t5, 10, solve #done when 10 characters are read
    lb $t6, 0($a0) #loads the current byte of input
    beqz $t6, pad_space #if null, change for space

check_digit:
    li $t7, 0x30 #ascii for '0'
    li $t8, 0x39 #ascii for '9'
    blt $t6, $t7, check_if_lowercase #if digit out of range check if lowercase
    bgt $t6, $t8, check_if_lowercase #if digit out of range check if lowercase
    sub $t9, $t6, $t7 #converts the ascii to an integer
    j valid_digit #jumps to valid_digit function

check_if_lowercase:
    li $t7, 0x61 #ascii for 'a'

    blt $t6, $t7, check_if_uppercase #if digit out of range check if uppercase
    addi $t8, $t7, 20 # 'a' + 20
    bge $t6, $t8, check_if_uppercase #if digit out of range check if uppercase
    sub $t9, $t6, $t7 #char - 'a'
    addi $t9, $t9, 10 #10 + (char - 'a')

    j valid_digit #jumps to valid digit function

check_if_uppercase:
    li $t7, 0x41 #ascii for 'A'
    blt $t6, $t7, invalid #if digit out of range, it is invalid
    addi $t8, $t7, 20 #'A' + 20
    bge $t6, $t8, invalid #if digit out of range, it is invalid
    sub $t9, $t6, $t7 #char - 'A'
    addi $t9, $t9, 10 # 10 + (char - 'A')

valid_digit:
    addi $s3, $s3, 1 #count of valid digits
    li $t7, 5 #loads 5 into $t7
    blt $t5, $t7, add_first #add to G if the first five digits
    add $s2, $s2, $t9 #adds to H if not in first 5
    j move_index #jumps to move_index function

add_first:
    add $s1, $s1, $t9 #adds digits to G
    j move_index #jumps to move index function

invalid:
    j move_index #jumps to move_index function

pad_space:
    li $t6, 0x20 #changes NULL with a space
    j check_digit #jumps to check_digit function

move_index:
    addi $t5, $t5, 1 #moves index by 1
    addi $a0, $a0, 1 #moves to the next character
    j get_character #jumps to get_character function

solve:
    beqz $s3, save_null #return NULL if no valid digits
    sub $v0, $s1, $s2 #print G - H
    jr $ra #jumps

save_null:
    li $v0, 0x7FFFFFFF #indicates NULL
    jr $ra
