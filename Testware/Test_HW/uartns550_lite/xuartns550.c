/******************************************************************************
* Copyright (C) 2002 - 2021 Xilinx, Inc.  All rights reserved.
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/

/****************************************************************************/
/**
*
* @file xuartns550.c
* @addtogroup uartns550 Overview
* @{
*
* This file contains the required functions for the 16450/16550 UART driver.
* Refer to the header file xuartns550.h for more detailed information.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00a ecm  08/16/01 First release
* 1.00b jhl  03/11/02 Repartitioned driver for smaller files.
* 1.00b rmm  05/14/03 Fixed diab compiler warnings relating to asserts.
* 1.01a jvb  12/13/05 I changed Initialize() into CfgInitialize(), and made
*                     CfgInitialize() take a pointer to a config structure
*                     instead of a device id. I moved Initialize() into
*                     xgpio_sinit.c, and had Initialize() call CfgInitialize()
*                     after it retrieved the config structure using the device
*                     id. I removed include of xparameters.h along with any
*                     dependencies on xparameters.h and the _g.c config table.
* 1.11a sv   03/20/07 Updated to use the new coding guidelines.
* 2.00a ktn  10/20/09 Converted all register accesses to 32 bit access.
*		      Updated to use HAL Processor APIs. _m is removed from the
*		      name of all the macro definitions. XUartNs550_mClearStats
*		      macro is removed, XUartNs550_ClearStats function should be
*		      used in its place.
* 2.01a bss  01/13/12 Removed unnecessary read of the LCR register in the
*                     XUartNs550_CfgInitialize function. Removed compiler
*		      warnings for unused variables in the
*		      XUartNs550_StubHandler.
* 3.3	nsk  04/13/15 Fixed Clock Divisor Enhancement.
*		      (CR 857013)
* 3.4   sk   11/10/15 Used UINTPTR instead of u32 for Baseaddress CR# 867425.
*                     Changed the prototype of XUartNs550_CfgInitialize API.
* 3.7   sd   03/02/20 Update the macro names.
* </pre>
*
*****************************************************************************/

/***************************** Include Files ********************************/

#include <xuartns550.h>
#include <xstatus.h>
#include <xuartns550_i.h>
#include <stddef.h>

/************************** Constant Definitions ****************************/

/* The following constant defines the amount of error that is allowed for
 * a specified baud rate. This error is the difference between the actual
 * baud rate that will be generated using the specified clock and the
 * desired baud rate.
 */
#define XUN_MAX_BAUD_ERROR_RATE		3	 /* max % error allowed */

/**************************** Type Definitions ******************************/


/***************** Macros (Inline Functions) Definitions ********************/


/************************** Variable Definitions ****************************/

extern XUartNs550 UartNs550;		/* The instance of the UART Driver */


/************************** Function Prototypes *****************************/

