/*
 * Sort.c
 *
 *  Created on: Apr 20, 2020
 *      Author: akzhol
 */
#include "sort.h"
int initIP(Sort* sort, u32 baseAddress){
	sort -> controlAddr = baseAddress;
	sort -> statusAddr = baseAddress+0x4;
	sort -> sortedAddr = baseAddress+0x8;
	sort -> unsortedAddr = baseAddress+0xC;
	return 0;
}

void setControl(Sort* sort){
	Xil_Out32(sort->controlAddr, 0x1);
}

void writeUnsorted(Sort* sort, u32 array){
	Xil_Out32(sort->unsortedAddr, array);
}
u32 getControl(Sort* sort){
	return Xil_In32(sort->controlAddr);
}

u32 getStatus(Sort* sort){
	return Xil_In32(sort->statusAddr);
}

u32 getSorted(Sort* sort){
	return Xil_In32(sort->sortedAddr);
}



