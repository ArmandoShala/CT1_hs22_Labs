;* ------------------------------------------------------------------
;* --  _____       ______  _____                                    -
;* -- |_   _|     |  ____|/ ____|                                   -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
;* --   | | | '_ \|  __|  \___ \   Zurich University of             -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                 -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
;* ------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 7
;* -- Description : Control structures
;* -- 
;* -- $Id: main.s 3748 2016-10-31 13:26:44Z kesr $
;* ------------------------------------------------------------------

; -------------------------------------------------------------------
; -- Constants
; -------------------------------------------------------------------
    
                AREA myCode, CODE, READONLY
                    
                THUMB

ADDR_LED_15_0           EQU     0x60000100
ADDR_LED_31_16          EQU     0x60000102
ADDR_7_SEG_BIN_DS1_0    EQU     0x60000114
ADDR_DIP_SWITCH_15_0    EQU     0x60000200
ADDR_HEX_SWITCH         EQU     0x60000211
NR_CASES        		EQU     0xC

jump_table      ; ordered table containing the labels of all cases
                ; STUDENTS: To be programmed 
                DCD case_dark
                DCD case_add
                DCD case_subs
                DCD case_uMuls
                DCD case_and
                DCD case_or
                DCD case_xor
                DCD case_not
                DCD case_nand
                DCD case_nor
                DCD case_xnor
                DCD case_bright
                ; END: To be programmed

; -------------------------------------------------------------------
; -- Main
; -------------------------------------------------------------------

main            PROC
                EXPORT main

read_dipsw      ; Read operands into R0 and R1 and display on LEDs
                ; STUDENTS: To be programmed
                LDR    R2, =ADDR_DIP_SWITCH_15_0            ; Load the Addr of the DIP switches into R2
                LDRB   R0, [R2]                             ; Load the second 8 bits into R0 (Operant 2)
                LDRB   R1, [R2, #1]                         ; Load the first 8 bits into R1 (Operant 1)

                LDR    R3, =ADDR_LED_15_0                   ; Load the Addr of the LEDs into R3

                STRB   R0, [R3]                             ; Store the first 8 bits into the LEDs
                STRB   R1, [R3, #1]                         ; Store the second 8 bits into the LEDs (Offset +1 because the next Addr is the one for the bytes, not +8)
                ; END: To be programmed

read_hexsw      ; Read operation into R2 and display on 7seg.
                ; STUDENTS: To be programmed
                LDR    R2, =ADDR_HEX_SWITCH                 ; Start with 0 in R2
				MOVS   R6, #0x0F                            ; Load 0x0F into R6 (Mask upper bits)
                LDRB   R2, [R2]                             ; Load the value of the Hex Switches into R2
				ANDS   R2, R2, R6                           ; AND R2 with R6
                LDR    R4, =ADDR_7_SEG_BIN_DS1_0            ; Load the Addr of the 7seg into R4
                STR    R2, [R4]                             ; Store R2 in the 7seg
                ; END: To be programmed

case_switch     ; Implement switch statement as shown on lecture slide
                ; STUDENTS: To be programmed
                CMP    R2, #NR_CASES                        ; Compare R2 with the number of cases
                BHS    case_bright                          ; If R2 is bigger or equal to the number of cases, jump to case_default
                ;LSLS   R2, #2                               ; Shift R2 left by 2 bits
                LDR    R3, =jump_table                      ; Load the Addr of the jump table into R3
                LDR    R7, [R7, R2]                         ; Load the Addr of the case into R7
                BX     R7                                   ; Jump to the label in the jump table
                ; END: To be programmed


; Add the code for the individual cases below
; - operand 1 in R0
; - operand 2 in R1
; - result in R0

case_dark
                LDR  R0, =0
                B    display_result

case_add
                ADDS R0, R0, R1
                B    display_result

case_subs
                SUBS R0, R0, R1
                B    display_result

case_uMuls
                MULS R0, R1, R0
                B    display_result

case_and
                ANDS R0, R0, R1
                B    display_result

case_or
                ORRS R0, R0, R1
                B    display_result

case_xor
                EORS R0, R0, R1
                B    display_result

case_not
                MVNS R0, R0
                B    display_result


case_nand
                ANDS R0, R0, R1
                MVNS R0, R0
                B    display_result

case_nor
                ORRS R0, R0, R1
                MVNS R0, R0
                B    display_result

case_xnor
                EORS R0, R0, R1
                MVNS R0, R0
                B    display_result

case_bright
                LDR  R0, =0xFFFF
                B    display_result

; STUDENTS: To be programmed


; END: To be programmed


display_result  ; Display result on LEDs
                ; STUDENTS: To be programmed
                LDR    R7, =ADDR_LED_31_16                   ; Load the Addr of the LEDs into R7
                STRB   R0, [R7]                              ; Store the first 8 bits into the LEDs

                ; END: To be programmed

                B    read_dipsw
                
                ALIGN
                ENDP

; -------------------------------------------------------------------
; -- End of file
; -------------------------------------------------------------------                      
                END

