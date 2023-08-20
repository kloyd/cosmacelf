; TIL for 1802
;
;
; Register aliases
; ***
R0 EQU  0
R1 EQU  1
R2 EQU  2
R3 EQU  3
R4 EQU  4
R5 EQU  5
R6 EQU  6
R7 EQU  7
R8 EQU  8
R9 EQU  9
RA EQU  10
RB EQU  11
RC EQU  12
RD EQU  13
RE EQU  14
RF EQU  15
; ***
; Register mapping
; TIL <=> 1802
; D (AF) 8 bit accumulator and program status word
; R5 (BC)  I  = Instruction Register
; R6 (DE)  WA = Word Address Register and Scratch Pad
; R7 (HL) Scratch Register - 16 Bit accumulator
; R8 (IX) RS Return Stack Pointer
; R9 (IY) NEXT Address of NEXT
; RA (SP)  SP Data Stack Pointer
;
I   EQU 5
WA  EQU 6
SR  EQU 7
IX  EQU 8
IY  EQU 9
SP  EQU 10
;
; Inner Interpreter
; Assume IX is R8... SEtX to R8
; COLON PSH I -> RS
;       WA -> I
;       JMP NEXT

      ORG 0100h
      SEX IX
SEMI  WORD SSTR   ; SEMI
SSTR  LDX         ; POP RS -> I
      PHI I
      LDX
      PLO I
NEXT  LDN I       ; NEXT
      PLO SR      ; @I -> WA
      INC I
      LDN I
      PHI SR
      INC I      ; I = I + 2
RUN   LDN R7            ; RUN
      PLO R6            ; @WA -> CA
                  ; WA = WA + 2
                  ; CA -> PC



    END
