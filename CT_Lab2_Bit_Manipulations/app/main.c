/* -----------------------------------------------------------------
 * --  _____       ______  _____                                    -
 * -- |_   _|     |  ____|/ ____|                                   -
 * --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
 * --   | | | '_ \|  __|  \___ \   Zurich University of             -
 * --  _| |_| | | | |____ ____) |  Applied Sciences                 -
 * -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
 * ------------------------------------------------------------------
 * --
 * -- main.c
 * --
 * -- main for Computer Engineering "Bit Manipulations"
 * --
 * -- $Id: main.c 744 2014-09-24 07:48:46Z ruan $
 * ------------------------------------------------------------------
 */
//#include <reg_ctboard.h>
#include "utils_ctboard.h"

#define ADDR_DIP_SWITCH_31_0 0x60000200
#define ADDR_DIP_SWITCH_7_0  0x60000200
#define ADDR_LED_31_24       0x60000103
#define ADDR_LED_23_16       0x60000102
#define ADDR_LED_15_8        0x60000101
#define ADDR_LED_7_0         0x60000100
#define ADDR_BUTTONS         0x60000210

// define your own macros for bitmasks below (#define)
/// STUDENTS: To be programmed
//#define BRIGHT 0b11000000
//#define DARK 0b11001111
#define UNUSED_BUTTONS 0x0F

/// END: To be programmed

int main(void)
{
    uint8_t led_value = 0;

    // add variables below
    /// STUDENTS: To be programmed

    uint8_t buttons_value = 0;
    uint8_t counter = 0;
    uint8_t push_counter = 0;

    /// END: To be programmed

    while (1) {
        // ---------- Task 3.1 ----------
        led_value = read_byte(ADDR_DIP_SWITCH_7_0);

        /// STUDENTS: To be programmed

        // set bit 6 and 7 to 1
        led_value |= 0b11000000;
        // clear bit 4 and 5
        led_value &= 0b11001111;

        /// END: To be programmed

        write_byte(ADDR_LED_7_0, led_value);

        // ---------- Task 3.2 and 3.3 ----------
        /// STUDENTS: To be programmed
        buttons_value = read_byte(ADDR_BUTTONS); // read addresses of buttons
        buttons_value = UNUSED_BUTTONS & buttons_value; // clear unused buttons

         // Increment this variable each time the button T0 is pressed i.e. whenever Bit 0 is high.
        if (buttons_value & 0b00000001) {
            counter++;
        }

        if (buttons_value == 0b00001000) {
            counter = 0;
        }


        // Count the push_counter independent on how long the button is pressed by the user
        if (buttons_value & 0b00000100) {
            push_counter++;
        } else {
            push_counter = 0;
        }



        // Implement an edge detection, which detects if one or more buttons were not pressed
        // (low) during the last loop iteration and are now pressed (high)
        if (buttons_value & 0b00000010) {
            counter = 0;
        }


        write_byte(ADDR_LED_31_24, counter);

        // Output the variable on LED15 to LED8 during each loop iteration.
        write_byte(ADDR_LED_15_8, counter);
        /// END: To be programmed
    }
}











