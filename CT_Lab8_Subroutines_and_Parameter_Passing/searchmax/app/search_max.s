;* ------------------------------------------------------------------
;* --  _____       ______  _____                                    -
;* -- |_   _|     |  ____|/ ____|                                   -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
;* --   | | | '_ \|  __|  \___ \   Zurich University of             -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                 -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
;* ------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 10
;* -- Description : Search Max
;* -- 
;* -- $Id: search_max.s 879 2014-10-24 09:00:00Z muln $
;* ------------------------------------------------------------------


; -------------------------------------------------------------------
; -- Constants
; -------------------------------------------------------------------
                AREA myCode, CODE, READONLY
                THUMB
                    
; STUDENTS: To be programmed




; END: To be programmed
; -------------------------------------------------------------------                    
; Searchmax
; - tableaddress in R0
; - table length in R1
; - result returned in R0
; -------------------------------------------------------------------   
search_max      PROC
                EXPORT search_max

                ; STUDENTS: To be programmed
                ;Compare if Table is empty
				PUSH{R4, R5, R6, R7, LR}
                MOVS R2, #0
                CMP R2, R1
                BEQ no_table
				
;R2 counter value, R3 Adress of Table, R4 table val, R0 biggest val
                MOVS R3, R0
                LDR R0, [R3]
                BL search_maxi	
				
				POP{R4, R5, R6, R7, PC}
				
no_table		LDR R0, =0x80000000
				POP{R4, R5, R6, R7, PC}

search_maxi     PUSH{LR}
				LDR R5, =0x00
				B loop
				
loop            CMP R1, R2
                BHI comapre_table
                POP{PC}
; Compare counter, if lower, search next table adress else go to end

comapre_table  	LDR R4, [R3, R5]
				ADDS R5, #4 ; Increase offset
                ADDS R2, #1 ;Increase counter
                CMP R4, R0
                BGT is_bigger
				B loop

is_bigger       MOVS R0, R4  
                B loop


                ; END: To be programmed
                ALIGN
                ENDP
; -------------------------------------------------------------------
; -- End of file
; -------------------------------------------------------------------                      
                END

