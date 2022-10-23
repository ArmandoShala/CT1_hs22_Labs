; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- sumdiff.s
; --
; -- CT1 P05 Summe und Differenz
; --
; -- $Id: sumdiff.s 705 2014-09-16 11:44:22Z muln $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_LED_7_0            EQU     0x60000100
ADDR_LED_15_8           EQU     0x60000101
ADDR_LED_23_16          EQU     0x60000102
ADDR_LED_31_24          EQU     0x60000103

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA MyCode, CODE, READONLY

main    PROC
        EXPORT main

user_prog
        ; STUDENTS: To be programmed
        LDR R0, =ADDR_DIP_SWITCH_15_8   ; load address of DIP switch 15-8 (Operand A)
        LDR R1, =ADDR_DIP_SWITCH_7_0    ; load address of DIP switch 7-0 (Operand B)
        LDR R6, =ADDR_LED_15_8          ; load address of LED 15-8 R6
        LDR R7, =ADDR_LED_31_24         ; load address of LED 31-24 R7
        
		LDRB R2, [R0]                   ; load value of DIP switch 15-8 (Operand A)
        LDRB R3, [R1]                   ; load value of DIP switch 7-0 (Operand B)
        LSLS R2, R2, #24                ; shift left operand A by 24 bits
        LSLS R3, R3, #24                ; shift left operand B by 24 bits

		ADDS R4, R2, R3                 ; add operand A and operand B
        MRS R0, APSR                    ; move APSR to R0
        LSRS R0, R0, #24                 ; shift left APSR by 4 bits
        STRB R0, [R6]                    ; store APSR in LED 15-8
        LDR R0, =ADDR_LED_7_0           ; load address of LED 7-0 (sum) in R6
		LSRS R4, R4, #24                ; shift right sum by 24 bits
        STRB R4, [R0]                   ; store sum in LED 7-0

        SUBS R5, R2, R3                 ; subtract operand B from operand A
        MRS R1, APSR                    ; move APSR to R1
        LSRS R1, R1, #24                 ; shift left APSR by 4 bits
        STRB R1, [R7]                    ; store APSR in LED 31-24
        LDR R1, =ADDR_LED_23_16         ; load address of LED 23-16 (difference) in R7
        LSRS R5, R5, #24                ; shift right difference by 24 bits
        STRB R5, [R1]                   ; store difference in LED 23-16





        ; END: To be programmed
        B       user_prog
        ALIGN
; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
