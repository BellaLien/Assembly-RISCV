	.option nopic
	.text
	.align	3
# ========================= #	
.LC0:
	.string "%llu\n"
	.text
	.align 1
	.globl	main
	.type	main, @function
.LC1:
	.string "%llu"
	.align 3
.LC2:
	.string "%llu "
	.align 3
.LC3:
	.string "\n%llu\n"
	.align 3

# ========================= #

main:
	addi x2,x2,-32
	sd	x1,24(x2)
	sd	x8,16(x2)
	addi x8,x2,32

	# begin

	# ===== 輸入範例 ===== #

	addi x7, x0, 0 # i = 0
	addi x9, x0, 11 # size of lottery[11]

	############################################
	# for (long long int i = 0; i < 11; i++){  #
    #        cin >> num;			 		   #
    #        lottery[i] = num;		 		   #
    # }										   #
    ############################################

    add x11, x8, zero	# x8 為存入輸值的暫存器 切記只能用 x8

	loop1: # store value into lottery[11]

    	lui  x15,%hi(.LC1)
    	addi x10,x15,%lo(.LC1)
    	slli x6, x7, 3 # x6 = x7*8 
    	addi x7, x7, 1 # i = i + 1
    	add  x11, x8, x6 # x11 = x8[i+1]
    	
    	call scanf
    	
		bltu x7, x9, loop1 # i < 11 goto loop1


	#########################################################################################
	#	void swap(long long int lottery[], long long int n){								#
	#		long long int tmp;																#
	#		tmp = lottery[n];																#
	#		lottery[n] = lottery[n+1];														#
	#		lottery[n+1] = tmp;																#
	#	}																					#
	#																						#
	#	for (long long int i = 1 ; i < 12; i++){											#
	#		for (long long int j = i - 1; j >= 1 && lottery[j] > lottery[j+1]; j--){		#
	#			swap(lottery, j);															#
	#		}																				#
	#	}																					#
    #########################################################################################

	li x1, 0
	li x23, 1
	li x22, 0
	li x21, 0
	li x20, 0
	li x19, 0

	sort:	
    	addi x2, x2, -40	    
    	sd   x1, 32(x2)
		sd   x22, 24(x2)
		sd   x21, 16(x2)
		sd   x20, 8(x2)	# x20 = j
		sd   x19, 0(x2)	# x19 = i

		li x18, 11
		
	mv x21, x8 
	mv x22, x18
		
	li	x19, 0	# i = 0
		
	outer:
		bge	 x19, x22, exitouter # if i >= n goto exitouter
		
	addi x20, x19, -1 	# j = i - 1

	inner:
		blt  x20, x23, exitinner # if j < 0 goto exitinner
		slli x5, x20, 3 # x5 = j*8
		add  x5, x21, x5 # x5 = lottery + j*8
		ld   x6, 0(x5) # x6 = lottery[j]
		ld   x7, 8(x5) # x7 = lottery[j+1]
		bltu  x6, x7, exitinner # if lottery[j] < lottery[j] goto exitinner
		
	mv   x8,  x21
	mv   x18, x20
	jal  x1,  swap
	
	addi x20, x20, -1
	j    inner

	exitinner:
		addi x19, x19, 1 # i = i + 1
		j	 outer
		
	swap:
		slli x6, x18, 3
		add  x6, x8, x6
		ld   x5, 0(x6)
		ld   x7, 8(x6)
		sd   x7, 0(x6)
		sd   x5, 8(x6)
		jalr x0, 0(x1)

	exitouter:
		ld   x19, 0(x2)
		ld   x20, 8(x2)
		ld   x21, 16(x2)
		ld   x22, 24(x2)
		ld   x1, 32(x2)
		addi x2, x2, 40	

	#####################################################
	# long long int position = 0;					  	#
    #    for (long long int i = 1; i < 11; i++){	  	#
    #        if (lottery[i] == lottery[0])				#
    #            position = i;			  				#
    #        printf("%llu ", lottery[i]); 				#
    #    }								  				#
    #####################################################

    ld x29, 0(x8) # x30 = x8[0] (position)
    li x18, 0
    addi x7, x0, 1 # i = 1
    addi x9, x0, 11 # x9 = 11
    
	loop3: # output

		slli x6, x7, 3 # x6 = x7*8
		add  x11, x8, x6 # lottery[i+1]

	   	ld x30, 0(x11) 		
	   	
		add  x11, x30, zero
	  	lui  x15,%hi(.LC2)    
		addi x10,x15,%lo(.LC2)
		call printf

		beq  x29, x30, Position  # if x8[0] == x8[i] goto Position
		addi x7, x7, 1 # x7 = x7 + 1
		bltu x7, x9, loop3 # i < 12 goto loop1
		j EXIT
		
    Position: 
    	add x18, x7, zero # x18 = x7 (position count)
    	addi x7, x7, 1 # x7 = x7 + 1 
		bltu x7, x9, loop3 # i < 11 goto loop1

    #################################
    # printf("\n%llu\n", position); #
    #################################

	EXIT:	
    	add  x11, x18, zero   # x11 = x18 (position) 
   		lui  x15,%hi(.LC3)    
    	addi x10,x15,%lo(.LC3)
    
    	call printf

	# end

	li	x15,0
	mv	x10,x15
	ld	x1,24(x2)
	ld	x8,16(x2)
	addi x2,x2,32
	jr	x1

	.size	main, .-main
	.ident	"GCC: (GNU) 7.2.0"

