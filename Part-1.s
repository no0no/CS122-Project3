@ Project 3: Part-1.s
@ Group 4
@ 10/30/16
@ Encrypts a message from an input file, outputs
@ encryption to an output file

Main:
	BL	OpenInput

OpenInput:
	ldr	r0,=InFileName
	mov	r1,#0
	swi	SWI_Open
	bcs	NoInFileFound
	ldr	r1,=InFileHandle			@ Memory [r1] is for input file handle
	str	r0,[r1]
	bx	lr					@ Branches back to where it was called (i.e Main)

Encrypt:
	

@ ==== Input File Error ==== @	
NoInFileFound:
	mov	r0,#StdOut
	ldr	r1,=NoInFileErr
	swi	SWI_PrStr
	B	Exit

@ ==== Closes input and output file ==== @
CloseFiles:
	ldr	r0,[r1]
	swi	SWI_Close

Exit:
	SWI	SWI_Exit

@ ==== File Components ==== @
InFileName:	.asciz "input.txt"
InFileHandle:	.word 0

@ ==== Strings ==== @
NoInFileErr:	.asciz "Fatal Error: Unable to find input.txt\r\n"

@ ==== SWI Statements ==== @
	.equ	StdOut,		1
	.equ	SWI_RdStr,	0x6a
	.equ	SWI_PrStr,	0x69
	.equ	SWI_Open,	0x66
	.equ	SWI_Close,	0x68
	.equ	SWI_Exit,	0x11
