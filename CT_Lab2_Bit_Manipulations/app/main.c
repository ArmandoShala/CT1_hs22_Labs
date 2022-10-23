#include "utils_ctboard.h"
#include <stdio.h>
#include <stdlib.h>
#include "reg_ctboard.h"

#define BRIGHT 0xC0
#define DARK 0xCF
#define MASK_WORD 0x0F
#define ADR_BUTTON 0x60000210
#define ONE 0x01
#define ZERO 0x00

int main(void) {
	
 uint8_t counter = ZERO;	
 uint8_t B1_BEFORE = ZERO;
 uint8_t B2_BEFORE = ZERO;
 uint8_t B3_BEFORE = ZERO;
 uint8_t B4_BEFORE = ZERO;
 uint8_t BITS = ZERO;	
	
 while (1) { 
	 // 3.1
	 uint8_t dipBytes = CT_DIPSW->BYTE.S7_0;
	 dipBytes |= BRIGHT;
	 dipBytes &= DARK;
	 CT_LED->BYTE.LED7_0 = dipBytes;
	 
	 // 3.2
	 uint8_t BUTTONS = read_byte(ADR_BUTTON);
	 BUTTONS = BUTTONS & MASK_WORD;
	 CT_LED->BYTE.LED31_24 = BUTTONS;
	 uint8_t B1 = (BUTTONS >> 0 ) & 1;
	 uint8_t B2 = (BUTTONS >> 1 ) & 1;
	 uint8_t B3 = (BUTTONS >> 2 ) & 1;
	 uint8_t B4 = (BUTTONS >> 3 ) & 1;
	 
	 if (B1 == ONE && B1_BEFORE == ZERO) {
		 counter += ONE;
	 }
	 
	 CT_LED->BYTE.LED15_8 = counter;	
	
	 // 3.3
	 if (B1 == ONE && B1_BEFORE == ZERO) {
		 BITS = dipBytes;
	 }
	 else if (B2 == ONE && B2_BEFORE == ZERO) {
		 BITS = ~BITS; 
	 }
	 else if (B3 == ONE && B3_BEFORE == ZERO) {
		 BITS = (uint8_t)((int)BITS << 1);
	 }
	 else if (B4 == ONE && B4_BEFORE == ZERO) {
		 BITS = (uint8_t)((int)BITS >> 1);
	 }
	 CT_LED->BYTE.LED23_16 = BITS;
	 
	 B1_BEFORE = B1;
	 B2_BEFORE = B2;
	 B3_BEFORE = B3;
	 B4_BEFORE = B4;
 }
 
	return EXIT_SUCCESS;
}
