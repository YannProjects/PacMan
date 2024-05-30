#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <windows.h>
#include <unistd.h>
#include <conio.h>
#include <xuartns550_l.h>
#include <uart16550_stub.h>
#include <pthread.h>
#include <fcntl.h>   /* File control definitions */
#include <errno.h>   /* Error number definitions */
#include <libserialport.h>

pthread_mutex_t lock; 

unsigned char uart_recv_buffer[128];
unsigned char uart_recv_index;

static volatile unsigned char Uart_Reg_Stub[] = {0x00, 0x00, 0xC1, 0x03, 0x00, 0x60, 0x00, 0x00, 0x00};

struct sp_port *serial_port;

typedef struct
{ 
   pthread_t uart_tx_thread;
   pthread_t uart_rx_thread;
   unsigned char	tx_fifo[FIFO_LENGTH];
   int				tx_queue_level;
   int				tx_queue_index;
   unsigned char	rx_fifo[FIFO_LENGTH];
   int				rx_queue_level;
   int				rx_queue_index;
}
uart_threads_t; 

static uart_threads_t uart_threads =
{
   .tx_queue_level = 0,
   .tx_queue_index = 0,
   .rx_queue_level = 0,
   .rx_queue_index = 0
};

/* Helper function for error handling. */
int check(enum sp_return result)
{
        /* For this example we'll just exit on any error by calling abort(). */
        char *error_message;
        switch (result) {
        case SP_ERR_ARG:
                printf("Error: Invalid argument.\n");
                abort();
        case SP_ERR_FAIL:
                error_message = sp_last_error_message();
                printf("Error: Failed: %s\n", error_message);
                sp_free_error_message(error_message);
                abort();
        case SP_ERR_SUPP:
                printf("Error: Not supported.\n");
                abort();
        case SP_ERR_MEM:
                printf("Error: Couldn't allocate memory.\n");
                abort();
        case SP_OK:
        default:
                return result;
        }
}

int open_port(void)
 {
	printf("Looking for port %s.\n", "COM5");
	check(sp_get_port_by_name("COM5", &serial_port));
	printf("Opening port.\n");
	check(sp_open(serial_port, SP_MODE_READ_WRITE));
	printf("Setting port to 9600 8N1, no flow control.\n");
	check(sp_set_baudrate(serial_port, 9600));
	check(sp_set_bits(serial_port, 8));
	check(sp_set_parity(serial_port, SP_PARITY_NONE));
	check(sp_set_stopbits(serial_port, 1));
	check(sp_set_flowcontrol(serial_port, SP_FLOWCONTROL_NONE));
}

static void * fn_uart_tx (void * p_data)
{
	int result;
	unsigned int timeout = 1000;

	while(1) {
		if (uart_threads.tx_queue_level != uart_threads.tx_queue_index) {
			/* Send data. */
			result = check(sp_blocking_write(serial_port, &uart_threads.tx_fifo[uart_threads.tx_queue_index], 1, timeout));
			uart_threads.tx_queue_index = (uart_threads.tx_queue_index + 1) % FIFO_LENGTH;
			/* Check whether we sent all of the data. */
			if (result != 1)
				printf("Timed out, %d/%d bytes sent.\n", result, 1);
		} else {
			Uart_Reg_Stub[LSR_REG] = Uart_Reg_Stub[LSR_REG] | (XUN_LSR_TX_EMPTY | XUN_LSR_TX_BUFFER_EMPTY);
		}
	}

	return NULL;
}

static void * fn_uart_rx (void * p_data)
{
	unsigned char c;
	int result = 0;

	while(1) {
		result = check(sp_blocking_read(serial_port, &c, 1, 0));
		/* Check whether we received the number of bytes we wanted. */
		if (result == 1) {
			pthread_mutex_lock(&lock); 
			uart_threads.rx_fifo[uart_threads.rx_queue_level] = c;
			uart_threads.rx_queue_level = (uart_threads.rx_queue_level + 1) % FIFO_LENGTH;
			pthread_mutex_unlock(&lock); 
		}
	}

	return NULL;
}

