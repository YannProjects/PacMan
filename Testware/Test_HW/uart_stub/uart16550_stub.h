#ifndef __UART16550_STUB
#define __UART16550_STUB

//#define UART_STUB

void uart_stub_init();
void uart_stub_write_reg(unsigned int RegOffset, unsigned char RegValue);
unsigned char uart_stub_read_reg(unsigned int RegOffset);

#define FIFO_LENGTH     32

#define RBR_REG         0
#define THR_REG         0
#define IER_REG         1
#define IIR_REG         2
#define FCR_REG         2
#define LCR_REG         3

#define LSR_REG         5

#endif