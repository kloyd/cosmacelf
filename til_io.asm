;******************************************************************
;	Threaded Interpretive Language (TIL) for COSMAC 1802 CPU.
;	Core of Threaded Interpretive Language I/O
;
;	From the book "Threaded Interpretive Languages: Their Design and Implementation"
;
;******************************************************************


; Register definitions (1802 has R0-RF 16 x 16 bit registers)
SP	EQU	2	; stack pointer
PC	EQU	3	; program counter
CALLR	EQU	4	; call register
RETR	EQU	5	; return register
TXTPTR	EQU	7	; text pointer
INBUF	EQU	8	; Input line buffer pointer register.
; TIL registers
I	EQU	10
WA	EQU	11
TPC	EQU	12


;; Stack for ram High - top of ram, minus monitor scratch pad area.
USTACK	EQU 0FFBFH
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

; Start at 8000h for ROM @ 0000h
	ORG 8000H
; Setup for SCRT routines.
; Set R3 as program counter
	LOAD PC, main
	SEP PC
; Main program entry.	
; Setup stack pointer
main	LOAD SP, USTACK
	SEX SP
; Setup 4 to CALL routine 8ADB
	LOAD CALLR, CALL
; Setup R5 to RETURN (8AED)
	LOAD RETR, RETURN
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
	GLO INDATA     ; io leaves in RB.0
	SDI 3 ; subtract ctrl-c
	BZ EXIT
	;; simplistic now, must add typed chars to a buffer.
	;;
	;; CHECK FOR <CR>
	GLO INDATA
	SDI 13 ; CR?
	BZ EXECBUF  ; YES - GOTO EXECUTE BUFFER
	CALL OUTCHR ; ECHO CHARACTER
	BR IOLOOP
	
EXECBUF	LOAD TXTPTR, OKMSG
	CALL OUTSTR
	BR INLINE
	
	; Exit to Membership Card monitor.
EXIT	SEP 1
	
	; Cold start
GREET	TEXT "Hello, I'm a TIL."
	BYTE 0

OKMSG	TEXT " OK"
	BYTE  0
	
PROMPT	BYTE 0DH, 0AH, 24H, 00


	END
	
