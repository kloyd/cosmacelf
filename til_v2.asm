;******************************************
;
; TIL - Threaded Interpretive Language
;   1802 Implementation
;   2023 Kelly S. Loyd
;
;******************************************

; Register list
; I = Instruction Register - Address of next Instruction in threaded list of current secondary.
; WA = Word Address Register - Word address of current keyword.
; CA = Code Address register
; RS = Return Stack
; SP = Stack Pointer
; PC = Program Conter

; 1802 register map
; Monitor uses R1, R2, R3, R4, R5, R7, RE
SCRTPC	EQU	$03
CALLR	EQU	$04
RETR	EQU	$05
TXTOUT	EQU	$07
VAR	EQU	$07	; dual use, variable pointer or text message pointer.

; P-REGISTERS
I	EQU	$08
WA	EQU	$09
CA	EQU	$0A
RS	EQU	$0C
SP	EQU	$0D
PC	EQU	$0F
NXT	EQU	$06	; Location of NEXT routine.

; Set at 0x8000 - RAM starts here on MC with ROM at 0x0000
	ORG	$8000	

; variables
BASE	DB	0
MODE	DB	0
LBEND	DW	0

UserStack EQU 0FFBFH
;; SCRT routine locations Standard ROM org'd at 0
CALL	EQU 0ADBH
RETURN	EQU 0AEDH
; I/O ROUTINES
OUTSTR	EQU 0526H
;The Monitor "INPUT" routine is at 8005hex in the ORG'ed 8000hex Monitor
;The inputted character is returned in RB.0
INDATA	EQU 11
INCHR	EQU 0005H
;;The Monitor "OUTPUT" routine is at 821Dhex in the ORG'ed 8000hex Monitor
;;The character to be outputted is stored in RB.0
OUTCHR	EQU 021DH


; Setup for SCRT
	LOAD	SCRTPC, START
	SEP SCRTPC
	
; START/RESTART
START	LOAD CALLR, CALL
	LOAD RETR, RETURN
	
	LOAD TXTOUT, STRMSG
	LOAD VAR, BASE
	LDN VAR
	ANI	$FF
	BZ	ABORT
	LDI	10
	STR VAR
ABORT	; set stack

;
; TIL code for Inner Interpreter
; All the VM code (Pseudo-Code) is commented with ;
; the addresses are based on ORG $100
; Save the location of NEXT into NXT register
	LOAD NXT, NEXT
;
;SEMI	LA	;Link Address
SEMI	DW	$+2	; This funny notation means put the address of SEMI+2 into the code here.
			; It forms the Link Address used to connect dictonary entries.
;POP RS -> I
; POP : M(RS) copied to I register, RS=RS+2
; *IMPORTANT* Endian-ness.. Push to stack pushes low order, dec sp, pushes high order, dec sp
; Pop from stack pops high order, inc sp, pop low order, inc sp
	LDN RS  ; take byte at M(RS), copy to D (accumulator)
	PHI I   ; put D into I High 
	INC RS	; RS++
	LDN RS	; take byte at M(RS), copy to D
	PLO I	; put D into I Low.
	INC RS  ; RS++
	
; NEXT entry point - fetch the NEXT word address and execute it.
;NEXT	@I -> WA   ; M(I) -> WA.H, I++, M(I) -> WA.L, I++
NEXT	LDN I
	PHI WA
	INC I
	LDN I
	PLO WA
	INC I
;	I = I + 2 ;; implied during the fetch.
;RUN	@WA -> CA
RUN	LDN WA
	PHI CA
	INC WA
	LDN WA
	PLO CA
	INC WA
;	WA = WA + 2 (Implied with 2x INC WA above)
;	CA -> PC
	GHI CA
	PHI PC
	GLO CA
	PLO PC
	; setting the program counter will jump to the primitive.
	; When the routine completes, it should SEP NXT
	; Causing the called routine to return to the NEXT
	; Entry Point
	SEP PC
;COLON	PSH I -> RS
COLON	DEC RS
	GLO I
	STR RS
	DEC RS
	GHI I
	STR RS
;	WA -> I
	GLO WA
	PLO I
	GHI WA
	PHI I
;	JMP NEXT ; should be in a register for SEP instruction.
	BR NEXT

;	7E
;	XE
;	LA  ; Link Address to Next dictionary entry.
;	EXECUTE	LA
;	Dictionary Entry.
	DB 7,'E','X','E'
	DW 0
EXECUTE	DW $+2
;	POP SP -> WA
; Pop from stack pops high order, inc sp, pop low order, inc sp
	LDN SP  ; take byte at M(RS), copy to D (accumulator)
	PHI WA   ; put D into I High 
	INC SP	; RS++
	LDN SP	; take byte at M(RS), copy to D
	PLO WA	; put D into I Low.
	INC SP  ; RS++
;	JMP RUN
	BR RUN


	; Cold start
STRMSG	TEXT "Hello, I'm a TIL."
	BYTE 0

RSTMSG	TEXT "TIL Reset"
	BYTE 0
	
	END
		
		
		
		