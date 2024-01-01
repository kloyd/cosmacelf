; Test 1802 OUT instruction
		ORG 8000h
		
START		OUT 4
DATA1		BYTE 00
INPTEST		BN4 START
		
		OUT 4
DATA2		BYTE 011h
		BR INPTEST
		
		END
		
		
		
;CLR  WAIT
; 0     0   >> LOAD mode
; 0     1   >> Ready to run (PC = 0)
; 1     1   >> RUN mode
; 1     0   >> Suspend clock 
 
;Correct transition to RESET mode from RUN mode
;Put CLR down (0). RESET the cpu
;Put WAIT down (0). LOAD mode

;LOAD mode, R/W switch in READ position, you can punch IN and see every byte one at a time
;LOAD mode, R/W switch in WRITE position, toggle switches will be stored in RAM(PC), PC++ on each press of IN

