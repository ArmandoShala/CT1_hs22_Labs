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
        uint8_t dipBytes = CT_DIPSW->BYTE.S7_0; // Load DIP switches
        dipBytes |= BRIGHT; // Set bit 8 and 7 to 1
        dipBytes &= DARK; // Set bit 6 and 5 to 0
        CT_LED->BYTE.LED7_0 = dipBytes; // Write to LED7_0

        // 3.2
        uint8_t BUTTONS = CT_BUTTON; // Load buttons
        BUTTONS = BUTTONS & MASK_WORD; // Mask out bits 7-4
        CT_LED->BYTE.LED31_24 = BUTTONS; // Write to LED31_24 the value of BUTTONS
        uint8_t B1 = (BUTTONS >> 0) & 1; // Shift right 0 times to get B1 in Buttons Array and mask out all other bits
        uint8_t B2 = (BUTTONS >> 1) & 1; // Shift right 1 times to get B2 in Buttons Array and mask out all other bits
        uint8_t B3 = (BUTTONS >> 2) & 1; // Shift right 2 times to get B3 in Buttons Array and mask out all other bits
        uint8_t B4 = (BUTTONS >> 3) & 1; // Shift right 3 times to get B4 in Buttons Array and mask out all other bits

        if (B1 == ONE && B1_BEFORE == ZERO) {
            // If B1 is pressed and was not pressed before
            counter += ONE;
        }

        CT_LED->BYTE.LED15_8 = counter; // Write to LED15_8 the value of counter

        // 3.3
        if (B1 == ONE && B1_BEFORE == ZERO) {
            // If B1 is pressed and was not pressed before
            BITS = dipBytes; // Write to BITS the value of dipBytes
        } else if (B2 == ONE && B2_BEFORE == ZERO) {
            // If B2 is pressed and was not pressed before
            BITS = ~BITS; // Invert all bits
        } else if (B3 == ONE && B3_BEFORE == ZERO) {
            // If B3 is pressed and was not pressed before
            BITS = (uint8_t)((int) BITS << 1); // Shift left 1 time
        } else if (B4 == ONE && B4_BEFORE == ZERO) {
            // If B4 is pressed and was not pressed before
            BITS = (uint8_t)((int) BITS >> 1); // Shift right 1 time
        }
        CT_LED->BYTE.LED23_16 = BITS; // Write to LED23_16 the value of BITS

        B1_BEFORE = B1; // Update state of B1 with the current state
        B2_BEFORE = B2; // Update state of B2 with the current state
        B3_BEFORE = B3; // Update state of B3 with the current state
        B4_BEFORE = B4; // Update state of B4 with the current state
    }

    return EXIT_SUCCESS;
}