/****************************************************************************/
/**
*
* This functions sends the specified buffer of data using the UART in either
* polled or interrupt driven modes. This function is non-blocking such that it
* will return before the data has been sent by the UART. If the UART is busy
* sending data, it will return and indicate zero bytes were sent.
*
* In a polled mode, this function will only send as much data as the UART can
* buffer, either in the transmitter or in the FIFO if present and enabled. The
* application may need to call it repeatedly to send a buffer.
*
* In interrupt mode, this function will start sending the specified buffer and
* then the interrupt handler of the driver will continue sending data until the
* buffer has been sent. A callback function, as specified by the application,
* will be called to indicate the completion of sending the buffer.
*
* @param	InstancePtr is a pointer to the XUartNs550 instance.
* @param	BufferPtr is pointer to a buffer of data to be sent.
* @param	NumBytes contains the number of bytes to be sent. A value of
*		zero will stop a previous send operation that is in progress
*		in interrupt mode. Any data that was already put into the
*		transmit FIFO will be sent.
*
* @return	The number of bytes actually sent.
*
* @note
*
* The number of bytes is not asserted so that this function may be called with
* a value of zero to stop an operation that is already in progress.
* <br><br>
*
*****************************************************************************/
unsigned int XUartNs550_Send(unsigned char *BufferPtr,
					unsigned int NumBytes)
{
	unsigned int BytesSent;
	unsigned char IerRegister;

	/*
	 * Setup the specified buffer to be sent by setting the instance
	 * variables so it can be sent with polled or interrupt mode
	 */
	UartNs550.SendBuffer.RequestedBytes = NumBytes;
	UartNs550.SendBuffer.RemainingBytes = NumBytes;
	UartNs550.SendBuffer.NextBytePtr = BufferPtr;

	/*
	 * Send the buffer using the UART and return the number of bytes sent
	 */

	BytesSent = XUartNs550_SendBuffer();

	/*
	 * The critical region is not exited in this function because of the way
	 * the transmit interrupts work.  The other function called enables the
	 * tranmit interrupt such that this function can't restore a value to
	 * the interrupt enable register and does not need to exit the critical
	 * region
	 */
	return BytesSent;
}

/****************************************************************************/
/**
*
* This function will attempt to receive a specified number of bytes of data
* from the UART and store it into the specified buffer. This function is
* designed for either polled or interrupt driven modes. It is non-blocking
* such that it will return if no data has already received by the UART.
*
* In a polled mode, this function will only receive as much data as the UART
* can buffer, either in the receiver or in the FIFO if present and enabled.
* The application may need to call it repeatedly to receive a buffer. Polled
* mode is the default mode of operation for the driver.
*
* In interrupt mode, this function will start receiving and then the interrupt
* handler of the driver will continue receiving data until the buffer has been
* received. A callback function, as specified by the application, will be called
* to indicate the completion of receiving the buffer or when any receive errors
* or timeouts occur. Interrupt mode must be enabled using the SetOptions function.
*
* @param	InstancePtr is a pointer to the XUartNs550 instance.
* @param	BufferPtr is pointer to buffer for data to be received into
* @param	NumBytes is the number of bytes to be received. A value of zero
*		will stop a previous receive operation that is in progress in
*		interrupt mode.
*
* @return	The number of bytes received.
*
* @note
*
* The number of bytes is not asserted so that this function may be called with
* a value of zero to stop an operation that is already in progress.
*
*****************************************************************************/
unsigned int XUartNs550_Recv(unsigned char *BufferPtr, unsigned int NumBytes)
{
	unsigned int ReceivedCount;
	unsigned char IerRegister;

	/*
	 * Setup the specified buffer to be received by setting the instance
	 * variables so it can be received with polled or interrupt mode
	 */
	UartNs550.ReceiveBuffer.RequestedBytes = NumBytes;
	UartNs550.ReceiveBuffer.RemainingBytes = NumBytes;
	UartNs550.ReceiveBuffer.NextBytePtr = BufferPtr;

	/*
	 * Receive the data from the UART and return the number of bytes
	 * received
	 */
	ReceivedCount = XUartNs550_ReceiveBuffer();

	return ReceivedCount;
}

