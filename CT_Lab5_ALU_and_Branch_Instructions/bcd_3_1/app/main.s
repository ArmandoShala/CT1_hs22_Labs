; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- main.s
; --
; -- CT1 P06 "ALU und Sprungbefehle" mit MUL
; --
; -- $Id: main.s 4857 2019-09-10 17:30:17Z akdi $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address Defines
; ------------------------------------------------------------------

ADDR_LED_15_0           EQU     0x60000100
ADDR_LED_31_16          EQU     0x60000102
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_7_SEG_BIN_DS3_0    EQU     0x60000114
ADDR_BUTTONS            EQU     0x60000210

ADDR_LCD_RED            EQU     0x60000340
ADDR_LCD_GREEN          EQU     0x60000342
ADDR_LCD_BLUE           EQU     0x60000344
LCD_BACKLIGHT_FULL      EQU     0xffff
LCD_BACKLIGHT_OFF       EQU     0x0000

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

        ENTRY

main    PROC
        export main
; 3.1 ------------------------------------------------------------------
; STUDENTS: To be programmed

    MOVS R7, #0x0F
    MOVS R4, #0x00

;    MOV KNAST, XATAR
;    ANDS REDEN, 0x00
;    SUBS XARAR, HANDY

    ; Read DIP bitches and load only necessary bits
    LDR R0, =ADDR_DIP_SWITCH_7_0            ; Load Address of DIP Switches
    LDRB R0, [R0]                           ; Load Value of DIP Switches
    ANDS R0, R0, R7                         ; Mask upper bits (not needed)


    LDR R1, =ADDR_DIP_SWITCH_15_8            ; Load Address of DIP Switches
    LDRB R1, [R1]                            ; Load Value of DIP Switches
    ANDS R1, R1, R7                          ; Mask upper bits (not needed)


    LSLS R3, R1, #4                          ; Shift bits to merge more easily (pretend to flip upper bits)
    ORRS R3, R3, R0                          ; Merge R0 and R3 into R4


    MOVS R2, #10                            ; Multiplier to convert left (upper) bits from ones to tens
    MULS R2, R1, R2                         ; Multiply upper bits with 10 (First and last register must be the same)

    ADDS R2, R2, R0                         ; Add lower bits to result of multiplication

    LDR R5, =ADDR_LED_15_0                  ; Load Address of LED7-0
    LSLS R2, R2, #8
    ORRS R3, R3, R2
    STR R3, [R5]

    ;Binary output LED 8-15
    LDR  R5, =ADDR_7_SEG_BIN_DS3_0
    STRH R3, [R5]

; 3.2 ------------------------------------------------------------------

    MOVS R0, #0      ; initialize counter to 0
    B LoopAddOnsTest

AddOneTwoBlock
    LSLS R4, R4, #1 ; shift one to the left to make space for next 1 bit
    ORRS R4, R4, R1 ; add 1 to the right side at the beginning of block
    B LoopAddOns

LoopAddOns
    ADDS R0, R0, #1 ; increment counter

LoopAddOnsTest
    ; get the values of LED
    MOVS R7, R3     ; make a temp copy of R3
    LSRS R7, R7, #8   ; remove the lower 8 bits "0b 0000 0000 0000 0000 => 0b 0000 0000"


    MOVS R1, #0x01 ; mask for first bit
    LSRS R7, R7, R0 ;shift bit to check to the right side at the beginning
    ANDS R7, R7, R1 ; eliminate all bits to check only needed one

    CMP R7, R1 ; Check if R1 equals R7 if true then jump to label
    BEQ AddOneTwoBlock ;Jump to add 1 bit to the bit block

	MOVS R2, #8
	CMP R0, R2
    BLT LoopAddOns       ; if counter < 10, go back to loop


; END: To be programmed



    ;Write code to rotate fucking lights from left to right

    MOVS R0, #16      ; initialize counter to 16
    LDR R5, =ADDR_LED_31_16
DISPLAY_LOOP

      ; body of loop

      STR R4, [R5]
      LSLS R4, R4, #1

      ; end body of loop
      SUBS R0, R0, #1 ; decrement counter
      CMP R0, #0    ; compare counter to 10
      BNE DISPLAY_LOOP       ; if counter < 10, go back to loop

        B       main
        ENDP

;----------------------------------------------------
; Subroutines
;----------------------------------------------------
;----------------------------------------------------
; pause for disco_lights
pause           PROC
        PUSH    {R0, R1}
        LDR     R1, =1
        LDR     R0, =0x000FFFFF

loop
        SUBS    R0, R0, R1
        BCS     loop

        POP     {R0, R1}
        BX      LR
        ALIGN
        ENDP

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
