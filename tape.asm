; Tape reader program sample assembly code.
; Input switch on EF4
; Tape sensor on EF1
    CPU 1802
    ORG 00H
    GHI 0H
    PHI 0fH
    LDI 10
    PLO 0FH
    BN4 PGM
TAPEWAIT  BN3 TAPEWAIT
    SEX 0FH
    INP 3
    OUT 4
    SEQ
    REQ
    BR TAPEWAIT
PGM BYTE 0

  END
