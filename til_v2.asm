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

I	EQU	$08
WA	EQU	$09
CA	EQU	$0A
RS	EQU	$0C
SP	EQU	$0D
PC	EQU	$0F
NXT	EQU	$06	; Location of NEXT routine.

; Set at 0x8000 - RAM starts here on MC with ROM at 0x0000
	ORG	$8000	

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

;NEXT	@I -> WA
; M(I) -> WA.H, I++, M(I) -> WA.L, I++
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
;	WA = WA + 2
;	CA -> PC
	GHI CA
	PHI PC
	GLO CA
	PLO PC
; setting the program counter should cause a jump - returning should probably be RS?
	SEP PC
;COLON	PSH I -> RS
	DEC RS
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



	END
		
		
		
		