#include <stdio.h>
#include <stdlib.h>
#include "utils_ctboard.h"

#define dip_switch_addr_7_0 0x60000200
#define dip_switch_addr_31_24 0x60000203

#define led_addr_7_0 0x60000100
#define led_addr_31_24 0x60000100
#define seven_seg_display_addr 0x60000110

#define poti_addr 0x60000211

#define mask_upper_4_bits 0x0F


int main()
{
		uint8_t DISPLAY[16];
		DISPLAY[0] = 0xC0;  /* 0 = 00 0xC0 11000000*/
		DISPLAY[1] = 0xF9;  /* 1 = 01	0xF9 11111001*/
		DISPLAY[2] = 0xA4;  /* 2 = 02 0xA4 10100100*/
		DISPLAY[3] = 0xB0;  /* 3 = 03 0xB0 10110000*/
		DISPLAY[4] = 0x98;  /* 4 = 04 0x98 10011000*/
		DISPLAY[5] = 0x92;  /* 5 = 05 0x92 10010010*/
		DISPLAY[6] = 0x82;  /* 6 = 06 0x82 10000010*/
		DISPLAY[7] = 0xF8;  /* 7 = 07 0xF8 11111000*/
		DISPLAY[8] = 0x80;  /* 8 = 08 0x80 10000000*/
		DISPLAY[9] = 0x90;  /* 9 = 09 0x90 10010000*/
		DISPLAY[10] = 0x88; /* A = 10 0x88 10001000*/
		DISPLAY[11] = 0x83; /* b = 11 0x83 10000011*/
		DISPLAY[12] = 0xC6; /* C = 12 0xC6 11000110*/
		DISPLAY[13] = 0xA1; /* d = 13 0xA1 10100001*/
		DISPLAY[14] = 0x86; /* E = 14 0x86 10000110*/
		DISPLAY[15] = 0x8E; /* F = 15 0x8E 10001110*/

	

    while(1)
    {
			
			//4.2
      /*  uint8_t readAddr7_0 = read_byte(dip_switch_addr_7_0);
				write_byte(led_addr_7_0, readAddr7_0);
			*/

			// 5.1
			/*  uint32_t readAddr_31_24 = read_word(dip_switch_addr_7_0);
				write_word(led_addr_31_24, readAddr_31_24);
			*/

			//5.2
			uint8_t rotaryState = read_byte(poti_addr) & mask_upper_4_bits;
			write_byte(seven_seg_display_addr, DISPLAY[rotaryState]);
			write_byte(led_addr_7_0, rotaryState);


        /*uint8_t data_byte = CT_DIPSW->BYTE.S7_0;       
			  CT_LED->BYTE.LED7_0 = (uint8_t) data_byte;
			*/
    }
}