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

I	EQU	08H
WA	EQU	09H
CA	EQU	0AH
RS	EQU	0CH
SP	EQU	0DH
PC	EQU	0FH

; Set at 0x8000 - RAM starts here on MC with ROM at 0x0000
	ORG	8000H	

;
; TIL code for Inner Interpreter

;0100	SEMI	0102
SEMI	DW	$+2
;0102		POP RS -> I
; POP : M(RS) copied to I register, RS=RS+2
; *IMPORTANT* Endian-ness.. Push to stack pushes low order, dec sp, pushes high order, dec sp
; Pop from stack pops high order, inc sp, pop low order, inc sp
		LDN RS
		PLO I
		INC RS
		LDN RS
		PHI I
		INC RS
;0104	NEXT	@I -> WA
;0106		I = I + 2
;0108	RUN	@WA -> CA
;010A		WA = WA + 2
;010C		CA -> PC

;0140	COLON	PSH I -> RS
;0142		WA -> I
;0144		JMP NEXT
;0146

;0050		7E
;0052		XE
;0054		LA  ; Link Address to Next dictionary entry.
;0056	EXECUTE	0058
;0058		POP SP -> WA
;005A		JMP
;005C		0108





		END
		
		
		
		