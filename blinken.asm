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

	ORG 0200h

BEGIN	SEQ		; announce running
INKEY	BN4 INKEY
	REQ		; ack "IN" pushed.
	
START 	LOAD R5, ARRAY	; pseudo code, gets low of AR, puts in LO of R5, get high of AR, put in HI of R5
        ;LDI 08         ; don't count bytes anymore. count to output
        ;PLO R4
        LOAD R7, TOGGLES   ; point R7 to switch input byte.
        SEX R7		; Read toggles into M(R7) 
        INP 4
SETOUT  SEX R5		; X register points to data
	LDX		; D register has array element
	BZ START	; If AR(R5) == 0, restart sequence.
        OUT 4		; output M(X) -> LEDS, R5++
        SEX R7		; get delay each time from toggle switches.
        LDX        
        PHI R3       	; R3.H = toggles R3.L = 0
WAIT    DEC R3		; R3--
        GHI R3 		; check if zero
        BNZ WAIT	; go around again 
        INP 4          	; read toggles each time. will become new delay next time around.
        BZ  DONE        ; if toggles all off, exit program
	; check last loaded value.
        ; DEC R4         ; count--
        ; GLO R4
	; BNZ SETOUT
	BR SETOUT       ; loop around to next array byte for output. 
    
DONE    SEP R1         ; R1 points to the monitor re-entry point.

TOGGLES BYTE 00

ARRAY	BYTE 01, 02, 04, 08, 10h, 20h, 40h, 80h, 00h


    END