void uart_stub_init()
{
	int ret;

	// Ouverture port serie virtuel
	open_port();

   	// Thread UART TX
	uart_threads.tx_queue_level = 0;
	uart_threads.tx_queue_index = 0;
	uart_threads.rx_queue_level = 0;
	uart_threads.rx_queue_index = 0;
   	ret = pthread_create (&uart_threads.uart_tx_thread, NULL,
      	fn_uart_tx, NULL);
 
   	// Thread UART RX
   	if (! ret)
   	{
		ret = pthread_create (&uart_threads.uart_rx_thread, NULL,
			fn_uart_rx, NULL);

		if (ret)
		{
			fprintf (stderr, "%s", strerror (ret));
		}
   	}
   	else
   	{
		fprintf (stderr, "%s", strerror (ret));
   	}

	pthread_mutex_init(&lock, NULL);

}

void uart_stub_write_reg(unsigned int RegOffset, unsigned char RegValue)
{
	unsigned int timeout = 1000;

	pthread_mutex_lock(&lock); 
	
	if (RegOffset == THR_REG) {
		// On ecrit dans la FIFO seulement si le bit d'acces aux registres de baud rate
		// n'est pas positionne.
		if ((Uart_Reg_Stub[LCR_REG] & XUN_LCR_DLAB) != XUN_LCR_DLAB) {
			uart_threads.tx_fifo[uart_threads.tx_queue_level] = RegValue;
			uart_threads.tx_queue_level = (uart_threads.tx_queue_level + 1) % FIFO_LENGTH;
			Uart_Reg_Stub[LSR_REG] = Uart_Reg_Stub[LSR_REG] & ((~(XUN_LSR_TX_EMPTY | XUN_LSR_TX_BUFFER_EMPTY)));
		}
	} else if (RegOffset == FCR_REG) {
		if ((Uart_Reg_Stub[RegOffset] & XUN_FIFO_RX_RESET) == XUN_FIFO_RX_RESET) {
			uart_threads.rx_queue_index = 0;
			uart_threads.rx_queue_level = 0;
		} else if ((Uart_Reg_Stub[RegOffset] & XUN_FIFO_TX_RESET) == XUN_FIFO_TX_RESET) {
			uart_threads.tx_queue_index = 0;
			uart_threads.tx_queue_level = 0;
		}
	}
	else {
		Uart_Reg_Stub[RegOffset] = RegValue;
	}

	pthread_mutex_unlock(&lock); 	
}

unsigned char uart_stub_read_reg(unsigned int RegOffset)
{
	unsigned char uart_data_register, c;

	pthread_mutex_lock(&lock); 
	uart_data_register = 0x00;
	if (RegOffset == RBR_REG) {
		if (uart_threads.rx_queue_level != uart_threads.rx_queue_index) {
			uart_data_register = uart_threads.rx_fifo[uart_threads.rx_queue_index];
			uart_threads.rx_queue_index = (uart_threads.rx_queue_index + 1) % FIFO_LENGTH;
		}
	} else if (RegOffset == LSR_REG) {
		// Si la FIFO est vide, on resette le bit data ready registre LSR
		if (uart_threads.rx_queue_level != uart_threads.rx_queue_index) {
			Uart_Reg_Stub[LSR_REG] = Uart_Reg_Stub[LSR_REG] | XUN_LSR_DATA_READY;
		}		
		else if (Uart_Reg_Stub[LSR_REG] & XUN_LSR_DATA_READY == XUN_LSR_DATA_READY)
		{
			Uart_Reg_Stub[LSR_REG] = Uart_Reg_Stub[LSR_REG] & (~XUN_LSR_DATA_READY);
		}
		uart_data_register = Uart_Reg_Stub[RegOffset];
	}
	else {
		uart_data_register = Uart_Reg_Stub[RegOffset];
	}
	pthread_mutex_unlock(&lock); 

	return uart_data_register;
}