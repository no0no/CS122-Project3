@ Project 3: Part-1.s
@ Group 4: (Gage Aschenbrenner, Ian B., Filiberto Reyes, Wei Zhao, Nathan Kandouw)
@ 10/30/16
@ Encrypts a message from an input file, outputs
@ encryption to an output file

.text
.extern _start
.global EncryptMain

EncryptMain:
	bl	OpenInput

	bl	ReadString
	bl	Encrypt
	bl	OpenOutput
	bl	PrintPassword
	bl	OpenShift
	bl	PrintShift
	bl	CloseFiles

OpenInput:
	ldr	r0,=InFileName
	mov	r1,#0
	swi	SWI_Open
	bcs	NoInFileFound
	ldr	r2,=InFileHandle		@ Memory [r2] is for input file handle
	str	r0,[r2]

	bx	lr						@ Branches back to where it was called (i.e Main)

ReadString:
	ldr	r0,[r2]
	ldr	r1,=InputString
	mov	r2,#80
	swi	SWI_RdStr
	cmp	r0,#1					@ If readString loads <= 1 into r0 nothing was read from file
	ble	ReadStringError

	bx	lr
	
@ ==== Encrypts the byte with a shift value determined by user ==== @	
Encrypt:
	cmp	r3,#0
	streq	lr,[r6]

	ldrb	r4,[r1], #1
	cmp	r4,#0
	bxeq	lr
	add	r4,r4,r9
	cmp	r4,#126
	blgt	RollOver
	strb	r4,[r1, #-1]
	add	r3,r3,#1
	cmp	r4,#0
	bne	Encrypt
	
	ldr	lr,[r6]
	bx	lr
	
OpenOutput:
	ldr	r0,=OutFileName
	mov	r1,#1
	swi	SWI_Open
	ldr	r7,=OutFileHandle
	str	r0,[r7]					@ Memory [r1] for output file handle
	
	bx	lr
	
PrintPassword:
	ldr	r0,[r7]
	ldr	r1,=InputString
	swi	SWI_PrStr

	bx	lr

OpenShift:
	ldr r0,=ShiftFileName
	mov	r1,#1
	swi	SWI_Open
	ldr	r3,=ShiftFileHandle
	str	r0,[r3]
	
	bx	lr

PrintShift:
	ldr	r0,[r3]
	mov	r1,r9
	swi	SWI_PrInt
	
	bx	lr
	
@ ==== Checks if the the ASCII value is over 126, rolls it back around if it is ==== @
RollOver:
	sub	r4,r4,#126
	add	r4,r4,#32
	add	r3,r3,#1

	bx	lr

@ ==== Input File Error ==== @	
NoInFileFound:
	mov	r0,#StdOut
	ldr	r1,[r3]
	swi	SWI_PrStr
	b	Exit

ReadError:
	mov	r0,#StdOut
	ldr	r1,=ReadErr
	swi	SWI_PrStr
	b	CloseFiles

ReadStringError:
	mov	r0,#StdOut
	ldr	r1,=ReadStringErr
	swi	SWI_PrStr
	b	CloseFiles

@ ==== Closes input and output file ==== @
CloseFiles:
	ldr	r0,[r2]
	swi	SWI_Close
	ldr	r0,[r7]
	swi	SWI_Close
	ldr	r0,[r3]
	swi	SWI_Close
	b	Return

Return:
	bl	_start
Exit:
	SWI	SWI_Exit

@ ==== File Components ==== @
InFileName:	.asciz "input.txt"
InFileHandle:	.word 0
OutFileName:	.asciz "output.txt"
OutFileHandle:	.word 0
ShiftFileName:	.asciz "shift.txt"
ShiftFileHandle:	.word 0

@ ==== Strings ==== @
NoInFileErr:	.asciz "Fatal Error: Unable to find input.txt\r\n"
ReadErr:	.asciz "Fatal Error: Unable to read number from input.txt"
ReadStringErr:	.asciz "Fatal Error: Unable to read string from input.txt"

@ ==== Memory Addresses ==== @
LinkRegister:	.word 0
InputString:	.skip 80

@ ==== SWI Statements ==== @
.equ	StdOut,		1
.equ	SWI_RdInt,	0x6c
.equ	SWI_PrInt,	0x6b
.equ	SWI_RdStr,	0x6a
.equ	SWI_PrStr,	0x69
.equ	SWI_Open,	0x66
.equ	SWI_Close,	0x68
.equ	SWI_Exit,	0x11