/****************************************************************************/
/**
*
* This function sends a buffer that has been previously specified by setting
* up the instance variables of the instance. This function is designed to be
* an internal function for the XUartNs550 component such that it may be called
* from a shell function that sets up the buffer or from an interrupt handler.
*
* This function sends the specified buffer of data to the UART in either
* polled or interrupt driven modes. This function is non-blocking such that
* it will return before the data has been sent by the UART.
*
* In a polled mode, this function will only send as much data as the UART can
* buffer, either in the transmitter or in the FIFO if present and enabled.
* The application may need to call it repeatedly to send a buffer.
*
* In interrupt mode, this function will start sending the specified buffer and
* then the interrupt handler of the driver will continue until the buffer
* has been sent. A callback function, as specified by the application, will
* be called to indicate the completion of sending the buffer.
*
* @param	InstancePtr is a pointer to the XUartNs550 instance.
*
* @return	NumBytes is the number of bytes actually sent (put into the
*		UART tranmitter and/or FIFO).
*
* @note		None.
*
*****************************************************************************/
unsigned int XUartNs550_SendBuffer()
{
	unsigned int SentCount = 0;
	unsigned int BytesToSend = 0;   /* default to not send anything */
	unsigned int FifoSize;
	unsigned char LsrRegister;

	/*
	 * Read the line status register to determine if the transmitter is
	 * empty
	 */
	LsrRegister = XUartNs550_GetLineStatusReg(UartNs550.BaseAddress);

	/*
	 * If the transmitter is not empty then don't send any data, the empty
	 * room in the FIFO is not available
	 */
	if (LsrRegister & XUN_LSR_TX_BUFFER_EMPTY) {
		/*
			* Determine how many bytes can be sent depending on if
			* the transmitter is empty, a FIFO size of N is really
			* N - 1 plus the transmitter register
			*/
		if (LsrRegister & XUN_LSR_TX_EMPTY) {
			FifoSize = XUN_FIFO_SIZE;
		} else {
			FifoSize = XUN_FIFO_SIZE - 1;
		}

		/*
			* FIFOs are enabled, if the number of bytes to send
			* is less than the size of the FIFO, then send all
			* bytes, otherwise fill the FIFO
			*/
		if (UartNs550.SendBuffer.RemainingBytes < FifoSize) {
			BytesToSend = UartNs550.SendBuffer.RemainingBytes;
		} else {
			BytesToSend = FifoSize;
		}

		/*
		 * Fill the FIFO if it's present or the transmitter only from
		 * the the buffer that was specified
		 */
		for (SentCount = 0; SentCount < BytesToSend; SentCount++) {
			XUartNs550_WriteReg(UartNs550.BaseAddress,
				XUN_THR_OFFSET,
				UartNs550.SendBuffer.NextBytePtr[SentCount]);
		}
	}
	/*
	 * Update the buffer to reflect the bytes that were sent from it
	 */
	UartNs550.SendBuffer.NextBytePtr += SentCount;
	UartNs550.SendBuffer.RemainingBytes -= SentCount;

	/*
	 * Return the number of bytes that were sent, although they really were
	 * only put into the FIFO, not completely sent yet
	 */
	return SentCount;
}

/****************************************************************************/
/**
*
* This function receives a buffer that has been previously specified by setting
* up the instance variables of the instance. This function is designed to be
* an internal function for the XUartNs550 component such that it may be called
* from a shell function that sets up the buffer or from an interrupt handler.
*
* This function will attempt to receive a specified number of bytes of data
* from the UART and store it into the specified buffer. This function is
* designed for either polled or interrupt driven modes. It is non-blocking
* such that it will return if there is no data has already received by the
* UART.
*
* In a polled mode, this function will only receive as much data as the UART
* can buffer, either in the receiver or in the FIFO if present and enabled.
* The application may need to call it repeatedly to receive a buffer. Polled
* mode is the default mode of operation for the driver.
*
* In interrupt mode, this function will start receiving and then the interrupt
* handler of the driver will continue until the buffer has been received. A
* callback function, as specified by the application, will be called to indicate
* the completion of receiving the buffer or when any receive errors or timeouts
* occur. Interrupt mode must be enabled using the SetOptions function.
*
* @param	InstancePtr is a pointer to the XUartNs550 instance.
*
* @return	The number of bytes received.
*
* @note		None.
*
*****************************************************************************/
unsigned int XUartNs550_ReceiveBuffer()
{
	unsigned char LsrRegister;
	unsigned int ReceivedCount = 0;

	/*
	 * Loop until there is not more data buffered by the UART or the
	 * specified number of bytes is received
	 */
	while (ReceivedCount < UartNs550.ReceiveBuffer.RemainingBytes) {

		/*
		 * Read the Line Status Register to determine if there is any
		 * data in the receiver/FIFO
		 */
		LsrRegister = XUartNs550_GetLineStatusReg(UartNs550.BaseAddress);

		/*
		 * If there is data ready to be removed, then put the next byte
		 * received into the specified buffer and update the stats to
		 * reflect any receive errors for the byte
		 */
		if (LsrRegister & XUN_LSR_DATA_READY) {
			UartNs550.ReceiveBuffer.NextBytePtr[ReceivedCount++] =
			XUartNs550_ReadReg(UartNs550.BaseAddress,
						XUN_RBR_OFFSET);
		}

		/*
		 * There's no more data buffered, so exit such that this
		 * function does not block waiting for data
		 */
		else {
			break;
		}
	}

	/*
	 * Update the receive buffer to reflect the number of bytes that was
	 * received
	 */
	UartNs550.ReceiveBuffer.NextBytePtr += ReceivedCount;
	UartNs550.ReceiveBuffer.RemainingBytes -= ReceivedCount;

	return ReceivedCount;
}

