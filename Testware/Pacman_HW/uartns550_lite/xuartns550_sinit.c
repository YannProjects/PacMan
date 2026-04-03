/******************************************************************************
* Copyright (C) 2002 - 2021 Xilinx, Inc.  All rights reserved.
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/

/****************************************************************************/
/**
*
* @file xuartns550_sinit.c
* @addtogroup uartns550 Overview
* @{
*
* The implementation of the XUartNs550 component's static initialization
* functionality.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date	 Changes
* ----- ---- -------- -----------------------------------------------
* 1.01a jvb  10/13/05 First release
* 1.11a sv   03/20/07 Updated to use the new coding guidelines.
* 2.00a ktn  10/20/09 Updated to use HAL Processor APIs.
* 3.9   gm   07/09/23 Added SDT support
* 			 19/04/2024 SImplifications pour le test du HW Pacman
* </pre>
*
*****************************************************************************/

/***************************** Include Files ********************************/

#include <stdio.h>
#include <xstatus.h>
#include <xparameters.h>
#include <xuartns550_i.h>
#include <uart16550_stub.h>

/************************** Constant Definitions ****************************/

/**************************** Type Definitions ******************************/


/***************** Macros (Inline Functions) Definitions ********************/


/************************** Variable Definitions ****************************/

XUartNs550 UartNs550;		/* The instance of the UART Driver */

/************************** Function Prototypes *****************************/

/****************************************************************************/
/**
*
* Initializes a specific XUartNs550 instance such that it is ready to be used.
* The data format of the device is setup for 8 data bits, 1 stop bit, and no
* parity by default. The baud rate is set to a default value specified by
* XPAR_DEFAULT_BAUD_RATE if the symbol is defined, otherwise it is set to
* 19.2K baud. If the device has FIFOs (16550), they are enabled and the a
* receive FIFO threshold is set for 8 bytes. The default operating mode of the
* driver is polled mode.
*
* @param	InstancePtr is a pointer to the XUartNs550 instance .
* @param	DeviceId is the unique id of the device controlled by this
*		XUartNs550 instance. Passing in a device id associates the
*		generic XUartNs550 instance to a specific device, as chosen
*		by the caller or application developer.
*
* @return
*
* 		- XST_SUCCESS if initialization was successful
* 		- XST_DEVICE_NOT_FOUND if the device ID could not be found in
*		the configuration table
* 		- XST_UART_BAUD_ERROR if the baud rate is not possible because
*		the input clock frequency is not divisible with an acceptable
*		amount of error
*
* @note		None.
*
*****************************************************************************/
int XUartNs550_Initialize()
{

#ifdef UART_STUB
	uart_stub_init();
#endif

	int Status;

	/*
	 * Setup the data that is from the configuration information
	 */
	UartNs550.BaseAddress = (unsigned char *)XPAR_UARTNS550_0_BASEADDR;
	UartNs550.InputClockHz = XPAR_UARTNS550_0_CLOCK_HZ;

	UartNs550.SendBuffer.NextBytePtr = NULL;
	UartNs550.SendBuffer.RemainingBytes = 0;
	UartNs550.SendBuffer.RequestedBytes = 0;

	UartNs550.ReceiveBuffer.NextBytePtr = NULL;
	UartNs550.ReceiveBuffer.RemainingBytes = 0;
	UartNs550.ReceiveBuffer.RequestedBytes = 0;

	/*
	 * Indicate the instance is now ready to use, initialized without error
	 */
	UartNs550.IsReady = XIL_COMPONENT_IS_READY;

	/*
	 * Set the default Baud rate here, can be changed prior to
	 * starting the device
	 */
	Status = XUartNs550_SetBaudRate(XPAR_DEFAULT_BAUD_RATE);

	/*
	 * Set up the default format for the data, 8 bit data, 1 stop bit,
	 * no parity
	 */
	XUartNs550_SetLineControlReg(UartNs550.BaseAddress,
						XUN_FORMAT_8_BITS);

	/*
	 * Enable the FIFOs assuming they are present and set the receive FIFO
	 * trigger level for 8 bytes assuming that this will work best with most
	 * baud rates, enabling the FIFOs also clears them, note that this must
	 * be done with 2 writes, 1st enabling the FIFOs then set the trigger
	 * level
	 */
	XUartNs550_WriteReg(UartNs550.BaseAddress, XUN_FCR_OFFSET,
				XUN_FIFO_ENABLE | XUN_FIFO_RX_TRIG_MSB | XUN_FIFO_TX_RESET | XUN_FIFO_RX_RESET);

	return XST_SUCCESS;				
}
/** @} */
