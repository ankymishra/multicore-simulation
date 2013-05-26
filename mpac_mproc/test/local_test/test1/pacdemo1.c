#include "stdio.h"

int aaa = 999;

int main()
{
    int i = 0;
    int bbb = 222;
    
//    printf("aaa address.... 0x%08x\r\n", &aaa);
//    printf("bbb address.... 0x%08x\r\n", &bbb);
    
    while(1) {
    printf("pac application-1 sending.... \t\t%d\r\n", i++);
	my_mdelay(200);
	printf("pac application-1 running.... \t\t%d\r\n", i++);
    }
    return 0;
}
