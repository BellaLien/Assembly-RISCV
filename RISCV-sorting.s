	.option nopic
	.text
	.align	3
.LC0:
	.string "%lli\n"
	.text
	.align 1
	.globl	main
	.type	main, @function
.LC1:
	.string "%lli"
	.align 3
.LC2:
	.string "%lli "
	.align 3
.LC3:
	.string "\n"
	.align 3
main:
	addi x2,x2,-32
	sd	x1,24(x2)
	sd	x8,16(x2)
	addi x8,x2,32
		
	#begin
    add x11, x8, zero
    lui x15,%hi(.LC1)
    addi x10,x15,%lo(.LC1)
    call scanf

    lw x29, 0(x8)
	jal x1, floor_func
	
	add x11, x26, 0
    lui x15,%hi(.LC0)    
    addi x10,x15,%lo(.LC0)
    call printf
	
	beq x0, x0, end
	
floor_func: 

	addi x2,x2,-16
	sd	x1,8(x2)
	sd	x29,0(x2)
	
	#unsigned long floor(unsigned long x){
    #	
    #	if (x > 20)			  //rec_func5
    #   	return 2*x + floor(x/5);
    #
    #	else if (x > 10)	  //rec_func4
    #    	return floor(x-2) + floor(x-3);
    #
    #	else if (x > 1)		  //rec_func3
    #    	return floor(x-1) + floor(x-2);
    #
    #	else if (x == 1)	  //rec_func2
    #     	return 5;
    #
    #	else if (x == 0)      //rec_fu nc1
    #    	return 1;
    #
    #	return -1;
	#}
	
	li x31, 1
	li x30, 2
	li x28, 5
	li x19, 11
	li x20, 21

	bge x29, x20, rec_func5 # if x > 20, then go to rec_func5
	bge x29, x19, rec_func4 # if x > 10, then go to rec_func4
	bge x29, x30, rec_func3 # if x > 1, then go to rec_func3
	beq x29, x31, rec_func2 # if x == 1, then go to rec_func2
	beq x29, x0, rec_func1	# if x == 0, then go to rec_func1

rec_func1:
    #addi x29, x0, 1                 # if i == 0, then return 1
	addi x26, x26, 1
    addi x2, x2, 16                 # reset stack point
    jalr x0, 0(x1)

rec_func2:
    #addi x29, x0, 5                 # if i == 1, then return 5
    addi x26, x26, 5
	addi x2, x2, 16                 # reset stack point
    jalr x0, 0(x1)

rec_func3:
	addi x29, x29, -1               # compute x-1 (floor(x-1))
    jal x1, floor_func              # call recursive func for i-2
	#addi x12, x29, 0				
	
	ld x29, 0(x2)                   # restore caller's x
    ld x1, 8(x2)                    # restore caller's return address
	
	addi x29, x29, -2               # compute x-2 (floor(x-2))
    jal x1, floor_func              # call recursive func for i-2
	#addi x13, x29, 0				
	
	ld x29, 0(x2)                   # restore caller's x
    ld x1, 8(x2)                    # restore caller's return address
	
    addi x2, x2, 16                 # reset stack point
	
    #add x29, x12, x13               # floor(x-1) + floor(x-2)
    jalr x0, 0(x1)                  # return

rec_func4:
	addi x29, x29, -2               # compute x-2 (floor(x-2))
    jal x1, floor_func              # call recursive func for i-2	
	#addi x12, x29, 0				
	
	ld x29, 0(x2)                   # restore caller's x
    ld x1, 8(x2)                    # restore caller's return address
	
	addi x29, x29, -3               # compute x-3 (floor(x-3))
    jal x1, floor_func              # call recursive func for i-3
	#addi x13, x29, 0				
	
	ld x29, 0(x2)                   # restore caller's x
    ld x1, 8(x2)                    # restore caller's return address
	
    addi x2, x2, 16                 # reset stack point
	
    #add x29, x12, x13              # floor(x-2) + floor(x-3)
    jalr x0, 0(x1)                  # return

rec_func5:
	
	div x29, x29, x28               # compute x/5 (floor(x/5))
    jal x1, floor_func              # call recursive func for x/5
	addi x12, x26, 0				
	
	ld x29, 0(x2)                   # restore caller's x
    ld x1, 8(x2)                    # restore caller's return address
	
	mul x13, x29, x30
	
    addi x2, x2, 16                 # reset stack point
	
    add x26, x12, x13               # 2*x + floor(x/5)
    jalr x0, 0(x1)                  # return
	
	
end:
	#end
	
	li	x15,0
	mv	x10,x15
	ld	x1,24(x2)
	ld	x8,16(x2)
	addi x2,x2,32
	jr	x1
	.size	main, .-main
	.ident	"GCC: (GNU) 7.2.0"
