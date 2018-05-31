#include <stdio.h>
#include "platform.h"
#include <xparameters.h>
#include "xaxidma.h"

XAxiDma axiDMA;
XAxiDma_Config *axiDMA_cfg;

//DMA Addresses
#ifndef DDR_BASE_ADDR
#warning CHECK FOR THE VALID DDR ADDRESS IN XPARAMETERS.H, \
		 DEFAULT SET TO 0x01000000
#define MEM_BASE_ADDR		0x01000000
#else
#define MEM_BASE_ADDR		(DDR_BASE_ADDR + 0x1000000)
#endif

#define TX_BUFFER_BASE (MEM_BASE_ADDR + 0x00100000)
#define RX_BUFFER_BASE (MEM_BASE_ADDR + 0x00300000)

#define SIZE_ARR 8
int inStreamData[SIZE_ARR];

void initPeripherals()
{
	printf("Initializing AxiDMA\n");
	axiDMA_cfg = XAxiDma_LookupConfig(XPAR_AXI_DMA_0_DEVICE_ID);
	if (axiDMA_cfg)
	{
		printf("Checking Status...\n");
		int status = XAxiDma_CfgInitialize(&axiDMA,axiDMA_cfg);
		if(status != XST_SUCCESS)
		{
			printf("Error Initializing AXI DMA core\n");
		}
	}
	//Disable Interrupts
	XAxiDma_IntrDisable(&axiDMA, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(&axiDMA, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);
}


int main()
{
	printf ("Welcome:");
	//Pointers to DMA TX/RX addresses
	int *m_dma_buffer_TX = (int*) TX_BUFFER_BASE;
	int *m_dma_buffer_RX = (int*) RX_BUFFER_BASE;

	initPeripherals();

	//Do the Stream Calculation
	for (int idx = 0; idx < SIZE_ARR; idx++)
	{
		inStreamData[idx] = idx;
	}

	//Set Gain to 5 and start core
	while (1)
	{


	//Flush the cache of the buffers
	Xil_DCacheFlushRange((u32)inStreamData, SIZE_ARR*sizeof(int));
	Xil_DCacheFlushRange((u32)m_dma_buffer_RX, SIZE_ARR*sizeof(int));

	printf("Sending Data to IP core slave\n");
	XAxiDma_SimpleTransfer(&axiDMA,(u32)inStreamData,SIZE_ARR*sizeof(int),XAXIDMA_DMA_TO_DEVICE);
	while(XAxiDma_Busy(&axiDMA,XAXIDMA_DMA_TO_DEVICE)){printf("Stuck TX");};

	printf("Getting the Data\n");
	XAxiDma_SimpleTransfer(&axiDMA,(u32)m_dma_buffer_RX,SIZE_ARR*sizeof(int),XAXIDMA_DEVICE_TO_DMA);
	while(XAxiDma_Busy(&axiDMA,XAXIDMA_DEVICE_TO_DMA)){printf("Stuck RX");};

	//Invalidate
	Xil_DCacheInvalidateRange((u32)m_dma_buffer_RX,SIZE_ARR*sizeof(int));

	//Display Data
	for (int idx = 0; idx < SIZE_ARR; idx++)
		{
			printf("Recv[%d]=%d\n", idx,m_dma_buffer_RX[idx]);
		}
	return 0;
	}
}
