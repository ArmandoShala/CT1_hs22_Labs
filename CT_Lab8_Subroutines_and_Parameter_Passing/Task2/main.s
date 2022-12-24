;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
MY_CONST                EQU     0x12
ADDR_DIP_SWITCH_31_0    EQU     0x60000200
ADDR_LED_31_0           EQU     0x60000100
		
	AREA SCopy, CODE, READONLY
	EXPORT out_word, in_word

	; R0 points to out_address
	; R1 points to out_value
out_word STR R1, [R0]
		 BX LR
		 
	; R0 points to in_address
in_word LDR R0, [R0]
		BX LR