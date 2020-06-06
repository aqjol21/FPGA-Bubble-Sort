/*
 * mergeTest.c
 *
 *  Created on: Apr 20, 2020
 *      Author: akzhol
 */

#include "sort.h"
#include "xparameters.h"

int main(){
	Sort sort;
	initIP(&sort, XPAR_SORT_V1_0_0_BASEADDR);
	u32 unsortedArray[] = {7,2,9,3,5,13,1,5};
	u32 sortedArray[8];
	u32 status;

	for(int i=0;i<8;i++){
		writeUnsorted(&sort,unsortedArray[i]);
	}

	setControl(&sort);
	status=getStatus(&sort);
	while(!status){
			status=getStatus(&sort);
	}

	for(int i=0;i<8;i++){
		sortedArray[i]=getSorted(&sort);
		xil_printf("%d ", sortedArray[i]);
	}
}
