; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- table.s
; --
; -- CT1 P04 Ein- und Ausgabe von Tabellenwerten
; --
; -- $Id: table.s 800 2014-10-06 13:19:25Z ruan $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB
; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0         EQU     0x60000200
ADDR_DIP_SWITCH_15_8        EQU     0x60000201
ADDR_DIP_SWITCH_31_24       EQU     0x60000203
ADDR_LED_7_0                EQU     0x60000100
ADDR_LED_15_8               EQU     0x60000101
ADDR_LED_23_16              EQU     0x60000102
ADDR_LED_31_24              EQU     0x60000103
ADDR_BUTTONS                EQU     0x60000210
ADDR_SEG7_BIN               EQU     0x60000114

BITMASK_KEY_T0              EQU     0x01
BITMASK_LOWER_NIBBLE        EQU     0x0F

; ------------------------------------------------------------------
; -- Variables
; ------------------------------------------------------------------
        AREA MyAsmVar, DATA, READWRITE
; STUDENTS: To be programmed

myArray    SPACE   16  ; reserve 8 byte (4 words)

; END: To be programmed
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

main    PROC
        EXPORT main

readInput
        BL    waitForKey                    ; wait for key to be pressed and released
; STUDENTS: To be programmed


        ;----------------------------------START READ INPUTS----------------------------------

        MOVS R7, #BITMASK_LOWER_NIBBLE
        LDR R4, =myArray                   ; load address of myArray into R4


        ; Load all DIP switches into the corresponding registers
        LDR R0, =ADDR_DIP_SWITCH_7_0        ; load address of DIP switch 7-0. This is the Input Value
        LDRB R0, [R0]

        LDR R1, =ADDR_DIP_SWITCH_15_8       ; load address of DIP switch 15-8. This is the Input Value
        LDRB R1, [R1]                        ; load value of DIP switch 15-8. This is the Input Value
        ANDS R1, R1, R7   ; mask the upper nibble of R2

        ; Load all LEDs into the corresponding registers
        LDR R2, =ADDR_LED_15_8              ; load address of LED 15-8. This is the Output Value
        LDR R3, =ADDR_LED_7_0               ; load address of LED 7-0. This is the Output Value

        ; Display the input value on the LEDs
        STRB R0, [R3]                       ; Write the value of R0 to the address of R3
        STRB R1, [R2]                       ; store value of DIP switch 15-8 to LED 15-8. This is the Output Value
        ;----------------------------------END READ INPUTS----------------------------------



        ;----------------------------------START WRITING TO ARRAY----------------------------------
        STRB R0, [R4, R1]                   ; store value of R0 into myArray at index R1
        ;----------------------------------END WRITING TO ARRAY----------------------------------



        ;----------------------------------START READING OUTPUT INDEX----------------------------------
        LDR R0, =ADDR_DIP_SWITCH_31_24      ; load address of DIP switch 31-24. This is the Output Index
        LDR R0, [R0]
        ANDS R0, R0, R7                     ; mask the upper nibble of R0
        ;----------------------------------END READING OUTPUT INDEX----------------------------------



        ;----------------------------------START READING FROM ARRAY----------------------------------
        LDRB R1, [R4, R0]                   ; get value of myArray at index R0 into R1
        ;----------------------------------END READING FROM ARRAY----------------------------------



        ;----------------------------------START OUTPUT VALUES TO OUTPUT DISPLAY (INDEX & VALUES)----------------------------------
        LDR R2, =ADDR_LED_23_16             ; load address of LED 23-16. This is the Output Value
        STRB R1, [R2]                        ; store value of R1 into LED 23-16. This is the Output Value

        LDR R3, =ADDR_LED_31_24             ; load address of LED 31-24. This is the Output Index
        STRB R0, [R3]
        ;----------------------------------END OUTPUT VALUES TO OUTPUT DISPLAY (INDEX & VALUES)----------------------------------



        ;----------------------------------START OUTPUT VALUES TO 7 SEGMENT DISPLAY HEX----------------------------------
        LDR r0, =ADDR_SEG7_BIN
        STRB r1, [r0, #0]                     ; Write byte of binary data to DS1..0.

        ;----------------------------------END OUTPUT VALUES TO 7 SEGMENT DISPLAY HEX----------------------------------



; END: To be programmed
        B       readInput
        ALIGN

; ------------------------------------------------------------------
; Subroutines
; ------------------------------------------------------------------

; wait for key to be pressed and released
waitForKey
        PUSH    {R0, R1, R2}
        LDR     R1, =ADDR_BUTTONS           ; laod base address of keys
        LDR     R2, =BITMASK_KEY_T0         ; load key mask T0

waitForPress
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is pressed
        BEQ     waitForPress

waitForRelease
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is released
        BNE     waitForRelease
                
        POP     {R0, R1, R2}
        BX      LR
        ALIGN

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
