#include "stdcomm.h"
#include <stdio.h>

#define MSG_SIZE	16
int sc_my_address;

union c2cc_msg {
	int msg_word[4];
	char message[16];
};

#define min(a, b) (a > b ? b : a)

// 0 succ, -1 fail
static int sc_send_msg(const int address, union c2cc_msg *msg, int try_count) {
    /* The address of data MUST BE devideable by 4!*/
	while (TX_STATUS != 0) {
		if (try_count == 1) { /* Tried sending try_count times.*/
			return -1;
		} else /* There are still attempts left.*/
			if (try_count>1) try_count--;
	}
	
	/* Transmitter ready, we can send.*/
	TX_MESSAGE_0 = msg->msg_word[0];
	TX_MESSAGE_1 = msg->msg_word[1];
	TX_MESSAGE_2 = msg->msg_word[2];
	TX_MESSAGE_3 = msg->msg_word[3];
	TX_CTRL = (address << 16) & 0xf0000;

	TX_SEND_TRIG = 1;
	return 0;
}

int sc_send(const int address, const void *data, const int size)
{
    int i, ret;
    union c2cc_msg msg;
//printf("send message begin...\n");
    while(size > 0){
    	int len = min(MSG_SIZE, size);
    	memcpy(msg.message, data, len);
	data += MSG_SIZE;
	size -= MSG_SIZE;
	
	ret = sc_send_msg(address, &msg, -1);
	if (ret != 0) {
		printf("sc_send error.\r\n");
		return ret;
	}
    };
//printf("send message finish...\n");
    return size;
}

// 0 succ, -1 fail
static int sc_receive_word(union c2cc_msg *msg, int try_count) {
    /* The address of data MUST BE devideable by 4!*/

    while (RX_STATUS != 2) {
        if (try_count == 1) {/* Tried receiving try_count times.*/
            return -1;
        } else /* There are still attempts left.*/
            if (try_count>1) try_count--;
    }
    
    /* Transmitter ready, we can send.*/
    msg->msg_word[0] = RX_MESSAGE_0;
    msg->msg_word[1] = RX_MESSAGE_1;
    msg->msg_word[2] = RX_MESSAGE_2;
    msg->msg_word[3] = RX_MESSAGE_3;
    RX_ACCEPT = 1;
     
    return 0;
}

int sc_receive(void *data, const int size)
{
    int i, ret;
    union c2cc_msg msg;
    char *p = data;

//printf("receive message begin...\n");
    while(size > 0) {
     	int len = min(MSG_SIZE, size);
	size -= len;
	
	ret = sc_receive_word(&msg, -1);
	if (ret == -1) {
		printf("sc_receive error.\r\n");
		return ret;
	}
    	memcpy(p, msg.message, len);
	p += len;
    };
//printf("receive message finish...\n");
    return size;
}
