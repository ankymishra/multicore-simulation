#include "common.h"

void my_udelay(int n)
{
	while(n--)
	{};
}

void my_mdelay(int n)
{
//	int i;
//	for(i = 0; i < 10; i++) {
	n = n*10;
		while(n--)
		{};
//	}
}

void my_delay(int n)
{
	volatile int i, j;
	for(i = 0; i < 1000; i++) {
		for(j = 0; j < 500; j++) {
			while(n--)
			{};
		}
	}
}
