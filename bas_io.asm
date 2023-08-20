		CPU 1802

;
; Register Definitions:
;
R0		EQU	0
R1		EQU	1
R2		EQU	2
R3		EQU	3
R4		EQU	4
R5		EQU	5
R6		EQU	6
R7		EQU	7
R8		EQU	8
R9		EQU	9
R10		EQU	10
R11		EQU	11
R12		EQU	12
R13		EQU	13
R14		EQU	14
R15		EQU	15

		ORG 200H
		; Setup for SCRT routines.
		; Set R3 as program counter
		LDI HIGH ENTRY
		PHI R3
		LDI LOW ENTRY
		PLO R3
		SEP R3
		; Main program entry.
ENTRY	
		; Setup stack pointer (r2)
		; 7FBF
		LDI 07FH
		PHI R2
		LDI 0BFH
		PLO R2
		SEX R2
		; Setup 4 to CALL routine 8ADB
	    LDI	HIGH CALL
	    PHI	R4
	    LDI	LOW CALL
	    PLO	R4
		; Setup R5 to RETURN (8AED)
	    LDI	HIGH RETURN
	    PHI	R5
	    LDI	LOW RETURN
	    PLO	R5
		
		; R7 points to string.
		LDI HIGH STR
		PHI R7
		LDI LOW STR
		PLO R7
		; Call SCRT dispatcher (R3 points to 8526H)
		; How to understand this weirdness.
		; R4 points to a Dispatch routine.
		; R3 is the program counter. R3 will be incremented to the address
		; of the data after the SEP R4 instruction and contains the address
		; of the actual routine.
		; ergo it will indirectly jump to 8526H
		SEP R4
		WORD 8526H



		SEP 1 ; exit to mon.
	
STR		TEXT "Hello, I'm a TIL."
		BYTE 0dh
		BYTE 0


;; routine locations
CALL	EQU 8ADBH

RETURN	EQU 8AEDH

		END
	
;To call the "OUTSTR" routine your source code should be
;SEP	R4
;DW	8526H
;NOTE: R7 points to the string to output and the string must be terminated by
;a 00H byte