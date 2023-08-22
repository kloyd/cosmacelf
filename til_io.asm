	CPU 1802

;
; Register Definitions:
;
R0	EQU	0
R1	EQU	1
R2	EQU	2
R3	EQU	3
R4	EQU	4
R5	EQU	5
R6	EQU	6
R7	EQU	7
R8	EQU	8
R9	EQU	9
R10	EQU	10
R11	EQU	11
R12	EQU	12
R13	EQU	13
R14	EQU	14
R15	EQU	15

;; named registers
SP	EQU	2
PC	EQU	3
CALLR	EQU	4
RETR	EQU	5
TXTPTR	EQU	7
INBUF	EQU	8	; Input line buffer pointer register.
; TIL registers
I	EQU	10
WA	EQU	11
TPC	EQU	12


;; Stack for ram High - top of ram, minus monitor scratch pad area.
UserStack EQU 0FFBFH
;; SCRT routine locations Standard ROM org'd at 0
; 
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

	ORG 8000H
	; Setup for SCRT routines.
	; Set R3 as program counter
	LDI HIGH main
	PHI PC
	LDI LOW main
	PLO PC
	SEP PC
	; Main program entry.	
	; Setup stack pointer R2 @7FBFh
main	LDI HIGH UserStack
	PHI R2
	LDI LOW UserStack
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
	; Use SCRT 
	; R3 is the PC
	; R4 is the call register - points to the call routine in rom
	; R5 is the return register - points to return routine in rom
	; CALL pseudo-op of the A18 assembler
	; Set program counter to R4 and follow with word address of the routine to be called.
	LOAD TXTPTR, GREET
	CALL OUTSTR

INLINE	LOAD TXTPTR, PROMPT
	CALL OUTSTR
	
	; Read a char, echo a char
	; if ctrl-c stop
IOLOOP	CALL INCHR
	CALL OUTCHR
	GLO INDATA     ; io leaves in RB.0
	SDI 3 ; subtract ctrl-c
	BZ EXIT
	;; simplistic now, must add typed chars to a buffer.
	;;
	;;
	GLO INDATA
	SDI 13 ; CR?
	BNQ IOLOOP
	LOAD TXTPTR, OKMSG
	CALL OUTSTR
	BR INLINE
	
	; Exit to Membership Card monitor.
EXIT	SEP 1
	
	; Cold start
GREET	TEXT "Hello, I'm a TIL."
	BYTE 0

OKMSG	TEXT " OK"
	BYTE 0
	
PROMPT	BYTE 0DH, 0AH, 24H, 00


	END
	
