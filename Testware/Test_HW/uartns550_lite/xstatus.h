/******************************************************************************
* Copyright (c) 2002 - 2021 Xilinx, Inc.  All rights reserved.
* Copyright (C) 2022-2023, Advanced Micro Devices, Inc. All Rights Reserved. *
* SPDX-License-Identifier: MIT
******************************************************************************/

/*****************************************************************************/
/**
*
* @file xstatus.h
*
* @addtogroup common_status_codes Xilinx software status codes
*
* The xstatus.h file contains the Xilinx software status codes.These codes are
* used throughout the Xilinx device drivers.
*
* @{
******************************************************************************/

/**
 *@cond nocomments
 */

#ifndef XSTATUS_H		/* prevent circular inclusions */
#define XSTATUS_H		/* by using protection macros */

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/

/************************** Constant Definitions *****************************/

/*********************** Common statuses 0 - 500 *****************************/
/**
@name Common Status Codes for All Device Drivers
@{
*/
#define XST_SUCCESS                     0
#define XST_FAILURE                     1
#define XST_DEVICE_NOT_FOUND            2
#define XST_DEVICE_BLOCK_NOT_FOUND      3
#define XST_INVALID_VERSION             4
#define XST_DEVICE_IS_STARTED           5
#define XST_DEVICE_IS_STOPPED           6
#define XST_FIFO_ERROR                  7	/*!< An error occurred during an
						   operation with a FIFO such as
						   an underrun or overrun, this
						   error requires the device to
						   be reset */
#define XST_RESET_ERROR                 8	/*!< An error occurred which requires
						   the device to be reset */
#define XST_DMA_ERROR                   9	/*!< A DMA error occurred, this error
						   typically requires the device
						   using the DMA to be reset */
#define XST_NOT_POLLED                  10	/*!< The device is not configured for
						   polled mode operation */
#define XST_FIFO_NO_ROOM                11	/*!< A FIFO did not have room to put
						   the specified data into */
#define XST_BUFFER_TOO_SMALL            12	/*!< The buffer is not large enough
						   to hold the expected data */
#define XST_NO_DATA                     13	/*!< There was no data available */
#define XST_REGISTER_ERROR              14	/*!< A register did not contain the
						   expected value */
#define XST_INVALID_PARAM               15	/*!< An invalid parameter was passed
						   into the function */
#define XST_NOT_SGDMA                   16	/*!< The device is not configured for
						   scatter-gather DMA operation */
#define XST_LOOPBACK_ERROR              17	/*!< A loopback test failed */
#define XST_NO_CALLBACK                 18	/*!< A callback has not yet been
						   registered */
#define XST_NO_FEATURE                  19	/*!< Device is not configured with
						   the requested feature */
#define XST_NOT_INTERRUPT               20	/*!< Device is not configured for
						   interrupt mode operation */
#define XST_DEVICE_BUSY                 21	/*!< Device is busy */
#define XST_ERROR_COUNT_MAX             22	/*!< The error counters of a device
						   have maxed out */
#define XST_IS_STARTED                  23	/*!< Used when part of device is
						   already started i.e.
						   sub channel */
#define XST_IS_STOPPED                  24	/*!< Used when part of device is
						   already stopped i.e.
						   sub channel */
#define XST_DATA_LOST                   26	/*!< Driver defined error */
#define XST_RECV_ERROR                  27	/*!< Generic receive error */
#define XST_SEND_ERROR                  28	/*!< Generic transmit error */
#define XST_NOT_ENABLED                 29	/*!< A requested service is not
						   available because it has not
						   been enabled */
#define XST_NO_ACCESS			30	/* Generic access error */
#define XST_TIMEOUT                     31	/*!< Event timeout occurred */
#define XST_GLITCH_ERROR		32     /*!< Used when a glitch occurs*/

#define XIL_COMPONENT_IS_READY	1

/*********************** UART statuses 1051 - 1075 ***************************/
#define XST_UART

#define XST_UART_INIT_ERROR         1051L
#define XST_UART_START_ERROR        1052L
#define XST_UART_CONFIG_ERROR       1053L
#define XST_UART_TEST_FAIL          1054L
#define XST_UART_BAUD_ERROR         1055L
#define XST_UART_BAUD_RANGE         1056L


/**************************** Type Definitions *******************************/

typedef int XStatus;

/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/

#ifdef __cplusplus
}
#endif

#endif /* end of protection macro */

/**
 *@endcond
 */

/**
* @} End of "addtogroup common_status_codes".
*/
