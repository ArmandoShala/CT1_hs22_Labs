#include "utils_ctboard.h"
#include "reg_ctboard.h"
#include <stdint.h>

#define DIP_SWITCH 0x60000200
#define LED 0x60000100
#define P11 0x60000211
#define DS0 0x60000110

	extern void out_word(uint32_t out_address, uint32_t out_value);
	extern uint32_t in_word(uint32_t in_address);

int main(void) {

	uint32_t res = in_word(DIP_SWITCH);
	
	out_word(LED, res);
	
	return 0;
	
}
