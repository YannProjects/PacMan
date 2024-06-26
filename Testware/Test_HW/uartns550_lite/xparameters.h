/******************************************************************************
* Copyright (C) 2002 - 2021 Xilinx, Inc.  All rights reserved.
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/

/*****************************************************************************/
/**
*
* @file xparameters.h
* @addtogroup common Overview
* @{
*
* This file contains system parameters for the Xilinx device driver environment.
* It is a representation of the system in that it contains the number of each
* device in the system as well as the parameters and memory map for each
* device.  The user can view this file to obtain a summary of the devices in
* their system and the device parameters.
*
* This file may be automatically generated by a design tool such as System
* Generator.
*
******************************************************************************/

/***************************** Include Files *********************************/

#ifndef XPARAMETERS_H    /* prevent circular inclusions */
#define XPARAMETERS_H    /* by using protection macros */

#ifdef __cplusplus
extern "C" {
#endif


/*****************************************************************************
 *
 * NS16550 UART defines.
 * DeviceID starts at 20
 */

#define XPAR_UARTNS550_0_BASEADDR    0x6000     /* UART base address */
#define XPAR_UARTNS550_0_CLOCK_HZ    18000000    /* Frequence horloge */
#define XPAR_DEFAULT_BAUD_RATE       9600       /* Baud rate / 100 (9600 bauds) */


#endif              /* end of protection macro */


/** @} */