/****************************************************************************
*
* Sets the baud rate for the specified UART. Checks the input value for
* validity and also verifies that the requested rate can be configured to
* within the 3 percent error range for RS-232 communications. If the provided
* rate is not valid, the current setting is unchanged.
*
* This function is designed to be an internal function only used within the
* XUartNs550 component. It is necessary for initialization and for the user
* available function that sets the data format.
*
* @param	InstancePtr is a pointer to the XUartNs550 instance.
* @param	BaudRate to be set in the hardware.
*
* @return
*		- XST_SUCCESS if everything configures as expected
* 		- XST_UART_BAUD_ERROR if the requested rate is not available
*		because there was too much error due to the input clock
*
* @note		None.
*
*****************************************************************************/
int XUartNs550_SetBaudRate(unsigned int BaudRate)
{
	unsigned char BaudLSB, BaudMSB;
	unsigned char LcrRegister;
	unsigned int Divisor;

	UartNs550.BaudRate = BaudRate;
	/*
	 * Determine what the divisor should be to get the specified baud
	 * rater based upon the input clock frequency and a baud clock prescaler
	 * of 16
	 */
	Divisor = UartNs550.InputClockHz / (UartNs550.BaudRate * 16L);

	/*
	 * Get the least significant and most significant bytes of the divisor
	 * so they can be written to 2 byte registers
	 */
    BaudLSB = (unsigned char)(Divisor);
    BaudMSB = (unsigned char)(Divisor >> 8);

	/*
	 * Save the baud rate in the instance so that the get baud rate function
	 * won't have to calculate it from the divisor
	 */
	UartNs550.BaudRate = BaudRate;

	/*
	 * Get the line control register contents and set the divisor latch
	 * access bit so the baud rate can be set
	 */
	LcrRegister = XUartNs550_GetLineControlReg(UartNs550.BaseAddress);
	XUartNs550_SetLineControlReg(UartNs550.BaseAddress ,
					LcrRegister | XUN_LCR_DLAB);

	/*
	 * Set the baud Divisors to set rate, the initial write of 0xFF is
	 * to keep the divisor from being 0 which is not recommended as per
	 * the NS16550D spec sheet
	 */
	XUartNs550_WriteReg(UartNs550.BaseAddress, XUN_DLL_OFFSET, 0xFF);
	XUartNs550_WriteReg(UartNs550.BaseAddress, XUN_DLM_OFFSET,
				BaudMSB);
	XUartNs550_WriteReg(UartNs550.BaseAddress, XUN_DLL_OFFSET,
				BaudLSB);

	/*
	 * Clear the Divisor latch access bit, DLAB to allow nornal
	 * operation and write to the line control register
	 */
	XUartNs550_SetLineControlReg(UartNs550.BaseAddress, LcrRegister);

	return XST_SUCCESS;
}
