; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- add64.s
; --
; -- CT1 P05 64 Bit Addition
; --
; -- $Id: add64.s 3712 2016-10-20 08:44:57Z kesr $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_31_0        EQU     0x60000200
ADDR_BUTTONS                EQU     0x60000210
ADDR_LCD_RED                EQU     0x60000340
ADDR_LCD_GREEN              EQU     0x60000342
ADDR_LCD_BLUE               EQU     0x60000344
ADDR_LCD_BIN                EQU     0x60000330
MASK_KEY_T0                 EQU     0x00000001
BACKLIGHT_FULL              EQU     0xffff

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA MyCode, CODE, READONLY

main    PROC
        EXPORT main

user_prog
        LDR     R7, =ADDR_LCD_BLUE              ; load base address of pwm blue
        LDR     R6, =BACKLIGHT_FULL             ; backlight full blue
        STRH    R6, [R7]                        ; write pwm register

        LDR     R0, =0                          ; lower 32 bits of total sum
        LDR     R1, =0                          ; higher 32 bits of total sum
endless
        BL      waitForKey                      ; wait for key T0 to be pressed

        ; STUDENTS: To be programmed
        LDR     R2, =ADDR_DIP_SWITCH_31_0       ; load base address of dip switch
        LDR     R2, [R2]                        ; load value of dip switch
        ADDS    R0, R2                          ; store value of dip switch into Sumpart1

        ;Add Carry to R1
		MOVS    R4, #0                          ; Workaround to add 0 to carry in order to use ADCS
		ADCS    R1, R1, R4                      ; Add carry to R1

        ;Display new value on LCD
		LDR     R5, =ADDR_LCD_BIN               ; load base address of lcd bin
        STR     r0, [r5]                        ; Write word of data to LCD.
		STR     r1, [r5, #32]                   ; Write word of data to LCD.

        ; END: To be programmed
        B       endless
        ALIGN


;----------------------------------------------------
; Subroutines
;----------------------------------------------------

; wait for key to be pressed and released
waitForKey
        PUSH    {R0, R1, R2}
        LDR     R1, =ADDR_BUTTONS               ; laod base address of keys
        LDR     R2, =MASK_KEY_T0                ; load key mask T0

waitForPress
        LDRB    R0, [R1]                        ; load key values
        TST     R0, R2                          ; check, if key T0 is pressed
        BEQ     waitForPress

waitForRelease
        LDRB    R0, [R1]                        ; load key values
        TST     R0, R2                          ; check, if key T0 is released
        BNE     waitForRelease

        POP     {R0, R1, R2}
        BX      LR
        ALIGN

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
