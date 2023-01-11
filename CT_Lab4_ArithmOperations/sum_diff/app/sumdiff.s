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

        ;---------- Read DIP switches
        ; OPERAND A
        LDR R0, =ADDR_DIP_SWITCH_15_8    ; Get Address of DIP switches
        LDRB R0, [R0]                    ; Get value of DIP switches
        ; OPERAND B
        LDR R1, =ADDR_DIP_SWITCH_7_0     ; Get Address of DIP switches
        LDRB R1, [R1]                    ; Get value of DIP switches

        ;---------- Expand to 32 bit
        LSLS R0, R0, #24                 ; shift to the left by 24 bits (three bytes)
        LSLS R1, R1, #24                 ; shift to the left by 24 bits (three bytes)

        ;---------- Add these two values and store their flags in R4 to display them on LED15-12
        ADDS R3, R0, R1                  ; add the two values and store the result in R3
        MRS R4, APSR                     ; store the flags in R4
        LSRS R4, R4, #24                 ; shift the flags to the right by 24 bits (three bytes) in order to display them on LED15-12
        LSRS R3, R3, #24                 ; shift the result to the right by 24 bits (three bytes) in order to display it on LED7-0
        LDR R2, =ADDR_LED_7_0            ; get the address of LED7-0
        STRB R3, [R2]                    ; store the result of the calc in LED7-0
        LDR R2, =ADDR_LED_15_8           ; get the address of LED15-8
        STRB R4, [R2]                    ; store the flags in of the calc in LED15-8


        ;---------- Subtract these two values and store their flags in R6 to display them on LED31-28
        SUBS R6, R0, R1                 ; subtract the two values and store the result in R6
        MRS R7, APSR                    ; store the flags in R7
        LSRS R7, R7, #24                ; shift the flags to the right by 24 bits (three bytes) in order to display them on LED31-28
        LSRS R6, R6, #24                ; shift the result to the right by 24 bits (three bytes) in order to display it on LED23-16
        LDR R1, =ADDR_LED_31_24
        STRB R7, [R1]
        LDR R1, =ADDR_LED_23_16
        STRB R6, [R1]


        ; END: To be programmed
        B       user_prog
        ALIGN
; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
