/*
 * sort.h
 *
 *  Created on: Apr 20, 2020
 *      Author: akzhol
 */

#ifndef SRC_SORT_H_
#define SRC_SORT_H_
#include <xil_types.h>
#include <xil_io.h>

typedef struct Sort{
	u32 controlAddr;
	u32 statusAddr;
	u32 sortedAddr;
	u32 unsortedAddr;
}Sort;

int initIP(Sort* sort, u32 baseAddress);
void setControl(Sort* sort);
void writeUnsorted(Sort* sort, u32 array);
u32 getControl(Sort* sort);
u32 getStatus(Sort* sort);
u32 getSorted(Sort* sort);

#endif /* SRC_SORT_H_ */
