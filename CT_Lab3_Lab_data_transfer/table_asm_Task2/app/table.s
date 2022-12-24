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

BITMASK_KEY_T0              EQU     0x01
BITMASK_LOWER_NIBBLE        EQU     0x0F
	
ADDR_SEG7_BIN   			EQU      0x60000114

; ------------------------------------------------------------------
; -- Variables
; ------------------------------------------------------------------
        AREA MyAsmVar, DATA, READWRITE
; STUDENTS: To be programmed

byte_array					SPACE	32



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
; 3
		LDR		R3, =byte_array				; load ARRAY_ADDRESS address
		LDR		R4, =BITMASK_LOWER_NIBBLE
		
		LDR		R7, =ADDR_DIP_SWITCH_15_8	; set address to read index to R7
		LDRB	R5, [R7]					; load INDEX to R5
		ANDS	R5, R5, R4
		LDR		R7, =ADDR_DIP_SWITCH_7_0	; set address to read value to R7
		LDRB	R6, [R7]					; load VALUE to R6
		
		LSLS	R1, R5, #1					; multiply table index *2
		STRB	R5, [R3,R1]
		ADDS	R1, R1, #1
		STRB	R6, [R3,R1]
		
		;debug
		LDR		R7, =ADDR_LED_15_8
		STRB	R5, [R7]
		LDR		R7, =ADDR_LED_7_0
		STRB	R6, [R7]
; 3.1
		LDR		R7, =ADDR_DIP_SWITCH_31_24	; set address to ouput index to R7
		LDRB	R5, [R7]					; load OUPUT INDEX to R5
		ANDS	R5, R5, R4
		LDR		R7, =ADDR_LED_31_24 		; OUTPUT INDEX address
		STRB	R5, [R7]					; display OUTPUT INDEX to LED 27 - 24
		LSLS	R1, R5, #1					; multiply index
		ADDS	R2, R1, #1					; add 1 to index
		LDRB	R6, [R3,R2]					; load output value from memory
		LDR		R7, =ADDR_LED_23_16 		; OUTPUT VALUE address
		STRB	R6, [R7]
		
		;led panel
		LDR 	R7, =ADDR_SEG7_BIN			; load led address
		LDRB	R6, [R3,R1]					; load index
		STRB	R6, [R7, #1]
		LDRB	R6, [R3,R2]					; load value
		STRB		R6, [R7]


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
