# the data segment must have the following format exclusively
# no additions or changes to the data segment are permitted
.data
	STR0: .string "aid"
	STR1: .string "act" 
	STR2: .string "acid"
	STR3: .string "accept" 
	STR4: .string "zygote" 
	STR5: .string "abbreviate"
	STR6: .string "grandchildren" 
	STR7: .string "acidic"
	STR8: .string "grandchild" 
	STR9: .string "Achilles" 
     
	arr: .word 10

# The .text region must be structured with an init label at the top,
# followed by a main label, and then followed by any named procedures 
# or other labels you create for branching and jumping
# At the very bottom of the program include an exit label
 

.text
init:
# TODO: initialize arr here
la s1, arr
la t0, STR0 #loading the address of string 0
sw t0, 0(s1) #storing t0 into arr

la t0, STR1 #loading address of string1
sw t0, 4(s1) #storing it in the next spot in the array

la t0, STR2
sw t0, 8(s1)

la t0, STR3
sw t0, 12(s1)

la t0, STR4
sw t0, 16(s1)

la t0, STR5
sw t0, 20(s1)

la t0, STR6
sw t0, 24(s1)

la t0, STR7
sw t0, 28(s1)

la t0, STR8
sw t0, 32(s1)

la t0, STR9
sw t0, 36(s1)

#where do i use t0
#is 4 the right thing to use? how do i move thru bytes?

main:
# TODO: implement the sorting pro
	la a0, arr 	#load address starting at arr[0]
	li t1, 9	#n, implement a counter to know where the items are in respect to each other
	li t2, 0	#number of elements done , i
	la s5, arr	#pointer for array that moves
	li s6, 0	#inner counter for values, j
	
outer_loop:
	mv s5, a0		#go back to the beginning word/address of the array since it bubbles to the end
	
	
inner_loop: #does the incrementing through the string 
	bge s6, t1, outer_loop_close 	#j, inner loop counter, equals number of unsorted items

	lw a1, 0(s5) 	# current in a1
	lb s3, 0(a1) 	#load first digit of array
	
    	lw a2, 4(s5)	# current in a1
    	lb s4, 0(a2)	#load first digit of array
   
	li t4, 97	#if either are less than 97, theure uppercase
	blt s3, t4, upper_case1
	blt s4, t4, upper_case2

	beq s3, s4, equal 		#have to do additional comparisons
	blt s3, s4, inner_loop_close 	#move on to next word
	bgt s3, s4, swap		#if greater than, we can swap
	
upper_case1:
	addi s3, s3, 32
	blt s4, t4, upper_case2		#need to check if the other bit is also upper case
	beq s3, s4, equal 		#have to do additional comparisons
	blt s3, s4, inner_loop_close 	#move on to next word
	bgt s3, s4, swap		#if greater than, we can swap
upper_case2:
	addi s4, s4, 32
	beq s3, s4, equal 		#have to do additional comparisons
	blt s3, s4, inner_loop_close 	#move on to next word
	bgt s3, s4, swap		#if greater than, we can swap
inner_loop_close:
	#after loop
	addi s6, s6, 1		#add 1 to j
	addi s5, s5, 4		#move arr pointer dowm
	mv s10, s5		#so this pointer for equals loop is always the same as s5
	mv t6, t1		#testing j-1
	addi t6, t6, -1		#t6 is temp j-1
	j inner_loop	#goes to next word
	
outer_loop_close:
	#closing the loop
	li s6, 0		#set j back to 0
	addi t2, t2, 1 		#gone through this many items, i = i+1
	addi t1, t1, -1 	#decrement the counter by 1 when loop is done, n - i
	mv t6, t1
	addi t6, t6, -1		#t6 is temp j-1
	bne t6, zero, outer_loop
	beqz t6, exit 	#if number of elements done is equal to the number of items

equal: #initializes equal loop 
	li t5, 0 #counter of loop running through equals

	li a4, 0 # char num2ber (byte) (starts at 0)
	mv a3, a1 #address of first string into a3
	mv a6, a2 #address of second string into a6
equal_loop:
	li a4, 1
	add a3, a3, a4 		#increase by bit diwn the string
	lb s3, 0(a3) 		#load the byte of string 1 into s3
	
	add a6, a6, a4 		#increase by bit diwn the string
	lb s4, 0(a6) 		#load the byte of string 2 into s4
	beq s3, s4, equal_loop	#if they're equal cycle thru the entire string
	bgt s3, s4, swap	#if they start w different letters, automatically swap words
	blt s3, s4, inner_loop_close	#if the end of the string and there's more to str2 than str1, no need to swap
swap:
	lw t5, 0(s5)		#load the word in current s5 position
	lw t6, 4(s5)		#load the word with offset of one word into the t6 position
	sw  t6, 0(s5) 		#list[i+1]=list[i]
	sw  t5, 4(s5) 		#list[i]=list[i+1]
    	
	jal ra, inner_loop_close	#after swap, go back to next word in inner loop
exit:
	li a7, 10
	li a0, 0
	ecall
