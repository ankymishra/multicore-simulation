.include "mpeg2_decoder.inc"
.data
H264_STATUS_SUCCESS				=	0
H264_STATUS_ERROR				=	-1
H264_BITSTREAM_END				=	-5
.section .text, "ax", "progbits"
.align	4
.section 	.text
.proc	Mpeg2_interface
.global	Mpeg2_interface
{ nop 			     | moviu a7,0x24007500      | moviu d7,0x20100704       |nop                  | nop				}
{ nop 			     | sw d7,a7,0 	           | nop	                     |nop                  | nop				}
{ nop 			     | nop				           | nop	                     |nop                  | nop				}
{ b r7,dsp_main     | nop				           | nop	                     |nop                  | nop				}
{ nop  			     | nop				           | nop	                     |nop                  | nop				}
{ nop 			     | nop				           | nop	                     |nop                  | nop				}
{ nop 			     | nop				           | nop	                     |nop                  | nop				}
{ nop 			     | nop				           | nop	                     |nop                  | nop				}
{ nop    		     | nop				           | nop	                     |nop                  | nop				}
;
{ nop 			     | moviu a7,0x24007500      | moviu d7,0x20100728       |nop                  | nop				}
{ nop 			     | sw d7,a7,0 	           | nop	                     |nop                  | nop				}
{ trap 			     | nop				           | nop	                     |nop                  | nop				}
;
.endp	Mpeg2_interface



;----dsp_main-----
.proc	dsp_main
.global	dsp_main

dsp_main:
; Stack Pointer
{nop 			      | set_cpi cp1,1,0 		    | nop 				| nop 				  | nop				   }
{ nop  			      | nop 				        | nop 				| nop 				          | nop				   }
{ nop  			      | nop 				        | nop 				| nop 				          | nop				   }
{ nop  			      | nop 				        | nop 				| nop 				          | nop				   }
{ nop  			      | copy [cp1],a0 				| nop 				| nop 				          | nop				   }
{ nop  			      | nop 				        | nop 				| nop 				          | nop				   }
{ nop  			      | nop 				        | nop 				| nop 				          | nop				   }
;


{moviu sp3,STACKER_POINTER_ADDR | moviu sp, STACKER_POINTER_ADDR| nop   | moviu sp2,STACKER_POINTER_ADDR  | nop            }
; Establish tables

.if 0
;;***********************************
Initial:
{ movi r2, 0x1E168000 |	nop	|	nop	|	nop	|	nop	}
{ movi r3, 0x00000000 |	nop	|	nop	|	nop	|	nop	}
{ movi r4, 0x00000000 |	nop	|	nop	|	nop	|	nop	}
{ movi r5, 0x80000000 |	nop	|	nop	|	nop	|	nop	}
{ NOP |	nop	|	nop	|	nop	|	nop	}

CONFIG_TIMER:
;Configure Timer
;{	sw r3, r2, 0x04	|	nop	|	nop	|	nop	|	nop	}     ;;CPP Control, Set TIMER MODE
;{	sw r4, r2, 0x08	|	nop	|	nop	|	nop	|	nop	}   ;;Preload Register = 0
;{	sw r5, r2, 0x00	|	nop	|	nop	|	nop	|	nop	}     ;;Enable Timer
{ moviu r13,0x1c000000 |	nop	|	nop	|	nop	|	nop	}
;{ lw r15, r2, 0x10  |	nop	|	nop	|	nop	|	nop	}
{ nop |	nop	|	nop	|	nop	|	nop	}
{ nop |	nop	|	nop	|	nop	|	nop	}
;{ sw r15,r13,0 |	nop	|	nop	|	nop	|	nop	}
{ nop |	nop	|	nop	|	nop	|	nop	}
;;************************************************************
.endif


{ b r5, init_tables   |moviu d0,Init_table_ADDR     | nop               | nop                         | nop                }
{addi sp3,sp3,(-8)    |addi sp,sp,(-8)              |moviu d1,Entropy_table_ADDR|addi sp2,sp2,(-8)    | nop                }
{ nop                 | sw d0, sp,0                 | nop 				| nop                         | nop				   }
{ clr r0			  | sw d1, sp,4	                | nop 				| nop 				          | nop				   }
{ nop                 | nop 			            | nop 				| nop 				          | nop				   }
{ nop  			      | nop 				        | nop 				| nop 				          | nop				   }
;


;{ trap              | nop                                       | nop                                  | nop                                      | nop                               }



;{ nop 			      | copy a5,[cp0] 				| nop                  | nop                      | nop				     }
;{ bdr r7		      | bdt a5 				        | nop 				   | nop 				      | nop				   }
;{ nop  			      | nop 				        | nop 				   | nop 				      | nop				   }
;{ br r7			      | nop                         | moviu d0,0x1e003500  | nop                      | nop				     }
;{ nop 			      | moviu a5,GLOBAL_POINTER_ADDR| moviu d1,0x1e003800  | nop                      | nop				     }
;{ nop 			      | dsw d0,d1,a5,Print_Start_ADDR | nop                | nop                      | nop				     }
;{ nop 			      | nop      				    | nop                  | nop                      | nop				     }
;{ nop 			      | nop  	         	        | nop                  | nop                      | nop				     }
;{ nop  			      | nop 				        | nop 				   | nop 				      | nop				   }
;;********************************************


{addi sp3,sp3,8       | addi sp,sp,8                | nop 				| addi sp2,sp2,8              | nop				   }
; Dsp main loop
_main_loop:
;;while((bs.Mpeg2BitStreamSize + bs.ByteLeft + bs.LastLength) && (shead.start_code!=sequence_end_code))


{ nop 			     | moviu a7,BitStream_ADDR | nop 			      | moviu a7,Sequence_header_ADDR | nop		          }
{ nop 			     | lw d0,a7,H264BitStreamSize  | nop 			  | lbu	d0,a7,start_code	 | nop		              }
{ nop 			     | lw d1,a7,ByteLeft       | nop 			      | nop 			         | nop		              }
{ nop 			     | lhu d2,a7,LastLength	   | nop 			      | nop 			         | nop		}
{ nop 			     | nop                     | nop 			      | seqiu d1,p0,p1,d0,sequence_end_code | nop         }
;p1=1 >> start_code!=sequence_end_code
{ nop 			     | nop                     | add ac7,d0,d1        | nop                      | nop     }
{ nop 			     | nop 				       | add ac7,ac7,d2       | nop                      | nop		}
{ nop 			     | nop			           | seqiu ac0,p0,p2,ac7,0| nop                      | nop		}
;p2=1 >> (bs.Mpeg2BitStreamSize + bs.ByteLeft + bs.LastLength))!=0
{ nop 			     | andp p3,p1,p2 		   | nop 			      | nop 				     | nop	   }
{ nop 			     | notp p3,p3 			   | nop 		          | nop 				     | nop		}
{(p3)b _decode_end   | nop 				       | nop 				  | nop 				     | nop	   }
{ nop 			     | nop 				       | nop 				  | nop 				     | nop				   }
{ nop 			     | nop 				       | nop 				  | nop 				     | nop				   }
{ nop 			     | nop 				       | nop 				  | nop 				     | nop				   }
{ nop 			     | nop 				       | nop 				  | nop 				     | nop				   }
{ nop                | moviu a7,Sequence_header_ADDR | nop            | nop                      | nop              }


;
;Start to decode Mpeg2 bitstream!!
;;* Error_temp=shead.Error_flag;
;;* if(shead.Error_flag!=0)
;;*    shead.Error_flag=0;
;;* shead.start_code=Next_start_code(&bs,&shead);\
;_Error_resistence:
;;*	if(Error_temp!=0){
;;%% (p2==1)
;;*	  while(shead.start_code!=picture_start_code && shead.Error_flag==0)
;;%% while(p6 && p4)
;;	*      shead.start_code=Next_start_code(&bs,&shead);
;;	*	shead.Error_flag=0;
;;	}
;cluster 1: d0>>Error_temp, d2>>start_code, d1>>Error_flag




{ b r3,Next_start_code  | lbu d0,a7,Error_flag | nop                  | moviu a7,Sequence_header_ADDR | nop             }
{ nop                | lbu d2,a7,start_code 	  | nop                  | nop                      | nop	               }
{ moviu r6,BitStream_ADDR | moviu a6,BitStream_ADDR | nop             | moviu a6,BitStream_ADDR  | nop                  }
{ nop 			      | nop 				        | seqiu ac7,p0,p13,d0,0 | moviu d3,0 				    | nop	               }
{ nop 	            | copy d1,d0              | nop 		             | (p13)sb d3,a7,Error_flag  | nop	               }
{ nop                | nop                     | nop                  | nop                      | nop                  }
;p13=1,d3=0 >>Error_temp!=0


.if 0
test_456:
{br r5                 | nop                                 | nop                             | nop                             | nop                            }
{nop                 | nop                                 | nop                             | nop                             | nop                            }
{nop                 | nop                                 | nop                             | nop                             | nop                            }
{nop                 | nop                                 | nop                             | nop                             | nop                            }
{nop                 | nop                                 | nop                             | nop                             | nop                            }
{nop                 | nop                                 | nop                             | nop                             | nop                            }
.endif




.if 1
;--------------------------------------------------
;(bs.Mpeg2BitStreamSize + bs.ByteLeft + bs.LastLength))==0
{ nop 			     | moviu a5,BitStream_ADDR | nop 			      | nop| nop		          }
{ nop 			     | lw d0,a5,H264BitStreamSize  | nop 			  | nop	 | nop		              }
{ nop 			     | lw d1,a5,ByteLeft       | nop 			      | nop 			         | nop		              }
{ nop 			     | lhu d2,a5,LastLength	   | nop 			      | nop 			         | nop		}
{ nop 			     | nop                     | nop 			      | nop | nop         }
{ nop 			     | nop                     | add ac7,d0,d1        | nop                      | nop     }
{ nop 			     | nop 				       | add ac7,ac7,d2       | nop                      | nop		}
{ nop 			     | nop			           | seqiu ac0,p1,p0,ac7,0| nop                      | nop		}
{(p1)b _decode_end   | nop 	             	   | nop 			      | nop 				     | nop	   }
{ nop 			     | nop 			           | nop 		          | nop 				     | nop		}
{ nop 			     | nop 				       | nop 				  | nop 				     | nop				   }
{ nop 			     | nop 				       | nop 				  | nop 				     | nop				   }
{ nop 			     | nop 				       | nop 				  | nop 				     | nop				   }
{ nop 			     | nop 				       | nop 				  | nop 				     | nop				   }
;-----------------------------------------------------
.endif

.if 0 
test_456:
{br r5                 | nop                                 | nop                             | nop                             | nop                            }
{nop                 | nop                                 | nop                             | nop                             | nop                            }
{nop                 | nop                                 | nop                             | nop                             | nop                            }
{nop                 | nop                                 | nop                             | nop                             | nop                            }
{nop                 | nop                                 | nop                             | nop                             | nop                            }
{nop                 | nop                                 | nop                             | nop                             | nop                            }
.endif



_Error_resistence:
{ nop 	            |(p13)lbu d1,a7,Error_flag | nop 	                | moviu a7,Sequence_header_ADDR | nop	               }
{ nop                | nop                     | nop 				       | (p13)lbu d0,a7,start_code | nop                  }
{ nop 	            | nop                     | nop 	                | nop                      | nop	               }
{ notp p9,p0          | nop                     | nop                  | nop                      | nop	               }
{ nop    	      | (p13)seqiu d2,p0,p4,d1,1 | nop 				       | (p13)seqiu d1,p1,p6,d0,picture_start_code | nop  }
{ (p13)andp p9,p4,p6 	| nop				           | nop 				       | nop 				          | nop	               }

;p4=1 >>p2=1:Error_flag=0 >> p3=1:head.start_code!=picture_start_code && !shead.Error_flag
{ (p9)b r3,Next_start_code | nop 				  | nop 				       | nop 				   | nop		}
{ nop 			      | moviu a7,Sequence_header_ADDR | nop            | nop                | nop		}
{ nop                | lbu d2,a7,start_code 	  | nop                  | nop                | nop	   }
{ nop 			      | lbu d1,a7,Error_flag 	  | nop                  | nop                | nop	   }
{(p9)moviu r6,BitStream_ADDR | nop 				  | nop 				       | nop 				   | nop	   }
{ nop 			      | moviu a6,BitStream_ADDR | nop 				       | moviu a6,BitStream_ADDR | nop	   }
;;
{ (p9)b _Error_resistence | nop 				     | nop 				       | nop 				   | nop		}
{ nop 			      | nop 				        | nop 				       | nop 				   | nop	   }
{ nop 			      | nop 				        | nop 				       | nop 				   | nop	   }
{(p9)moviu r6,BitStream_ADDR | nop 				  | nop 				       | nop 				   | nop	   }
{ nop 			      | moviu a7,Sequence_header_ADDR | nop 				 | moviu a7,Sequence_header_ADDR | nop }
{ nop 			      | moviu d6,0 				  | nop 				       | nop 				   | nop	   }
;
{ nop                | (p2) sb d6,a7,Error_flag| nop 		             | nop 				   | nop		}

;end of _Error_resistence
;;*switch(shead.start_code){
;;*			case sequence_start_code:
;           % p1
;;*				Sequence_header(&bs,&shead,&itable);
;;*				break;
;;*			case extension_start_code:
;           % p2
;;				buffer=(unsigned char)(readbits(&bs,4,&shead));
;;			//******identify whom the extension is belong to
;; 			switch(buffer){
;;					case 0x1:
;;						Sequence_extension(&bs,&shead,&sext);
;;						break;
;;					case 0x3:
;;						Quant_matrix_extension(&bs,&shead);
;;						break;
;;					case 0x8:
;;						Picture_coding_extension(&bs,&shead,&gop,&pdata);
;;						break;
;;				}
;;				break;
;;*			case GOP_start_code:
;           % p3
;;*				   GOP_header(&bs,&gop,&shead);
;;*				break;
;;*			case picture_start_code:
;           % p4
;;*			   Picture_header(&bs,&shead,&gop,&pdata);
;;				MB_run=0;
;;*				break;
;;			   default:
;                 % p5= ! (p1 | p2 | p3 | p4)
;;*				   if(shead.start_code>=slice_start_code_low && shead.start_code<=slice_start_code_high)
;;* 					  Slice(&bs,&shead,&gop,&pdata,&itable,&sdata,&Fmem);
;;		}
_decode_start:
{ nop 			      | lbu d0,a7,start_code    | nop 				       | nop 				  | nop				   }
{ nop 			      | nop 			           | nop 				       | nop 				  | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				  | nop	            }
{ nop 			      | nop 				        | seqiu ac7,p1,p0,d0,sequence_start_code  | nop | nop	   }
{ nop                | nop                     | seqiu ac6,p2,p0,d0,extension_start_code | nop | nop	   }
{ nop                | nop                     | seqiu ac5,p3,p0,d0,GOP_start_code       | orp p5,p1,p2 | nop }
{ (p1)b _seq_header_decode | nop               | seqiu ac4,p4,p0,d0,picture_start_code   | nop | nop	   }
{ (p2)b _ext_header_decode | nop 		        | orp p6,p3,p4	       | nop               | nop	            }
{ (p3)b _gop_header_decode | nop 		        | orp p5,p5,p6 	       | nop 				  | nop				   }
{ (p4)b _pic_header_decode | nop 		        | notp p5,p5	          | nop 				  | nop				   }
{ (p5)b _slice_decode      | nop 	           | nop                  | nop 			     | nop				   }
{ nop                | (p5) moviu d4,slice_start_code_low | nop 	    | nop 		 | nop				   }
{ nop                | (p5) moviu d5,slice_start_code_high | nop 	    | nop 		 | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				  | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				  | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				  | nop				   }
;
;The decoding procedure is over!!
_decode_end:
{ moviu r3,2  	      | moviu a7,GLOBAL_POINTER_ADDR | nop 				 | moviu a7,Picture_data_ADDR| nop				      }
{ nop                 | copy a5,[cp0]	        | nop 				       | lbu d1,a7,IP_frame_retain| nop				      }
{ moviu sr13,3 		| lw d0,a7,Ref_Back_ADDR  | nop 				       | moviu a6,GLOBAL_POINTER_ADDR| nop     }
_ccr_test:
;{ test p1,p2,2,2     | copy sp,[cp1] 		              | nop 				       | lw d0,a6,Memcpy_Mode     | nop				      }
{ nop                 | copy sp,[cp1]                         | nop                                    | lw d0,a6,Memcpy_Mode     | nop                               }
;{(p2)b _ccr_test     | nop 				        | nop 				       | nop 				          | nop				      }
{ nop                 | nop                                     | nop                                  | nop                                      | nop                               }
{ bdr r7             | bdt a5                   | nop 				       | nop                      | sgtiu ac7,p3,p0,d1,0	}
{ nop 			      | sw d0,a7,Ref_Copy_ADDR  | nop 				       |(p3)ori d2,d0,0x00010000  | nop				      }
{ nop 			      | nop 		              | nop 				       |(p3)sw d2,a6,Memcpy_Mode  | nop				      }
{ bdr sp3		      | bdt sp 				        | nop 				       | bdr sp2			          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;

;****timer setting*****
{ movi r2, 0x1E168000 |	nop	|	nop	|	nop	|	nop	}
{ moviu r13,0x1c000004 |	nop	|	nop	|	nop	|	nop	}
;{ lw r15, r2, 0x10  |	nop	|	nop	|	nop	|	nop	}
{ nop |	nop	|	nop	|	nop	|	nop	}
{ nop |	nop	|	nop	|	nop	|	nop	}
;{ sw r15,r13,0 |	nop	|	nop	|	nop	|	nop	}
{ nop |	nop	|	nop	|	nop	|	nop	}
;************************

;**********for ESL
;{ trap 			     | nop 				        | nop 				| nop 				          | nop				   }
;*************************************

{ br r7 		     | moviu d0,0x5566  	        | nop 				| nop 				          | nop				   }
{ nop 			     | moviu a2,0x07fffffc	        | nop 				| nop 				          | nop				   }
;{ nop 			     | sw d0,a2,0			        | nop 				| nop 				          | nop				   }
{ nop 			     | nop 				        | nop 				| nop 				          | nop				   }
{ nop 			     | nop 				        | nop 				| nop 				          | nop				   }
{ nop 			     | nop 				        | nop 				| nop 				          | nop				   }
{ nop 			     | nop 				        | nop 				| nop 				          | nop				   }
;


;;*case sequence_start_code:
;;* Sequence_header(&bs,&shead,&itable);
;;* break;
_seq_header_decode:
{ b r7,Sequence_header | moviu d0,BitStream_ADDR | nop                  | nop                         | nop              }
{ addi sp3,sp3,(-12) | addi sp,sp,(-12)        | moviu d1,Sequence_header_ADDR | addi sp2,sp2,(-12)   | nop }
{ nop 			      | sw d0,sp,0             | moviu d2,Init_table_ADDR | nop                       | nop }
{ nop 			      | sw d1,sp,4	           | nop                    | nop 				          | nop				   }
{ nop 			      | sw d2,sp,8   		   | nop 	                | nop 				          | nop				   }
{ nop 			      | nop 				   | nop                    | nop 				          | nop				   }
;
{ nop                | lw d8,a1,horizontal_size| nop                  | lw d5,a1,Image_size      | nop              }
{b _main_loop        | addi sp,sp,12           | nop 	                | addi sp2,sp2,12          | nop				  }
{ addi sp3,sp3,12    | lw d5,a1,Image_size     | nop 	                | moviu a5,GLOBAL_POINTER_ADDR| nop			   }	
{ nop 			      | nop                     | add ac6,d8,d8 	    | nop 				          | add ac5,d5,d5	   }
{ nop 			      | moviu a3,GLOBAL_POINTER_ADDR| add ac7,ac6,d8 	 | nop 				          | add ac5,ac5,d5	   }
{ nop 			      | sw d5,a3,YSize 			  | srli d9,ac7,1 	    | nop 				          | srli d5,ac5,1	   }	
{ nop 			      | sw d9,a3,FrameWidth_Multi| nop                 | sw d5,a5,Frame_Size_420  | nop				   }
;
_ext_header_decode:



;;*   case extension_start_code:
;;*		buffer=(unsigned char)(readbits(&bs,4,&shead));
;;			//******identify whom the extension is belong to
;;* 			switch(buffer){
;;*					case 0x1:
;               %% p1
;;*						Sequence_extension(&bs,&shead,&sext);
;;*						break;
;;*					case 0x3:
;               %% p2
;;*						Quant_matrix_extension(&bs,&shead,&init);
;;*						break;
;;*					case 0x8:
;               %% p3
;;*						Picture_coding_extension(&bs,&shead,&gop,&pdata,&itable,&sdata,&sdata2);
;;*						break;
;;*				}
;;*				break;
{ b r1,_readbits     | moviu d0,4 			     | nop                  | nop 		                | clr ac2				}
{ nop 			      | moviu a6,BitStream_ADDR | nop 		             | moviu a6,BitStream_ADDR  | nop			      }
{ moviu r6,BitStream_ADDR | nop 		           | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop                     | nop 				       | nop                      | nop               }
{ moviu r14,Sequence_header_ADDR | nop 		  | nop 			 	       | nop 				          | nop				   }
;;cluster1:
;;d1>> Sequence_header_ADDR, d0>>bitsz, d9>>Sequence_ext_ADDR, d11>> Init_ADDR
; ,d2>>GOP_header_ADDR, d3>>Picture_data_ADDR, d8>>BitStream_ADDR
{ addi sp3,sp3,(-28) | addi sp,sp,(-28)        | moviu d1,Sequence_header_ADDR | addi sp2,sp2,(-28) | nop }
{ (p9)sb r13,r14,Error_flag | moviu d2,GOP_header_ADDR| moviu d8,BitStream_ADDR   | nop          | nop }
{ nop 			      | moviu d3,Picture_data_ADDR | moviu d9,Sequence_ext_ADDR | nop             | nop }
{ nop 			      | sw d8,sp,0              | seqiu ac7,p1,p0,d5,1 | nop                      | nop }
{ (p1)b r7,Sequence_extension | moviu d11,Init_table_ADDR | seqiu ac7,p2,p0,d5,3 | nop           | nop }
{ (p2)b r7,Quant_matrix_extension | nop        | seqiu ac7,p3,p0,d5,8 | nop                      | nop }
{ nop                |(p2)sw d11,sp,8          | nop             | nop                      | nop	}
{(p3)b r7,Picture_coding_extension | sw d1,sp,4 	| nop 				       | nop 				          | nop	}
{ nop                 | (p1)sw d9,sp,8 		  | nop 				       | nop 				          | nop }
{ nop 			      | (p3)sw d2,sp,8 		     | nop 				       | nop 				          | nop	}
;(p1)
{ nop 			      | (p3)sw d3,sp,12 		  |(p3)moviu d4,Slice_data0_ADDR| nop   				    | nop }
;(p2)
{ nop 			      | (p3)sw d4,sp,16 		  |(p3)moviu d5,Init_table_ADDR | moviu d0,Slice_data1_ADDR   | nop }
{ nop 			      | (p3)sw d5,sp,20 		  | nop 				       |(p3)sw d0,sp2,24          | nop }

;
{ b _main_loop       | nop                     | nop                  | nop              | nop              }
{ addi sp3,sp3,28    | addi sp,sp,28           | nop 	                | addi sp2,sp2,28  | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				  | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				  | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				  | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				  | nop				   }
;
_gop_header_decode:
;;*case GOP_start_code:
;;*   GOP_header(&bs,&gop,&shead);
;;*break;
{ b r7,GOP_header    | moviu d0,BitStream_ADDR | nop                  | nop              | nop              }
{ addi sp3,sp3,(-12) | addi sp,sp,(-12)        | moviu d1,Sequence_header_ADDR | addi sp2,sp2,(-12) | nop }
{ nop 			      | sw d0,sp,0              | moviu d2,GOP_header_ADDR | nop         | nop }
{ nop 			      | sw d1,sp,4	           | nop                  | nop 				  | nop				   }
{ nop 			      | sw d2,sp,8   			  | nop 	                | nop 				  | nop				   }
{ nop 			      | nop 				        | nop                  | nop 				  | nop				   }
;
{ b _main_loop       | nop                     | nop                  | nop              | nop              }
{addi sp3,sp3,12     | addi sp,sp,12           | nop 	                | addi sp2,sp2,12  | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				  | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				  | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				  | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				  | nop				   }
;
_pic_header_decode:
;;Picture_header(&bs,&shead,&gop,&pdata,&itable,&sdata,&sdata2);
{ nop                 | moviu d0,BitStream_ADDR | nop                       | nop                 | nop              }
{ b r7,Picture_header | nop                     | moviu d8,GOP_header_ADDR  | moviu d1,Sequence_header_ADDR | nop    }
{ addi sp3,sp3,(-28)  | addi sp,sp,(-28)        | nop                       | addi sp2,sp2,(-28) | nop }
{ nop 			      | sw d0,sp,0	            | moviu d3,Picture_data_ADDR| sw d1,sp2,4         | nop	}
{ nop 			      | sw d8,sp,8   			| moviu d4,Slice_data0_ADDR | nop 				  | moviu d8,Slice_data1_ADDR}
{ nop 			      | sw d3,sp,12 		    | nop                       | sw d8,sp2,24   	  | moviu d5,Init_table_ADDR }
{ nop 			      | sw d4,sp,16 			| nop                       | sw d5,sp2,20  	  | nop				   }
;{ nop 			      | nop         			| nop 	                    | nop 				  | nop				   }
;

;;*****************Break_Point!!!!!!!!!
;{ nop 			      | nop 				        | nop 				       | nop 				          | orp p11,p11,p0}
;{ seqiu r11,p14,p0,r0,675| nop 	              | nop 				       | nop 				          | orp p15,p15,p0}
;{ andp p14,p14,p11 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p15,p14 		|(p14)moviu a7,0xb00a9000 | nop 				       | nop 				          | nop				      }
;{(p15)b _end4 	      | nop				           | nop 				       | nop		                | nop				      }
;{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p14)sw d5,a7,0         | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    | nop 				        | notp p15,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end4:
;;********************************************


;;*****************Break_Point!!!!!!!!!
;{ trap 	        | nop 				      | nop 				| nop 				  | nop				   }
;;********************************************

{ b _main_loop       | nop                     | nop                  | nop              | nop              }
{addi sp3,sp3,28     | addi sp,sp,28           | nop 	                | addi sp2,sp2,28  | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				  | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				  | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				  | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				  | nop				   }
;
_slice_decode:
;;void Slice(Bitstream *pbs,Seq_header *shead,GOP_data *gop,Picture_data *pdata,Init_table *itable
;;		   ,Slice_data *sdata,Slice_data *sdata2,Frame_memory *Fmem,Frame_memory *Fmem2){
;;*if(shead.start_code>=slice_start_code_low && shead.start_code<=slice_start_code_high)
;        %% p1 && p2
;;* 					  Slice(&bs,&shead,&gop,&pdata,&itable,&sdata,&Fmem,&etable);
;d0 >> start_code
;d9>> Sequence_header_ADDR, d10>Slice_data0_ADDR, d1>>GOP_header_ADDR,d11 >>Init_table_ADDR,d12<<Entropy_table_ADDR
;, d2>>Picture_data_ADDR, d8>>BitStream_ADDR,d4<<slice_start_code_low,d5<<slice_start_code_high

;sp : 0>>bitstream_addr, 4>>sequence_header, 8>>GOP_header, 12>>pic_data, 16>>Slice_data0, 20>>Init_table
;     24>>Entropy_table, 28>>Slice_data1, 32>>Frame_memory0, 36 >>Frame_memory1, 40>>Slice_data_op, 44>>Frame_memory_op
{ nop 			      | slt d1,p0,p1,d0,d4      | moviu d8,BitStream_ADDR  | moviu d0,Slice_data0_ADDR | nop	}
{ nop 			      | slt d1,p0,p2,d5,d0      | moviu d9,Sequence_header_ADDR | moviu d1,Init_table_ADDR | nop }
{ nop 			      | andp p3,p1,p2 		     | moviu d0,GOP_header_ADDR| moviu d2,Entropy_table_ADDR   | nop				   }
{ nop                 | moviu d1,Picture_data_ADDR | nop                   | nop                   | nop				}
{ nop            	  | addi a1,sp,(-48)         | nop                     | addi a1,sp2,(-48)      | nop				   }
{(p3)b r7,Slice       |(p3)sw d8,a1,0      	     | nop 				       |(p3)sw d0,a1,16 	   | nop				   }
{ addi sp3,sp3,(-48)  |(p3)sw d9,a1,4            | nop 				       |(p3)sw d1,a1,20	   | nop				   }
{ nop 			      |(p3)sw d0,a1,8 	         | nop 				       |(p3)sw d2,a1,24 	   | moviu d8,Frame_memory_ADDR }
{ nop 			      |(p3)sw d1,a1,12           | moviu d8,Slice_data1_ADDR |(p3)sw d8,a1,32     | moviu d3,Frame_memory1_ADDR}
{ nop 			      |(p3)sw d8,a1,28 			 | nop 	                   |  addi sp2,sp2,(-48) | nop				   }
{ nop 			      |    addi sp,sp,(-48)      | nop 	                   |(p3)sw d3,a1,36      | nop				   }
;



{ b _main_loop       | nop                     | nop                  | nop                      | nop              }
{ addi sp3,sp3,48   | addi sp,sp,48           | nop 	                | addi sp2,sp2,48          | nop				}
{ nop 			      | nop 				        | nop 	                | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 	                | nop 				          | nop				   }
;
;{ nop 			      | nop 				        | nop 	                | nop 				          | nop				   }
;;unsigned char Next_start_code(Bitstream *pbs,Seq_header *shead){
;;	int ret;
;;	unsigned int tmpbuffer = 0xffffffff, tmp=0;
;;_data_notready0:
;;		if(pbs->ByteLeft==0)
;;	   {//if(pbs->ByteLeft==0)
;;			ret = _refill_data(pbs);
;;			if(ret!=0)
;;			goto H264_NAL_Decode_exit;
;;		}//if(pbs->ByteLeft==0)
;//*********************************
;;		if(pbs->BitLeftInCache<24){  //this condition is not existed in c-code of h.264 decoder!!!
;;			pbs->DataCache = (pbs->DataCache<<8) | ((*pbs->BytePos++) & 0xff);
;;			pbs->ByteLeft--;
;;		}
;;		else
;;			pbs->BitLeftInCache-=8;
;//**********************************
;;		if((pbs->DataCache & 0xffffff) == 0x000001)
;;		{
;;			if(pbs->ByteLeft==0)
;;			{//if(pbs->ByteLeft==0)
;;				ret = _refill_data(pbs);
;;				if(ret!=0)
;;					goto H264_NAL_Decode_exit;
;;			}//if(pbs->ByteLeft==0)
;;			tmp = (*pbs->BytePos++) & 0xff;
;;			pbs->ByteLeft--;
;;			pbs->BitLeftInCache=0;
;;			ret = 0;
;;		}
;;		else
;;		{
;;			goto _data_notready0;
;;		}
;;H264_NAL_Decode_exit:;
;;		return tmp;
;;}
Next_start_code:
; cluster 1 -	d9:DataCache, a1:*BytePos, a6:pbitstream
; cluster 2 -  d8:ByteLeft, a6:pbitstream



{ nop 			      | nop                     | nop 				      | lw d8,a6,ByteLeft		    | nop				}
{ nop 			      | lw d9,a6,DataCache	     | nop		            | lbu d7,a6,BitLeftInCache  | nop				}
{ nop 			      | lw a1,a6,BytePos		  | clr ac2				   | nop  		                | nop				}
; p3==1, ByteLeft==0
; p4==1, ByteLeft!=0
; p7==1, find start code '0x000001'
; p8==1, do not find start code '0x000001'
_data_notready0:
;//*********************************
; % p4
;;		if(pbs->BitLeftInCache<24){  //this condition is not existed in c-code of h.264 decoder!!!
;     % p10
;;			pbs->DataCache = (pbs->DataCache<<8) | ((*pbs->BytePos++) & 0xff);
;;			pbs->ByteLeft--;
;;		}
;     % p11
;;		else
;;			pbs->BitLeftInCache-=8;
;//**********************************
;cluster1:  d9<<DataCache, a1<<BytePos
;cluster2: d8<<ByteLeft,d7<<BitLeftInCache
{ notp p10,p0 			| clr d8				        | notp p11,p0 			 | nop 	                   | seqiu ac0,p3,p4,d8,0	}
{(p3)b _data_notready1 | nop				        | clr d0 				    | nop                      | (p4)sltiu ac7,p10,p11,d7,24 }
{ nop                | (p10)lbu d8,a1,1+		  |(p10)slli ac0,d9,8    | (p10)addi d8,d8,(-1)	    | nop 				      }
{(p3)notp p15,p0	   | (p4)lbu d0,a1,0	        |(p11)copy ac0,d9 		 | (p11)addi d7,d7,(-8)	    | nop 				      }
{ nop 			      |(p3)sw d9,a6,DataCache	  | nop                  | nop                      | nop				   }
{ nop 			      | nop                     |(p10) or d9,d8,ac0    |(p11)sb d7,a6,BitLeftInCache  | nop 				      }
{ nop 			      | (p4)bdt d0 			     |(p4)andi ac0,d9,0xffffff| (p4)bdr d15		       | nop                  }
;;
;;		if((pbs->DataCache & 0xffffff) == 0x000001)
;;		{
;     % p7
;;			if(pbs->ByteLeft==0)
;;			{//if(pbs->ByteLeft==0)
;        % p1
;;				ret = _refill_data(pbs);
;;				if(ret!=0)
;;					goto H264_NAL_Decode_exit;
;;			}//if(pbs->ByteLeft==0)
;;			tmp = (*pbs->BytePos++) & 0xff;
;;			pbs->ByteLeft--;
;;			pbs->BitLeftInCache=0;
;;			ret = 0;
;;		}
;;		else
;      % p8
;;		{
;;			goto _data_notready0;
;;		}
;;H264_NAL_Decode_exit:;
;;		return tmp;
{ nop 			      | nop				           | seqiu ac7,p7,p8,ac0,0x000001| nop 			       | seqiu ac0,p1,p2,d8,0	}

;;*****************Break_Point!!!!!!!!!
;{ seqiu r11,p14,p0,r0,524| nop 	              | nop 				       | nop 				          | orp p15,p15,p0}
;{ andp p14,p14,p7 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p15,p14 		|(p14)moviu a7,0xb00a9000 | nop 				       | nop 				          | nop				      }
;{(p15)b _end2 	      | nop				           | nop 				       | nop		                | nop				      }
;{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p14)bdr d8              | nop 				       |(p14)bdt d8		          | nop				      }
;{ nop 			      |(p14)sw a1,a7,0          | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    |(p14)sw d5,a7,4	        | notp p15,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end2:
;;********************************************

{ (p8)b _data_notready0| nop 				        | andp p7,p7,p2		    | nop				          | andp p1,p1,p7		   }
{ (p1)b _data_notready1| (p7)addi a1,a1,1	     | (p7)clr d8			    | nop				          | nop	               }
{ (p7)br r3		      | (p7)sw a1,a6,BytePos	  | (p1)orp p15,p15,p0	 | (p7)moviu a5,Sequence_header_ADDR | nop	      }
{ nop 			      | nop			              | nop 				       | (p7)addi a7,d8,(-1)	    | nop		            }
{ nop 			      |(p1)sw d9,a6,DataCache   | nop 				       | (p7)sw a7,a6,ByteLeft	 | nop	               }
{ nop 			      | (p7)sb d8,a6,BitLeftInCache| nop 			       | nop                      | nop                  }
{ nop 			      | nop 				        | nop 				       | (p7)sb d15,a5,start_code | nop	               }
{ nop 			      | nop 				        | clr d5 				    | nop                      | nop 				      }
_data_notready1:
{  b r1,_load_bs_from_extmem| nop 			     | nop 				       | nop 				          | nop				}
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				}
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				}
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				}
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				}
{ nop 			      | nop 				        | nop 				       | nop 				          | nop 				}
;



{ nop                | nop				           | seqiu ac0,p1,p2,d5,H264_STATUS_SUCCESS |(p1)lbu d7,a6,BitLeftInCache	 | notp p14,p15	}

;;*****************Break_Point!!!!!!!!!
;{ seqiu r11,p11,p0,r0,15092| nop 	           | nop 				       | nop 				          | orp p12,p12,p0       }
;{ andp p11,p11,p12 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p12,p11 		| nop  				        | nop 				       | nop 				          | nop				      }
;{(p12)b _end1 	      | nop			              | nop 				       | nop 				          | nop				      }
;{ nop 			      | nop                     | nop 				       |(p11)notp p14,p15 			 | nop				      }
;{ nop 			      | nop                     | nop 				       |(p11)andp p14,p14,p1 		 | nop				      }
;{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;{(p11) moviu r3,1    | nop 				        | notp p12,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p11,p0 			 | nop 				          | nop				      }
;
;{ nop 			      | nop                     | nop 				       | moviu a7,0xb00a5004 		 | moviu d11,0x55667788	}
;{ nop 			      | nop                     | nop 				       |(p14)sw d11,a7,0 		    | nop				      }
;{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end1:
;;********************************************

{ (p2)br r3		     | (p1)lw a1,a6,BytePos	   | andp p15,p15,p1		 | clr d8                   | andp p14,p14,p1      }
{(p14)b _data_notready0 | nop				         | (p15)clr d8			 | (p1)lw d8,a6,ByteLeft    | nop		      }
{ nop               |(p15)sb d8,a6,BitLeftInCache| nop			       | nop		                | nop				}
{ (p15)br r3		  | (p15)lbu d8,a1,1+		   | nop 				    | nop                      | nop				}
{ nop 			     | (p15)sb a1,a6,BytePos	   | nop 				    | (p15)addi d8,d8,(-1)	    | nop				}
{ nop 			     | (p14)lw d9,a6,DataCache   | nop 			       | nop                      | nop				}
{ nop 			     | (p15)moviu a5,Sequence_header_ADDR | (p15)andi d8,d8,0xff |(p14)lbu d7,a6,BitLeftInCache | nop	}
;;(p14)
{ nop		           | (p15)sb d8,a5,start_code  | nop	                | nop 				          | nop 				}
{ nop 			     | nop				            | nop	                |(p15)sw d8,a6,ByteLeft    | nop				}
;
;;*****************Break_Point!!!!!!!!!
;{ trap 	        | nop 				      | nop 				| nop 				  | nop				   }
;;********************************************
;

.endp dsp_main
;------------------


;------utility.s
; -----------------------------------------------------------------------------
; subroutine : _load_bs_from_extmem (** pass parameters by pacdsp registers  **)
; Load h264 bitstream into StreamBuffer0/1
; Input :
; cluster 1 - a6 : pbs
; cluster 1 - a6 : pbs
; scalar - r6 : pbs
; Output :
; cluster 1 - d5 : return value
; return address : r1
; -----------------------------------------------------------------------------
.proc	_load_bs_from_extmem
.global	_load_bs_from_extmem
;int _refill_data(struct BitStream *pbs)
;{
;	if(pbs->LastLength!=0)
;	{//if(pbs->LastLength!=0)
;%% p2
;		if(pbs->CurrentBuffer==pbs->StreamBuffer0)
;		{
;				pbs->CurrentBuffer = pbs->BytePos = pbs->StreamBuffer1;
;		}
;		else
;		{
;				pbs->CurrentBuffer = pbs->BytePos = pbs->StreamBuffer0;
;		}
;		pbs->ByteLeft = pbs->LastLength;
;		pbs->LastLength = 0;
;	}//if(pbs->LastLength!=0)
;	else
;	{//if(pbs->LastLength==0)
;		if(pbs->CurrentBuffer==NULL)
;		{//if(pbs->CurrentBuffer==NULL)
;%% p1 & p3
;			memcpy(pbs->StreamBuffer0,pbs->H264BitStream,4096);
;			pbs->H264BitStream+=4096;
;			pbs->H264BitStreamSize-=4096;
;			pbs->CurrentBuffer = pbs->BytePos = pbs->StreamBuffer0;
;			pbs->ByteLeft = 2048;
;			pbs->BitLeftInCache = pbs->DataCache = 0;
;		}//if(pbs->CurrentBuffer==NULL)
;		else
;		{//if(pbs->CurrentBuffer!=NULL)
;			unsigned int tmp_length;
;%% p1 & p4
;			if(pbs->H264BitStreamSize==0)
;				return H264_BITSTREAM_END;
;			else if(pbs->H264BitStreamSize>2048)
;			{
;				tmp_length = 2048;
;			}
;			else
;			{
;				tmp_length = pbs->H264BitStreamSize;
;				pbs->LastLength = pbs->H264BitStreamSize;
;			}
;			memcpy(pbs->CurrentBuffer,pbs->H264BitStream,tmp_length);
;			pbs->H264BitStream+=tmp_length;
;			pbs->H264BitStreamSize-=tmp_length;
;			pbs->ByteLeft=2048;
;			if(pbs->CurrentBuffer==pbs->StreamBuffer0)
;			{
;				pbs->CurrentBuffer = pbs->BytePos = pbs->StreamBuffer1;
;			}
;			else
;			{
;				pbs->CurrentBuffer = pbs->BytePos = pbs->StreamBuffer0;
;			}
;		}//if(pbs->CurrentBuffer!=NULL)
;	}//if(pbs->LastLength==0)
;
;	return 0;
;}
;
_load_bs_from_extmem:


.if 0
{moviu r13,DSP0_DMA_BASE		| nop				| nop 				| nop				| nop				}
{lw r13,r13,DSP0_DMASR			| nop				| nop 				| nop				| nop				}
{nop					| nop				| nop 				| nop				| nop				}
{nop					| nop				| nop 				| nop				| nop				}
;{andi r13,r13,0x0000000f					| nop				| nop 				| nop				| nop				}
{seqiu r13,p0,p3,r13,0x00002222| nop				| nop 				| nop				| nop				}
{(p3)b _load_bs_from_extmem 	| nop				| nop 				| nop				| nop				}
{nop					| nop				| nop 				| nop				| nop				}
{nop					| nop				| nop 				| nop				| nop				}
{nop					| nop				| nop 				| nop				| nop				}
{nop					| nop				| nop 				| nop				| nop				}
{nop					| nop				| nop 				| nop				| nop				}
.endif



; scalar unit:
; r13: pacdsp1 dma base address, r6: *pbs, r9:H264BitStream, r10:CurrentBuffer, r11:tmp_length
; cluster 1 :
; a6:*pbs, d7: LastLength, d6:H264BitStreamSize, d4:H264BitStream, d0:tmp_length
; cluster 2:
; a6:*pbs, d7:CurrentBuffer
; p1==1, LastLength == 0
; p2==1, LastLength != 0
; p3==1, CurrentBuffer == NULL
; p4==1, CurrentBuffer != NULL
; p5==1, H264BitStreamSize == 0
; p6==1, H264BitStreamSize != 0
;; p7==1, H264BitStreamSize<=2048
; p8==1, H264BitStreamSize>2048
; p9==1, CurrentBuffer==StreamBuffer0
; p10==1, CurrentBuffer==StreamBuffer1






{ nop 			      | lhu  d7,a6,LastLength   | nop 				       | moviu a5,StreamBuffer0   | nop				}
{moviu r13,DSP0_DMA_BASE| nop				        | nop 				       | lw  d7,a6,CurrentBuffer  | nop				}
{ nop			         | lw  d6,a6,H264BitStreamSize| nop 			       | nop				          | nop				}
{ lw r9,r6,H264BitStream| nop				        | seqiu ac0,p1,p2,d7,0 | nop				          | nop				}
{(p2)b __LastLength_nz| nop				        | nop 				       | nop				          | seqiu ac0,p3,p4,d7,0	}
{ andp p3,p3,p1	   | lw d4,a6,H264BitStream  |seqiu ac0,p5,p6,d6,0	 | nop				          | andp p4,p4,p1		}
{ andp p5,p5,p4	   | nop 		       	     | sgti ac0,p8,p7,d6,StreamBufferSize | nop		    | seqiu ac0,p9,p10,d7,StreamBuffer0}
;; p5==1, LastLength == 0 && CurrentBuffer != NULL && H264BitStreamSize == 0
{ (p5)br r1		      |(p5)moviu d5,H264_BITSTREAM_END| andp p7,p7,p4	 | nop 			             | andp p8,p8,p4		}
;; p3==1, LastLength == 0 && CurrentBuffer == NULL
{(p3)b __CurBuf_null | (p7) sh d6,a6,LastLength| (p8)moviu d0,StreamBufferSize| nop 			    | nop				}
;; p4==1, LastLength == 0 && CurrentBuffer != NULL
{ (p4)bdr r10		   | nop 			           | (p7)copy d0,d6		 | (p4) bdt d7			       | nop				}
{ (p4)bdr r11		   | (p4)bdt d0		        | andp p9,p9,p4		    | nop 				          | andp p10,p10,p4		}
{(p4)moviu r15,0x00000007| nop		           | nop 				       | nop				          | nop				}
{(p4)slli r11,r11,12 | nop 			           | nop 				       | nop				          | nop				}
{(p4)or r15,r15,r11  | nop 			           | nop 			          | (p9)moviu a5,StreamBuffer1| nop				}
{ lw r12,r13,DSP0_DMASR| nop 			           | nop 				       |(p10)moviu a5,StreamBuffer0| nop				}
;
{ br r1			      | nop 				        | nop 				       | (p4)sw a5,a6,BytePos	    | nop				}
{ sw r9,r13,DSP0_DMASAR0| (p4)sub d6,d6,d0		  | nop 				       | (p4)sw a5,a6,CurrentBuffer| nop				}
{ sw r10,r13,DSP0_DMADAR0 | (p4)add d4,d4,d0	  | nop 				       | nop 				          | nop				}
{ sw r15,r13,DSP0_DMACTL0 | (p4)sw d6,a6,H264BitStreamSize| nop 			    | nop 				          | nop				}
{ sw r15,r13,DSP0_DMACLR0 | (p4)sw d4,a6,H264BitStream |(p4)moviu d15,StreamBufferSize| nop 		    | nop				}
{ sw r15,r13,DSP0_DMAEN0	 | (p4)sw d15,a6,ByteLeft  | moviu d5,H264_STATUS_SUCCESS| nop 			       | nop				}
__LastLength_nz:
{ br r1			      | nop 				        | nop 				       | (p9)moviu a5,StreamBuffer1| nop				}
{ nop 			      | nop 				        | nop 				       |(p10)moviu a5,StreamBuffer0| nop				}
{ nop 			      | nop 				        | nop 				       | sw a5,a6,BytePos		    | nop				}
{ nop 			      | nop 				        | nop 				       | sw a5,a6,CurrentBuffer	 | nop				}
{ nop 			      | sw d7,a6,ByteLeft		  | clr d15              | nop 		        	       | nop				}
{ nop 			      | sh d15,a6,LastLength 	  | moviu d5,H264_STATUS_SUCCESS| nop 			       | nop				}
__CurBuf_null:
; copy h264bitStream to StreamBuffer0 and StreamBuffer1
; r13: pacdsp1 dma base address, r9:H264BitStream
; p1==1, H264BitStreamSize > 2048
; p2==1, H264BitStreamSize <= 2048
; p3==1, H264BitStreamSize > 4096
; p4==1, 2048 < H264BitStreamSize <= 4096
{ sw r9,r13,DSP0_DMASAR0| moviu d10,0x00000007	  | sgtiu ac7,p1,p2,d6,2048| nop 				       | nop				}
{moviu r10,StreamBuffer0|(p1)addi d6,d6,(-2048)   |(p1)moviu d14,0x00800000| sw a5,a6,BytePos	    | clr d15				}
{ sw r10,r13,DSP0_DMADAR0| nop				      | (p2)slli d14,d6,12	 | nop 				          | nop				}
{ nop			         | or d10,d10,d14		     | sgtiu ac7,p3,p4,d6,2048| sw a5,a6,CurrentBuffer | nop				}
{ bdr r10 		      | bdt d10	 			     | andp p3,p3,p1		    | sb d15,a6,BitLeftInCache | andp p4,p4,p1		}
{ (p2)b Size_LT_2048 | (p2)clr d6			     | (p2)copy d15,d6		 | sw d15,a6,DataCache	    | nop				}
{ sw r10,r13,DSP0_DMACTL0	| (p3)addi d6,d6,(-2048)  |(p3)moviu d15,StreamBufferSize| nop 			    | nop				}
{ sw r10,r13,DSP0_DMACLR0	| (p4)copy d7,d6		     |(p4)moviu d15,StreamBufferSize| nop			       | nop				}
{ sw r10,r13,DSP0_DMAEN0	| (p4)clr d6			     | nop 				       | nop 				          | nop				}
; to polling dma0 status delay 2 cycles at least
{ nop 			      | sw d15,a6,ByteLeft	     | nop 				       | nop 				          | nop				}
{ nop 			      | sw d6,a6,H264BitStreamSize| nop 				    | nop 				          | nop				}
{ nop 			      |(p4) sh d7,a6,LastLength | nop 				       | nop 				          | nop				}
__wait_dma0:
{ lw r12,r13,DSP0_DMASR	   | moviu d10,0x00000007	  | nop				       | nop 				          | nop				}
{ nop 			      | nop 				        |(p3)moviu d14,0x00800000| nop 				       | nop				}
{ nop 			      | nop 				        |(p4)slli d14,d7,12	 | nop 				          | nop				}
{ andi r12,r12,0x0000000f | or d10,d10,d14		     | nop 				       | nop 				          | nop				}
{ seqiu r15,p1,p2,r12,0x00000002| nop 			  | nop 				       | nop 				          | nop				}
{ (p2)b __wait_dma0	| nop 				        | nop 				       | nop 				          | nop				}
{ (p1)addi r9,r9,StreamBufferSize| nop 		  | nop 				       | nop 			           	 | nop				}
{ (p1)sw r9,r13,DSP0_DMASAR0| nop 				        | nop 				       | nop 				          | nop				}
{ (p1)moviu r10,StreamBuffer1| nop			     | nop 				       | nop 				          | nop				}
{ (p1)sw r10,r13,DSP0_DMADAR0| nop 				        | nop 			          | nop 				          | nop				}
{ (p1)bdr r10		   | (p1)bdt d10			     | nop 				       | nop 				          | nop				}
;

;;*****************Break_Point!!!!!!!!!
;{ nop 			      | copy a5,[cp0] 				| nop                  | nop                      | nop				     }
;{ bdr r7		      | bdt a5 				        | nop 				   | nop 				      | nop				   }
;{ nop  			      | nop 				        | nop 				   | nop 				      | nop				   }
;{ br r7			      | nop                         | moviu d0,0x1e004000  | nop                      | nop				     }
;{ nop 			      | moviu a5,GLOBAL_POINTER_ADDR| moviu d1,0x1e004804  | nop                      | nop				     }
;{ nop 			      | dsw d0,d1,a5,Print_Start_ADDR | nop                | nop                      | nop				     }
;{ nop 			      | nop      				    | nop                  | nop                      | nop				     }
;{ nop 			      | nop  	         	        | nop                  | nop                      | nop				     }
;{ nop  			      | nop 				        | nop 				   | nop 				      | nop				   }
;;********************************************

{ br r1			      | nop				           | nop				       | nop				          | nop				}
{ sw r10,r13,DSP0_DMACTL0	| nop				           | nop 				       | nop				          | nop				}
{ sw r10,r13,DSP0_DMACLR0  | nop				           | nop 				       | nop				          | nop				}
{ sw r10,r13,DSP0_DMAEN0   | nop 				        | moviu d5,H264_STATUS_SUCCESS| nop		 	       | nop				}
{ nop			         | nop 				        | (p3)addi d4,d4,4096  | nop				          | nop				}
{ nop			         | (p3) sw d4,a6,H264BitStream | nop 			    | nop				          | nop				}
;
; H264BitStreamSize <= 2048
;
Size_LT_2048:
{ lw r12,r13,DSP0_DMASR	   | nop 				        | nop 				       | nop 				| nop				}
{ nop 			      | nop 				        | nop 				       | nop 				| nop				}
{ nop 			      | nop 				        | nop 			          | nop 				| nop				}
{ andi r12,r12,0x0000000f	   | nop 				        | nop 				       | nop 				| nop				}
{ seqiu r15,p1,p2,r12,0x00000002| nop 				        | nop 				       | nop 				| nop				}
{ (p2)b Size_LT_2048 | nop 				        | nop 				       | nop 				| nop				}
{ (p1)br r1		      | nop 				        |(p1)moviu d5,H264_STATUS_SUCCESS| nop 			| nop				}
{ nop 			      | nop 				        | nop 				       | nop 				| nop				}
{ nop 			      | nop				           | nop 				       | nop 				| nop				}
{ nop 			      | nop 				        | nop 				       | nop 				| nop				}
{ nop 			      | nop 				        | nop 				       | nop 				| nop				}
{ nop 			      | nop 				        | nop 				       | nop 				| nop				}
.endp	_load_bs_from_extmem
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; subroutine : _readbits (** pass parameters by pacdsp registers  **)
; read n bits from h264 bitstream (n<=16)
; Input :
; cluster 1 - a6:pbs, d0:bitz
; cluster 2 - a6:pbs, ac2:flag==0
; scalar - r6 : pbs
; Output :
; cluster 1 - d5:return value, d0:readbits
; return address : r1
; -----------------------------------------------------------------------------
.proc	_readbits
.global	_readbits
;// readbits
;int readbits(struct BitStream *pbs, unsigned char bitsz, char *readbits)
;{
;	int value, ret;
;	unsigned char tmp, i, flag=0;
;
;_readbit:
;
;	if(pbs->BitLeftInCache>=bitsz)
;	{//if(pbs->BitLeftInCache>=bitsz)
; %% p2 == 1
;		int i, masker = 0;
;
;		value = ((pbs->DataCache << (32-pbs->BitLeftInCache)) >> (32 - bitsz));
;
;		for(i=0;i<bitsz;i++)
;		{
;			masker = masker | (1 << i);
;		}
;
;		value = value & masker;
;		pbs->BitLeftInCache-=bitsz;
;		*readbits = bitsz;
;	}//if(pbs->BitLeftInCache>=bitsz)
;	else
;	{//if(pbs->BitLeftInCache<bitsz)
; %% p1 == 1
;		if(pbs->ByteLeft==0)
;		{//if(pbs->ByteLeft==0)
; %% p1 & p3
;			ret = _refill_data(pbs);
;
;			if(ret == H264_BITSTREAM_END)
;			{//if(ret == H264_BITSTREAM_END)
;
;				value = ((pbs->DataCache << (32-pbs->BitLeftInCache)) >> (32 - pbs->BitLeftInCache));
;				*readbits = pbs->BitLeftInCache;
;				pbs->BitLeftInCache = 0;
;				return value;
;
;			}//if(ret == H264_BITSTREAM_END)
;			else if(ret != H264_STATUS_SUCCESS)
;			{
;				*readbits = H264_STATUS_ERROR;
;				goto _readbit_exit;
;			}
;		}//if(pbs->ByteLeft==0)
;
; %% p1 & p4
;		tmp = (*pbs->BytePos++);
;		pbs->ByteLeft-=1;
;		pbs->DataCache = (pbs->DataCache << 8) | tmp;
;
;		if(((pbs->DataCache & 0xffffff) == 0x000003) && !flag)
;		{
;			flag = 1;
;			pbs->DataCache = pbs->DataCache >> 8;
;		}
;		else
;		{
;			pbs->BitLeftInCache+=8;
;		}
;
;		goto _readbit;
;
;	}//if(pbs->BitLeftInCache<bitsz)
;
;_readbit_exit:
;
;	return value;
;}

_readbits:
; scalar - r6 : pbs  ,return address : r1
; cluster1:
; a6:*pbs, d7:BitLeftInCache, d6:DataCache, d5:return value, d15:bitstream byte,d0:bitz
; cluster2:
; a6:*pbs, d7:ByteLeft,ac2:flag==0
; p1==1, BitLeftInCache<bitsz
; p2==1, BitLeftInCache>=bitsz
; p3==1, ByteLeft<=1
; p4==1, ByteLeft>1
; p7==1, Execute the general action to fetch the bitstream data!!
; p8==1, Execute the detection of which the MBs of slice are completely decoded!!
{ nop 			      |lbu d7,a6,BitLeftInCache | slli ac2,d0,16		 | nop 				          | seqiu ac7,p7,p8,ac2,0}
{ nop 			      | nop                     | nop				       | lw d7,a6,ByteLeft        | nop				      }
{ nop 			      | lw d6,a6,DataCache      | nop 				       | nop 				          |(p8)notp p4,p0			}
{ nop 			      | lw a3,a6,BytePos        | slt ac0,p1,p2,d7,d0	 | nop 				          |(p8)orp p3,p3,p0		}
{ (p2)b _readbit_exit| nop                     | (p2)sub d15,d7,d0	 | lw d15,a6,DataCache      |(p7)sgtiu ac0,p4,p3,d7,1  }
{ andp p3,p3,p1	   | addi d7,d7,16		     | (p2)or ac1,ac2,d15	 |lbu d5,a6,BitLeftInCache  | andp p4,p4,p1		   }
{(p3)b __ByteLeft_zero|(p4)lnw d15,a3,2+	     | (p2)extractu d5,d6,ac1 | (p2)lhu d14,a6,LastLength | (p4)addi d7,d7,(-2)}
{ nop	               | (p2)sb d15,a6,BitLeftInCache| (p4)slli d6,d6,16	| nop				          | slli d15,d15,8		   }
{ (p4)b _readbit_exit| (p4)sw a3,a6,BytePos    | (p4)sub d5,d7,d0		 | (p4)lhu d14,a6,LastLength|(p3)sgtiu ac0,p5,p6,d7,0}
{ nop			         | (p4)swap4e d15,d15	     | (p4)or ac1,ac2,d5	 | lw a7,a6,BytePos         |(p8)addi d7,d7,(-1)   }
{(p3)bdt r1 			| (p4)sb d5,a6,BitLeftInCache|(p4)srli d4,d15,16 |(p3)bdr d12 				    | andp p9,p5,p7		   }
{ nop 			      | nop				           | (p4)or d6,d6,d4		 |(p8)sw d7,a6,ByteLeft	    | andp p8,p5,p8		   }
;;(p3)
{ nop 			      | nop				           | (p4)extractu d5,d6,ac1 | (p4)sw d7,a6,ByteLeft	 | nop				      }
{ nop 			      | (p4)sw d6,a6,DataCache  | nop 				       | nop 				          | nop				      }
__ByteLeft_zero:
; p5==1, ByteLeft=1
; p6==1, ByteLeft=0
{(p6)b r1,_load_bs_from_extmem|(p6) copy d8,d0 | nop 				       | (p5)lbu d8,a7,0		    | (p9)clr d7			}
{ (p5)b _readbits	   | nop				           | nop 				       | (p9)sw d7,a6,ByteLeft	 | nop				      }
{ nop 			      | nop				           | nop 				       |(p8)addi a5,a7,1 			 | (p5)addi d5,d5,8		}
{ nop 			      | nop				           |  nop 				    |(p5)sb d5,a6,BitLeftInCache| (p5)or d8,d8,d15	}
{ nop 			      | nop				           | nop 				       |(p5)sw d8,a6,DataCache    | nop				}
{ nop 			      | nop 				        | nop 				       |(p8)sw a5,a6,BytePos 	    | nop				}
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				}
; default (p2==1 or p3==1): p6==0
{ bdr r1		         | nop				           |seqiu ac0,p3,p4,d5,H264_STATUS_SUCCESS| bdt d12  | nop				}
{ (p3)b _readbits	   | nop				           |seqiu ac0,p1,p2,d5,H264_BITSTREAM_END| nop		 | notp p6,p0			}
{ nop			         | (p3)copy d0,d8		     | (p1) clr d8			 |(p1)lbu d0,a6,BitLeftInCache| andp p2,p2,p4	}
; p2==1, ret != H264_STATUS_SUCCESS && ret !=H264_BITSTREAM_END
{ (p2)b _readbit_exit| (p1)lbu d0,a6,BitLeftInCache| (p1)moviu ac7,6	 | nop 				          | nop				}
{ nop			         | (p1)lw d10,a6,DataCache  | nop				       | nop 				          | nop				}
{ (p1)b _readbit_exit| (p1)sb d8,a6,BitLeftInCache|(p2) moviu d0,H264_STATUS_ERROR|nop           |(p1)slti ac7,p6,p0,d0,6}
{ nop 			      | (p6)moviu d0,6		     | (p6)sub ac7,ac7,d0	 | nop 				          | nop				}
{ nop 			      | (p1)slli d1,d0,16		  | (p1)copy ac0,d10		 | nop 				          | nop				}
{ nop 			      | nop				           | (p6)sll ac0,d10,ac7	 | nop 				          | nop				}
{ nop 			      | nop				           | (p1)extractu d5,ac0,d1	| nop 				       | nop				}
{ nop 			      | (p1)sw d5,a6,DataCache  | nop 				       | nop 				          | nop				}
;
_readbit_exit:
{ br r1 			      | nop                     | nop 				       | lw d12,a6,H264BitStreamSize | nop				  }
{ nop 			      | nop 	                 | nop 				       | lw d13,a6,ByteLeft 	    | nop				     }
{ nop 			      | nop                     | nop 				       | nop 				          | nop				     }
{ nop 			      | nop 				        | nop 				       | nop 				          | add ac7,d12,d14	  }
{ nop 			      | nop 				        | nop 		             | notp p9,p0 				    | add ac7,ac7,d13	  }
{ moviu r13,1 			| nop 				        | nop 		             | nop 				          | seqiu d12,p9,p0,ac7,0 }
.endp	_readbits
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; subroutine : _table_search (** pass parameters by pacdsp registers  **)
; read n bits from h264 bitstream (n<=16)
; Input :
; cluster 1 - a6:pbs, d0:bitz
; cluster 2 - a6:pbs, ac2:flag==0
; scalar - r6 : pbs
; Output :
; cluster 1 - d5:return value, d0:readbits
; return address : r1
; -----------------------------------------------------------------------------
.proc	_table_search
.global	_table_search
;unsigned char Table_Search(unsigned short cache,unsigned char cachesz
;						   ,cavld_lookup_table *entry,Seq_header *shead){
;	unsigned char bit_offset=0;
;	unsigned char clumpsz;
;	unsigned char count=0;
;	table=entry->coef_token;
;	clumpsz=entry->startbit;
;  count++;
;	pair=&table[(cache>>(cachesz-clumpsz)) & ((1<<clumpsz)-1)];
;	bit_offset=clumpsz;
;	if(pair->ptr.final)
;		bit_offset=(unsigned char)pair->ptr.bits;
;	else
;		bit_offset+=(unsigned char)pair->ptr.bits;
;	while(!pair->ptr.final){
;		if(count==entry->maxcomptimes){
;			shead->Error_flag=1;
;			pair->ptr.final=1;
;		}
;		else{
;			count++;
;			cachesz-=clumpsz;
;			clumpsz=(unsigned char)pair->ptr.bits;
;			pair=&table[pair->ptr.offset+((cache>>(cachesz-clumpsz)) & ((1<<clumpsz)-1))];
;			if(!pair->ptr.final)
;				bit_offset+=(unsigned char)pair->ptr.bits;
;			else if(clumpsz!=(unsigned char)pair->ptr.bits)
;				bit_offset-=(clumpsz-(unsigned char)pair->ptr.bits);
;		}
;	}
;	return bit_offset;
;}

;scalar: r1<<return address,r6 << *pbs,r13 <<Error_flag
;cluster1:d5<<cache, d15<<return value,d13 << cachesz,a2 << *entry,d2: pair[0..15],d14 << clumpsz,a3 << *table
;cluster2:a3<<BitLeft,a2 << *entry,ac2 << count

;;typedef union
;;{
;;	struct{
;;		unsigned short final  :  1;
;;		unsigned short bits   :  3;
;;		unsigned short offset :  12;
;;	}ptr;
;;	struct{
;;		unsigned short final  :  1;
;;		unsigned short bits   :  3;
;;		unsigned short val    :  6;
;;		unsigned short level  :  6;
;;	}value;
;;}COEF_TOKEN *pair;
_table_search:
;	*table=entry->coef_token;
;	*clumpsz=entry->startbit;
;  *count++;
;	*pair=&table[(cache>>(cachesz-clumpsz)) & ((1<<clumpsz)-1)];
;	*bit_offset=clumpsz;
;	*if(pair->ptr.final)
;      %p1
;	*	bit_offset=(unsigned char)pair->ptr.bits;
;	*else
;      %p2
;	*	bit_offset+=(unsigned char)pair->ptr.bits;
{ nop 			      | nop 			           | sub ac7,d13,d14 		 | nop 				          | addi ac2,ac2,1		   }
{ nop 			      | sll d8,d8,d14 		     | srl ac7,d5,ac7 		 | nop 				          | nop				      }
{ nop 			      | addi d8,d8,(-1) 		  | nop 			          | nop 				          | nop				      }
{ nop 			      | nop 		              | and d8,d8,ac7  		 | nop 				          | nop				      }
{ nop 			      | nop 		              | slli d8,d8,1  		 | nop 				          | nop				      }
{ nop 			      | addi a3,d8,2	           | nop                  | nop 				          | nop				      }
{ nop 			      | lhu d2,a2,a3 			  | copy d15,d14 			 | nop 				          | nop				      }
{ nop 			      | nop				           | copy ac5,d5 		    | nop 				          | nop				      }
{ nop 			      | nop 			           | nop                  | nop 				          | nop				      }
{ nop 	            | nop 				        | extractiu d8,d2,1,0  | lbu d1,a2,1 				 | nop				      }

;;*****************Break_Point!!!!!!!!!
;{ seqiu r15,p1,p2,r15,0x55667788| nop                     | nop 				       | nop 				          | nop				      }
;{(p2)b _end3         | nop                     | nop 				       | nop 				          | nop				      }E
;{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p1)moviu a7,0xb00a9000  | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p1)sw sp,a7,0         | nop 				       | nop 				          | nop				      }
;{(p1) moviu r3,1    |(p1)sw d2,a7,4		        | notp p2,p0			 | nop 				          | nop				      }
;{ nop 			      |(p1)sw a3,a7,8	        | notp p1,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end3:
;;********************************************

{ notp p6,p0 			| seqiu d9,p1,p2,d8,1 	  | extractiu ac6,d2,3,1 | nop 				          | nop				      }
{(p1)br r1 			   | notp p3,p0 			     | (p2)add d15,d15,ac6  | notp p4,p0 				    | nop				      }
;	while(!pair->ptr.final){
;;      % p2
;*		if(count==entry->maxcomptimes){
;;       % p3
;*			shead->Error_flag=1;
;*			pair->ptr.final=1;
;		}
;		else{
;;       % p4
;*			count++;
;*			cachesz-=clumpsz;
;*			clumpsz=(unsigned char)pair->ptr.bits;
;*			pair=&table[pair->ptr.offset+((cache>>(cachesz-clumpsz)) & ((1<<clumpsz)-1))];
;*			if(!pair->ptr.final)
;           % p5
;*				bit_offset+=(unsigned char)pair->ptr.bits;
;*			else if(clumpsz!=(unsigned char)pair->ptr.bits)
;           % p6 && p7
;*				bit_offset-=(clumpsz-(unsigned char)pair->ptr.bits);
;		}
;	}
;  % p1
;	return bit_offset;
_table_loop:
{ (p6)br r1 			| (p2)moviu d0,1          | (p2)extractiu ac4,d2,3,1 | nop   				    | (p2)seq ac7,p3,p4,ac2,d1}
{ (p3)br r1 	      | (p4)sub d13,d13,d14     | (p4)sll d0,d0,ac4    | nop 				          | (p4)addi ac2,ac2,1   }
{ (p3)moviu r13,1    | (p4)addi d0,d0,(-1)	  | (p4)sub ac7,d13,ac4  | nop 				          | nop				      }
{ nop 			      | (p4)extractiu d9,d2,12,4| (p4)srl d3,ac5,ac7   | nop 				          | nop                  }
{ nop 			      | (p4)and a3,d3,d0        | (p1)copy d15,ac6     | nop 				          | nop				      }
;;(p1)
{ nop 			      | (p4)add d8,a3,d9        |(p3)inserti d2,d0,1,0 | nop 				          | nop                  }
;;(p6)
{ nop 			      | nop 				        | (p4)slli d8,d8,1     | nop 				          | nop                  }
;;(p3)
{ nop 			      | (p4)addi a3,d8,2 		  |(p4)copy d14,ac4 		 | nop 				          | nop				      }
{ nop 			      | (p4)lhu d2,a2,a3 		  | nop 				       | nop 				          | nop				      }
{ notp p5,p0 			| notp p6,p0              |(p4)copy ac5,d5 		 | notp p7,p0 				    | nop				      }
{ (p2)b _table_loop  | nop				           | nop 				       | nop 				          | nop				      }
{ notp p5,p0 			| (p4)extractiu d10,d2,3,1 | nop 				    | nop 				          | nop				      }
{ nop 			      | (p4)seq d12,p0,p7,d14,d10 | (p4)extractiu ac6,d2,1,0| nop                 | nop				      }
{ notp p3,p0 			| (p7)sub d12,d14,d10 	  | (p4)seqiu ac7,p5,p6,ac6,0 | nop 				    | nop				      }
{ andp p8,p6,p7 		| (p5)add d15,d15,d10     | nop                  | andp p2,p5,p0 				 | nop				      }
{ notp p4,p0 			| (p8)sub d15,d15,d12 	  |  nop                 | notp p6,p2 				    | nop                  }
.endp	_table_search
;---------------------

;-----------GOP_header.s
.proc	GOP_header
.global	GOP_header
GOP_header:



;;void GOP_header(Bitstream *pbs,GOP_data *gop,Seq_header *shead){
;;	i=0;
;;	gop->time_code=(unsigned int)(readbits(pbs,25,shead)); //25bits
;;	gop->closed_gop =(unsigned char)(readbits(pbs,1,shead));   //1bit
;;	gop->broken_link=(unsigned char)(readbits(pbs,1,shead));   //1bit
;;	gop->field_count_flag=0;  //Initialize the field-flag which determines the top or bottom field pic
;;}
; a6: *pbitstream, a1: *shead, a2: *gop
;;	gop->time_code=(unsigned int)(readbits(pbs,25,shead)); //25bits
;;********************************
{ b r1,_readbits     | lw a6, sp, 0            | moviu d0,16          | lw a6,sp2,0              | clr ac2           }
{ lw r6,sp3,0        | lw a1, sp, 4            | nop                  | nop                      | nop               }
{ lw r14,sp3,4       | lw a2, sp, 8            | nop                  | nop                      | nop               }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
{ b r1,_readbits 	   | nop 	                 | clr ac6 		       | nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | slli ac6,d5,9 		 | nop 				          | nop				   }
{ nop 			      | nop 				        | moviu d0,9 			 | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 			          | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;;**********************************
;;	gop->closed_gop =(unsigned char)(readbits(pbs,1,shead));   //1bit
{ b r1,_readbits 	   | nop 	                 | moviu d0,1 		    | nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | or d4,ac6,d5 			 | nop 				          | nop				   }
{ nop 			      | sw d4,a2,time_code 	  | nop 			          | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 			          | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	gop->broken_link=(unsigned char)(readbits(pbs,1,shead));   //1bit
{ b r1,_readbits 	   | sb d5,a2,closed_gop 	  | moviu d0,1 		    | nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 			          | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 			          | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	gop->field_count_flag=0;
{ br r7			      | sb d5,a2,broken_link    | nop 				       | nop 				          | nop				   }
{ (p9)sb r13,r14,Error_flag | nop 				  | nop 				       | nop 				          | nop				   }
{ nop 			      | moviu d0,0 				  | nop 				       | nop 				          | nop				   }
{ nop 			      | sb d0,a2,field_count_flag | nop 			       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | clr d5			           | nop 				       | nop 				          | nop				   }
.endp	GOP_header
;----------------------------

;-----idct_23002
.proc	idct_23002_2
.global	idct_23002_2
idct_23002_2:
; a6: *itable, a4: *sdata
; a7: address of itable->scale[i]
; a3: address of sdata->QF[i]
; a5: address of sdata->block_in[i]

;p9>>p15 && p3 >>Mode=1
;p13>>p15 && p4 >>Mode=2
;p11>>p2 && p3 >>Mode=3
;p15>>(p2 && p4) || p5 >>Mode4
;p12>>p10 && p3 && p6 >>Mode5
;p5>>p10 && ((p6 && p4) || p7) >>Mode6
;p4>> p8 && p3 >>Mode7
;p2=Mode2 || Mode3=p13 || p11
;p3=Mode4 || Mode5=p15 || p12
;p6=Mode6 || Mode7=p5 || p4
;p8=Mode3 || Mode4 ||Mode5 || Mode6 || Mode7=p11 || p3 || p6
;p1=Mode4 || Mode5 || Mode6 || Mode7
;p7=Mode5 || Mode6 || Mode7

;{ br r5              | nop  				        | nop                  |nop				             |nop      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;


{	nop	               |	dlw d4,a3,8+	    |	nop	                |	dlw d4,a3,8+	           |	nop	}
{	nop	               |	dlw d6,a7,8+	    |	nop               	|	dlw d6,a7,8+	           |	nop	}
{	nop	               |	dlw d12,a3,8+	    |	nop	                |	dlw d12,a3,8+	           |	nop	}
{	nop	               |	dlw d14,a7,8+	    |	nop	                |	dlw d14,a7,8+	           |	nop	}
{	b r11,_1DTransforms|	nop	                |	fmul.d d8,d5,d7	    |	nop	                       |	fmul.d d8,d5,d7	}
{	nop	               |	nop	                |	fmul.d d0,d4,d6	    |	nop	                       |	fmul.d d0,d4,d6	}
{	nop	               |	nop              	|	fmul.d d2,d12,d14	|	nop	                       |	fmul.d d2,d12,d14	}
{	nop	               |	addi d0,d0,4096	    |	fmul.d d10,d13,d15	|	nop	                       |	fmul.d d10,d13,d15	}
{addi r10,r10,(-1)     |	copy d8,d1	        |	copy d1,d8	        |	copy d8,d1	               |	copy d1,d8	}
{seqiu r13,p14,p0,r10,0|	copy d10,d3	        |	copy d3,d10	        |	copy d10,d3	               |	copy d3,d10	}
;;
{(p14)b _1DColumnIDCT  |	dsw d2,d0,a5,8+	    |   nop              	|	dsw d2,d0,a5,8+	           |	nop	}
{   nop                |	dsw d10,d8,a5,8+    |	nop	                |	dsw d10,d8,a5,8+	       |	nop	}
{	nop                |	dsw d9,d11,a5,8+	|	nop	                |	dsw d9,d11,a5,8+	       |	nop	}
{	nop	               |	dsw d1,d3,a5,8+   	|	nop	                |	dsw d1,d3,a5,8+	           |	nop	}
;
{	nop	               |(p1)addi a3,a4,QF+32    |	nop             	|(p7)addi a3,a4,QF+48          |	nop	}
{	nop	               |(p1)addi a7,a6,scale+32 |	nop             	|(p7)addi a7,a6,scale+48       |	nop	}
;;(p14)
{	nop	               |(p1)addi a5,a4,block_in+64 |	nop           	|(p7)addi a5,a4,block_in+96    |	nop	}
{	nop	               |    dlw d4,a3,8+        |	nop           	    |(p15)addi a3,a4,QF+112        |	nop	}
{	nop	               |    dlw d6,a7,8+        |	nop           	    |(p15)addi a7,a6,scale+112     |	nop	}
{	nop	               |    dlw d12,a3,8+       |	nop           	    |(p15)addi a5,a4,block_in+224  |	nop	}
{	nop	               |    nop	                |	nop             	|   dlw d4,a3,8+	           |	nop	}
{	nop	               |    nop	                |	nop	                |   dlw d6,a7,8+	           |	nop	}
{	nop	               |    nop	                |	nop	                |   dlw d12,a3,8+	           |	nop	}
{	nop	               |	dlw d14,a7,8+	    |	nop	                |	dlw d14,a7,8+	           |	nop	}
{	b r11,_1DTransforms|	nop	                |	fmul.d d8,d5,d7	    |	nop	                       |	fmul.d d8,d5,d7	}
{	nop	               |	nop	                |	fmul.d d0,d4,d6	    |	nop	                       |	fmul.d d0,d4,d6	}
{	nop	               |	nop	                |	fmul.d d2,d12,d14	|	nop	                       |	fmul.d d2,d12,d14	}
{	nop	               |	nop	                |	fmul.d d10,d13,d15	|	nop	                       |	fmul.d d10,d13,d15	}
{addi r10,r10,(-1)     |	copy d8,d1 	        |	copy d1,d8	        |	copy d8,d1	               |	copy d1,d8	}
{seqiu r13,p14,p0,r10,0|	copy d10,d3	        |	copy d3,d10     	|	copy d10,d3	               |	copy d3,d10	}
;;
{(p14)b _1DColumnIDCT  |	dsw d2,d0,a5,8+	    |	nop	                |	dsw d2,d0,a5,8+	           |	nop	}
{   nop                |	dsw d10,d8,a5,8+	|	nop	                |	dsw d10,d8,a5,8+	       |	nop	}
{	nop	               |	dsw d9,d11,a5,8+	|	nop	                |	dsw d9,d11,a5,8+	       |	nop	}
{	nop	               |	dsw d1,d3,a5,8+	    |	nop	                |	dsw d1,d3,a5,8+	           |	nop	}
{	nop	               |(p6)addi a3,a4,QF+64    |	nop	                |(p5)addi a3,a4,QF+112         |	nop	}
{	nop	               |(p6)addi a7,a6,scale+64 |	nop	                |(p5)addi a7,a6,scale+112      |	nop	}
;;(p14)
{	nop	               |(p6)addi a5,a4,block_in+128 |	nop	            |(p5)addi a5,a4,block_in+224   |	nop	}
{	nop	               |	dlw d4,a3,8+        |	nop	                |(p4)addi a3,a4,QF+80          |	nop	}
{	nop	               |	dlw d6,a7,8+        |	nop	                |(p4)addi a7,a6,scale+80       |	nop	}
{	nop	               |	dlw d12,a3,8+       |	nop	                |(p4)addi a5,a4,block_in+160   |	nop	}
;
{	nop	               |    nop         	    |	nop	                |   dlw d4,a3,8+	           |	nop	}
{	nop	               |    nop          	    |	nop	                |   dlw d6,a7,8+	           |	nop	}
{	nop	               |    nop         	    |	nop	                |   dlw d12,a3,8+	           |	nop	}
{	nop	               |	dlw d14,a7,8+	    |	nop	                |	dlw d14,a7,8+	           |	nop	}
{	b r11,_1DTransforms|	nop	                |	fmul.d d8,d5,d7	    |	nop	                       |	fmul.d d8,d5,d7	}
{	nop                |	nop	                |	fmul.d d0,d4,d6	    |	nop	                       |	fmul.d d0,d4,d6	}
{	nop	               |	nop	                |	fmul.d d2,d12,d14	|	nop                        |	fmul.d d2,d12,d14	}
{	nop	               |	nop	                |	fmul.d d10,d13,d15	|	nop	                       |	fmul.d d10,d13,d15	}
{addi r10,r10,(-1)     |	copy d8,d1	        |	copy d1,d8	        |	copy d8,d1	               |	copy d1,d8	}
{seqiu r13,p14,p15,r10,0|	copy d10,d3	        |	copy d3,d10	        |	copy d10,d3	               |	copy d3,d10	}
;;
{(p14)b _1DColumnIDCT  |	dsw d2,d0,a5,8+	    |	nop	                |	dsw d2,d0,a5,8+	           |	nop	}
{   nop                |	dsw d10,d8,a5,8+	|	nop	                |	dsw d10,d8,a5,8+	       |	nop	}
{	nop	               |	dsw d9,d11,a5,8+	|	nop	                |	dsw d9,d11,a5,8+	       |	nop	}
{	nop	               |	dsw d1,d3,a5,8+	    |	nop	                |	dsw d1,d3,a5,8+	           |	nop	}
;
{	nop	               |(p15)dlw d4,a3,8+	    |	nop	                |(p15)dlw d4,a3,8+	           |	nop	}
{	nop	               |(p15)dlw d6,a7,8+	    |	nop	                |(p15)dlw d6,a7,8+	           |	nop	}
;(p14)
{	nop |     dlw d12,a3,8+	    |	nop	                |    dlw d12,a3,8+	           |	nop	}
{	nop	|	dlw d14,a7,8+	|	nop	|	dlw d14,a7,8+	|	nop	}
{	b r11,_1DTransforms	|	nop	|	fmul.d d8,d5,d7	|	nop	|	fmul.d d8,d5,d7	}
{	nop	|	nop	|	fmul.d d0,d4,d6	|	nop	|	fmul.d d0,d4,d6	}
{	nop	|	nop	|	fmul.d d2,d12,d14	|	nop	|	fmul.d d2,d12,d14	}
{	nop	|	nop	|	fmul.d d10,d13,d15	|	nop	|	fmul.d d10,d13,d15	}
{	nop	|	copy d8,d1	|	copy d1,d8	|	copy d8,d1	|	copy d1,d8	}
{	nop	|	copy d10,d3	|	copy d3,d10	|	copy d10,d3	|	copy d3,d10	}
;;
{	nop	|	dsw d2,d0,a5,8+	|	nop	|	dsw d2,d0,a5,8+	|	nop	}
{	nop	|	dsw d10,d8,a5,8+	|	nop	|	dsw d10,d8,a5,8+	|	nop	}
{	nop	|	dsw d9,d11,a5,8+	|	nop	|	dsw d9,d11,a5,8+	|	nop	}
{	nop	|	dsw d1,d3,a5,8+	|	nop	|	dsw d1,d3,a5,8+	|	nop	}
;
_1DColumnIDCT:
{	nop	|	addi a5,a4,block_in	|	nop	|	addi a5,a4,block_in+16 |	nop	}
{	nop	|	lw d11,a5,224	|	nop	|	lw d11,a5,224	|	nop	}
{	nop	|	lw d0,a5,32+	|	nop	|	lw d0,a5,32+	|	nop	}
{	b r11,_1DTransforms	|	lw d8,a5,32+	|	nop	|	lw d8,a5,32+	|	nop	}
{	nop	|	lw d1,a5,32+	|	nop	|	lw d1,a5,32+	|	nop	}
{	nop	|	lw d9,a5,32+	|	nop	|	lw d9,a5,32+	|	nop	}
{	nop	|	lw d2,a5,32+	|	nop	|	lw d2,a5,32+	|	nop	}
{	nop	|	lw d10,a5,32+	|	nop	|	lw d10,a5,32+	|	nop	}
{	nop	|	lw d3,a5,(-188)+	|	nop	|	lw d3,a5,(-188)+	|	nop	}
;;
{	nop	|	addi a3,a4,QF	|	srai d12,d2,13	|	addi a3,a4,QF+8	|	srai d12,d2,13	}
{	nop	|	sh d12,a3,16+	|	srai d4,d0,13	|	sh d12,a3,16+	|	srai d4,d0,13	}
{	nop	|	sh d4,a3,16+	|	srai d5,d10,13	|	sh d4,a3,16+	|	srai d5,d10,13	}
{	nop	|	sh d5,a3,16+	|	srai d4,d8,13	|	sh d5,a3,16+	|	srai d4,d8,13	}
{	nop	|	sh d4,a3,16+	|	srai d5,d9,13	|	sh d4,a3,16+	|	srai d5,d9,13	}
{	nop	|	sh d5,a3,16+	|	srai d12,d11,13	|	sh d5,a3,16+	|	srai d12,d11,13	}
{	nop	|	sh d12,a3,16+	|	srai d13,d1,13	|	sh d12,a3,16+	|	srai d13,d1,13	}
{	nop	|	sh d13,a3,16+	|	srai d12,d3,13	|	sh d13,a3,16+	|	srai d12,d3,13	}
{	nop	|	sh d12,a3,16+	|	nop	|	sh d12,a3,16+	|	nop	}
;
{	nop	|	lw d11,a5,224	|	nop	|	lw d11,a5,224	|	nop	}
{	nop	|	lw d0,a5,32+	|	nop	|	lw d0,a5,32+	|	nop	}
{	b r11,_1DTransforms	|	lw d8,a5,32+	|	nop	|	lw d8,a5,32+	|	nop	}
{	nop	|	lw d1,a5,32+	|	nop	|	lw d1,a5,32+	|	nop	}
{	nop	|	lw d9,a5,32+	|	nop	|	lw d9,a5,32+	|	nop	}
{	nop	|	lw d2,a5,32+	|	nop	|	lw d2,a5,32+	|	nop	}
{	nop	|	lw d10,a5,32+	|	nop	|	lw d10,a5,32+	|	nop	}
{	nop	|	lw d3,a5,(-188)+	|	nop	|	lw d3,a5,(-188)+	|	nop	            }
;;
{	nop	|	addi a3,a4,QF+2	|	srai d12,d2,13	|	addi a3,a4,QF+10	|	srai d12,d2,13	}
{	nop	|	sh d12,a3,16+	|	srai d4,d0,13	|	sh d12,a3,16+	|	srai d4,d0,13	}
{	nop	|	sh d4,a3,16+	|	srai d5,d10,13	|	sh d4,a3,16+	|	srai d5,d10,13	}
{	nop	|	sh d5,a3,16+	|	srai d4,d8,13	|	sh d5,a3,16+	|	srai d4,d8,13	}
{	nop	|	sh d4,a3,16+	|	srai d5,d9,13	|	sh d4,a3,16+	|	srai d5,d9,13	}
{	nop	|	sh d5,a3,16+	|	srai d12,d11,13	|	sh d5,a3,16+	|	srai d12,d11,13	}
{	nop	|	sh d12,a3,16+	|	srai d13,d1,13	|	sh d12,a3,16+	|	srai d13,d1,13	}
{	nop	|	sh d13,a3,16+	|	srai d12,d3,13	|	sh d13,a3,16+	|	srai d12,d3,13	}
{	nop	|	sh d12,a3,16+	|	nop	|	sh d12,a3,16+	|	nop	}
;
{	nop	|	lw d11,a5,224	|	nop	|	lw d11,a5,224	|	nop	}
{	nop	|	lw d0,a5,32+	|	nop	|	lw d0,a5,32+	|	nop	}
{	b r11,_1DTransforms	|	lw d8,a5,32+	|	nop	|	lw d8,a5,32+	|	nop	}
{	nop	|	lw d1,a5,32+	|	nop	|	lw d1,a5,32+	|	nop	}
{	nop	|	lw d9,a5,32+	|	nop	|	lw d9,a5,32+	|	nop	}
{	nop	|	lw d2,a5,32+	|	nop	|	lw d2,a5,32+	|	nop	}
{	nop	|	lw d10,a5,32+	|	nop	|	lw d10,a5,32+	|	nop	}
{	nop	|	lw d3,a5,(-188)+	|	nop	|	lw d3,a5,(-188)+	|  nop	}
;;
{	nop	|  addi a3,a4,QF+4	|	srai d12,d2,13	|	addi a3,a4,QF+12	|	srai d12,d2,13	}
{	nop	|	sh d12,a3,16+	|	srai d4,d0,13	|	sh d12,a3,16+	|	srai d4,d0,13	}
{	nop	|	sh d4,a3,16+	|	srai d5,d10,13	|	sh d4,a3,16+	|	srai d5,d10,13	}
{	nop	|	sh d5,a3,16+	|	srai d4,d8,13	|	sh d5,a3,16+	|	srai d4,d8,13	}
{	nop	|	sh d4,a3,16+	|	srai d5,d9,13	|	sh d4,a3,16+	|	srai d5,d9,13	}
{	nop	|	sh d5,a3,16+	|	srai d12,d11,13	|	sh d5,a3,16+	|	srai d12,d11,13	}
{	nop	|	sh d12,a3,16+	|	srai d13,d1,13	|	sh d12,a3,16+	|	srai d13,d1,13	}
{	nop	|	sh d13,a3,16+	|	srai d12,d3,13	|	sh d13,a3,16+	|	srai d12,d3,13	}
{	nop	|	sh d12,a3,16+	|	nop	|	sh d12,a3,16+	|	nop	}
;
{	nop	|	lw d11,a5,224	|	nop	|	lw d11,a5,224	|	nop	}
{	nop	|	lw d0,a5,32+	|	nop	|	lw d0,a5,32+	|	nop	}
{	b r11,_1DTransforms	|	lw d8,a5,32+	|	nop	|	lw d8,a5,32+	|	nop	}
{	nop	|	lw d1,a5,32+	|	nop	|	lw d1,a5,32+	|	nop	}
{	nop	|	lw d9,a5,32+	|	nop	|	lw d9,a5,32+	|	nop	}
{	nop	|	lw d2,a5,32+	|	nop	|	lw d2,a5,32+	|	nop	}
{	nop	|	lw d10,a5,32+	|	nop	|	lw d10,a5,32+	|	nop	}
{	nop	|	lw d3,a5,(-188)+	|	nop	|	lw d3,a5,(-188)+	|	nop	}
;;
{	nop	|	addi a3,a4,QF+6	|	srai d12,d2,13	|	addi a3,a4,QF+14	|	srai d12,d2,13	}
{	nop	|	sh d12,a3,16+	|	srai d4,d0,13	|	sh d12,a3,16+	|	srai d4,d0,13	}
{	nop	|	sh d4,a3,16+	|	srai d5,d10,13	|	sh d4,a3,16+	|	srai d5,d10,13	}
{	br r5	|	sh d5,a3,16+	|	srai d4,d8,13	|	sh d5,a3,16+	|	srai d4,d8,13	}
{	notp p10,p0	|	sh d4,a3,16+	|	srai d5,d9,13	|	sh d4,a3,16+	|	srai d5,d9,13	}
{	notp p15,p0	|	sh d5,a3,16+	|	srai d12,d11,13	|	sh d5,a3,16+	|	srai d12,d11,13	}
{	nop	|	sh d12,a3,16+	|	srai d13,d1,13	|	sh d12,a3,16+	|	srai d13,d1,13	}
{	nop	|	sh d13,a3,16+	|	srai d12,d3,13	|	sh d13,a3,16+	|	srai d12,d3,13	}
{	nop	|	sh d12,a3,16+	|	clr d5	|	sh d12,a3,16+	|	nop	}
;
_1DTransforms:
{	nop	|	nop	|	bf d12,d8,d11	|	nop	|	bf d12,d8,d11	}
{	nop	|	nop	|	bf d4,d12,d9	|	nop	|	bf d4,d12,d9	}
{	nop	|	nop	|	bf d12,d13,d10	|	nop	|	bf d12,d13,d10	}
{	nop	|	srai a0,d13,3	|	srai ac0,d5,3	|	srai a0,d13,3	|	srai ac0,d5,3	}
{	nop	|	srai a1,d13,7	|	srai ac1,d5,7	|	srai a1,d13,7	|	srai ac1,d5,7	}
{	nop	|	sub a0,a0,a1	|	sub ac0,ac0,ac1	|	sub a0,a0,a1	|	sub ac0,ac0,ac1	}
{	nop	|	srai a1,d13,11	|	srai ac1,d5,11	|	srai a1,d13,11	|	srai ac1,d5,11	}
{	nop	|	sub a2,a0,a1	|	sub ac2,ac0,ac1	|	sub a2,a0,a1	|	sub ac2,ac0,ac1	}
{	nop	|	srai a2,a2,1	|	srai ac2,ac2,1	|	srai a2,a2,1	|	srai ac2,ac2,1	}
{	nop	|	add d7,a0,a2	|	add d15,ac0,ac2	|	add d7,a0,a2	|	add d15,ac0,ac2	}
{	nop	|	sub a0,d13,a0	|	sub ac0,d5,ac0	|	sub a0,d13,a0	|	sub ac0,d5,ac0	}
{	nop	|	add d14,a0,d15	|	sub d6,ac0,d7	|	add d14,a0,d15	|	sub d6,ac0,d7	}
{	nop	|	srai a0,d12,9	|	srai ac0,d4,9	|	srai a0,d12,9	|	srai ac0,d4,9	}
{	nop	|	sub a0,a0,d12	|	sub ac0,ac0,d4	|	sub a0,a0,d12	|	sub ac0,ac0,d4	}
{	nop	|	srai a1,a0,2	|	srai ac1,ac0,2	|	srai a1,a0,2	|	srai ac1,ac0,2	}
{	nop	|	srai d15,d12,1	|	srai d7,d4,1	|	srai d15,d12,1	|	srai d7,d4,1	}
{	nop	|	sub a0,a1,a0	|	sub ac0,ac1,ac0	|	sub a0,a1,a0	|	sub ac0,ac1,ac0	}
{	nop	|	sub d7,a0,d7	|	add d15,ac0,d15	|	sub d7,a0,d7	|	add d15,ac0,d15	}
{	nop	|	copy d8,d3	|	nop	|	copy d8,d3	|	nop	}
{	nop	|	srai a0,d8,5	|	srai ac0,d1,5	|	srai a0,d8,5	|	srai ac0,d1,5	}
{	nop	|	add a0,d8,a0	|	add ac0,d1,ac0	|	add a0,d8,a0	|	add ac0,d1,ac0	}
{	nop	|	srai a1,a0,2	|	srai ac1,ac0,2	|	srai a1,a0,2	|	srai ac1,ac0,2	}
{	nop	|	srai a2,d8,4	|	srai ac2,d1,4	|	srai a2,d8,4	|	srai ac2,d1,4	}
{	nop	|	add a2,a1,a2	|	add ac2,ac1,ac2	|	add a2,a1,a2	|	add ac2,ac1,ac2	}
{	nop	|	sub d9,a0,a1	|	sub d4,ac0,ac1	|	sub d9,a0,a1	|	sub d4,ac0,ac1	}
{	nop	|	add d3,a2,d4	|	sub d8,ac2,d9	|	add d3,a2,d4	|	sub d8,ac2,d9	}
{	nop	|	nop	|	bf d4,d0,d2	|	nop	|	bf d4,d0,d2	}
{	br r11	|	copy d1,d8	|	bf d10,d4,d3	|	copy d1,d8	|	bf d10,d4,d3	}
{	nop	|	copy d4,d11	|	bf d12,d5,d1	|	copy d4,d11	|	bf d12,d5,d1	}
{	nop	|	copy d5,d13	|	bf d8,d4,d7	|	copy d5,d13	|	bf d8,d4,d7	}
{	nop	|	nop	|	bf d2,d10,d15	|	nop	|	bf d2,d10,d15	}
{	nop	|	nop	|	bf d0,d12,d14	|	nop	|	bf d0,d12,d14	}
{	nop	|	nop	|	bf d10,d5,d6	|	nop	|	bf d10,d5,d6	}
;
.endp	idct_23002_2
;-------------------------

;-------init_table.s
.proc	init_tables
.global	init_tables
init_tables:
; a6: *itable, a7: *etableas





{nop             | lw a6, sp, 0     | nop         | nop           | nop          }
{nop             | lw a7, sp, 4     | nop         | nop           | nop          }
{nop 			 | set_cpi cp0,0,0 				      | nop 				| nop 				  | nop				   }
{bdt r7          | bdr a5  	      | nop 				| nop 				  | nop				   }



; establish Init_table
;Default_intra_quantiser_matrix[64]
{	nop		|	nop			| moviu d0,0x16131008	|	nop		|	nop		}
{	nop		|	nop			| moviu d1,0x221d1b1a	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x18161010	|	nop		|	nop		}
{	nop		|	copy [cp0],a5  | moviu d1,0x25221d1b	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x1b1a1613	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x2622221d	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x1b1a1616	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x2825221d	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x1d1b1a16	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x30282320	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x201d1b1a	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x3a302823	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x221d1b1a	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x45382e26	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x26231d1b	|	nop		|	nop		}
{	nop		|	clr a5   	   | moviu d1,0x5345382e	|	nop		|	nop		}
;Scan[2][64]

{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x10080100	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x0a030209	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x19201811	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x05040b12	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x211a130c	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x22293028	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x060d141b	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x1c150e07	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x38312a23	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x242b3239	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x170f161d	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x332c251e	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x2d343b3a	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x2e271f26	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x363d3c35	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x3f3e372f	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x18100800	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x0a020901	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x28201911	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x31393830	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x121a2129	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x0c040b03	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x2a221b13	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x2b233a32	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x1c143b33	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x0e060d05	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x2c241d15	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x2d253c34	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x1e163d35	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x1f170f07	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x3e362e26	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x3f372f27	|	nop		|	nop		}

;Quantiser_scale[32]
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x03020100	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x07060504	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x0e0c0a08	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x16141210	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x24201c18	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x34302c28	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x50484038	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x70686058	|	nop		|	nop		}
;scale [8*8]
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x04720400	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x064906c2	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x06490400	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x047206c2	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x04f00472	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x06fc0782	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x06fc0472	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x04f00782	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x078206c2	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x0a9e0b6b	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x0a9e06c2	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x07820b6b	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x06fc0649	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x09e00a9e	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x09e00649	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x06fc0a9e	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x04720400	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x064906c2	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x06490400	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x047206c2	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x06fc0649	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x09e00a9e	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x09e00649	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x06fc0a9e	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x078206c2	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x0a9e0b6b	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x0a9e06c2	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x07820b6b	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x04f00472	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x06fc0782	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| moviu d0,0x06fc0472	|	nop		|	nop		}
{	nop		|	nop			   | moviu d1,0x04f00782	|	nop		|	nop		}
{	nop		|	dsw d0,d1,a6,8+| nop				|	nop		|	nop		}
; establish entropy_table
;coef_token_tableB_1
;B1_startbit and B1_maxcomptimes
{	nop		|	nop				 | moviu d1,0x00000304	|	nop		|	nop		}
;tableB1
{	nop		|	sh d1,a7,2+     | moviu d0,0x02020108	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00490059	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00370037	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00270027	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00130013	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00130013	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00130013	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00130013	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00000000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x02260000	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x032402a6	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00e900f9	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00c900d9	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00a900b9	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00970097	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00870087	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00630073	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x02070217	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01e701f7	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01c701d7	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01a701b7	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01870197	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01670177	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01550155	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01450145	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01250135	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01050115	|	nop		|	nop		}
;coef_token_tableB_2
;B2_startbit and B2_maxcomptimes
{	nop		|	nop				 | moviu d1,0x00000102	|	nop		|	nop		}
;tableB2
{	nop		|	dsnw d0,d1,a7,6+| moviu d0,0x01150000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00130013	|	nop		|	nop		}
;coef_token_tableB_3
;B3_startbit and B3_maxcomptimes
{	nop		|	dsnw d0,d1,a7,8+| moviu d1,0x00000203	|	nop		|	nop		}
{	nop		|	nop             | nop	               |	nop		|	nop		}
;tableB3
{	nop		|	sh  d1,a7,2+   | moviu d0,0x00870086	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00250025	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00a300a3	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00a300a3	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01170000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01250125	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01a501a5	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00150015	|	nop		|	nop		}
;coef_token_tableB_4
;B4_startbit and B4_maxcomptimes
{	nop		|	dsnw d0,d1,a7,8+| moviu d1,0x00000203	|	nop		|	nop		}
{	nop		|	nop             | nop	               |	nop		|	nop		}
;tableB4
{	nop		|	sh  d1,a7,2+   | moviu d0,0x01020086	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00670047	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00c500c5	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00e500e5	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01170000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01a70167	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01e501e5	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00150015	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00a30083	|	nop		|	nop		}
;coef_token_tableB_9
;B9_startbit and B9_maxcomptimes
{	nop		|	nop             | moviu d1,0x00000404	|	nop		|	nop		}
;tableB9
{	nop		|	dsnw d0,d1,a7,6+| moviu d0,0x01440104	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01c40184	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x02440204	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x02c40284	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x03440304	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01090209	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00490089	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x03c703c7	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x03c40384	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x04440404	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04c40484	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x05440504	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x05c40584	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x06440604	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x003503f5	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01850245	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x03e303e3	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00230023	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x03d303d3	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00130013	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x03830383	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x03430343	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x02c302c3	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01c301c3	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x02830283	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01430143	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x03030303	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00c300c3	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x06820000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x06c206a2	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x036503a5	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01e502e5	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x03550395	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01d502d5	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01a50265	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01950255	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x017502b5	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00f50335	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x016502a5	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00e50325	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01550295	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00d50315	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01350235	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x007500b5	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x02230223	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01230123	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00a300a3	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00630063	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x02130213	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01130113	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00930093	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00530053	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01b30273	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x037303b3	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01f302f3	|	nop		|	nop		}
;coef_token_tableB_10
;B10_startbit and B10_maxcomptimes
{	nop		|	nop             | moviu d1,0x00000304	|	nop		|	nop		}
;tableB10
{	nop		|	dsnw d0,d1,a7,6+| moviu d0,0x02020108	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01290029	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00170017	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01170117	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00030003	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00030003	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00030003	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00030003	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00000000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x02260000	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x032402a6	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01790079	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01690069	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01590059	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00470047	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01470147	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01330033	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x02070107	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01f700f7	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01e700e7	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01d700d7	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01c700c7	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01b700b7	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00a500a5	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01a501a5	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01950095	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x01850085	|	nop		|	nop		}
;coef_token_tableB_12
;B12_startbit and B12_maxcomptimes
{	nop		|	nop				 | moviu d1,0x00000303	|	nop		|	nop		}
;tableB12
{	nop		|	dsnw d0,d1,a7,6+| moviu d0,0x00150015	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00250025	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00370007	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00860047	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00530053	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00530053	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00650065	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01060077	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00830083	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00830083	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00950095	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00b700a7	|	nop		|	nop		}
;coef_token_tableB_13
;B13_startbit and B13_maxcomptimes
{	nop		|	dsnw d0,d1,a7,8+| moviu d1,0x00000304	|	nop		|	nop		}
{	nop		|	nop		       | nop				      |	nop		|	nop		}
;tableB13
{	nop		|	sh  d1,a7,2+   | moviu d0,0x00050005	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00050005	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00150015	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00150015	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00250025	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00250025	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00370037	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01060049	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00530053	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00530053	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00650065	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x01860077	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00830083	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00830083	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00950095	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00b700a7	|	nop		|	nop		}
;coef_token_tableB_14
;B14_startbit and B14_maxcomptimes
{	nop		|	dsnw d0,d1,a7,8+| moviu d1,0x00000404	|	nop		|	nop		}
{	nop		|	nop		       | nop				      |	nop		|	nop		}
;tableB14
{	nop		|	sh  d1,a7,2+   | moviu d0,0x02040108	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x03420248	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04290809	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x04170417	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00000000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00000000	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00000000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00000000	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04680368	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x05a40564	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00000000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00000000	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x08270827	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x04970497	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x10071007	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x04870487	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04650475	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x04550815	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x180904d9	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x04b904c9	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x0c190839	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x04a91409	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x0c030c03	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x0c030c03	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x0c030c03	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x0c030c03	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04330443	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x05e80000	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x076606e6	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x082407e4	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x08a40864	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x090208e2	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x09420922	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x09820962	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x09c209a2	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x08892c09	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x28090c49	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x08791029	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x05490559	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x05392409	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x14190529	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x20090c39	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x05190869	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x08550505	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x0c251c05	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x04f51015	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x084504e5	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x44194819	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x3c194019	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x09090c69	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x08e908f9	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x08c908d9	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x05f908b9	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x05d905e9	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x05b905c9	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x9c07a007	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x94079807	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x8c079007	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x84078807	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x38178007	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x30173417	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x28172c17	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x20172417	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x78057c05	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x70057405	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x68056c05	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x60056405	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x58055c05	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x50055405	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x48054c05	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x40054405	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x089308a3	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x10330c53	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x1c131423	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x3c031813	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x34033803	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x05a33003	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x05830593	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x05630573	|	nop		|	nop		}
;coef_token_tableB_15
;B15_startbit and B15_maxcomptimes
{	nop		|	nop				 | moviu d1,0x00000404	|	nop		|	nop		}
;tableB15
{	nop		|	dsnw d0,d1,a7,6+| moviu d0,0x02040108	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x03420248	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04170417	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x0c090000	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04050405	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x04050405	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x08070807	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x03880362	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x05880488	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x06a40682	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00000000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00000000	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04770477	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x04870487	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04670467	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x08270827	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x18051c05	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x04550445	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04b91419	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x28092c09	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04c904d9	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x10190839	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04230423	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x04230423	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04230423	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x04230423	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04330813	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x14031003	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04970497	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x0c170c17	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04a704a7	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x20072007	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x24072407	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x34093009	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x08490c29	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x3c093809	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x06e80000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x086607e6	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x092408e4	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x09a40964	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x0a0209e2	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x0a420a22	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x0a620000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x0aa20a82	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x08890000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00000c49	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x08790000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x05490559	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x05390000	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x00000529	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00000c39	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x05190869	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04e30853	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x05051025	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x04f304f3	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x44194819	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x3c194019	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x09090c69	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x08e908f9	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x08c908d9	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x05f908b9	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x05d905e9	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x05b905c9	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x9c07a007	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x94079807	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x8c079007	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x84078807	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x38178007	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x30173417	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x28172c17	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x20172417	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x78057c05	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x70057405	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x68056c05	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x60056405	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x58055c05	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x50055405	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x48054c05	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x40054405	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x089308a3	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x10330c53	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x1c131423	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x00001813	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x05a30000	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| moviu d0,0x05830593	|	nop		|	nop		}
{	nop		|	nop			    | moviu d1,0x05630573	|	nop		|	nop		}
{	nop		|	dsnw d0,d1,a7,8+| nop				      |	nop		|	nop		}
;End of initialization of Entropy Table
{ br r5			     | nop 				      | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
{ nop 			     | clr d5			      | nop 				| nop 				  | nop				   }
.endp	init_tables
;-----------------------




;--------picture_coding_extension.s
.proc	Picture_coding_extension
.global	Picture_coding_extension
Picture_coding_extension:
;;void Picture_coding_extension(Bitstream *pbs,Seq_header *shead,GOP_data *gop,Picture_data *pdata){
;;	unsigned char buffer;
;;	i=0;
;;	pdata->f_code[0][0]=(unsigned char)(readbits(pbs,4,shead));  //4bits
;;	pdata->f_code[0][1]=(unsigned char)(readbits(pbs,4,shead));      //4bits
;;	pdata->f_code[1][0]=(unsigned char)(readbits(pbs,4,shead));   //4bits
;;	pdata->f_code[1][1]=(unsigned char)(readbits(pbs,4,shead));    //4bits
;;	pdata->intra_dc_precision        =(unsigned char)(readbits(pbs,2,shead));   //2bits
;;	pdata->picture_structure         =(unsigned char)(readbits(pbs,2,shead)); //2bits
;	//********record which field picture has been deocded first
;;	if(pdata->picture_structure!=Frame_picture)
;;		gop->field_count_flag=!gop->field_count_flag;
;	//*************************************************
;;	pdata->top_field_first           =(unsigned char)(readbits(pbs,1,shead));   //1bit
;;	pdata->frame_pred_frame_dct      =(unsigned char)(readbits(pbs,1,shead));    //1bit
;;	pdata->concealment_motion_vectors=(unsigned char)(readbits(pbs,1,shead));  //1bit
;;	pdata->q_scale_type              =(unsigned char)(readbits(pbs,1,shead));    //1bit
;;	pdata->intra_vlc_format          =(unsigned char)(readbits(pbs,1,shead));   //1bit
;;	pdata->alternate_scan            =(unsigned char)(readbits(pbs,1,shead));    //1bit
;;	pdata->repeat_first_field        =(unsigned char)(readbits(pbs,1,shead));   //1bit
;;	pdata->chroma_420_type           =(unsigned char)(readbits(pbs,1,shead));   //1bit
;;	pdata->progressive_frame         =(unsigned char)(readbits(pbs,1,shead));   //1bit
;;	pdata->composite_display_flag    =(unsigned char)(readbits(pbs,1,shead));   //1bit
;;	if(pdata->composite_display_flag)
;;		buffer=(unsigned char)(readbits(pbs,20,shead));  //skip 20bits
;;	shead->mb_height=(shead->vertical_size+15)>>4;
;;	if(pdata->picture_structure!=Frame_picture)
;;		shead->mb_height>>=1;
;;}
; a4: *pdata, a6: *pbitstream, a1: *shead, a2: *gop
;;	pdata->f_code[0][0]=(unsigned char)(readbits(pbs,4,shead));  //4bits

;;sp>> 0:bitstream, 4:seq_header, 8:gop_header, 12:pic_data, 16:Slice_data0, 20:Init_table, 24:Slice_data1

{ b r1,_readbits     | lw a6, sp, 0            | moviu d0,4           | lw a6,sp2,0              | clr ac2           }
{ lw r6,sp3,0        | lw a1, sp, 4            | nop                  | lw a2,sp2,8              | nop               }
{ lw r14,sp3,4       | lw a2, sp, 8            | nop                  | nop                      | nop               }
{ nop 			      | lw a4, sp,12            | nop 				       | nop 				          | nop				   }
{ nop 			      | lw a5, sp,16 			  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | lw a4,sp2,12             | nop				   }
;
;;	pdata->f_code[0][1]=(unsigned char)(readbits(pbs,4,shead));      //4bits
{ b r1,_readbits 	   | sb d5,a4,f_code00 		  | moviu d0,4 		    | nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	pdata->f_code[1][0]=(unsigned char)(readbits(pbs,4,shead));   //4bits
{ b r1,_readbits 	   | sb d5,a4,f_code01 		  | moviu d0,4 		    | nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	pdata->f_code[1][1]=(unsigned char)(readbits(pbs,4,shead));    //4bits
{ b r1,_readbits 	   | sb d5,a4,f_code10 		  | moviu d0,4 		    | nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	pdata->intra_dc_precision        =(unsigned char)(readbits(pbs,2,shead));   //2bits
;;if(pdata->intra_dc_precision==0)      pdata->intra_dc_mult=3;
;;	else if(pdata->intra_dc_precision==1) pdata->intra_dc_mult=2;
;;	else if(pdata->intra_dc_precision==2) pdata->intra_dc_mult=1;
;;	else                                  pdata->intra_dc_mult=0;
{ b r1,_readbits 	   | sb d5,a4,f_code11 		  | moviu d0,2 		    | nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	pdata->picture_structure         =(unsigned char)(readbits(pbs,2,shead)); //2bits
{ b r1,_readbits 	   | sb d5,a4,intra_dc_precision | moviu d0,2 		 | clr d0 				       | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | seqiu ac7,p1,p0,d5,0 | nop 				          | nop				   }
{ nop 			      | nop 				        | seqiu ac7,p2,p0,d5,1 |(p1)moviu d0,3 				 | nop				   }
{ nop 			      | nop 				        | seqiu ac7,p3,p0,d5,2 |(p2)moviu d0,2 				 | nop				   }
{ nop 			      | nop 				        | nop 				       |(p3)moviu d0,1 				 | nop				   }
{ nop 			      | nop 				        | nop 				       | sb d0,a4,intra_dc_mult   | nop				   }
;
;	//********record which field picture has been deocded first
;;if(pdata->picture_structure!=Frame_picture){
; % p1
;;		gop->field_count_flag=!gop->field_count_flag;
;;		if(pdata->picture_coding_type!=Bframe){
;  % p11
;;			if(gop->field_count_flag)
;        % p14
;;				De_frame=Ref_back;
;;			else if(pdata->picture_coding_type==Iframe && pdata->temporal_reference==0){
;        % !p14 && p12 && p13
;;				Ref_back=Ref_front;
;;				Ref_front=De_frame;
;;			}
;;		}
;;	}
;	//*************************************************
;;	pdata->top_field_first           =(unsigned char)(readbits(pbs,1,shead));   //1bit
{ b r1,_readbits     | lbu d12,a2,field_count_flag | seqiu ac7,p2,p1,d5,Frame_picture | moviu a3,GLOBAL_POINTER_ADDR| nop		   }
{(p9)sb r13,r14,Error_flag  | moviu a7,GLOBAL_POINTER_ADDR| moviu d0,1| lbu d9,a4,picture_coding_type| clr ac2        }
{ notp p12,p0 			| nop                     | notp p11,p0          | lhu d3,a4,temporal_reference| nop            }
{ notp p14,p0 			|(p1)lw d11,a7,Ref_Front_ADDR|(p1)xori ac2,d12,0x1 |(p1)lw d11,a3,Ref_Back_ADDR	 | nop	            }
{ notp p15,p0 			| sb d5,a4,picture_structure|(p1)copy d3,ac2     | nop 				          |(p1)seqiu ac7,p0,p11,d9,Bframe}
{ notp p13,p0 			|(p1)sb d3,a2,field_count_flag|(p11)sgtiu ac7,p14,p15,ac2,0| nop           |(p11)seqiu ac7,p12,p0,d9,Iframe}
;
;;	pdata->frame_pred_frame_dct      =(unsigned char)(readbits(pbs,1,shead));    //1bit
{ b r1,_readbits 		| nop                     | andp p15,p15,p12     |(p14)sw d11,a3,Decode_ADDR|(p15)seqiu ac7,p13,p0,d3,0}
{(p9)sb r13,r14,Error_flag|(p15) lw d12,a7,Decode_ADDR| nop 		    | nop 				          | andp p15,p15,p13  }
{ nop 			      |(p15)bdt d11 				  | nop 				       |(p15)bdr d11 				 | nop				   }
{ nop 			      | sb d5,a4,top_field_first| moviu d0,1 			 | nop 				          | clr ac2  		   }
{ nop 			      |(p15)sw d12,a7,Ref_Front_ADDR| nop 				 | nop                      | nop				   }
{ nop 			      | nop 				        | nop 				       |(p15)sw d11,a3,Ref_Back_ADDR| nop				   }
;
;;	pdata->concealment_motion_vectors=(unsigned char)(readbits(pbs,1,shead));  //1bit
{ b r1,_readbits 	   | sb d5,a4,frame_pred_frame_dct| moviu d0,1 		 | nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	pdata->q_scale_type              =(unsigned char)(readbits(pbs,1,shead));    //1bit
{ b r1,_readbits 	   | sb d5,a4,concealment_motion_vectors| moviu d0,1| nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	pdata->intra_vlc_format          =(unsigned char)(readbits(pbs,1,shead));   //1bit
{ b r1,_readbits 	   | sb d5,a4,q_scale_type   | moviu d0,1           | nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	pdata->alternate_scan            =(unsigned char)(readbits(pbs,1,shead));    //1bit

;;;for(i=0;i<64;i++){
;;			itable->IS_address[i]=&(sdata->QF[itable->Scan[pdata->alternate_scan][i]]);
;;			itable->IS_address2[i]=&(sdata2->QF[itable->Scan[pdata->alternate_scan][i]]);
;;}

;;for(i=0;i<64;i++)
;;			itable->IS_address[i]=&(sdata->QF[itable->Scan[pdata->alternate_scan][i]]);
{ b r1,_readbits 	  | nop                       | moviu d0,1                 | lw a3,sp2,24 	              | clr ac2				}

{ nop                 | lw d12,sp,20 			  | nop 				       | nop 				          | nop				   }
{ nop                 | sb d5,a4,intra_vlc_format | nop 				       | nop           		          | nop				   }
{(p9)sb r13,r14,Error_flag| addi a2,a5,QF    	  | moviu d3,64 			   | addi a2,a3,QF		          | nop         	   }
{ set_lbci r5,64 	  | bdt d12                   | nop 				       | bdr d10			          | nop				   }
{ nop 			      | nop               		  | addi d11,d12,Scan          | nop 				          | nop				   }
;
{ nop                 | addi a7,d12,IS_address    | fmuluu d13,d5,d3 	       | addi a7,d10,IS_address2      | nop				   }
_IS_loop2:
{ nop                 | add a5,d11,d13 			  | nop 				       | nop                          | nop				   }
{ nop                 | lbu d8,a5,0 			  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				      | addi d13,d13,1 		       | nop         		          | nop				   }
{ lbcb r5,_IS_loop2   | nop 				      | nop 				       | nop 				          | nop				   }
{ nop 			      | add a3,d8,d8 			  | nop 				       | nop 				          | nop				   }
{ nop 			      | bdt a3 				      | nop 				       | bdr a3				          | nop				   }
{ nop 			      | add d15,a3,a2 			  | nop 				       | nop 				          | nop				   }
{ nop 			      | sw d15,a7,4+			  | nop 				       | add d15,a3,a2		          | nop				   }
{ nop 			      | nop         			  | nop 				       | sw d15,a7,4+		          | nop				   }
;


;;	pdata->repeat_first_field        =(unsigned char)(readbits(pbs,1,shead));   //1bit
{ b r1,_readbits 	   | sb d5,a4,alternate_scan | moviu d0,1           | nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag   | nop            | nop 			          | nop 				          | nop				   }
{ nop 			      | bdr a2 				     | nop 	                | bdt a2 				       | nop				   }
{ nop 			      | nop 			           | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	pdata->chroma_420_type           =(unsigned char)(readbits(pbs,1,shead));   //1bit
{ b r1,_readbits 	   | sb d5,a4,repeat_first_field | moviu d0,1       | nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	pdata->progressive_frame         =(unsigned char)(readbits(pbs,1,shead));   //1bit
{ b r1,_readbits 	   | sb d5,a4,chroma_420_type| moviu d0,1           | nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	pdata->composite_display_flag    =(unsigned char)(readbits(pbs,1,shead));   //1bit
{ b r1,_readbits 	   | sb d5,a4,progressive_frame| moviu d0,1         | nop 				          | clr ac2				}
{ (p9)sb r13,r14,Error_flag | nop 				  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	if(pdata->composite_display_flag)
;;		buffer=(unsigned char)(readbits(pbs,20,shead));  //skip 20bits
;;	shead->mb_height=(shead->vertical_size+15)>>4;
;;	if(pdata->picture_structure!=Frame_picture)
;;		shead->mb_height>>=1;
;;}
;cluster1: a5<<mb_height, a7<<vertical_size
;cluster2: a3<<picture_structure
{ (p9)sb r13,r14,Error_flag | nop              | seqiu ac7,p1,p2,d5,1 | nop 		                | nop				   }
{ (p1)b r1,_readbits | lw a7,a1,vertical_size  | nop 			          | nop 				          | (p1)clr ac2		   }
{ (p2)b _table1 	   | sb d5,a4,composite_display_flag| nop           | nop 				          | nop				   }
{ nop 			      | nop 				        | (p1)moviu d0,16 	    | lbu a3,a4,picture_structure | nop				}
{ nop 			      | nop 			           | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 			           | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop			              | nop 				       | nop 				          | nop				   }
;
{ (p1)b r1,_readbits | nop                     | nop 			          | nop 				          | (p1)clr ac2		   }
{ (p9)sb r13,r14,Error_flag | nop 				  | (p1)moviu d0,4 		 | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
_table1:



{ br r7			      | addi a7,a7,15 			  | nop 				       | seqiu d0,p0,p3,a3,Frame_picture | nop		   }
{ nop 			      | srli a7,a7,4 			  | nop 				       | nop 				          | nop				   }
{ nop 			      | (p3)srli a7,a7,1 		  | nop 				       | nop 				          | nop				   }
{ nop 			      | sb a7,a1,mb_height 	  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | clr d5			           | nop 				       | nop 				          | nop				   }
.endp	Picture_coding_extension
;----------------------------------

;------Picture_header.s
.proc	Picture_header
.global	Picture_header
Picture_header:

.if 0
;;*****************Break_Point!!!!!!!!!
{ seqiu r11,p14,p0,r0,0| nop 	              | nop 				       | nop 				          | orp p15,p15,p0}
{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
{ notp p15,p14 		|(p14)moviu a7,0x24009000 | nop 				       | nop 				          | nop				      }
{(p15)b _end2 	      | nop				           | nop 				       | nop		                | nop				      }
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop 			      |(p14)moviu d5,0x55667788| nop 				       | nop 				          | nop				      }
{ nop 			      |(p14)sw d5,a7,0         | nop 				       | nop 				          | nop				      }
{(p14) moviu r3,1    | nop 				        | notp p15,p0			 | nop 				          | nop				      }
{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;
{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
_end2:
;;********************************************
.endif

;;void Picture_header(Bitstream *pbs,Seq_header *shead,GOP_data *gop,Picture_data *pdata,*Init_table *itable){
;;	Frame_buf *temp;
;;	unsigned char buffer;
;;	i=0;
;;	pdata->temporal_reference=(unsigned char)(readbits(pbs,10,shead));  //10bits
;;	pdata->picture_coding_type  =(unsigned char)(readbits(pbs,3,shead)); //3bits
;;	pdata->vbv_delay=(unsigned char)(readbits(pbs,16,shead));
;;	if(pdata->picture_coding_type==2 || pdata->picture_coding_type==3){
;;		if(shead->constrained_parameter_flag){  //Mpeg1
;;			buffer=(unsigned char)(readbits(pbs,1,shead)); // skip 1bit
;;			pdata->f_code[0][0]=pdata->f_code[0][1]=(unsigned char)(readbits(pbs,3,shead));
;;		}
;;		else
;;			buffer=(unsigned char)(readbits(pbs,4,shead));  //skip 4bits
;;	}
;;	if(pdata->picture_coding_type==3){
;;		if(shead->constrained_parameter_flag){  //Mpeg1
;;			buffer=(unsigned char)(readbits(pbs,1,shead));  //skip 1bit
;;			pdata->f_code[1][0]=pdata->f_code[1][1]=(unsigned char)(readbits(pbs,3,shead));
;;		}
;;		else
;;			buffer=(unsigned char)(readbits(pbs,4,shead)); //skip 4bits
;;	}
;;	while(readbits(pbs,1,shead))
;;		pdata->extra_information_picture=(unsigned char)(readbits(pbs,8,shead));  //skip 1 or 9 bits
;;	pdata->mb_row_reg=pdata->increment_flag=pdata->increment_temp=0;   //initialize the start of the row of MB address
;;	pdata->previous_MB_address=-1;
;	//********Initialize the parameter of picture_coding_extension in Mpeg1 Bitstream
;;	if(shead->constrained_parameter_flag || pdata->picture_coding_type==Dframe){
;;		pdata->picture_structure=Frame_picture;
;;		pdata->frame_pred_frame_dct=1;
;;		pdata->intra_dc_precision=pdata->concealment_motion_vectors=pdata->q_scale_type=pdata->intra_vlc_format=pdata->alternate_scan=0;
;;	}
;	//***************************Picture_reorder
;;	if(!gop->field_count_flag){
;;		if(pdata->picture_coding_type==Iframe || pdata->picture_coding_type==Pframe){
;;			if(pdata->IP_frame_retain){
;				//The Pframe decoded before the Bframe can not be displayed !
;;				memcpy(Frame[shead->display_order].Y,Ref_back->Y,shead->Image_size);
;;				memcpy(Frame[shead->display_order].U,Ref_back->U,shead->Chroma_size);
;;				memcpy(Frame[shead->display_order].V,Ref_back->V,shead->Chroma_size);
;;          shead->display_order++;
;;				YUV_Output(shead);
;;				pdata->IP_frame_retain=0;
;;				temp=Ref_front;
;;				Ref_front=Ref_back;
;;				Ref_back=temp;
;;			}
;;		}
;;	}
;;}


;sp>> 0:bitstream, 4:sequence_header, 8:gop_header, 12:pic_data, 16:Slice_data0, 20:Init_table, 24: Slice_data1


; a4: *pdata, a6: *pbitstream, a1: *shead, a2: *gop
;;	pdata->temporal_reference=(unsigned char)(readbits(pbs,10,shead));  //10bits
{ b r1,_readbits     | lw a6, sp, 0            | moviu d0,10          | lw a6, sp2, 0            | clr ac2              }
{ lw r6,sp3,0        | lw a1, sp, 4            | nop                  | lw a4,sp2,12             | nop                  }
{ lw r14,sp3,4       | lw a2, sp, 8            | nop                  | lw a1,sp2,4              | nop                  }
{ nop 			      | lw a4, sp,12            | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | lw a2, sp2,8 				 | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;



;;	pdata->picture_coding_type  =(unsigned char)(readbits(pbs,3,shead)); //3bits
{ b r1,_readbits     | sh d5,a4,temporal_reference | moviu d0,3       | nop                      | clr ac2          }
{ (p9)sb r13,r14,Error_flag | nop              | nop                  | nop                      | nop              }
{ nop                | nop                     | nop                  | nop                      | nop              }
{ nop                | nop 	                 | nop 				       | nop 				          | nop			      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	pdata->vbv_delay=(unsigned char)(readbits(pbs,16,shead));
;; pdata->full_pel_vector[0]=pdata->full_pel_vector[1]=0;
{ b r1,_readbits     | sb d5,a4,picture_coding_type | moviu d0,16     | nop                      | clr ac2          }
{ (p9)sb r13,r14,Error_flag | nop              | clr d1              | nop                      | nop              }
{ nop                | sh d1,a4,full_pel_vector_0 | nop                 | nop                      | nop              }
{ nop                | nop 	                 | nop 				       | nop 				          | nop			      }
{ nop 			      | bdt d5 				     | nop 				       | bdr a3 				       | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;
;;	if(pdata->picture_coding_type==2 || pdata->picture_coding_type==3){
;   % p3 = p1 or (p2=p12)
;;		if(shead->constrained_parameter_flag){  //Mpeg1
;        % p4=p13
;;			pdata->full_pel_vector[0]=(unsigned char)(readbits(pbs,1,shead)); // skip 1bit
;;			pdata->f_code[0][0]=pdata->f_code[0][1]=(unsigned char)(readbits(pbs,3,shead));
;;		}
;;		else
;;			buffer=(unsigned char)(readbits(pbs,4,shead));  //skip 4bits
;;	}
;% p11=p3 && (p4=p13)
;cluster1:
;cluster2: d0<<picture_coding_type
{ (p9)sb r13,r14,Error_flag | lbu d0,a1,constrained_parameter_flag | nop | seqiu d1,p1,p0,a3,Pframe | nop              }
{ nop                | nop                     | nop                  | seqiu d1,p2,p0,a3,Bframe | nop                 }
{ nop                | sh d5,a4,vbv_delay      | nop                  | orp p3,p1,p2             | nop                 }
{ (p3)b r1,_readbits | nop 	                 | seqiu ac7,p4,p5,d0,1 | nop                      | (p3)clr ac2         }
{ nop 			      | andp p11,p3,p4 	        | (p3)moviu d0,4       | nop                      | nop				     }
{ nop 			      | nop 				        | nop                  | nop                      | nop				     }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				     }
{ nop 			      | nop 				        | nop                  | andp p12,p2,p0           | nop				     }
{ nop 			      | nop 				        | nop 				       | andp p13,p4,p0 			 | nop				      }
;;
;;	if(pdata->picture_coding_type==3){
;    % p12
;;		if(shead->constrained_parameter_flag){  //Mpeg1
;        % p13
;;			pdata->full_pel_vector[1]=(unsigned char)(readbits(pbs,1,shead));  //skip 1bit
;;			pdata->f_code[1][0]=pdata->f_code[1][1]=(unsigned char)(readbits(pbs,3,shead));
;;		}
;;		else
;;			buffer=(unsigned char)(readbits(pbs,4,shead)); //skip 4bits
;;	}
{ (p12)b r1,_readbits| (p11)slli d4,d5,29 	  | nop 		             | moviu a7,GLOBAL_POINTER_ADDR| (p12)clr ac2		}
{ nop 			      | (p11)srli d4,d4,29 	  | andp p14,p12,p13 	 | lw d15,a7,Memcpy_Mode    | nop				      }
{ nop 			      | (p11)sb d4,a4,f_code00  | nop 				       | nop                      | nop		            }
{ nop 			      |(p11)srli d8,d5,3        | (p12)moviu d0,4 		 | lbu d11,a1,Mpeg2_flag      | nop				      }
{ nop 			      | (p11)sb d4,a4,f_code01  | nop 				       | nop                      | copy ac5,d15         }
{ nop 			      |(p11)sb d8,a4,full_pel_vector_0  | nop    	       | nop 				          | nop				      }
;



;;	while(readbits(pbs,1,shead))
;       % p1
;;		pdata->extra_information_picture=(unsigned char)(readbits(pbs,8,shead));  //skip 1 or 9 bits
_extra_loop:
{ b r1,_readbits 	   | (p14)slli d4,d5,29 	  | nop 				   | moviu d9,1                   | nop				      }
{ (p9)sb r13,r14,Error_flag |(p14)srli d4,d4,29| nop 				       | xor d0,d9,d11  	          | nop				      }
{ nop 			      | (p14)sb d4,a4,f_code10  | moviu d0,1		       | sb d0,a1,constrained_parameter_flag | clr d8       }
{ nop 			      | nop 				        |(p14)srli d8,d5,3     | sb d8,a4,Pipeline_skip_flag  | clr ac2				   }
{ nop 			      | (p14)sb d4,a4,f_code11  | nop 				       | nop         		          | sgtiu ac7,p13,p0,d0,0 }
{ notp p14,p0         |(p14)sb d8,a4,full_pel_vector_1 | nop		       | nop                          | nop				      }
;
;  % p2
;;	pdata->mb_row_reg=pdata->increment_flag=pdata->increment_temp=0;   //initialize the start of the row of MB address
;;	pdata->previous_MB_address=-1;

;;*	pdata->pipeline_flag_A=2;
;;*	pdata->pipeline_flag_B=0;
;;*	sdata->mb_row=sdata2->mb_row=0;
;;*	sdata->mb_column=sdata2->mb_column=0;


;   shead->constrained_parameter_flag=!shead->Mpeg2_flag;
;	//********Initialize the parameter of picture_coding_extension in Mpeg1 Bitstream
;;	if(shead->constrained_parameter_flag || pdata->picture_coding_type==Dframe){
;     %p15=%p13 || %p12
;;		pdata->picture_structure=Frame_picture;
;;		pdata->frame_pred_frame_dct=1;
;;		pdata->intra_dc_precision=pdata->concealment_motion_vectors=pdata->q_scale_type=pdata->intra_vlc_format=pdata->alternate_scan=0;
;;    pdata->intra_dc_mult=3;
;;    for(i=0;i<64;i++)
;;			itable->IS_address[i]=&(sdata->QF[itable->Scan[0][i]]);
;;	}
; % p11=p2=!p1
{ nop   	         | lw a3,sp,16		       | moviu d10,2    	  | clr d10				     | nop           	      }
{ nop  	             | sb d10,a4,Pipeline_flag_A | nop 				  | nop 				     | nop				      }
{ nop  	             | nop 				       | clr d10			  | lw a5,sp2,24    	     | nop				      }
{ nop  	             | sh d10,a3,mb_row        | nop 	              | nop 				     | nop				      }
{ nop  	             | sb d10,a4,Pipeline_flag_B | nop    			  | nop             	     | nop				      }

{ (p9)sb r13,r14,Error_flag | lhu d14,a1,display_order| seqiu ac7,p1,p2,d5,1 | sh d10,a5,mb_row  | movi d1,(-1)		    }
{ (p1)b r1,_readbits | moviu d9,IS_address	  | (p1)moviu d0,8 		 | lbu a3,a4,picture_coding_type | (p1)clr ac2	   }
{ nop 	            | lw d11,a1,vertical_size | clr d1 				    | sh d1,a4,previous_MB_address  | nop		         }
{ nop 			      | sb d1,a4,mb_row_reg     | nop 				       | nop                      | nop				      }
{ clr r5 			   | lw d12,sp,20            | nop 				       | seqiu d2,p12,p0,a3,Dframe| nop				      }
{ andp p11,p2,p0     | lw d13,sp,16            |(p2)clr d5            | orp p15,p12,p13          | nop			         }
{ andp p14,p1,p0     | sh d1,a4,increment_flag | fmuluu d11,d11,d14   | andp p15,p15,p11         | nop                  }
;
{(p14)b _extra_loop  |(p15)addi a5,d12,Scan    | moviu d8,0           | lbu d10,a2,field_count_flag | moviu d1,1		   }
{(p15)set_lbci r5,64 |(p15)addi a6,d13,QF      | nop                  | lbu d11,a4,picture_coding_type  | (p15)moviu d4,Frame_picture}
_IS_loop:
{ lbcb r5,_IS_loop   | (p15)lbu d14,a5,1+      | notp p11,p0          | clr d8                   | notp p9,p0	         }
{ notp p12,p0        | add a3,d9,d12           | notp p13,p0 	       | lbu d2,a4,IP_frame_retain| seqiu ac7,p10,p8,d10,0}
{ notp p14,p0        |(p15)snw d8,a4,concealment_motion_vectors | nop | moviu d9,3 	             |(p10)seqiu ac7,p12,p0,d11,Iframe}
{(p9)sb r13,r14,Error_flag |(p15)add a7,d14,d14| notp p3,p0           |(p15)sb d1,a4,frame_pred_frame_dct|(p10)seqiu ac7,p13,p0,d11,Pframe 	}
;;(p14)
{ orp p11,p12,p13    |(p15)add d2,a6,a7        | nop 			          |(p15)sb d9,a4,intra_dc_mult |(p10)sgtiu ac7,p14,p3,d2,0}
{ andp p14,p14,p11   |(p15)sw d2,a3,0          | addi d9,d9,4 		    |(p15)sb d8,a4,intra_dc_precision | notp p9,p11	}
;
{ nop   			 | moviu a7,GLOBAL_POINTER_ADDR | moviu d1,1      |(p11)sb d8,a4,IP_frame_retain 	| orp p6,p9,p14   }
{ nop                |(p6)lw d10,a7,FrameWidth_Multi|(p8)clr d5         |(p15)sb d4,a4,picture_structure|(p14)ori d15,ac5,0x00000001}
{(p8)br r7           | nop                     | nop 	            |(p14)lhu d7,a1,display_order 	| nop				   }
{ nop                |(p10)lw d2,a7,Ref_Front_ADDR |(p6)unpack2u d12,d11|(p10)moviu a7,GLOBAL_POINTER_ADDR | moviu ac2,Frame_buffer_size}
{(p14)moviu r11,1    | nop                     |(p6)fmuluu ac3,d10,d12 |(p10)lw d2,a7,Ref_Back_ADDR | srli ac2,ac2,1		}
{ nop 			     |(p6)lw d9,a7,REFFRAME_ADDR|(p6)fmuluu ac6,d10,d13 | nop 				          | nop				      }
{ nop 			     |(p10)lhu d8,a4,temporal_reference |(p6)slli ac6,ac6,16    | nop 				          | nop				      }

;----Mpeg2 Consecutivity
;{ notp p7,p0 			|sb d5,a4,extra_information_picture |(p6)add ac3,ac3,ac6 |(p14)sw d15,a7,Memcpy_Mode|(p14)addi d7,d7,1	}
{ notp p7,p0 			|sb d5,a4,extra_information_picture |(p6)add ac3,ac3,ac6 |(p14)sw d15,a7,Memcpy_Mode|nop	}


;//***************************Picture_reorder
;;*if(!gop->field_count_flag){
;  % p10
;;*	if(pdata->picture_coding_type==Iframe || pdata->picture_coding_type==Pframe){
;    % p11=p12 || p13
;;*    if(pdata->IP_frame_retain){
;    % p14
;*				//Mode1
;				//The Pframe decoded before the Bframe can not be displayed !
;;*		     memcpy(Frame[shead->display_order].Y,Ref_back->Y,shead->Image_size);
;;*		     memcpy(Frame[shead->display_order].U,Ref_back->U,shead->Chroma_size);
;;*		     memcpy(Frame[shead->display_order].V,Ref_back->V,shead->Chroma_size);
;;*		  shead->display_order++;
;;*		  YUV_Output(shead,pdata);
;;         if(!(pdata->picture_coding_type==Iframe && pdata->temporal_reference==0)){
;           % p14 && !(p6)
;           %p6=1 >> pdata->picture_coding_type==Iframe && pdata->temporal_reference==0

;;					temp=Ref_front;
;;					Ref_front=Ref_back;
;;					Ref_back=temp;
;;				}
;;	   }
;;    else if(pdata->picture_coding_type==Iframe && pdata->temporal_reference==0){
;     % p6 && !p14
;				//I(0)I(0).....
;;				temp=Ref_front;
;;				Ref_front=Ref_back;
;;				Ref_back=temp;
;;		}
;    p15=p6 xor p14
;;	   if(pdata->picture_coding_type==Iframe){
;  % p12
;;		     if(pdata->temporal_reference==0)
;          % p6
;;*	        De_frame=Ref_front;
;;		     else
;          % p7
;;*		    De_frame=Ref_back;
;;	   }
;;	   else
;  % p13
;;*	     De_frame=Ref_back;
;;*  pdata->IP_frame_retain=0;
;;	}
;;	else  //B-  or D- frame
;  % p9= !p11
;;*   De_frame=&Frame[shead->display_order];
;;}
; p8
; p8;cluster1: d2<< ref_front_addr, d8<<temporal_reference, d9<<REFERENCE_ADDR, d10<< FrameWidth_Multi, d11<<display_order*vertical_size
;          d3<< ref_back_addr
;cluster2: d2<< ref_back_addr,  d7<<display_order, d3<<ref_front_addr

;;*****************Break_Point!!!!!!!!!
;{ seqiu r11,p10,p0,r0,16200| nop 	              | nop 				       | nop 				          | orp p13,p13,p0}
;{ andp p10,p10,p13 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p13,p10 		|(p10)moviu a7,0xb00a9000 | nop 				       | nop 				          | nop				      }
;{(p13)b _end1 	      | nop				           |(p12)seqiu ac7,p6,p7,d8,0 				       | nop		                | nop				      }
;{ nop	               | nop                     | xorp p15,p14,p6 				       | nop 				          | nop				      }
;{ nop 			      |(p7)moviu d5,0x55667788| nop 				       | nop 				          | nop				      }
;{ nop 			      |(p10)sw d5,a7,0         | nop 				       | nop 				          | nop				      }
;{(p10) moviu r3,1    | nop 				        | notp p13,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p10,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end1:
;;********************************************
;r12>>DAR, r13>>SAR
;cluster1:d4>>DAR,  cluster2:d2>>SAR
{ notp p6,p0         |(p11)bdt d2 		        |(p6)add d4,d9,ac3 	 |(p11)bdr d3 				    | seq ac7,p1,p0,d7,ac2}
;{ notp p6,p0         |(p11)bdt d2                       |(p6)copy d4,d9          |(p11)bdr d3                               | seq ac7,p1,p0,d7,ac2}


{(p3)br r7 			   |(p11)bdr d3 				  |(p12)seqiu ac7,p6,p7,d8,0|(p11)bdt d2 				 |nop				}
{ orp p13,p13,p7 	   |(p9)sw d4,a7,Decode_ADDR | xorp p15,p14,p6      |(p14)sh d7,a1,display_order| nop		            }	
{(p14)moviu r10,EMDMAC_ADDR|(p6)sw d2,a7,Decode_ADDR | clr d5         |(p13)sw d2,a7,Decode_ADDR | orp p8,p14,p9        }
{(p14)bdr r13  	   |(p15)sw d3,a7,Ref_Front_ADDR  | nop 		       |(p14)bdt d2               | andp p13,p13,p15   }
{(p14)bdr r12 			|(p14)bdt d4              | andp p6,p6,p15       |(p13)sw d3,a7,Decode_ADDR | nop				      }
{ orp p15,p15,p0    	|(p6)sw d3,a7,Decode_ADDR | nop 				       |(p15)sw d3,a7,Ref_Back_ADDR| nop				      }
;;(p3)

.if 0
_Frame_Moving_Polling:
{(p14)lw r11,r10,R054_DMASTAT| nop 			  | nop 				       | nop 				          | nop				      }
{(p14)notp p15,p0    | nop   	        | nop 				       | nop 				          | nop				      }
{ notp p6,p0         | nop 				        | nop 				       | nop 				          | nop				      }
{(p14)andi r11,r11,0x0000000f | nop 				        | nop 				       | nop 				          | nop				      }
{(p14 )seqiu r11,p15,p6,r11,0x00000002 | nop   | nop 				       | nop 				          | nop				      }
;(p8)
{(p6)b _Frame_Moving_Polling | nop 				        | nop 				       | nop 				          | nop				      }
{ nop                | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 	            | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 	            | nop 				        | nop 				       |(p14)lw d8,a7,Frame_Size_420 | nop			      }
{(p15)moviu r11,1    | nop 				        | nop 				       | nop 				          | nop				      }
{(p15)br r7          | nop 				        | nop 				       | nop 				          | nop				      }
;
.endif

{(p14)sw r12,r10,R074_DAR0 | nop 				  | nop 				       |(p14)slli d8,d8,12        | moviu ac2,0x00000007  }
{(p14)sw r13,r10,R070_SAR0 | nop 				  | nop 				       |(p14)moviu a7,EMDMAC_ADDR | nop				      }
{(p14)sw r11,r10,R088_CLR0 | nop 	           | nop 				       | nop                      |(p14)or d8,d8,ac2     }
{ nop 	            | nop 	                 | nop 				       |(p14)sw d8,a7,R080_CTL0   | nop				      }

;---Mpeg2 Consecutivity
;{(p14)sw r11,r10,R084_EN0  | nop 	     | nop 				       | nop                      | nop				      }
{ nop                      | nop 	     | nop 				       | nop                      | nop				      }
;		 
.endp	Picture_header
;------------------------------------


;----Quant_matrix_extension.s
.proc	Quant_matrix_extension
.global	Quant_matrix_extension
Quant_matrix_extension:



;;void Quant_matrix_extension(Bitstream *pbs,Seq_header *shead){
;;	i=0;
;;	shead->load_intra_quantiser_matrix=(unsigned char)(readbits(pbs,1,shead));
;;	if(shead->load_intra_quantiser_matrix){ //load_intra_quantiser_matrix >>1bit
;;		for(i=0;i<64;i++)   //8*64bits
;;			shead->intra_quantiser_matrix[i]=(unsigned char)(readbits(pbs,8,shead));
;;	}
;;	shead->load_non_intra_quantiser_matrix=(unsigned char)(readbits(pbs,1,shead));
;;	if(shead->load_non_intra_quantiser_matrix){ //load_non_intra_quantiser_matrix >>1bit
;;		for(i=0;i<64;i++)   //8*64bits
;;			shead->non_intra_quantiser_matrix[i]=(unsigned char)(readbits(pbs,8,shead));
;;	}
;;}
; a6: *pbitstream, a1: *shead
;;	shead->load_intra_quantiser_matrix=(unsigned char)(readbits(pbs,1,shead));
{ b r1,_readbits     | lw a6, sp, 0            | moviu d0,1           | lw a6,sp2,0              | clr ac2              }
{ lw r6,sp3,0        | lw a1, sp, 4            | nop                  | nop                      | nop                  }
{ lw r14,sp3,4 	   | lw a7,sp,8    	        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;
;;if(shead->load_intra_quantiser_matrix){ //load_intra_quantiser_matrix >>1bit;;
;;		for(i=0;i<64;i++)   //8*64bits
;;			//shead->intra_quantiser_matrix[i]=(unsigned char)(readbits(pbs,8,shead));
;;			shead->intra_quantiser_matrix[itable->Scan[0][i]]=(unsigned char)(readbits(pbs,8,shead));
;;	}

{ nop                | sb d5,a1,load_intra_quantiser_matrix | nop     | nop                      | nop              }
{ set_lbci r5,16     | copy a2,a7              | seqiu ac7,p11,p12,d5,1 | nop                    | nop              }
_intra_loop2:
{ (p11)b r1,_readbits| nop                     | (p11)moviu d0,16     | nop                      | (p11)clr ac2      }
{ seqiu r2,p3,p0,r5,16 | nop                   | nop 	                | nop                      | nop	            }
{(p12)clr r5         |(p3)addi a5,a7,Scan      | nop                  | nop                      | nop				   }
{ nop                |(p11)lw d11,a5,4+        | nop 				       | nop 				          | nop				   }
{ nop 			      |(p3)addi a4,a1,intra_quantiser_matrix | nop     | nop 				          | nop				   }
{ nop                | nop                     | nop 				       | nop 				          | nop				   }
;;
{ (p11)b r1,_readbits|(p11)swap4 d2,d5         |(p11)extractiu d12,d11,8,8| nop                  | (p11)clr ac2      }
{ nop                |(p11)andi d13,d11,0xff   |(p11)extractiu d3,d2,8,8  | nop                  | nop	            }
{ nop 	            |(p11)add a3,a4,d13       |(p11)andi d2,d2,0xff  | nop                      | nop				   }
{ nop                |(p11)sb d2,a3,0          | nop 				       | nop 				          | nop				   }
{ nop 			      |(p11)add a3,a4,d12       |(p11)moviu d0,16      | nop 				          | nop				   }
{ nop                |(p11)sb d3,a3,0          |(p11)srli d11,d11,16  | nop 				          | nop				   }
;;
{ lbcb r5,_intra_loop2|(p11)swap4 d2,d5         |(p11)extractiu d12,d11,8,8| nop                  | nop              }
{ nop                |(p11)andi d13,d11,0xff   |(p11)extractiu d3,d2,8,8| nop                    | nop              }
{ nop 			      |(p11)add a3,a4,d13		  | (p11)andi d2,d2,0xff | nop 				          | nop			      }
{ nop 			      |(p11)sb d2,a3,0			  | nop 				       | nop 				          | nop				   }
{ nop 			      |(p11)add a3,a4,d12 		  | nop 				       | nop 				          | nop				   }
{ nop 			      |(p11)sb d3,a3,0 			  | nop 				       | nop 				          | nop				   }



;;	shead->load_non_intra_quantiser_matrix=(unsigned char)(readbits(pbs,1,shead));
{ b r1,_readbits 	   | nop 				        | moviu d0,1 		    | nop 				          | clr ac2				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;;	if(shead->load_non_intra_quantiser_matrix){ //load_non_intra_quantiser_matrix >>1bit
;;		for(i=0;i<64;i++)   //8*64bits
;;			shead->non_intra_quantiser_matrix[i]=(unsigned char)(readbits(pbs,8,shead));
;;	}

;;*****************Break_Point!!!!!!!!!
;{ seqiu r11,p14,p0,r0,16200| nop 	              | nop 				       | nop 				          | orp p15,p15,p0}
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p15,p14 		|(p14)moviu a7,0xb00a9000 | nop 				       | nop 				          | nop				      }
;{(p15)b _end2 	      | nop				           | nop 				       | nop		                | nop				      }
;{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p13)moviu d5,0x55667788| nop 				       | nop 				          | nop				      }
;{ nop 			      |(p14)sw d5,a7,0         | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    | nop 				        | notp p15,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end2:
;;********************************************

{ nop                | sb d5,a1,load_non_intra_quantiser_matrix | nop | nop                      | nop              }
{ set_lbci r5,16     | copy a2,a7              | seqiu ac7,p11,p12,d5,1 | nop                    | nop              }
_nonintra_loop2:
{ (p11)b r1,_readbits| nop                     | (p11)moviu d0,16     | nop                      | (p11)clr ac2   }
{ seqiu r2,p3,p0,r5,16| nop                    | nop 	                | nop                      | nop	            }
{(p12)clr r5         |(p3)addi a5,a7,Scan      | nop                  | nop                      | nop				   }
{ nop                |(p11)lw d11,a5,4+        | nop                  | nop 				          | nop				   }
{ nop                |(p3)addi a4,a1,non_intra_quantiser_matrix| nop  | nop               | nop				   }
{ nop                | nop 	                 | nop 				       | nop 				          | nop				   }
;;
{ (p11)b r1,_readbits|(p11)swap4 d2,d5         |(p11)extractiu d12,d11,8,8| nop                  | (p11)clr ac2      }
{ nop                |(p11)andi d13,d11,0xff   |(p11)extractiu d3,d2,8,8  | nop                  | nop	            }
{ nop 	            |(p11)add a3,a4,d13       |(p11)andi d2,d2,0xff  | nop                      | nop				   }
{ nop                |(p11)sb d2,a3,0          | nop 				       | nop 				          | nop				   }
{ nop 			      |(p11)add a3,a4,d12       |(p11)moviu d0,16      | nop 				          | nop				   }
{ nop                |(p11)sb d3,a3,0          |(p11)srli d11,d11,16  | nop 				          | nop				   }
;;
{ lbcb r5,_nonintra_loop2|(p11)swap4 d2,d5      |(p11)extractiu d12,d11,8,8| nop                  | nop              }
{ nop                |(p11)andi d13,d11,0xff   |(p11)extractiu d3,d2,8,8| nop                    | nop              }
{ nop 			      |(p11)add a3,a4,d13		  | (p11)andi d2,d2,0xff | nop 				          | nop			      }
{ nop 			      |(p11)sb d2,a3,0			  | nop 				       | nop 				          | nop				   }
{ nop 			      |(p11)add a3,a4,d12 		  | nop 				       | nop 				          | nop				   }
{ nop 			      |(p11)sb d3,a3,0 			  | nop 				       | nop 				          | nop				   }
;



{ br r7			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | clr d5			           | nop 				       | nop 				          | nop				      }
.endp	Quant_matrix_extension
;-----------------------------------

;-----------Sequence_extension.s
.proc	Sequence_extension
.global	Sequence_extension
Sequence_extension:
;;void Sequence_extension(Bitstream* pbs,Seq_header *shead,Seq_ext *sext){
;;	unsigned char buffer;
;;	i=0;
;;	sext->profile_and_level_indication=(unsigned char)(readbits(pbs,8,shead));
;;	sext->progressive_sequence     =(unsigned char)(readbits(pbs,1,shead));   //1bit
;;	sext->chroma_format            =(unsigned char)(readbits(pbs,2,shead));  //2bits
;;	sext->horizontal_size_extension=(unsigned char)(readbits(pbs,2,shead));  //2bits
;;	sext->vertical_size_extension=(unsigned char)(readbits(pbs,2,shead));  //2bits
;;	sext->bit_rate_extension    =(unsigned short)(readbits(pbs,12,shead));   //12bits
;;	buffer=(unsigned char)(readbits(pbs,1,shead));  //skip 1bit
;;	sext->vbv_buffer_size_extension=(unsigned char)(readbits(pbs,8,shead));
;;	sext->low_delay=(unsigned char)(readbits(pbs,1,shead));
;;	sext->frame_rate_extension_n=(unsigned char)(readbits(pbs,2,shead));
;;	sext->frame_rate_extension_d=(unsigned char)(readbits(pbs,5,shead));
;;	shead->horizontal_size+=(sext->horizontal_size_extension<<12);
;;	shead->vertical_size+=(sext->vertical_size_extension<<12);
;;	shead->bit_rate       +=(sext->bit_rate_extension<<18);
;;}
; a6: *pbitstream, a1: *shead, a2: *sext

;;shead->Mpeg2_flag=1;
;;	sext->profile_and_level_indication=(unsigned char)(readbits(pbs,8,shead));
{ b r1,_readbits     | lw a6, sp, 0            | moviu d0,8           | lw a6,sp2,0              | nop                  }
{ lw r6,sp3,0        | lw a1, sp, 4            | nop                  | lw a1,sp2,4              | nop                  }
{ lw r14,sp3,4       | lw a2, sp, 8            | nop                  | lw a2,sp2,8              | nop                  }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;
;;	sext->progressive_sequence     =(unsigned char)(readbits(pbs,1,shead));   //1bit
{ b r1,_readbits 	   | sb d5,a2,profile_and_level_indication | nop    | nop 				          | nop				      }
{ (p9)sb r13,r14,Error_flag | nop 				  | moviu d0,1 			 | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop			              | nop 				       | nop 				          | nop				      }
{ nop 			      | sb d0,a1,Mpeg2_flag         | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;
;;	sext->chroma_format            =(unsigned char)(readbits(pbs,2,shead));  //2bits
{ b r1,_readbits 	   | sb d5,a2,progressive_sequence | nop            | nop 				          | nop				      }
{ (p9)sb r13,r14,Error_flag | nop 				  | moviu d0,2 			 | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop			              | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;
;;	sext->horizontal_size_extension=(unsigned char)(readbits(pbs,2,shead));  //2bits
{ b r1,_readbits 	   | sb d5,a2,chroma_format  | nop                  | nop 				          | nop				      }
{ (p9)sb r13,r14,Error_flag | nop 				  | moviu d0,2 			 | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop			              | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;
;;	sext->vertical_size_extension=(unsigned char)(readbits(pbs,2,shead));  //2bits
{ b r1,_readbits 	   | sb d5,a2,horizontal_size_extension | nop       | nop 				          | nop				      }
{ (p9)sb r13,r14,Error_flag | nop 				  | moviu d0,2 			 | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop			              | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;
;;	sext->bit_rate_extension    =(unsigned short)(readbits(pbs,12,shead));   //12bits
{ b r1,_readbits 	   | sb d5,a2,vertical_size_extension | nop         | nop 				          | nop				      }
{ (p9)sb r13,r14,Error_flag | nop 				  | moviu d0,12 			 | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop			              | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;
;;	buffer=(unsigned char)(readbits(pbs,1,shead));  //skip 1bit
;;	sext->vbv_buffer_size_extension=(unsigned char)(readbits(pbs,8,shead));
{ b r1,_readbits 	   | sh d5,a2,bit_rate_extension | nop              | nop 				          | nop				      }
{ (p9)sb r13,r14,Error_flag | nop 				  | moviu d0,9 			 | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop			              | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;
;;	sext->low_delay=(unsigned char)(readbits(pbs,1,shead));
{ b r1,_readbits 	   | nop                     | moviu d0,1           | nop 				          | nop				      }
{ (p9)sb r13,r14,Error_flag | slli d4,d5,24 	  | nop 			          | nop 				          | nop				      }
{ nop 			      | srli d4,d4,24 			  | nop 				       | nop 				          | nop				      }
{ nop 			      | sb d4,a1,vbv_buffer_size_extension | nop 		 | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;
;;	sext->frame_rate_extension_n=(unsigned char)(readbits(pbs,2,shead));
{ b r1,_readbits 	   | sb d5,a2,low_delay      | nop                  | nop 				          | nop				      }
{ (p9)sb r13,r14,Error_flag | nop 				  | moviu d0,2 			 | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop			              | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;
;;	sext->frame_rate_extension_d=(unsigned char)(readbits(pbs,5,shead));
{ b r1,_readbits 	   | sb d5,a2,frame_rate_extension_n | nop          | nop 				          | nop				      }
{ (p9)sb r13,r14,Error_flag | nop 				  | moviu d0,5 			 | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop			              | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;
;;	shead->horizontal_size+=(sext->horizontal_size_extension<<12);
;;	shead->vertical_size+=(sext->vertical_size_extension<<12);
;;	shead->bit_rate       +=(sext->bit_rate_extension<<18);
{ nop 	            | sb d5,a2,frame_rate_extension_d | nop          | lbu d1,a2,horizontal_size_extension | nop		   }
{ (p9)sb r13,r14,Error_flag | lw d1,a1,horizontal_size | nop 			 | lbu d8,a2,vertical_size_extension   | nop			}
{ nop 			      | lw d8,a1,vertical_size  | nop 				       | lhu d3,a2,bit_rate_extension 		   | nop		   }
{ nop 			      | lw d9,a1,bit_rate		  | nop 				       | nop 				          | slli d1,d1,12		   }
{ nop 			      | bdr d3 				     | nop 				       | bdt d1 				       | slli d8,d8,12		   }
{ br r7 			      | bdr d10 				     | nop 				       | bdt d8 				       | slli d3,d3,18		   }
{ nop 			      | bdr d11 				     | add d1,d1,d3 		    | bdt d3 				       | nop				      }
{ nop 			      | sw d1,a1,horizontal_size| add d2,d8,d10 		 | nop 				          | nop				      }
{ nop 			      | sw d2,a1,vertical_size  | add d9,d9,d11 	    | nop 				          | nop				      }
{ nop 			      | sw d9,a1,bit_rate 	     | nop 				       | nop 				          | nop				      }
{ nop 			      | clr d5			           | nop 				       | nop 				          | nop				      }
.endp	Sequence_extension
;-----------------------------------------

;----------------Sequence_header.s
.proc	Sequence_header
.global	Sequence_header
Sequence_header:
;;void Sequence_header(Bitstream *pbs,Seq_header *shead,Init_table *itable){
;;	unsigned short buffer;
;;	i=0;
;;*	shead->horizontal_size=(unsigned int)(readbits(pbs,12,shead));  //12bits
;;*	shead->vertical_size=(unsigned int)(readbits(pbs,12,shead));  //12bits
;;*	shead->aspect_ratio_information=(unsigned char)(readbits(pbs,4,shead));  //4bits
;;*	shead->frame_rate_code         =(unsigned char)(readbits(pbs,4,shead));  //4bits
;;*   shead->bit_rate=(unsigned int)(readbits(pbs,18,shead));
;;*	buffer=(unsigned char)(readbits(pbs,1,shead)); //skip 1bit
;;*	shead->vbv_buffer_size_value=(unsigned short)(readbits(pbs,10,shead));//10bits
;;*	shead->constrained_parameter_flag=(unsigned char)(readbits(pbs,1,shead)); //1bit
;;*	shead->load_intra_quantiser_matrix=(unsigned char)(readbits(pbs,1,shead));  //1bit
;;*	if(shead->load_intra_quantiser_matrix){
;;*		for(i=0;i<64;i++)   //8*64bits
;;*			shead->intra_quantiser_matrix[i]=(unsigned char)(readbits(pbs,8,shead));
;;*	}
;;*	else{
;;*		for(i=0;i<64;i++)
;;*			shead->intra_quantiser_matrix[i]=itable->Default_intra_quantiser_matrix[i];
;;*	}
;;*shead->load_non_intra_quantiser_matrix=(unsigned char)(readbits(pbs,1,shead));  //1bit
;;*if(shead->load_non_intra_quantiser_matrix){
;;*	for(i=0;i<64;i++)   //8*64bits
;;*		shead->non_intra_quantiser_matrix[i]=(unsigned char)(readbits(pbs,8,shead));
;;*}
;;*else{
;;*	for(i=0;i<64;i++)
;;*		shead->non_intra_quantiser_matrix[i]=16;   //default matrix for non_quantisation matrix
;;*}
;;	//**********Initialize the image and row size
;;*	if(shead->Image_size==0){
;;*		shead->Image_size=shead->horizontal_size*shead->vertical_size;
;;*		shead->Chroma_size=shead->Image_size>>2;
;;*	}
;;*	if(shead->mb_width==0){
;;*		shead->mb_width=(shead->horizontal_size+15)>>4;
;;*		shead->mb_height=(shead->vertical_size+15)>>4;
;;*	}
;;	//***************
;;*}
; a6: *pbitstream, a1: *shead, a7: *itable
; r6: *pnistream, r14: *shead
;shead->horizontal_size=(unsigned int)(readbits(pbs,12,shead));
{ b r1,_readbits    | lw a6, sp, 0        | moviu d0,12     | lw a6,sp2,0       | clr ac2          }
{ lw r6,sp3,0       | lw a1, sp, 4        | nop             | lw a1,sp2,4       | nop              }
{ lw r14,sp3,4      | lw a7, sp, 8        | nop             | nop               | nop              }
{ nop               | nop 	               | nop 				| nop 				  | nop			      }
{ nop               | nop 		            | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
;shead->vertical_size=(unsigned int)(readbits(pbs,12,shead));
{ b r1,_readbits    | sw d5,a1,horizontal_size | moviu d0,12 | nop              | clr ac2          }
{ (p9)sb r13,r14,Error_flag | clr d8      | sltiu ac7,p1,p0,d5,17 | nop         | nop              }
{ nop               |(p1)moviu d8,1        | nop             | nop               | nop              }
{ nop               | sb d8,a1,frame_16x16_flag | nop 		 | nop 				  | nop			      }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
;shead->aspect_ratio_information=(unsigned char)(readbits(pbs,4,shead));
{ b r1,_readbits    | sw d5,a1,vertical_size | moviu d0,4   | nop               | clr ac2          }
{ (p9)sb r13,r14,Error_flag | nop         | nop             | nop               | nop              }
{ nop               | nop                 | nop             | nop               | nop              }
{ nop               | nop 	               | nop 				| nop 				  | nop			      }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
;shead->frame_rate_code         =(unsigned char)(readbits(pbs,4,shead));
{ b r1,_readbits    | sb d5,a1,aspect_ratio_information | moviu d0,4   | nop    | clr ac2          }
{ (p9)sb r13,r14,Error_flag | nop         | nop             | nop               | nop              }
{ nop               | nop                 | nop             | nop               | nop              }
{ nop               | nop 	               | nop 				| nop 				  | nop			      }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
;shead->bit_rate=(unsigned int)(readbits(pbs,18,shead));
;;******************************************
{ b r1,_readbits    | sb d5,a1,frame_rate_code | moviu d0,16| nop               | clr ac2          }
{ (p9)sb r13,r14,Error_flag | nop         | nop             | nop               | nop              }
{ nop               | nop                 | nop             | nop               | nop              }
{ nop 	           | nop 		            | nop 				| nop 				  | nop			      }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
;
{ b r1,_readbits    | nop                 | clr ac6         | nop               | clr ac2          }
{ (p9)sb r13,r14,Error_flag | nop         | slli ac6,d5,2   | nop               | nop              }
{ nop               | nop                 | moviu d0,2      | nop               | nop              }
{ nop 	           | nop 		            | nop 				| nop 				  | nop			      }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
;;***********************************************
;buffer=(unsigned char)(readbits(pbs,1,shead)); //skip 1bit
;shead->vbv_buffer_size_value=(unsigned short)(readbits(pbs,10,shead));//10bits
{ b r1,_readbits    | nop                 | moviu d0,11     | nop               | clr ac2          }
{ (p9)sb r13,r14,Error_flag | nop         | or d4,ac6,d5    | nop               | nop              }
{ nop               | sw d4,a1,bit_rate   | nop             | nop               | nop              }
{ nop 	           | nop 		            | nop 				| nop 				  | nop			      }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
;shead->constrained_parameter_flag=(unsigned char)(readbits(pbs,1,shead)); //1bit
{ b r1,_readbits    | nop                 | moviu d0,1      | nop               | clr ac2          }
{ (p9)sb r13,r14,Error_flag | slli d4,d5,22       | nop     | nop               | nop              }
{ nop               | srli d4,d4,22       | nop             | nop               | nop              }
{ nop		           | sh d4,a1,vbv_buffer_size_value | nop 	| nop 				  | nop			      }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
;shead->load_intra_quantiser_matrix=(unsigned char)(readbits(pbs,1,shead));  //1bit
{ b r1,_readbits    | sb d5,a1,constrained_parameter_flag | moviu d0,1 | nop    | clr ac2          }
{ (p9)sb r13,r14,Error_flag | nop         | nop             | nop               | nop              }
{ nop               | nop                 | nop             | nop               | nop              }
{ nop 	           | nop 		            | nop 				| nop 				  | nop			      }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }

;;if(shead->load_intra_quantiser_matrix){
; %p11
;;		for(i=0;i<64;i++)   //8*64bits
;;			shead->intra_quantiser_matrix[itable->Scan[0][i]]=(unsigned char)(readbits(pbs,8,shead));
;;	}
;;	else{
;  %p12
;;		for(i=0;i<64;i++)
;;			shead->intra_quantiser_matrix[i]=itable->Default_intra_quantiser_matrix[i];
;;	}

;% p3=1>> r5==32  >> a4=address of intra_quantiser_matrix
{ nop                | sb d5,a1,load_intra_quantiser_matrix | nop     | nop                      | nop              }
{ set_lbci r5,16     | copy a2,a7              | seqiu ac7,p11,p12,d5,1 | nop                    | nop              }
_intra_loop:
{ (p11)b r1,_readbits| nop                     | (p11)moviu d0,16     | nop                      | (p11)clr ac2      }
{ seqiu r2,p3,p0,r5,16| (p12)lw d1,a2,4+       | nop 	                | nop                      | nop	            }
{ nop 	            |(p3)addi a5,a7,Scan      | nop                  | nop                      | nop				   }
{ (p9)sb r13,r14,Error_flag|(p11)lw d11,a5,4+  | nop 				       | nop 				          | nop				   }
{ nop 			      |(p3)addi a4,a1,intra_quantiser_matrix | nop     | nop 				          | nop				   }
{ nop                |(p12)sw d1,a4,4+         | nop 				       | nop 				          | nop				   }
;;
{ (p11)b r1,_readbits|(p11)swap4 d2,d5         |(p11)extractiu d12,d11,8,8| nop                  | (p11)clr ac2      }
{ nop                |(p11)andi d13,d11,0xff   |(p11)extractiu d3,d2,8,8  | nop                  | nop	            }
{ nop 	            |(p11)add a3,a4,d13       |(p11)andi d2,d2,0xff  | nop                      | nop				   }
{ (p9)sb r13,r14,Error_flag |(p11)sb d2,a3,0   | nop 				       | nop 				          | nop				   }
{ nop 			      |(p11)add a3,a4,d12       |(p11)moviu d0,16      | nop 				          | nop				   }
{ nop                |(p11)sb d3,a3,0          |(p11)srli d11,d11,16  | nop 				          | nop				   }
;;
{ lbcb r5,_intra_loop|(p11)swap4 d2,d5         |(p11)extractiu d12,d11,8,8| nop                  | nop              }
{ (p9)sb r13,r14,Error_flag |(p11)andi d13,d11,0xff |(p11)extractiu d3,d2,8,8| nop               | nop              }
{ nop 			      |(p11)add a3,a4,d13		  | (p11)andi d2,d2,0xff | nop 				          | nop			      }
{ nop 			      |(p11)sb d2,a3,0			  | nop 				       | nop 				          | nop				   }
{ nop 			      |(p11)add a3,a4,d12 		  | nop 				       | nop 				          | nop				   }
{ nop 			      |(p11)sb d3,a3,0 			  | nop 				       | nop 				          | nop				   }
;




;	shead->load_non_intra_quantiser_matrix=(unsigned char)(readbits(pbs,1,shead));  //1bit
{ b r1,_readbits    | nop                 | moviu d0,1      | nop               | clr ac2          }
{ nop               | nop                 | nop             | nop               | nop              }
{ nop               | nop                 | nop             | nop               | nop              }
{ nop  	           | nop 		            | nop 				| nop 				  | nop			      }
{ nop               | nop 		            | nop 				| nop 				  | nop				   }
{ nop 			     | nop 				      | nop 				| nop 				  | nop				   }
;
;;if(shead->load_non_intra_quantiser_matrix){
;   %p11
;;		for(i=0;i<64;i++)   //8*64bits
;;			//shead->non_intra_quantiser_matrix[i]=(unsigned char)(readbits(pbs,8,shead));
;;			shead->non_intra_quantiser_matrix[itable->Scan[0][i]]=(unsigned char)(readbits(pbs,8,shead));
;;	}
;;	*else{
;  *   % p12
;;	*	for(i=0;i<64;i++)
;;	*		shead->non_intra_quantiser_matrix[i]=16;   //default matrix for non_quantisation matrix
;;	*}




{ nop                | sb d5,a1,load_non_intra_quantiser_matrix | nop | nop                      | nop              }
{ set_lbci r5,16     | copy a2,a7              | seqiu ac7,p11,p12,d5,1 | nop                    | nop              }
_nonintra_loop:
{ (p11)b r1,_readbits| nop                     | (p11)moviu d0,16     | nop                      | (p11)clr ac2   }
{ seqiu r2,p3,p0,r5,16|(p12)moviu d1,0x10101010| nop 	                | nop                      | nop	            }
{ nop                |(p3)addi a5,a7,Scan      | nop                  | nop                      | nop				   }
{ nop                |(p11)lw d11,a5,4+        | nop                  | nop 				          | nop				   }
{ (p9)sb r13,r14,Error_flag |(p3)addi a4,a1,non_intra_quantiser_matrix| nop  | nop               | nop				   }
{ nop                |(p12)sw d1,a4,4+ 	     | nop 				       | nop 				          | nop				   }
;;
{ (p11)b r1,_readbits|(p11)swap4 d2,d5         |(p11)extractiu d12,d11,8,8| nop                  | (p11)clr ac2      }
{ nop                |(p11)andi d13,d11,0xff   |(p11)extractiu d3,d2,8,8  | nop                  | nop	            }
{ nop 	            |(p11)add a3,a4,d13       |(p11)andi d2,d2,0xff  | nop                      | nop				   }
{ (p9)sb r13,r14,Error_flag |(p11)sb d2,a3,0   | nop 				       | nop 				          | nop				   }
{ nop 			      |(p11)add a3,a4,d12       |(p11)moviu d0,16      | nop 				          | nop				   }
{ nop                |(p11)sb d3,a3,0          |(p11)srli d11,d11,16  | nop 				          | nop				   }
;;
{ lbcb r5,_nonintra_loop|(p11)swap4 d2,d5      |(p11)extractiu d12,d11,8,8| nop                  | nop              }
{ (p9)sb r13,r14,Error_flag |(p11)andi d13,d11,0xff |(p11)extractiu d3,d2,8,8| nop               | nop              }
{ nop 			      |(p11)add a3,a4,d13		  | (p11)andi d2,d2,0xff | nop 				          | nop			      }
{ nop 			      |(p11)sb d2,a3,0			  | nop 				       | nop 				          | nop				   }
{ nop 			      |(p11)add a3,a4,d12 		  | nop 				       | nop 				          | nop				   }
{ nop 			      |(p11)sb d3,a3,0 			  | nop 				       | nop 				          | nop				   }
;

;{ trap               | nop 		            | nop 				| nop 				  | nop				   }

;;*****************Break_Point!!!!!!!!!
;{ seqiu r11,p14,p0,r0,1848| nop 	              | nop 				       | nop 				          | orp p15,p15,p0}
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop          }
;{ notp p15,p14 		|(p14)moviu a7,0xb00a9000 | nop 				       | nop 				          | nop			 }
;{(p15)b _end2 	      | nop				           | nop 				       | nop		                | nop			 }
;{ nop	               | nop                     | nop 				       | nop 				          | nop			 }
;{ nop 			      |nop                      | nop 				       | nop 				          | nop			 }
;{ nop 			      |(p14)sw a1,a7,0         | nop 				       | nop 				          | nop			 }
;{(p14) moviu r3,1    | nop 				        | notp p15,p0			 | nop 				          | nop			 }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop			 }
;;;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop			 }
;_end2:
;;********************************************

;;*	if(shead->Image_size==0){
;  %p1 in cluster1
;;*		shead->Image_size=shead->horizontal_size*shead->vertical_size;
;;*		shead->Chroma_size=shead->Image_size>>2;
;;*	}
;;*	if(shead->mb_width==0){
;  %p2 in cluster2
;;*		shead->mb_width=(shead->horizontal_size+15)>>4;
;;*		shead->mb_height=(shead->vertical_size+15)>>4;
;;*	}
;cluster1: d0<< Image_size,d8<<horizontal_size, d9<<vertical_size
;cluster2: d0<< mb_width, d1<<horizontal_size, d9<<vertical_size
{ nop 			      | lw d8,a1,horizontal_size| nop 			          | lw d1,a1,horizontal_size | nop			}
{ nop 			      | lw d9,a1,vertical_size  | nop 			          | lw d9,a1,vertical_size 	 | nop			}
{ nop 			      | lw d0,a1,Image_size     | nop 				       | lbu d0,a1,mb_width       | nop				   }
{ br r7  		      | nop 				        | nop 				       | nop 				          | addi d1,d1,15		}
{ nop 			      | nop 				        | fmul d10,d8,d9 	    | srli d1,d1,4 	          | addi d9,d9,15		}
{ nop 		    	  | srli d11,d10,2  			  | seqiu ac7,p1,p3,d0,0 | srli d9,d9,4             | seqiu ac7,p2,p0,d0,0 }
{ nop 			      | (p1)dsw d10,d11,a1,Image_size| nop                  | (p2)sb d1,a1,mb_width    | nop		}
{ nop 			      | nop                      | nop 			          | (p2)sb d9,a1,mb_height 	 | nop		}
{ nop 			      | clr d5 				     | nop 				       | nop 				          | nop				   }
.endp	Sequence_header
;-------------------------------------------

;---------Slice.s
.proc	Slice
.global	Slice
Slice:
;;void Slice(Bitstream *pbs,Seq_header *shead,GOP_data *gop,Picture_data *pdata
;;		   ,Init_table *itable,Slice_data *sdata,Frame_memory *Fmem){
;;	unsigned char buffer,MB_over;
;;	unsigned int index;

;;#########################################
;;	sdata->PMV0[0][0]=sdata->PMV0[0][1]=sdata->PMV0[1][0]=sdata->PMV0[1][1]=0;
;;	sdata->PMV1[0][0]=sdata->PMV1[0][1]=sdata->PMV1[1][0]=sdata->PMV1[1][1]=0;
;;	i=0;
;;	shead->Error_flag=0;
;;	sdata->mb_row=shead->start_code-1;
;;if(sdata->mb_row>=shead->mb_height)
;;		sdata->mb_row=0;
;;	if(pdata->mb_row_reg==sdata->mb_row && pdata->increment_temp>0){
;;		sdata->Same_slice_flag=1;
;;		if(pdata->increment_temp>0)   //Set the Same_slice_flag for the first time
;;		pdata->previous_MB_address=(sdata->mb_row*shead->mb_width)-1;
;;	}
;;	else{
;;		sdata->Same_slice_flag=0;
;;		pdata->mb_row_reg=sdata->mb_row;
;;		pdata->increment_temp=pdata->increment_flag=0;
;;		pdata->previous_MB_address=(sdata->mb_row*shead->mb_width)-1;
;;	}
;;	sdata->slice_quantiser_scale_code=(unsigned char)(readbits(pbs,5,shead));  //5bits
;;	if(readbits(pbs,1,shead)){
;;		buffer=(unsigned char)(readbits(pbs,8,shead));  //skip 8+1 bits
;;		while(readbits(pbs,1,shead))
;;			buffer=(unsigned char)(readbits(pbs,8,shead));  //skip 8+1 bits
;;	}
;;	sdata->dc_dct_pred[0]=sdata->dc_dct_pred[1]=sdata->dc_dct_pred[2]=(1<<(pdata->intra_dc_precision+7));
;;	do{
;;		macroblock(pbs,shead,gop,pdata,itable,sdata,Fmem);
;;		pdata->increment_temp++;
;;		sdata->Same_slice_flag=0;
;;		if(shead->start_code==0x01 && (shead->constrained_parameter_flag || pdata->picture_coding_type==Dframe)
;;			&& sdata->mb_column==shead->mb_width-1 && sdata->mb_row<shead->mb_height-1)
;;			sdata->mb_row++;
;;		if(shead->Error_flag)
;;			MB_over=0;
;;		else{
;;			MB_over = (readbits(pbs,23,shead)==0) ? 0 : 1;
;;			pbs->BitLeftInCache+=23;
;;		}
;;	}while(MB_over);
;;#################################################

;;*******************************************************
;;	if((pdata->picture_coding_type!=Bframe) && gop->field_count_flag){
;;		memcpy(Ref_back->Y,Frame[shead->display_order].Y,shead->Image_size);
;;		memcpy(Ref_back->U,Frame[shead->display_order].U,shead->Chroma_size);
;;		memcpy(Ref_back->V,Frame[shead->display_order].V,shead->Chroma_size);
;;	}
;;	if(shead->Error_flag || (sdata->mb_row==shead->mb_height-1 && sdata->mb_column==shead->mb_width-1
;;		&& !gop->field_count_flag)){
;;		if(shead->Error_flag && shead->display_order>0){
;;			index=(sdata->mb_row<<4)*shead->horizontal_size+(sdata->mb_column<<4);
;;			memcpy(Frame[shead->display_order].Y+index,Frame[shead->display_order-1].Y+index
;;					,shead->Image_size-index);
;;			index=(sdata->mb_row<<3)*(shead->horizontal_size>>1)+(sdata->mb_column<<3);
;;			memcpy(Frame[shead->display_order].U+index,Frame[shead->display_order-1].U+index
;;					,shead->Chroma_size-index);
;;			memcpy(Frame[shead->display_order].V+index,Frame[shead->display_order-1].V+index
;;					,shead->Chroma_size-index);
;;		}
;;		switch(pdata->picture_coding_type){
;;				case Iframe:  //I-frame  >> store the frame information either Front_reg or Back_reg
;;					if(pdata->temporal_reference==0){
;;						memcpy(Ref_front->Y,Frame[shead->display_order].Y,shead->Image_size);
;;						memcpy(Ref_front->U,Frame[shead->display_order].U,shead->Chroma_size);
;;						memcpy(Ref_front->V,Frame[shead->display_order].V,shead->Chroma_size);
;;                shead->display_order++;
;;						YUV_Output(shead);
;;						pdata->IP_frame_retain=0;
;;					}
;;					else{
;;						memcpy(Ref_back->Y,Frame[shead->display_order].Y,shead->Image_size);
;;						memcpy(Ref_back->U,Frame[shead->display_order].U,shead->Chroma_size);
;;						memcpy(Ref_back->V,Frame[shead->display_order].V,shead->Chroma_size);
;;						pdata->IP_frame_retain=1;
;;					}
;;					break;
;;				case Pframe:  //P-frame  >> shall store the frome information in Back_reg
;;					memcpy(Ref_back->Y,Frame[shead->display_order].Y,shead->Image_size);
;;					memcpy(Ref_back->U,Frame[shead->display_order].U,shead->Chroma_size);
;;					memcpy(Ref_back->V,Frame[shead->display_order].V,shead->Chroma_size);
;;					pdata->IP_frame_retain=1;
;;					break;
;;				case Bframe:   //B-frame
;;             shead->display_order++;
;;					YUV_Output(shead);
;;					break;
;;				default:    //D-frame
;;             shead->display_order++;
;;					YUV_Output(shead);
;;					break;
;;		}
;;		gop->field_count_flag=0;
;;	}
;;*******************************************88
;;}
; a4: *sdata, a2: *pdata, a6: *pbitstream, a1: *shead
;sp : 0>>bitstream_addr, 4>>sequence_header, 8>>GOP_header, 12>>pic_data, 16>>Slice_data0, 20>>Init_table
;     24>>Entropy_table, 28>>Slice_data1, 32>>Frame_memory0, 36 >>Frame_memory1, 40>>Slice_data_op, 44>>Frame_memory_op

{ lw r6, sp3, 0       | lw a2, sp, 12       | nop                 | lw a1, sp2, 4       | nop                 }
{ lw r14, sp3, 4      | lw a6, sp, 0        | nop                 | lw a6, sp2, 0       | nop                 }
{ nop                 | lw a4, sp, 16       | nop                 | lw a2, sp2, 12      | nop                 }
{ nop                 | lw a1, sp, 4        | nop                 | lbu d1, a1, start_code| nop               }
{ nop                 | nop                 | nop                 | lbu d3, a1, mb_height| nop                }
{ nop                 | nop                 | nop                 | lw a4, sp2, 16      | nop                 }
;

;;*if(pdata->pipeline_flag_B==2){
; %p14
;;*		sdata2->slice_start_flag=1;
;;*		sdata->slice_start_flag=0;
;;*		sdata2->PMV0[0][0]=sdata2->PMV0[0][1]=sdata2->PMV0[1][0]=sdata2->PMV0[1][1]=0;
;;*		sdata2->PMV1[0][0]=sdata2->PMV1[0][1]=sdata2->PMV1[1][0]=sdata2->PMV1[1][1]=0;
;;	}
;;*	else{
;  %p15
;;*		sdata->slice_start_flag=1;
;;*		sdata2->slice_start_flag=0;
;;*		sdata->PMV0[0][0]=sdata->PMV0[0][1]=sdata->PMV0[1][0]=sdata->PMV0[1][1]=0;
;;*		sdata->PMV1[0][0]=sdata->PMV1[0][1]=sdata->PMV1[1][0]=sdata->PMV1[1][1]=0;
;;	}

;; sdata->slice_start_flag=1;
;;	*sdata->PMV0[0][0]=sdata->PMV0[0][1]=sdata->PMV0[1][0]=sdata->PMV0[1][1]=0;
;;	*sdata->PMV1[0][0]=sdata->PMV1[0][1]=sdata->PMV1[1][0]=sdata->PMV1[1][1]=0;

{ nop                 | lbu d0,a2,Pipeline_flag_B | nop           | nop                 | nop                 }
{ lw r2,sp3,28        | nop                 | nop                 | nop                 | nop                 }
{ lw r3,sp3,16        | nop                 | nop                 | nop                 | nop                 }
{ nop                 | copy a7,a4          | seqiu ac7,p14,p15,d0,2 | copy a7,a4       | nop                 }
{ copy r5,r2          |(p14)lw a7,sp,28     | nop                 | nop                 | nop                 }
{(p14)copy r5,r3      | nop                 | nop                 |(p14)lw a7,sp2,28    | nop                 }

;;	*i=0;
;;	*shead->Error_flag=0;
;;	*sdata->mb_row=shead->start_code-1;
;; *if(sdata->mb_row>=shead->mb_height)
;;	*	return;
;;	*if(pdata->mb_row_reg==sdata->mb_row && pdata->increment_temp>0){
;     % p3=p1 && p2
;;	*	sdata->Same_slice_flag=sdata2->Same_slice_flag=1;
;;	*	if(pdata->increment_temp>0)   //Set the Same_slice_flag for the first time
;       %p5=p3 && p2
;;	*	  pdata->previous_MB_address=(sdata->mb_row*shead->mb_width)-1;
;;	}
;;	*else{
;     % p4
;;	*	sdata->Same_slice_flag=sdata2->Same_slice_flag=0;sdata->Same_slice_flag=sdata2->Same_slice_flag=0;
;;	*	pdata->mb_row_reg=sdata->mb_row;
;;	*	pdata->increment_temp=pdata->increment_flag=0;
;;	*	pdata->previous_MB_address=(sdata->mb_row*shead->mb_width)-1;
;;	}
;% p6=p4 || p5 >>pdata->previous_MB_address=(sdata->mb_row*shead->mb_width)-1;
;cluster1: d2<<mb_row,d3<<mb_width
;cluster2: d1<<mb_row,d3<<mb_height
{ clr r2              | moviu d0, 0         | nop                 | lbu d9, a2, mb_row_reg   |addi d1, d1, (-1)         }
{ sb r2,r5,slice_start_flag  | lbu d1, a2, increment_temp| nop    | clr d8                   | slt ac7, p6, p1, d1, d3 }
{ (p1)br r7           | (p6)dsw d0, d0, a7, PMV0_0_0| nop         | (p6)sb d8, a1, Error_flag| nop            }
{ nop                 | (p6)dsw d0, d0, a7, PMV1_0_0| nop         | nop                 | copy d2,d9          }
{ nop                 | nop                 | sgtiu ac7, p2, p0, d1, 0| (p6)sb d1, a4, mb_row| nop            }
{ nop                 | lbu d3, a1, mb_width| nop                 | nop                 | seq ac7, p1, p0, d1, d2 }
{ andp p3, p1, p2     | bdr d2              | nop                 | bdt d1              | moviu d10, 1        }
{ notp p4, p3         | (p3)moviu d0, 1     | nop                 | sb d10, a7, slice_start_flag| nop         }
;(p1)
{ andp p5, p2, p3     | (p4)moviu d0, 0     | fmul d8, d2, d3     | (p4)sh d8, a2, increment_flag| nop        }
{ orp p6, p4, p5      | sb d0, a4, Same_slice_flag| addi d8, d8, (-1)| (p4)sb d1, a2, mb_row_reg| nop         }
{ nop                 | (p6)sh d8, a2, previous_MB_address| nop   | nop                 | nop                 }
;;	sdata->slice_quantiser_scale_code=(unsigned char)(readbits(pbs,5,shead));  //5bits
;;  sdata2->slice_quantiser_scale_code=sdata->slice_quantiser_scale_code;
{ b r1, _readbits     | lw a5,sp,28         | nop                 | nop                 | clr ac2             }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | sb d0,a5,Same_slice_flag | nop            | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | moviu d0, 5         | nop                 | nop                 | nop                 }

;
;;	if(readbits(pbs,1,shead)){
;     % p11
;;		buffer=(unsigned char)(readbits(pbs,8,shead));  //skip 8+1 bits
;;		while(readbits(pbs,1,shead))
;;		sdata->extra_information_slice=(unsigned char)(readbits(pbs,8,shead));  //skip 8+1 bits
;;	}
;;*	sdata->dc_dct_pred[0]=sdata->dc_dct_pred[1]=sdata->dc_dct_pred[2]=(1<<(pdata->intra_dc_precision+7));
;;sdata2->dc_dct_pred[0]=sdata2->dc_dct_pred[1]=sdata2->dc_dct_pred[2]=(1<<(pdata->intra_dc_precision+7));
;**********for ESL
;{ trap 			     | nop 				        | nop 				| nop 				          | nop				   }
;*************************************


{ b r1, _readbits     | sb d5, a4, slice_quantiser_scale_code| moviu d0, 1| nop         | clr ac2             }
{ (p9)sb r13, r14, Error_flag| nop          | nop                 | lbu a3, a2, intra_dc_precision| nop       }
{ nop                 | sb d5,a5,slice_quantiser_scale_code  | nop| nop                 | nop                 }
{ nop                 | lbu d11,a2,intra_dc_precision        | nop| moviu d1, 1         | nop                 }
{ nop                 | nop                 | nop                 | addi a3, a3, 7      | nop                 }
{ nop                 | nop                 | nop                 | sll a3, d1, a3      | nop                 }



;
{ (p9)sb r13, r14, Error_flag| moviu d10,1  | seqiu ac7, p11, p12, d5, 1| sh a3, a4, dc_dct_pred0| nop        }
{ (p11)b r1, _readbits| addi d11,d11,7      | (p11)moviu d0, 9    | sh a3, a4, dc_dct_pred1| (p11)clr ac2     }
{ (p12)b _MB_loop     | sll d11,d10,d11     | nop                 | sh a3, a4, dc_dct_pred2| nop              }
{ nop                 | sh d11,a5,dc_dct_pred0  | nop             | nop                 | nop                 }
{ nop                 | sh d11,a5,dc_dct_pred1  | nop             | nop                 | nop                 }
{ nop                 | sh d11,a5,dc_dct_pred2  | nop             | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;(p11)
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;
_loop1:
{ (p9)sb r13, r14, Error_flag| andi d5, d5, 0x1| notp p11, p0     | nop                 | nop                 }
{ nop                 | nop                 | seqiu ac7, p11, p12, d5, 1| nop           | nop                 }
{ (p11)b r1, _readbits| nop                 | (p11)moviu d0, 9    | nop                 | (p11)clr ac2        }
{ (p12)b _MB_loop     | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;
{ (p11)b _loop1       | (p11)copy d4, d5    | nop                 | nop                 | nop                 }
{ (p9)sb r13, r14, Error_flag| nop          | (p11)srli d4, d4, 1 | nop                 | nop                 }
{ nop                 | (p11)sb d4, a4, extra_information_slice| nop| nop               | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
_MB_loop:
;;	do{
;;	   *macroblock(pbs,shead,gop,pdata,itable,sdata,Fmem);
;;		*pdata->increment_temp++;
;;		*sdata->Same_slice_flag=sdata2->Same_slice_flag=0;
;;		*if((shead->constrained_parameter_flag || pdata->picture_coding_type==Dframe)
;        %p7=(p2 ||  p3) && (p5 && p6)
;;			&& sdata->mb_column==shead->mb_width-1 && sdata->mb_row<shead->mb_height-1){
;;		*	sdata->mb_row++;
;;			sdata->mb_column=-1;
;;		}
;;		if(shead->Error_flag)
;        %p10
;;		*	MB_over=0;
;;		else{
;       %p11
;;		*	MB_over = (readbits(pbs,23,shead)==0) ? 0 : 1;
;;		*	pbs->BitLeftInCache+=23;
;;		}
;;	}while(MB_over);
;cluster1: d0<<increment_temp,d8<<constrained_parameter_flag,d2<<picture_coding_type,d9<<Error_flag
;cluster2: d1<<start_code,d2<<mb_column,d8<<mb_row,d3<<mb_widht,d9<<mb_height
;
;p1=1>>shead->start_code==0x01
;p2=1>>shead->constrained_parameter_flag
;p3=1>>pdata->picture_coding_type==Dframe
;p4=1>> p1 && (p2 || p3)
;p5=1>>sdata->mb_column==shead->mb_width-1
;p6=1>>sdata->mb_row<shead->mb_height-1
;p7=1>>p4 && (p5 && p6)
;p10=1>>shead->Error_flag=1, p11=!p10
;p12=1>>readbits(pbs,23,shead)==0,p13=!p12

.if 0 
;;*****************Break_Point!!!!!!!!!
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }

{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ seqiu r11, p14, p0, r0,0| nop          | nop                 | nop                 | orp p15, p15, p0    }
{ andp p14, p14, p15  | nop                 | nop                 | nop                 | nop                 }
{ notp p15, p14       | (p14)moviu a7, 0x24007500| nop            | nop                 | nop                 }
{ (p15)b _end2        | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop           | nop                 | nop                 | nop                 }
{ nop                 | (p14)moviu d5, 0x4545| nop            | nop                 | nop                 }
{ nop                 |(p14)sw d5,a7,0      | nop                 | nop                 | nop                 }
{ (p14) moviu r3, 1   | nop                 | notp p15, p0        | nop                 | nop                 }
{ clr r11             | nop                 | notp p14, p0        | nop                 | nop                 }
;(p15)
;****timer setting*****
;{ movi r2, 0x1E168000 |	nop	|	nop	|	nop	|	nop	}
;{ moviu r13,0x1c000004 |	nop	|	nop	|	nop	|	nop	}
;{ lw r15, r2, 0x10  |	nop	|	nop	|	nop	|	nop	}
;{ nop |	nop	|	nop	|	nop	|	nop	}
;{ nop |	nop	|	nop	|	nop	|	nop	}
;{ sw r15,r13,0 |	nop	|	nop	|	nop	|	nop	}
;{ nop |	nop	|	nop	|	nop	|	nop	}
;************************


{ trap                 | nop                 | nop                 | nop                 | nop                 }
;
;;********************************************
_end2:
;;********************************************
.endif

{ b r3, _macroblock   | nop                 | nop                 | nop                 | nop                 }
{ nop                 | lw a4,sp,16         | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;

.if 1  
;;*****************Break_Point!!!!!!!!!
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }

{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ sgtiu r11, p14, p0, r0,0| nop          | nop                 | nop                 | orp p15, p15, p0    }
{ andp p14, p14, p15  | nop                 | nop                 | nop                 | nop                 }
{ notp p15, p14       | (p14)moviu a7, 0x24007500| nop            | nop                 | nop                 }
{ (p15)b _end4        | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop           | nop                 | nop                 | nop                 }
{ nop                 | (p14)moviu d5, 0x557788| nop            | nop                 | nop                 }
{ nop                 |(p14)sw d5,a7,0      | nop                 | nop                 | nop                 }
{ (p14) moviu r3, 1   | nop                 | notp p15, p0        | nop                 | nop                 }
{ clr r11             | nop                 | notp p14, p0        | nop                 | nop                 }
;(p15)
{ trap                 | nop                 | nop                 | nop                 | nop                 }
;
;;********************************************
_end4:
;;*******************
.endif



.if 0
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }

{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }


{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }



.endif


{ nop                 | lbu d0, a2, increment_temp| nop           | nop                 | nop                 }
{ nop                 | lbu d8, a1, constrained_parameter_flag| nop| lbu d3, a1, mb_width| nop                }
{ nop                 | lbu d2, a2, picture_coding_type| nop      | lbu d9, a1, mb_height| moviu d0, 0        }
{ nop                 | lbu d9, a1, Error_flag| addi d0, d0, 1    | lb d2, a4, mb_column| nop                 }
{ nop                 | sb d0, a2, increment_temp| seqiu ac7, p2, p0, d8, 1| lbu d8, a4, mb_row| addi d3, d3, (-1) }
{ nop                 | nop                 | seqiu ac7, p3, p0, d2, Dframe| sb d0, a4, Same_slice_flag| addi d9, d9, (-1) }
{ orp p4, p2, p3      | bdt a2              | seqiu ac7, p10, p11, d9, 1| bdr a2        | seq ac7, p5, p0, d2, d3 }
{ (p11)b r1, _readbits| (p11)lbu d7, a6, BitLeftInCache| nop      | nop                 | slt ac7, p6, p0, d8, d9 }
{ andp p7, p5, p6     | lw a4,sp,16         | (p11)moviu d0, 16   | lw a7,sp2,28        | movi d9,(-1)        }
{ andp p7, p4, p7     | nop                 | nop                 |(p10)lbu d1, a1, mb_height |(p11)clr ac2   }
{ (p10)b _MB_loop_end | nop                 | nop                 | lw a3, sp2, 8       | (p7)addi d8, d8, 1  }
{ nop                 | (p10)lb d2, a4, mb_column| nop            | sb d0, a7, Same_slice_flag |(p7)inserti d8,d9,8,8}
{ nop                 | (p10)lbu d1, a1, mb_width| (p10)clr d12   |(p7)sh d8,a4,mb_row  | nop           }
;;(p11)
{ (p11)b r1, _readbits| (p10)moviu a7, GLOBAL_POINTER_ADDR| (p11)moviu d0, 7| (p10)lbu d8, a3, field_count_flag| notp p1,p0 }
{ (p9)sb r13, r14, Error_flag| (p10)lw d15, a7, FrameWidth_Multi| (p11)clr ac6| (p10)lbu d2, a4, mb_row|(p10)notp p1,p11  }
{ nop                 | (p10)lw d14, a7, Ref_Front_ADDR| (p11)slli ac6, d5, 7|(p1)copy a3,a7  | (p11)moviu ac2, 1   }
;;(p10)
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | notp p12, p0        }
{ nop                 | nop                 | nop                 | nop                 | notp p13, p0        }
;;(p11)
{ (p9)sb r13, r14, Error_flag| (p11)lbu d8, a6, BitLeftInCache| (p11)or d4, ac6, d5| nop| nop                 }
{ nop                 | bdr a3              | (p11)seqiu ac7, p12, p13, d4, 0| bdt a3   | nop                 }
{ (p13)b _MB_loop     | (p12)moviu a7, GLOBAL_POINTER_ADDR| nop   | (p12)lbu d8, a3, field_count_flag| nop    }
{ notp p1, p0         | (p12)lw d15, a7, FrameWidth_Multi| nop    | (p12)lbu d1, a1, mb_height| nop           }
{ (p11)notp p10, p0   | (p12)lw d14, a7, Ref_Front_ADDR| nop      | (p12)lbu d2, a4, mb_row| nop              }
{ (p12)moviu r10, GLOBAL_POINTER_ADDR| (p12)lbu d1, a1, mb_width| nop|(p12)lw a3,sp2,28 | nop                 }
{ (p12)lw r11, r10, Frame_Count| (p12)lb d2, a4, mb_column| (p11)addi d8, d8, 23| nop   | nop                 }
{ nop                 | (p11)sb d8, a6, BitLeftInCache| (p12)clr d12| nop               | nop                 }
;
_MB_loop_end:

;;  if(sdata->mb_column>sdata2->mb_column)
;   %p2
;;		sdata_op=sdata;
;;	else
;   %p1
;;		sdata_op=sdata2;
;;	if(pdata->pipeline_flag_B!=0 && sdata_op->mb_row==shead->mb_height-1 && sdata_op->mb_column==shead->mb_width-1){
;   %p4
;;		if(pdata->picture_coding_type==Bframe || pdata->picture_coding_type==Pframe){
;;						Write_to_YUV(shead,pdata,sdata,Fmem,sdata2,Fmem2);
;;		}
;;	}
;;	if(shead->Error_flag || (sdata_op->mb_row==shead->mb_height-1 && sdata_op->mb_column==shead->mb_width-1
;;		&& !gop->field_count_flag)){
;cluster1: d1<<mb_width, d2<<mb_column,
;cluster2: d1<<mb_height, d2<<mb_row,a3>> address of sdata2

{ notp p5,p0          | lbu d0,a2,Pipeline_flag_B | nop 	      | lb d10,a3,mb_column  | nop				      }
{ notp p6,p0          | bdt d2              | nop 				  | bdr d9 				| nop				      }
{ notp p7,p0          | bdr a3              | notp p8,p0          | bdt a3 				| nop				      }
{ nop       	      | lbu d8,a2,picture_coding_type | seqiu ac7,p3,p4,d0,0| nop    	| sgt ac7,p2,p1,d9,d10    }
{ nop                 |(p2)bdt a4           |(p4)addi d7,d1,(-1)   |(p2)bdr a3           |(p1)copy d9,d10         }
{(p3)b _MB_loop_end2  | bdt d7              | nop                 | bdr d12             | nop                     }
{ moviu r12, EMDMAC_ADDR |(p1)copy a4,a3    | clr d0              | lbu d13,a3,mb_row	|(p4)addi ac2,d1,(-1)     }
{ nop                 | bdr d11             |(p4)seqiu ac7,p7,p0,d8,Pframe | bdt d10   	| nop				      }
{(p4)lw r11, sp3, 40  | addi a5, a4, MB_reg_U |(p4)seqiu ac7,p8,p10,d8,Bframe | copy a4,a3 |(p4)seq ac7,p6,p0,d9,d12}
{ orp p9,p7,p8	      | nop                 |(p1)moviu d0,1       | lhu d0, a4, half_flag_0_0  |(p4)seq ac7,p5,p0,d13,ac2}
{ andp p4,p4,p9	      | sb d0,a4,mb_Pipeline_bit   |(p1)copy d2,d11 |(p1)copy d2,d13   	| andp p5,p5,p6		      }
;;(p3)
{ lbu r15, r11, Ref_num | nop               | andp p4,p4,p5		  | inserti d13,d9,8,8 	| nop                 }
;;***********************************

;;*******************************System DMA Status Polling!!!
_Last_Polling_loop:
{ lw r9,r12,R054_DMASTAT  | nop               | nop                 | nop                     | notp p5,p4              }
{(p5)b _MB_loop_end_Pipeline | nop          | nop 				  |(p4)lbu d15,a4,Ref_num   | nop				      }
{(p4)moviu r10,0x0f     | notp p12,p0    	| nop 				  |(p1)sh d13,a4,mb_row_Pipeline | nop  		      }
{(p4)moviu r11,0x02     | nop 				| nop 				  | nop                     | nop				      }
{(p4)slli r12,r15,3     | nop 				| nop 				  | nop 				    | nop				      }
{(p4)sll r10,r10,r12    | nop 				| nop 				  | nop 				    | nop				      }
{(p4)sll r11,r11,r12    | nop 				| nop 				  | nop                     | nop				      }
;(b5)
{ and r9,r9,r10         | nop 				| nop 				  | nop 				    | nop				      }

{(p4)seq r10,p0,p12,r9,r11 | nop 			| nop 				  | nop 				    | nop				      }
{(p12)b _Last_Polling_loop| nop 			| nop 				  | nop 				    | nop                     }
{(p4)moviu r12, EMDMAC_ADDR | nop 	   	| nop 				  | nop 				    | nop				      }
{(p4)lw r11,sp3,40      | nop 				| nop 				  | nop                     | nop				      }

{ nop                   | nop 	            | nop 				  |(p4)lw a7,sp2,44         | nop				      }
{(p4)clr r10            | nop 				| nop 				  | nop 				    | nop				      }
{(p4)sb r10, r11, Ref_count | nop     		| nop            	  | nop 				    | nop       		      }
;
;;**********************************

{(p4)b r5, _interpolation |(p4)copy d14,a4  | nop                 |(p4)lw a6, a4, Prediction_buf_0| nop   }
{ nop                 |(p4)lw d10, a4, row_size_0  |(p4)moviu ac0, 16  | nop                      | nop }
{ nop                 |(p4)lhu d0, a4, half_flag_chroma_0_0| nop  | nop                           | nop       }
{ nop                 | nop                 |(p4)moviu ac0,16     |(p4)lw d10, a4, row_start_0    |(p4)moviu ac0,16        }
{ nop                 |(p4)dbdr a6          |(p4)notp p11,p0      |(p4)dbdt a6, a7                |(p4)orp p3, p3, p0 }
{ nop                 | nop                 | nop                 |(p4)addi a7,a7,Ref_MB_0_Y      |(p4)notp p10, p0     }
;(p5)
{ lw r4,sp3,44        | nop                 | nop                 | moviu a3, GLOBAL_POINTER_ADDR| nop        }
{ nop                 | addi a5, a4, MB_reg_U| nop                | lw d9, a3, YSize    | nop                  }
{ b r3, _Write_to_YUV | lw d10, a1, horizontal_size | nop         | lw d11, a3, Decode_ADDR| nop              }
{ bdt r4              | bdr a7              | nop                 | bdr d3                  | nop        }
{ nop                 | bdr d9              | nop                 | bdt d9              | nop                 }
{ bdr r5              | bdr d11             | nop                 | bdt d11             | addi d3, d3, Forward_pred_V}
{ addi r2, r11, MB_reg_Y| lh d2, a4, mb_row | nop                 | addi a3, a4, MB_reg_V| srli ac3, d9, 2    }
{ nop                 | addi a7, a7, Forward_pred_U| add d11, d11, d9| lh d2, a4, mb_row| add d11, d11, d9 }
;;********************************************************************

_MB_loop_end_Pipeline:
{ lbu r13,r14,Error_flag  | lbu d0,a4,mb_row| nop 				  | lw a3,sp2,8  		| nop				      }
{ nop                 | lb d2,a4,mb_column  | nop 				  | lbu d0,a4,mb_Pipeline_bit | nop			      }
{ nop                 | lb d10,a4,mb_column_Pipeline | nop        | lbu d10,a4,mb_row_Pipeline| nop				      }
{ sgtiu r15,p10,p0,r13,0 | bdt d0           | nop 				  | bdr d2             	| nop				      }
{ nop                 | nop                 | nop 				  | lbu d8,a3,field_count_flag | sgtiu ac7,p1,p0,d0,0    }
{ moviu r10, GLOBAL_POINTER_ADDR  | lbu d1,a1,mb_width  | nop | lbu d1,a1,mb_height | nop    }
{ lw r11, r10, Frame_Count  | moviu a7, GLOBAL_POINTER_ADDR  | nop	  | nop                 | nop    }
{ nop                 |(p1)copy d2,d10      | nop 	              |(p1)copy d2,d10      | nop    	              }



;;if(shead->Error_flag || (sdata->mb_row==shead->mb_height-1 && sdata->mb_column==shead->mb_width-1
;;		&& !gop->field_count_flag)){
;  %p1=p10 || (p1 && p2) && p3
;		//finish decoding one frame
;		//****************************   Frame Store Memory
;		//******************Load the data from previous frame buffer to fill the current one
;;		//Mode2
;;		if(shead->Error_flag && shead->display_order>0){
;     %p11= p10  && p11
;;			index=(sdata->mb_row<<4)*shead->horizontal_size+(sdata->mb_column<<4);
;;			memcpy(Frame[shead->display_order].Y+index,Frame[shead->display_order-1].Y+index
;;					,shead->Image_size-index);
;;			index=(sdata->mb_row<<3)*(shead->horizontal_size>>1)+(sdata->mb_column<<3);
;;			memcpy(Frame[shead->display_order].U+index,Frame[shead->display_order-1].U+index
;;					,shead->Chroma_size-index);
;;			memcpy(Frame[shead->display_order].V+index,Frame[shead->display_order-1].V+index
;;					,shead->Chroma_size-index);
;;		}
;;		switch(pdata->picture_coding_type){
;;				case Iframe:  //I-frame  >> store the frame information either Front_reg or Back_reg
;           % p4
;;					if(pdata->temporal_reference==0){
;              % p7
;;						//Mode3
;;						memcpy(Frame[shead->display_order].Y,Ref_front->Y,shead->Image_size);
;;						memcpy(Frame[shead->display_order].U,Ref_front->U,shead->Chroma_size);
;;						memcpy(Frame[shead->display_order].V,Ref_front->V,shead->Chroma_size);
;;						shead->display_order++;
;;						YUV_Output(shead,pdata);
;;						pdata->IP_frame_retain=0;
;;					}
;;					else{
;              % p8
;;						pdata->IP_frame_retain=1;
;;					}
;;					break;
;;				case Pframe:  //P-frame  >> shall store the frome information in Back_reg
;           %p5
;;					pdata->IP_frame_retain=1;
;;					break;
;;				case Bframe:   //B-frame
;           %p6
;;					//Mode4
;;					shead->display_order++;
;;					YUV_Output(shead,pdata);
;;					break;
;;				default:    //D-frame
;;					//Mode4
;;					shead->display_order++;
;;					YUV_Output(shead,pdata);
;;					break;
;;		}
;;		gop->field_count_flag=0;
;;	}
;scalar:   r13<<Error_flag
;cluster1: d1<<mb_width, d2<<mb_column, d7<< display_order, d3<<picture_coding_type,d9 << temporal_reference
;cluster2: d1<<mb_height, d2<<mb_row, d8<<field_count_flag,d3 << horizontal_size, d4 <<index_Y,d10 << index_UV
_MB_loop_end2:
{ notp p4, p0         | lhu d7, a1, display_order| addi ac2, d1, (-1)| seqiu a7, p3, p0, d8, 0| addi ac2, d1, (-1) }
{ notp p5, p0         | lbu d3, a2, picture_coding_type| seq ac7, p2, p0, d2, ac2| lw d3, a1, horizontal_size| seq ac7, p1, p8, d2, ac2 }
{ andp p1, p1, p2     | bdt d2              | notp p6, p0         | bdr d9              | slli d2, d2, 4      }
{ andp p1, p1, p3     | lw d5, a7, Memcpy_Mode| sgtiu ac7, p11, p0, d7, 0| moviu a7, GLOBAL_POINTER_ADDR| notp p7, p0 }
{ orp p1, p1, p10     | lhu d9, a2, temporal_reference| andp p11, p11, p10| slli d9, d9, 4| fmuluu ac3, d3, d2 }
{ andp p11,p11,p1    | lw d4,a7,Decode_ADDR    |(p1)seqiu ac7,p4,p0,d3,Iframe  |lw d11,a7,Memcpy_Mode | add d4,ac3,d9	}
{ notp p8, p0         | (p1)sb d12, a3, field_count_flag| (p1)seqiu ac7, p5, p0, d3, Pframe| srli d9, d9, 1| srli ac3, ac3, 2 }
{ (p1)addi r11, r11, 1| moviu a5, EMDMAC_ADDR| (p4)seqiu ac7, p7, p8, d9, 0| (p11)sw d4, a7, Padding_Luma| orp p9, p4, p5 }
{ (p1)notp p6, p9     | (p7)lw d8, a1, vertical_size| orp p12, p5, p8| moviu a5, EMDMAC_ADDR| add d10, ac3, d9 }
{ nop                |(p6)ori d6,d5,0x00001000 |(p12)moviu d12,1      |(p11)sw d10,a7,Padding_Chroma| orp p13,p6,p7    }

;;*****************Break_Point!!!!!!!!!
;{ nop 			      | nop 				        | nop 				       | nop 				          | orp p11,p11,p0}
;{ seqiu r11,p14,p0,r0,20262| nop               | nop 				       | nop 				          | orp p15,p15,p0}
;{ andp p14,p14,p11 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p15,p14 		|(p14)moviu a7,0xb00a9000 | nop 				       | nop 				          | nop				      }
;{(p15)b _end2 	      | nop				           | nop 				       | nop		                | nop				      }
;{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p14)sw d7,a7,0         | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    | nop 				        | notp p15,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end2: 
;;******************************************** 

{ nop                |(p9)sb d12,a2,IP_frame_retain |(p7)copy ac3,d7  |(p11)ori d11,d11,0x00000010| nop				      }
{ nop                |(p13)sw d6,a7,Memcpy_Mode|(p7)fmuluu ac3,ac3,d8 |(p11)sw d11,a7,Memcpy_Mode| nop                  }
{(p1)sw r11,r10,Frame_Count| nop               |(p7)fmuluu ac5,d15,ac3|(p7)lw d11,a7,Frame_Size_420 | nop			      }
{ br r7 			      |(p7)sw d14,a5,R070_SAR0  |(p7)add d15,d4,ac5    |(p7)moviu d0,0x00000007   | nop                  }
;{ nop 			      |(p7)sw d14,a5,R000_SAR0  |(p7)copy d15,d4       |(p7)moviu d0,0x00000080   | nop                  }

;-------Mpeg2 Consecutivity
;{ nop 			      |(p7)sw d15,a5,R074_DAR0  |(p13)addi d7,d7,1     | nop                      |(p7)copy ac2,d0       }

;{ nop                         |(p7)sw d15,a5,R074_DAR0  |(p13)addi d7,d7,0     | nop                      |(p7)copy ac2,d0       }
{ nop                         |(p7)sw d15,a5,R074_DAR0  | nop                  | nop                      |(p7)copy ac2,d0       }


{ nop 			      |(p13)sh d7,a1,display_order | nop		          |(p7)slli d11,d11,12       | nop                  }
;{ nop 	            | nop 				        | nop 				       |(p7)sw d0,a5,R088_CLR0    |(p7)or d11,d11,ac2    }
{ nop               | nop                                       | nop                                  | nop                      |(p7)or d11,d11,ac2    }
{ nop 	            | nop 				        | nop 				       |(p7)sw d11,a5,R080_CTL0   | nop				      }
;{ nop 	            | nop 				        | nop 				       |(p7)sw d0,a5,R21C_DMA_CH_EN | nop				      }
{ nop 	            | nop 				        | nop 				       | nop                      | nop				      }
;

_macroblock:
;Slice_data *sdata_op;
;	Frame_memory *Fmem_op;
;;*	if(pdata->pipeline_flag_B==2){
;   %p1
;;*		sdata_op=sdata2;
;;*		Fmem_op=Fmem2;
;;*		if(sdata->mb_row>sdata2->mb_row){
;       %p5
;;*			sdata_op->mb_row=sdata->mb_row;
;;*			if(sdata->mb_column!=0)
;           %p3
;;				sdata->mb_row--;
;		}
;	}
;	else{
;   %p2
;;*		sdata_op=sdata;
;;*		Fmem_op=Fmem;
;;*		if(sdata->mb_row<sdata2->mb_row){
;       %p6
;;*			sdata_op->mb_row=sdata2->mb_row;
;;*			if(sdata2->mb_column!=0)
;           %p4
;;				sdata2->mb_row--;
;		}
;	}
{ nop                 | lbu d0,a2,Pipeline_flag_B | nop           | lw a3,sp2,28        | nop                 }
{ nop                 | lbu d2,a4,mb_row    | nop                 | nop                 | nop                 }
{ nop                 | lb  d3,a4,mb_column | nop                 | nop                 | nop                 }
{ nop                 | copy a5,a4          | seqiu ac7,p1,p2,d0,2| lb  d5,a3,mb_column | nop                 }
{ nop                 |(p1)movi d15,Frame_memory1_ADDR  | nop     | lbu d4,a3,mb_row    | notp p5,p0          }
{ nop                 | dbdt d2,d3          |(p2)movi d15,Frame_memory_ADDR | dbdr d2   | notp p6,p0          }
{ nop                 |(p2)sw a4,sp,40      | seqi  ac7,p0,p3,d3,0|(p1)sw a3,sp2,40     | seqi ac7,p15,p4,d5,0}
{ nop                 |  sw d15,sp,44       | nop                 | nop                 |(p1)sgt ac7,p5,p0,d2,d4 }
{ andp p3,p3,p5       | lw a4,sp,40         | nop                 | nop                 |(p2)slt ac7,p6,p0,d2,d4 }
{ andp p4,p4,p6       | nop                 | addi d2,d2,(-1)     |(p5)sb d2,a3,mb_row  | nop                 }
{ nop                 | nop                 | nop                 |(p6)sb d4,a4,mb_row  | nop                 }
{ nop                 | bdt a4              | nop                 | bdr a4              | addi d4,d4,(-1)     }
{ nop                 |(p3)sb d2,a5,mb_row  | nop                 |(p4)sb d4,a3,mb_row  | nop                 }

;;********************************************
;;	short MB_address;
;;	*MB_increment=Macroblock_addressing(pbs,shead);
;;	*if(shead->Error_flag)
;     % p15
;;	*	return;
;  % p14
;;	*MB_address=pdata->previous_MB_address+MB_increment;
;;*pdata->increment_flag=MB_increment;
;;*if(sdata->Same_slice_flag)
;;*	pdata->increment_flag-=pdata->increment_temp;
;;	*pdata->previous_MB_address=MB_address;
;;	*sdata->Mode_select=0;
;;//***********reset of MB_increment due to the start of slice data
;;	if(sdata->slice_start_flag){
;;		pdata->increment_flag=1;
;;		sdata->slice_start_flag=0;
;;	}
;	//*****************************************************************
;cluster1: d5<<MB_increment,a7<<MB_address, ac3<< increment_temp
;cluster2: d10<<Same_slice_flag
{ b r4, _MB_addressing| nop                 | nop                 | lbu d10, a4, Same_slice_flag| nop         }
{ bdr r15             | bdt a2              | nop                 | nop                 | nop                 }
{ nop                 | lbu d11, a2, increment_temp| nop          | nop                 | nop                 }
{ lbu r11, r15, picture_coding_type| nop    | nop                 | nop                 | sgtiu ac7, p14, p15, d10, 0 }
{ nop                 | nop                 | (p15)clr ac3        | nop                 | nop                 }
{ nop                 | nop                 | (p14)copy ac3, d11  | nop                 | nop                 }
;



.if 0
;;*****************Break_Point!!!!!!!!!
{ seqiu r11,p10,p0,r0,396| nop 	              | nop 				       | nop 				          | orp p15,p15,p0}
{ andp p10,p10,p15 	| nop 		              | nop 				       | nop 				          | nop          }
{ notp p15,p10 		|(p10)moviu a7,0xb00a9000 | nop 				       | nop 				          | nop			 }
{(p15)b _end3 	      | nop				           | nop 				       | nop		                | nop			 }
{ nop	               | nop                     | nop 				       | nop 				          | nop			 }
{ nop 			      | nop                     |(p10)copy d15,ac3     | nop 				          | nop			 }
{ nop 			      |(p10)sw d15,a7,0         | nop 				       | nop 				          | nop			 }
{(p10) moviu r3,1    | nop 				        | notp p15,p0			 | nop 				          | nop			 }
{ nop 			      | nop 				        | notp p10,p0 			 | nop 				          | nop			 }
;;
{ trap 	            | nop 				        | nop 				       | nop 				          | nop			 }
_end3:
;;********************************************
.endif

{ seqiu r12, p11, p0, r11, Bframe  | nop    | moviu d11, 1        | lbu d8,a4,slice_start_flag | clr d2       }
{ seqiu r12, p12, p0, r11, Pframe  | nop 	| nop 				  | lbu d15,a2,Pipeline_flag_B | nop			 }
{ orp p10,p11,p12     | lbu d0, a2, picture_structure | nop       | notp p1,p0             | clr d11             }
{ notp p8,p0          | dclr d12            | sub ac3, d5, ac3    | lbu d0, a1, Error_flag | sgtiu ac7,p2,p3,d8,0}
{ notp p13,p0         | lh d1, a2, previous_MB_address|(p3)copy d11, ac3| nop              | sgtiu ac7,p7,p0,d15,0}
{ bdr r0              | bdt d11             |(p3)sgtiu ac7, p13, p0, ac3, 1| bdr d10       |(p7)seqiu ac7,p11,p8,d15,2}
{ andp p10, p10, p13  |(p7)lw a5,sp,16      | notp p11, p0        |(p2)sb d11,a4,slice_start_flag | seqiu ac7, p15, p14, d0, 1 }
{ (p15)br r3          | add a7, d1, d5      | (p14)notp p11, p10  | (p10)lbu d0, a4, MB_type| andp p7,p7,p10   }
{ orp p9, p11, p15    | nop 			    | nop 				  | (p7)lw a5,sp2,28           | andp p8,p8,p10  }
{(p11)b _skip_mode_end|(p7)lbu d10,a5,MB_type| nop 				  | nop 				       | nop			 }
{(p9)moviu r10, GLOBAL_POINTER_ADDR  | nop  | nop 				  | nop 				       | nop			 }
{(p9)lw r0, r10, MB_Count | nop 		    | nop 				  |(p8)lbu d12,a5,MB_type      | nop			 }
{ nop 	              |(p7)bdt d10          | nop 				  |(p7)bdr d0			       | nop			 }
;(p15)
_skip_mode:
;//********7.6.6 Skip MBs for P- or B-frame in frame picture
;	//***************Skip_mode****************************8
;;*if(pdata->increment_flag>1){
;  %p13
;;*	if(pdata->picture_coding_type==Bframe || pdata->picture_coding_type==Pframe){
;     %p10=(p11 || p12) && p13
;;*		sdata->prediction_type=(pdata->picture_structure==Frame_picture) ? 0 : 1;
;;*		sdata->mv_format      =(pdata->picture_structure==Frame_picture) ? 0 : 1;
;;*		sdata->motion_vertical_field_select[0][0]=(pdata->picture_structure==Bottom_field) ? 1 : 0;
;;*		sdata->motion_vertical_field_select[0][1]=(pdata->picture_structure==Bottom_field) ? 1 : 0;

;;		if(pdata->pipeline_flag_B>0){
;       %p7
;;			if(pdata->pipeline_flag_B==2)
;;				sdata_op->MB_type=sdata->MB_type;
;;			else
;              %p8
;;				sdata_op->MB_type=sdata2->MB_type;
;;		}

;;*		sdata->MB_type&=0xFE; //non_intra MB
;;*		if(pdata->picture_coding_type==Pframe){
;        %p12 && p10
;;*			sdata->PMV0[0][0]=sdata->PMV0[0][1]=sdata->PMV0[1][0]=sdata->PMV0[1][1]=0;
;;*			sdata->PMV1[0][0]=sdata->PMV1[0][1]=sdata->PMV1[1][0]=sdata->PMV1[1][1]=0;
;			}
;;*		sdata->MV0.vector[0][0]=sdata->PMV0[0][0];
;;*		sdata->MV0.vector[0][1]=sdata->PMV0[0][1];
;;*		sdata->MV0.vector[1][0]=sdata->PMV0[1][0];
;;*		sdata->MV0.vector[1][1]=sdata->PMV0[1][1];
;;*		sdata->Mode_select=1;

;;*		for(i=pdata->increment_flag;i>1;i--){
;; 			if(sdata->Mpeg1_MB_Space)
;;					sdata->mb_row++;
;;			sdata->Mpeg1_MB_Space=0;
;;*			sdata->Ref_num=0;
;;*			++MB_run;
;				//printf("MB_run=%d\n",MB_run);


;;			if(i==pdata->increment_flag && pdata->pipeline_flag_B!=0){
;            % p7 && p9
;;					if(pdata->pipeline_flag_B==2)// && sdata2->mb_column<sdata->mb_column)
;                   %p11
;;						sdata_op->mb_column=sdata->mb_column;
;;					if(pdata->pipeline_flag_A==2)// && sdata->mb_column<sdata2->mb_column)
;                   %p10
;;						sdata_op->mb_column=sdata2->mb_column;
;;			}


;;*				sdata->mb_column++;



;;*			if(shead->constrained_parameter_flag){
;;*				if(sdata->mb_column==shead->mb_width-1)
;              %p3
;;*					sdata->Mpeg1_MB_Space=1;
;;*				if(sdata->mb_column==shead->mb_width)
;              %p2
;;*					sdata->mb_column=0;
;				}

;;*			motion_vectors(0,pbs,shead,gop,pdata,sdata,Fmem);
;;*			if(pdata->picture_coding_type==Bframe){
;           %p13=p11 && p10
;;*				motion_vectors(1,pbs,shead,gop,pdata,sdata,Fmem);
;;*				if(sdata->MB_type & macroblock_motion_backward)
;;*   				Combining_predictions(pdata,sdata,Fmem);
;				}
;;*			for(j=0;j<256;j++)
;;*				sdata->MB_reg.Y[j]=0;
;;*			for(j=0;j<64;j++)
;;*				sdata->MB_reg.U[j]=sdata->MB_reg.V[j]=0;
;				//*************Output the current MB to YUV frame buffer
;;*			Write_to_YUV(shead,pdata,sdata,Fmem);
;				//***********************************
;;			}
;;		}
;;	}
;	//*********************************************************************
; % p10=1>> skip_mode
;cluster2: d10<<pdata->increment_flag
{ nop                 | (p14)sh a7, a2, previous_MB_address| andp p12, p12, p10|(p14)sb d2, a4, Mode_select | nop                  }
{ nop                 | (p12)dsw d12, d13, a4, PMV0_0_0| nop           |(p14)sb d10, a2, increment_flag |nop          }





;;(p11)
{ nop                 | (p12)dsw d12, d13, a4, PMV1_0_0| nop           | nop              |(p8)copy d0,d12 }
{ nop                 | (p10)moviu d7, 1               | (p10)sltiu d8, p2, p3, d0, Frame_picture| (p10)dlw d12, a4, PMV0_0_0| nop }
{ orp p7,p7,p0        | (p10)sb d8, a4, prediction_type| (p10)seqiu ac2, p2, p3, d0, Bottom_field| nop| nop   }
{ notp p8,p7          | (p10)sb d8, a4, mv_format| (p10)slli ac3, ac2, 8| nop         | notp p9,p0             }
{ notp p5,p0          | sb d7, a4, Mode_select| add d1, ac3, ac2  | dsw d12, d13, a4, MV0_vector_0_0| andi d0, d0, 0xFE }
{ seqiu r12, p13, p14, r11, Bframe| sh d1, a4, motion_vertical_field_select_0_0| nop| sb d0, a4, MB_type| nop }
_skip_mode_loop:

{(p8)b _skip_mode_loop2 |(p7)lbu d15,a2,Pipeline_flag_A | notp p11,p0 | nop             |(p7)seqiu ac7,p0,p9,d15,0}
{ andp p9,p9,p7       | notp p10,p0         | nop                 |(p7)lw a5,sp2,16     | nop                 }
{ nop                 |(p7)lw a5,sp,28      | nop                 | nop                 |(p9)seqiu ac7,p11,p0,d15,2}
{ nop                 | nop                 |(p9)seqiu ac7,p10,p0,d15,2 | nop           | nop                 }
{ nop                 | nop                 | nop                 |(p11)lb d0,a5,mb_column | nop                 }
{ nop                 |(p10)lb d0,a5,mb_column | nop              | nop                 | nop                 }
;(p8)
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 |(p11)sb d0,a4,mb_column | nop              }
{ nop                 |(p10)sb d0,a4,mb_column | nop              | nop                 | nop                 }
;;*****************Break_Point!!!!!!!!!
;{ seqiu r11,p10,p0,r0,1392| nop 	              | nop 				       | nop 				          | orp p15,p15,p0}
;{ andp p10,p10,p15 	| nop 		              | nop 				       | nop 				          | nop          }
;{ notp p15,p10 		|(p10)moviu a7,0xb00a9000 | nop 				       | nop 				          | nop			 }
;{(p15)b _end2 	      | nop				           | nop 				       | nop		                | nop			 }
;{ nop	               | nop                     | nop 				       | nop 				          | nop			 }
;{ nop 			      |(p10)moviu d5,0x55667788| nop 				       | nop 				          | nop			 }
;{ nop 			      |(p10)sw d5,a7,0         | nop 				       | nop 				          | nop			 }
;{(p10) moviu r3,1    | nop 				        | notp p15,p0			 | nop 				          | nop			 }
;{ nop 			      | nop 				        | notp p10,p0 			 | nop 				          | nop			 }
;;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop			 }
;_end2:
;;********************************************
_skip_mode_loop2:
{ nop                 | nop 				| nop 				  | lbu d14,a4,Mpeg1_MB_Space | nop			 }
{ nop 	              | lb d0, a4, mb_column| nop 				  | nop 				| nop			 }
{ nop                 | nop                 | notp p2, p0         | lbu d8, a1, constrained_parameter_flag| clr d1 }
{ nop                 | lbu d8, a1, mb_width| notp p3, p0         | lw a2, sp2, 12      | sgtiu ac7,p10,p0,d14,0  }
{ b r4, mc            | nop                 | addi ac0,d0,2       |(p10)lbu d15,a4,mb_row| nop                 }
{ addi sp3, sp3, (-4) | addi sp, sp, (-4)   | addi d9, d0, 1      | sb d1, a4, Ref_num  | sgtiu ac7, p1, p0, d8, 0 }
{ clr r12             | (p1)seq a7, p2, p0, d8, d9| nop           | addi sp2, sp2, (-4)| clr d0              }
{ sw r12, sp3, 0      | (p2)clr d9          | (p1)seq ac7, p3, p0, d8, ac0|(p10)addi d15,d15,1 | nop          }
{ nop                 | sb d9, a4, mb_column| nop                 |(p10)sb d15,a4,mb_row     |(p3)moviu d0, 1 }
{ nop                 | nop                 | nop                 | sb d0, a4, Mpeg1_MB_Space| nop            }
;

;{ moviu sr7,0x02015000   | nop                 | nop 				       |nop                        | nop				      }

{ (p13)b r4, mc       | nop                 | nop                 | nop                 | clr d1              }
{ bdt r6              | bdr a6              | nop                 | nop                 | nop                 }
{ addi sp3, sp3, 4    | addi sp, sp, 4      | nop                 | addi sp2, sp2, 4    | nop                 }
{ (p13)addi sp3, sp3, (-4)| (p13)addi sp, sp, (-4)| notp p14, p0  | (p13)addi sp2, sp2, (-4)| nop             }
{ nop                 | (p13)moviu d0, 1    | nop                 | sw d1, a4, clip_start_offset| nop         }
{ nop                 | (p13)sw d0, sp, 0   | nop                 | nop                 | nop                 }
;(p13)
;;*******************************System DMA Status Polling!!!
{ moviu r12, EMDMAC_ADDR | nop                  | notp p12,p0              | nop                    | nop                     }
_Skip_Polling_loop:
{ lw r9,r12,R054_DMASTAT  |(p13)addi sp, sp, 4    | moviu d0,0x0f     |(p13)addi sp2, sp2, 4   | nop     }
{(p13)addi sp3, sp3, 4  | lbu d15,a4,Ref_num   | moviu ac0,0x02       | lw a6, a4, Prediction_buf_0| nop				  }
{ nop                   | nop 				     | notp p13,p0          | lw a7,sp2,44    	    | nop				      }
{ bdt r9                | bdr a7 		        | nop                  | nop 				    | nop				      }
{ nop                | nop 				        | slli ac2,d15,3       | nop 				    | nop				      }
{ nop                | nop 				        | sll d0,d0,ac2        | nop 				    | nop				      }
;{ nop                | and a7,a7,d0  	        | sll d14,ac0,ac2      | nop 				    | nop				      }
;{ nop                | seq  a7,p0,p12,a7,d14   | nop 				       | nop 				    | nop				      }
{ nop                | nop                              | nop                                   | nop                                | nop                                     }
{ nop                | nop                              | nop                                   | nop                                | nop                                     }
{ nop                | seqiu  a6,p0,p12,a7,0x22222222   | nop                                   | nop                                | nop                                     }
{(p12)b _Skip_Polling_loop| nop 				| nop 				       | nop 				    | nop				      }
{ nop                | nop 				        | nop 				       | nop 				    | nop				      }
{ nop                | nop 				        | nop 				       | lw d10, a4, row_start_0| nop				      }
{ lw r11, sp3, 40    | nop 	                    | nop 				       | nop 				    | nop				      }
{ nop                | nop 				        | nop 				       | nop 				    | nop				      }
{ nop                | nop 				        | moviu ac0, 16 		   | nop 				    | moviu ac0, 16		      }
;;**********************************

;{ nop  | moviu a6,0x24007500                                 | nop                                  | nop                                | nop                                     }
;{ nop  | sw a7,a6,0                                 | nop                                  | nop                                | nop                                     }
;{ trap | nop                                 | nop                                  | nop                                | nop                                     }





{ b r5, _interpolation| lhu d0, a4, half_flag_chroma_0_0| nop     | nop                 | nop                }
{ lbu r15, r11, Ref_num| nop                | nop                 | nop                 | nop                 }
{ nop                 | dbdr a6             | nop                 | dbdt a6, a7         | nop                 }
{ clr r10             | copy d14,a4         | nop                 | lhu d0, a4, half_flag_0_0| nop            }
{ nop                 | lw d10, a4, row_size_0 | nop              | nop                 | orp p3, p3, p0 }
{ sb r10, r11, Ref_count | addi a7,a7,Ref_MB_0_Y | notp p11,p0    | addi a7,a7,Ref_MB_0_Y| notp p10, p0     }
;
{ lw r4, sp3,44       | nop                 | nop                 | moviu a3, GLOBAL_POINTER_ADDR| nop        }
;
;MB_reg_Y<<r2, MB_reg_U<<a5 in cluster1, MB_reg_V<<a3 in cluster2
;Forward_pred_Y<<r4,  Forward_pred_U<<a7 in cluster1,  Forward_pred_V<<d3 in cluster2
;Frame_buffer_Y<<r5, Frame_buffer_U<<d11 in cluster1, Frame_buffer_V<<d11 in cluster2

{ copy r8, r3         | addi a5, a4, MB_reg_U| nop                | lw d9, a3, YSize    | nop               }

.if 0
;;*****************Break_Point!!!!!!!!!
{ bdt r11            | bdr d1				        | nop 				       | nop 				    | nop				      }
{ moviu r11,GLOBAL_POINTER_ADDR  | nop 		  | nop 				       | nop 				    | nop				      }
{ lw r9,r11,MB_Count | nop                     | nop 				       | nop 				          | nop				      }
{ nop                | nop 				        | nop 				       | nop 				    | nop				      }
{ nop 			      | nop   	                 | nop 				       | nop 				          | nop				      }
{ seqiu r11,p12,p0,r9,398| nop 	                 | nop 				       | nop 				          | orp p11,p11,p0      }
{ andp p12,p12,p11	| nop 		              | nop                  | nop 				          | nop                  }
{ notp p11,p12        | nop                     |(p12)moviu ac0,0x5566 |nop				          | nop				      }
{(p11)b _end3 	      |(p13)moviu d0,0x55667788 | nop                  |nop 				          | nop				      }
{ nop 			      |(p12)moviu a7,0x24007500 | nop                  | nop 				    | nop				      }
{(p12)bdt r10	      |(p12)bdr d8              | nop 				       | nop 				          | nop				      }
{ nop 			      |(p12)sw d0,a7,4	        | nop 				       |nop           | nop				      }
{(p12) moviu r3,1    |(p12)sw d1,a7,8          | notp p11,p0			 | nop 				          | nop				      }
{ nop 			      | nop 				        | notp p12,p0 			 | nop 				          | nop				      }
;
{ trap 	            | nop 	
			        | nop 				       | nop 				          | nop				      }
_end3:
;;********************************************
.endif

{ b r3, _Write_to_YUV |  lw d10, a1, horizontal_size| nop         | lw d11, a3, Decode_ADDR| nop              }
{ bdt r4              | bdr a7              | nop                 | bdr d3              | nop                 }
{ addi r0, r0, (-1)   | bdr d9              | nop                 | bdt d9              | nop                 }
{ bdr r5              | bdr d11             | nop                 | bdt d11             | addi d3, d3, Forward_pred_V}
{ addi r2, r11, MB_reg_Y| lh d2, a4, mb_row | nop                 | addi a3, a4, MB_reg_V| srli ac3, d9, 2    }
{ sgtiu r10, p5, p6, r0, 1| addi a7, a7, Forward_pred_U| add d11, d11, d9| lh d2, a4, mb_row| add d11, d11, d9 }
;
{ (p5)b _skip_mode_loop| nop                | nop                 | lw d0, a3, MB_Count | nop                 }
{ nop                 |(p5)lbu d0, a2, picture_coding_type| nop   | nop                 | nop                 }
{ copy r3, r8         | (p6)lh a7, a2, previous_MB_address| nop   | nop                 | nop                 }
{ bdr r8              | bdt a0              | notp p7,p0          | bdr a0              | addi d0, d0, 1      }
{ notp p8,p7          | nop                 | (p5)seqiu ac7, p13, p14, d0, Bframe| sw d0, a3, MB_Count| notp p9,p0   }
{ (p6)bdr r0          | (p6)notp p13, p0    | nop                 | (p6)bdt d0          | (p6)notp p14, p0    }
;(p5)
_skip_mode_end:



;;*****************Break_Point!!!!!!!!!
;{ nop                | nop 	                 | seqiu ac7,p12,p0,ac0,0x5566 | nop 	       | orp p11,p11,p0      }
;{ andp p12,p12,p11	| nop 		              | nop                  | nop 				          | nop                  }
;{ notp p11,p12 		| nop  				        | nop                  |nop				          | nop				      }
;{(p11)b _end1 	      |nop                       | nop                  |nop 				          | nop				      }
;{ clr r9			      |(p12)moviu a7,0xb00a9000 |(p12)copy d1,ac3      | nop 				    | nop				      }
;{(p12)bdt r10	      |(p12)moviu d8,0x55667788 | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p12)sw d0,a7,4	        | nop 				       |nop           | nop				      }
;{(p12) moviu r3,1    |(p12)sw d8,a7,8          | notp p11,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p12,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end1:
;;********************************************

.if 0
;;*****************Break_Point!!!!!!!!!
{ moviu r11,GLOBAL_POINTER_ADDR  | nop 		  | nop 				       | nop 				    | nop				      }
{ lw r9,r11,MB_Count | nop                     | nop 				       | nop 				          | nop				      }
{ nop                | nop 				        | nop 				       | nop 				    | nop				      }
{ nop 			      | nop   	                 | nop 				       | nop 				          | nop				      }
{ seqiu r11,p12,p0,r9,399| nop 	                 | nop 				       | nop 				          | orp p11,p11,p0      }
{ andp p12,p12,p11	| nop 		              | nop                  | nop 				          | nop                  }
{ notp p11,p12       | nop                     |(p12)moviu ac0,0x5566 |nop				          | nop				      }
{(p11)b _end3 	      |(p12)moviu d0,0x7788 | nop                  |nop 				          | nop				      }
{ nop 			      |(p12)moviu a7,0x24007500 | nop                  | nop 				    | nop				      }
{(p12)bdt r10	      |(p12)bdr d8              | nop 				       | nop 				          | nop				      }
{ nop 			      |(p12)sw d0,a7,0	        | nop 				       |nop           | nop				      }
{(p12) moviu r3,1    |(p12)sw d1,a7,8          | notp p11,p0			 | nop 				          | nop				      }
{ nop 			      | nop 				        | notp p12,p0 			 | nop 				          | nop				      }
;
{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
_end3:
;;********************************************
.endif

;;sdata->Ref_num=0;
;;++MB_run;
;******************
;;*if(MB_address>=shead->mb_width){
;% p1
;;		i=1;
;;		do{
;;*			temp=MB_address-shead->mb_width*i;
;;*			i++;
;;*	}while(temp>=shead->mb_width);
;     %p3
;;*	sdata->mb_column=(unsigned char)temp;
;;}
;;*else
;%p2
;;*		sdata->mb_column=(unsigned char)MB_address;

;;if(sdata->Mpeg1_MB_Space){
;;		sdata->mb_row++;
;;		sdata->Mpeg1_MB_Space=0;
;;}
;*********************88
;;*	sdata->MB_type=0;
;cluster1: a7<<MB_address
{ nop                 | lbu d8, a1, mb_width| nop                 | lw a2, sp2, 12      | clr d0              }
{ nop                 | nop                 | nop                 | sb d0, a4, Ref_num  | nop                 }
{ nop                 | copy d1, a7         | moviu d9, 1         | sb d0, a4, MB_type  | nop                 }
{ notp p3, p0         | slt d15, p2, p1, a7, d8| nop              | notp p4, p0         | nop                 }
_residue_loop:
{ nop                 | (p2)sb a7, a4, mb_column| (p1)fmul ac7, d8, d9| nop             | nop                 }
{ nop                 | (p1)addi d9, d9, 1  | (p1)sub ac7, d1, ac7| lbu d2, a4, Mpeg1_MB_Space| nop           }
{ nop                 | nop                 | (p1)slt ac6, p4, p3, ac7, d8| lbu d8, a4, mb_row| nop           }
{ (p3)b _residue_loop | nop                 | (p4)copy d15, ac7   | nop                 | clr d0              }
{ nop                 | (p4)sb d15, a4, mb_column| nop            | nop                 | sgtiu ac7, p5, p0, d2, 0 }
{ nop                 | nop                 | nop                 | nop                 | andp p5, p5, p4     }
{ nop                 | nop                 | nop                 | (p5)sb d0, a4, Mpeg1_MB_Space| (p5)addi d8, d8, 1 }
{ nop                 | nop                 | nop                 | (p5)sb d8, a4, mb_row| nop                }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;
;;*	sdata->MB_type=Macroblock_type(pbs,shead,pdata);
;;*	if(shead->Error_flag)
;     %p15
;;*		return;
;;*	if((sdata->MB_type & macroblock_intra)==0 || pdata->increment_flag>1)
; *     %p2 || %p3
;;*		sdata->dc_dct_pred[0]=sdata->dc_dct_pred[1]=sdata->dc_dct_pred[2]=(1<<(pdata->intra_dc_precision+7));
;;*	pdata->increment_flag=0;
;;* if(sdata->MB_type & macroblock_intra){
;     % p4
;;*	if(pdata->concealment_motion_vectors){
;     % p5
;;*		sdata->prediction_type=(pdata->picture_structure==Frame_picture)?0:1;  //0>> frame_motion  1>> field_motion
;;*		sdata->motion_vector_count=1;
;;*		sdata->dmv=0;
;;		}
;;*		else{
;     % p6
;;*		sdata->PMV0[0][0]=sdata->PMV0[0][1]=sdata->PMV0[1][0]=sdata->PMV0[1][1]=0;
;;*		sdata->PMV1[0][0]=sdata->PMV1[0][1]=sdata->PMV1[1][0]=sdata->PMV1[1][1]=0;
;;		}
;; }




.if 0
;;*****************Break_Point!!!!!!!!!
{ seqiu r11,p14,p0,r0,396| nop              | nop                                      | nop                                      | orp p15,p15,p0}
{ andp p14,p14,p15      | nop                         | nop                                    | nop                                      | nop          }
{ notp p15,p14          |(p14)moviu a7,0x24007500 | nop                                        | nop                                      | nop                  }
{(p15)b _end3         | nop                                        | nop                                       | nop                            | nop                    }
{ nop                   | nop             | nop                                   | nop                                      | nop                  }
{ nop                         |(p13)moviu d5,0x55667788| nop                                   | nop                                      | nop                  }
{ nop                         |(p14)sw d5,a7,0         | nop                                   | nop                                      | nop                  }
{(p14) moviu r3,1    | nop                                      | notp p15,p0                    | nop                                    | nop                  }
{ nop                         | nop                                     | notp p14,p0                    | nop                                    | nop                  }
;
{ trap              | nop                                       | nop                                  | nop                                      | nop                  }
_end3:
;;********************************************
.endif




{ b r4, _MB_type      | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | lbu d0, a2, increment_flag| nop           }
{ nop                 | nop                 | nop                 | lbu d2, a2, concealment_motion_vectors| nop }
{ bdr r15             | bdt a2              | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;

;------SCT_FPGA_Trace
;{ trap                 | nop                 | nop                 | nop                 | nop                 }
;----------------------

.if 0    
;;*****************Break_Point!!!!!!!!!
{ seqiu r11,p14,p0,r0,396| nop              | nop 				       | nop 				          | orp p15,p15,p0}
{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop          }
{ notp p15,p14 		|(p14)moviu a7,0x24007500 | nop 				       | nop 				          | nop			 }
{(p15)b _end3 	        | nop				           | nop 				       | nop		                | nop			 }
{ nop                   |(p14)moviu d5,0x7878    | nop 				       | nop 				          | nop			 }
{ nop 		        | nop                    | nop 				       | nop 				          | nop			 }
{ nop 			|(p14)sw d5,a7,0         | nop 				       | nop 				          | nop			 }
{(p14) moviu r3,1    | nop 				        | notp p15,p0			 | nop 				          | nop			 }
{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop			 }
;
{ trap 	            | nop 				        | nop 				       | nop 				          | nop			 }
_end3:
;;********************************************
.endif

{ seqiu r10, p15, p1, r13, 1| notp p2, p0   | andi ac6, d5, macroblock_intra| notp p3, p0| moviu d8, 0        }
{ (p15)br r3          | (p1)lbu d0, a2, intra_dc_precision| (p1)seqiu ac7, p2, p4, ac6, 0| nop| (p1)sgtiu ac7, p3, p0, d0, 1 }
{ (p1)orp p2, p2, p3  | copy d10, d5        | notp p5, p0         | (p1)lbu d3, a2, picture_structure| andp p4, p4, p1 }
{ nop                 | (p2)moviu d1, 1     | nop                 | (p1)sb d8, a2, increment_flag| (p4)seqiu ac7, p5, p6, d2, 1 }
{ nop                 | (p2)addi d0, d0, 7  | andp p6, p4, p6     | (p5)sb d8, a4, dmv  | moviu d9, 1         }
{ nop                 | (p2)sll d1, d1, d0  | nop                 | (p5)sb d9, a4, motion_vector_count| (p5)seqiu ac7, p7, p8, d3, Frame_picture }
{ nop                 | (p2)sh d1, a4, dc_dct_pred0| moviu ac6, macroblock_motion_forward| (p6)dsw d8, d8, a4, PMV0_0_0| (p5)xori d4, ac7, 0x1 }
;;(p15)
{ nop                 | (p2)sh d1, a4, dc_dct_pred1| addi ac6, ac6, macroblock_motion_backward| (p6)dsw d8, d8, a4, PMV1_0_0| nop }
{ nop                 | (p2)sh d1, a4, dc_dct_pred2| and d10, d10, ac6| (p5)sb d4, a4, prediction_type| nop   }
_predict_select:



;;*if(sdata->MB_type & (macroblock_motion_forward + macroblock_motion_backward)){
; % p3
;;*		if(pdata->picture_structure==Frame_picture){
;     % p11
;;*		  sdata->prediction_type=0;   //default prediction_type >> Frame-based
;;*		  if(pdata->frame_pred_frame_dct==0){    // 1>> only frame prediction and frame DCT
;       % p13  (&& p11 && p3)
;;*				buffer=(unsigned char)(readbits(pbs,2,shead));   //2bits
;;*				switch (buffer){
;;					case 0x1:
;              % p1 (&& p13)
;;						sdata->prediction_type=1;
;;						sdata->motion_vector_count=2;
;;						sdata->dmv=0;
;;						break;
;;					case 0x2:
;              % p2  (&& p13)
;;						sdata->prediction_type=0;
;;						sdata->motion_vector_count=1;
;;						sdata->dmv=0;
;;						break;
;;					case 0x3:
;              % p3  (&& p13)
;;						sdata->prediction_type=2;
;;						sdata->motion_vector_count=1;
;;						sdata->dmv=1;
;;						break;
;;					default:
;              % p4=!(p1 | p2 | p3)
;;						printf("Error prediction_type!!\n");
;;						shead->Error_flag=1;
;;						break;
;;            }
;;			  }
;;*		  else{
;        % p14 (&& p11 && p3)
;;*				sdata->prediction_type=0;
;;*				sdata->motion_vector_count=1;
;;*				sdata->dmv=0;
;;			  }
;;		}
;;*	else{           //field pictures
;     % p12 (&& p3)
;;*			buffer=(unsigned char)(readbits(pbs,2,shead));   //2bits
;;*			switch (buffer){
;;				case 0x1:
;           % p5
;;					sdata->prediction_type=1;
;;					sdata->motion_vector_count=1;
;;					sdata->dmv=0;
;;					break;
;;				case 0x2:
;           % p6
;;					sdata->prediction_type=3;
;;					sdata->motion_vector_count=2;
;;					sdata->dmv=0;
;;					break;
;;				case 0x3:
;           % p7
;;					sdata->prediction_type=2;
;;					sdata->motion_vector_count=1;
;;					sdata->dmv=1;
;;					break;
;;				default:
;           % p8=!(p1 | p2 | p3)
;;					shead->Error_flag=1;
;;					break;
;;			   }
;;		}
;;	}
;  % p4

;scalar: r13<<Error_flag
;cluster1: d5<<MB_type,a7<<MB_type
;cluserer2: d3<<pictrue_structure,d6<<frame_pred_frame_dct
{ nop                 | moviu d1, 0         | sgtiu ac7, p3, p4, d10, 0| lbu d6, a2, frame_pred_frame_dct| moviu d8, 0 }
{ (p4)b _predict_select_end| nop            | notp p13, p0        | nop                 | seqiu ac7, p11, p12, d3, Frame_picture }
{ notp p14, p0        | nop                 | andp p11, p11, p3   | nop                 | andp p12, p12, p3   }
{ nop                 | (p11)sb d1, a4, prediction_type| notp p6, p0| nop               | (p11)seqiu ac7, p13, p14, d6, 0 }
{ nop                 | nop                 | nop                 | nop                 | orp p6, p12, p13    }
{ (p6)b r1, _readbits | (p6)moviu d0, 2     | nop                 | (p14)sb d8, a4, prediction_type| (p6)clr ac2 }
{ (p14)b _predict_select_end| copy a7, d5   | nop                 | (p14)sb d8, a4, dmv | (p14)moviu d9, 1    }
;;(p4)
{ nop                 | nop                 | nop                 | (p14)sb d9, a4, motion_vector_count| nop  }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;(p6)
{ notp p1, p0         | bdt d5              | notp p2, p0         | bdr d5              | notp p3, p0         }
;;(p14)
{ notp p5, p0         | notp p6, p0         | nop                 | lbu d6, a2, frame_pred_frame_dct| notp p7, p0 }
{ (p9)sb r13, r14, Error_flag| moviu d0, 1  | (p13)seqiu ac7, p1, p0, d5, 1| lbu d3, a2, picture_structure| (p12)seqiu ac7, p5, p4, d5, 1 }
{ nop                 | (p1)moviu d8, 1     | (p13)seqiu ac7, p2, p0, d5, 2| (p5)moviu d8, 1| (p12)seqiu ac7, p6, p4, d5, 2 }
{ orp p8, p5, p6      | (p2)moviu d8, 0     | (p13)seqiu ac7, p3, p0, d5, 3| (p6)moviu d8, 2| (p12)seqiu ac7, p7, p4, d5, 3 }
{ orp p4, p1, p2      | (p3)moviu d8, 2     | (p1)moviu d1, 2     | (p7)moviu d8, 1     | (p5)moviu d1, 1     }
{ orp p4, p4, p3      | (p1)moviu d9, 0     | (p2)moviu d1, 1     | (p12)sb d8, a4, motion_vector_count| (p6)moviu d1, 3 }
{ notp p4, p4         | (p2)moviu d9, 0     | (p3)moviu d1, 1     | (p5)moviu d9, 0     | (p7)moviu d1, 2     }
{ orp p8, p8, p7      | (p13)sb d1, a4, motion_vector_count| (p3)moviu d9, 1| (p12)sb d1, a4, prediction_type| (p6)moviu d9, 0 }
{ notp p8, p8         | (p13)sb d8, a4, prediction_type| andp p4, p4, p13| nop          | (p7)moviu d9, 1     }
{ andp p8, p8, p12    | (p4)sb d0, a1, Error_flag| nop            | (p12)sb d9, a4, dmv | moviu d0, 1         }
{ nop                 | (p13)sb d9, a4, dmv | nop                 | (p8)sb d0, a1, Error_flag| nop            }
_predict_select_end:



.if 0
;;*****************Break_Point!!!!!!!!!
{ seqiu r11,p14,p0,r0,396| nop              | nop                                      | nop                                      | orp p15,p15,p0}
{ andp p14,p14,p15      | nop                         | nop                                    | nop                                      | nop          }
{ notp p15,p14          |(p14)moviu a7,0x24007500 | nop                                        | nop                                      | nop                  }
{(p15)b _end3           | nop                                      | nop                                       | nop                            | nop                    }
{ nop                   |(p14)moviu d5,0x7777   | nop                                 | nop                                      | nop                  }
{ nop                   | nop                    | nop                                 | nop                                      | nop                  }
{ nop                   |(p14)sw d5,a7,0         | nop                                 | nop                                      | nop                  }
{(p14) moviu r3,1    | nop                                      | notp p15,p0                    | nop                                    | nop                  }
{ nop                         | nop                                     | notp p14,p0                    | nop                                    | nop                  }
;
{ trap              | nop                                       | nop                                  | nop                                      | nop                  }
_end3:
;;********************************************
.endif


;;*if(shead->Error_flag)
;;*		return;
;;*	sdata->mv_format=(sdata->prediction_type==0)? 0 : 1 ;
;                          % p1
;;*	if((pdata->picture_structure==Frame_picture) && (pdata->frame_pred_frame_dct==0)
;                % p14=p2 && p3 && (p4 || p5)
;;*		&& ((sdata->MB_type & macroblock_intra) || (sdata->MB_type & macroblock_pattern)))
;;*		sdata->dct_type=(unsigned char)(readbits(pbs,1,shead)); //1bit >> 0:frame DCT 1:field DCT
;;	else if(pdata->picture_structure==Top_field || pdata->picture_structure==Bottom_field)
;     % p7=  (p7 || p8) && p6
;;		sdata->dct_type=1;                    //shall be set one due to the field DCT
;;	else if(pdata->frame_pred_frame_dct==1)
;     % p10=p10 && p6
;;		sdata->dct_type=0;                   //shall be set zero due to the frame DCT

;;	if(sdata->MB_type & macroblock_quant){
;     % p11
;;		sdata->MB_quantiser_scale_code=(unsigned char)(readbits(pbs,5,shead));
;;		sdata->slice_quantiser_scale_code=sdata->MB_quantiser_scale_code;
;;	}
;;	else
;    % p12
;;		sdata->MB_quantiser_scale_code=sdata->slice_quantiser_scale_code;

;scalar: r13<<Error_flag
;cluster1: a7<<MB_type
;cluster2: d3<<picture_structure, d6<<frame_pred_frame_dct
{ (p9)br r3           | andi d8, a7, macroblock_intra| nop        | lbu d0, a4, prediction_type| seqiu ac7, p2, p0, d3, Frame_picture }
{ nop                 | andi d6, a7, macroblock_pattern| sgtiu ac7, p4, p0, d8, 0| nop  | seqiu ac7, p3, p10, d6, 0 }
{ nop                 | nop                 | sgtiu ac7, p5, p0, d6, 0| nop             | seqiu ac7, p7, p1, d3, Top_field }
{ orp p4, p4, p5      | nop                 | andp p2, p2, p3     | sgtiu d8, p1, p0, d0, 0| nop              }
{ nop                 | nop                 | andp p14, p2, p4    | sb d8, a4, mv_format| seqiu ac7, p8, p0, d3, Bottom_field }
{ (p14)b r1, _readbits| (p14)moviu d0, 1    | notp p6, p14        | nop                 | orp p7, p7, p8      }
;;(p9)
{ andp p10, p10, p6   | nop                 | nop                 | andp p7, p7, p6     | (p14)clr ac2        }
{ nop                 | andi d6, a7, macroblock_quant| (p7)moviu d10, 1| nop            | nop                 }
{ nop                 | (p7)sb d10, a4, dct_type| (p10)moviu d4, 0| nop                 | nop                 }
{ nop                 | (p10)sb d4, a4, dct_type| nop             | nop                 | nop                 }
{ nop                 | nop                 | sgtiu ac7, p11, p12, d6, 0| nop           | nop                 }
;;(p14)
{ (p11)b r1, _readbits| (p14)sb d5, a4, dct_type| (p11)moviu d0, 5| nop                 | (p11)clr ac2        }
{ (p9)sb r13, r14, Error_flag| nop          | nop                 | (p12)lbu d0, a4, slice_quantiser_scale_code| nop }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | lbu a3, a4, MB_type | nop                 }
{ nop                 | nop                 | nop                 | (p12)sb d0, a4, MB_quantiser_scale_code| nop }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;(p11)
;;*   if((sdata->MB_type & macroblock_motion_forward) || ((sdata->MB_type & macroblock_intra) && pdata->concealment_motion_vectors)){
;  % p13 = p1 || p2
;;*		sdata->Mode_select=2;
;;*		motion_vectors(0,pbs,shead,gop,pdata,sdata,Fmem);
;;*		if(shead->Error_flag)
;     % p15
;;*			return;
;;*	}
;;*	if(sdata->MB_type & macroblock_motion_backward){
;   %p14
;;*		sdata->Mode_select=2;
;;*		motion_vectors(1,pbs,shead,gop,pdata,sdata,Fmem);
;;*		if(shead->Error_flag)
;     %p15
;;*			return;f
;;*	}
;  %p5=!(p13 || p14)
;cluster2: a3<<MB_type
;p15=1<<Error_flag=1!!!



{ (p9)sb r13, r14, Error_flag| nop          | nop                 | lbu d9, a2, concealment_motion_vectors| nop }
{ nop                 | (p11)sb d5, a4, MB_quantiser_scale_code| nop| andi d0, a3, macroblock_motion_forward| nop }
{ nop                 | (p11)sb d5, a4, slice_quantiser_scale_code| nop| andi d8, a3, macroblock_intra| sgtiu ac7, p1, p0, d0, 0 }
{ nop                 | nop                 | nop                 | andi d1, a3, macroblock_motion_backward| and ac6, d8, d9 }
{ notp p15, p0        | nop                 | nop                 | nop                 | sgtiu ac7, p2, p0, ac6, 0 }


{ orp p13, p1, p2     | nop                 | nop                 | nop                 | sgtiu ac7, p14, p0, d1, 0 }
{ (p13)b r4, mc       | moviu d0, 2         | nop                 | nop                 | orp p4, p13, p14    }
{ (p13)moviu r12, 0   | (p4)sb d0, a4, Mode_select| nop           | nop                 | notp p5, p4         }
{ (p5)b _mc_end       | nop                 | nop                 | nop                 | nop                 }
{ (p13)addi sp3, sp3, (-4)| (p13)addi sp, sp, (-4)| nop           | (p13)addi sp2, sp2, (-4)| nop             }
{ (p13)sw r12, sp3, 0 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;(p13)

.if 0
;;*****************Break_Point!!!!!!!!!
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | orp p11,p11,p0       }
{ seqiu r11,p10,p0,r0,396| nop 	              | nop 				       | nop 				          | nop                  }
{ andp p10,p10,p11 	| nop 		              | nop 				       | nop 				          | nop                  }
{ notp p11,p10 		|(p10)moviu a7,0x24007500 | nop 				       | nop 				          | nop				      }
{(p11)b _end3 	      |(p10)moviu d5,0x3333          | nop 				       | nop		                | nop				      }
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
{ nop 			      |(p10)sw d5,a7,0         | nop 				       | nop 				          | nop				      }
{ nop                | nop 				        | notp p11,p0			 | nop 				          | nop				      }
{ nop 			      | nop 				        | notp p10,p0 			 | nop 				          | nop				      }
;;
{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
_end3:
;;********************************************
.endif

{ (p15)br r3          | (p15)notp p14, p0   | nop                 | nop                 | nop                 }
{ (p14)b r4, mc       | (p14)notp p15, p0   | nop                 | nop                 | nop                 }
;;(p5)
{ (p14)moviu r12, 1   | bdr a6              | nop                 | bdt a6              | nop                 }
{ (p13)addi sp3, sp3, 4| (p13)addi sp, sp, 4| nop                 | (p13)addi sp2, sp2, 4| nop                }
{ (p14)addi sp3, sp3, (-4)| (p14)addi sp, sp, (-4)| nop           | (p14)addi sp2, sp2, (-4)| nop             }
{ (p14)sw r12, sp3, 0 | nop                 | nop                 | nop                 | nop                 }
;;(p15)
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;(p14)
_mc_end:


.if 0
;;*****************Break_Point!!!!!!!!!
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | orp p11,p11,p0}
{ seqiu r11,p10,p0,r0,396| nop 	              | nop 				       | nop 				          | nop}
{ andp p10,p10,p11 	| nop 		              | nop 				       | nop 				          | nop                  }
{ notp p11,p10 		|(p10)moviu a7,0x24007500 | nop 				       | nop 				          | nop				      }
{(p11)b _end3 	      |(p10)moviu d5,0x7979     | nop 				       | nop		                | nop				      }
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
{ nop 			      |(p10)sw d5,a7,0         | nop 				       | nop 				          | nop				      }
{(p10) moviu r3,1    | nop 				        | notp p11,p0			 | nop 				          | nop				      }
{ nop 			      | nop 				        | notp p10,p0 			 | nop 				          | nop				      }
;;
{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
_end3:
;;********************************************
.endif

;;	//*********7.6.3.5 prediction in p-pictures
;;*	if(pdata->picture_coding_type==Pframe && (sdata->MB_type & (macroblock_intra + macroblock_motion_forward))==0){
;     % p9=p6 && p7
;;*		sdata->PMV0[0][0]=sdata->PMV0[0][1]=sdata->PMV1[0][0]=sdata->PMV1[0][1]=0;
;;*		if(pdata->picture_structure==Frame_picture){
;        % p8
;;*			sdata->prediction_type=0;
;;*			sdata->mv_format=0;
;;*		}
;;*		else{
;       % p10
;;*			sdata->prediction_type=1;
;;*			sdata->mv_format=1;
;;*			sdata->motion_vertical_field_select[0][0] = (pdata->picture_structure==Bottom_field);
;;*		}
;;*	}

;;if((pdata->picture_coding_type==Pframe && sdata->Mode_select!=2)){
;  %p13=p6 && p13
;		//not to do any prediction case in this MB of P-frame
;;				sdata->Mode_select=0;
;;				motion_vectors(0,pbs,shead,gop,pdata,sdata,Fmem);
;}

;cluster1: d0<<picture_coding_type, d8<<picture_structure



{ nop                 | (p14)addi sp, sp, 4 | nop                 | lbu a3, a4, MB_type | nop                 }
{ (p15)br r3          | lbu d0, a2, picture_coding_type| nop      | nop                 | moviu d0, macroblock_intra }
{ (p14)addi sp3, sp3, 4| lbu d8, a2, picture_structure| notp p8, p0| (p14)addi sp2, sp2, 4| addi d1, d0, macroblock_motion_forward }
{ notp p10, p0        | lw a6, sp, 0        | moviu d2, 0         | and d1, a3, d1      | nop                 }
{ nop                 | nop                 | seqiu ac7, p6, p0, d0, Pframe| lbu d11, a4, Mode_select| seqiu ac7, p7, p1, d1, 0 }
{ andp p9, p6, p7     | copy d10, d0        | seqiu ac7, p8, p10, d8, Frame_picture| nop| moviu d2, 0         }
{ andp p8, p8, p9     | (p9)sw d2, a4, PMV0_0_0| nop              | andp p10, p10, p9   | (p10)moviu d10, 1   }
;;(p15)
{ nop                 | (p9)sw d2, a4, PMV1_0_0| seqiu d9, p11, p0, d8, Bottom_field| (p8)sb d2, a4, mv_format| seqiu ac7, p1, p13, d11, 2 }
{ nop                 | (p10)sb d9, a4, motion_vertical_field_select_0_0| nop| (p8)sb d2, a4, prediction_type| andp p13, p13, p6 }
{ (p13)b r4, mc       | notp p7, p6         | nop                 | (p10)sb d10, a4, mv_format| andp p11, p14, p13 }
{ nop                 | nop                 | nop                 | (p10)sb d10, a4, prediction_type| nop     }
{ (p13)moviu r12, 0   | (p13)sb d2, a4, Mode_select| nop          | nop                 | nop                 }
{ (p13)addi sp3, sp3, (-4)| (p13)addi sp, sp, (-4)| nop           | (p13)addi sp2, sp2, (-4)| nop             }
{ (p13)sw r12, sp3, 0 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;(p13)
_combining_pred_end:

.if 0
;;*****************Break_Point!!!!!!!!!
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | orp p11,p11,p0}
{ seqiu r11,p14,p0,r0,396| nop 	              | nop 				       | nop 				          | orp p15,p15,p0}
{ andp p14,p14,p11 	| nop 		              | nop 				       | nop 				          | nop                  }
{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
{ notp p15,p14 		|(p14)moviu a7,0x24007500 | nop 				       | nop 				          | nop				      }
{(p15)b _end3 	      | nop				           | nop 				       | nop		                | nop				      }
{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
{ nop 			      |(p14)moviu d5,0x3333     | nop 				       | nop 				          | nop				      }
{ nop 			      |(p14)sw d5,a7,0         | notp p11,p0 				       | nop 				          | nop				      }
{(p14) moviu r3,1    | nop 				        | notp p15,p0			 | nop 				          | nop				      }
{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;;
{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
_end3:
;;********************************************
.endif

;; *if((sdata->MB_type & macroblock_intra) && pdata->concealment_motion_vectors)
;  % p13
;;	*	    buffer=(unsigned char)(readbits(pbs,1,shead));      //1bit >> marker_bit
;	//***********Detemine which block of MB is not coded
;; *sdata->pattern_code=0;
;_cbp_loop1:
;;	*for(i=0;i<block_count;i++){
;;	*	    sdata->pattern_code=(sdata->pattern_code<<1) | ((sdata->MB_type & macroblock_intra) ? 1 : 0);
;;	*}
;;	*if(sdata->MB_type & macroblock_pattern){
;  % p14
;;	*	     sdata->pattern_code=0;
;;	*	     MB_cbp=Search_cbp(pbs,shead);  //find the cbp value
;;		     if(shead->Error_flag)
;         % p15
;;			       return;
;_cbp_loop2:
;;		     for(i=0;i<6;i++){
;;			       if(MB_cbp & (1<<(5-i)))
;               % p11
;;				         sdata->pattern_code |= (1<<i);
;;		     }
;;	}
;  % p12
;//Table 7-6Q
;;	if(pdata->q_scale_type==0)
;;		sdata->IQ_value=sdata->MB_quantiser_scale_code<<1;
;;	else
;;		sdata->IQ_value=itable->Quantiser_scale[sdata->MB_quantiser_scale_code];
{ (p13)addi sp3, sp3, 4| (p13)addi sp, sp, 4| nop                 | lbu d0, a4, MB_type | nop                 }
{ (p13)bdt r6         | (p13)bdr a6         | clr d0              | lbu d1, a2, concealment_motion_vectors| nop }
{ nop                 | lw a3, sp, 20       | nop                 | (p13)addi sp2, sp2, 4| nop                }
{ nop                 | lbu d11, a4, MB_quantiser_scale_code| nop | andi d3, d0, macroblock_intra| nop        }
{ nop                 | sb d0, a4, pattern_code| nop              | and d3, d3, d1      | nop                 }
{ nop                 | lbu d12, a2, q_scale_type| nop            | nop                 | sgtiu ac7, p13, p0, d3, 0 }
{ (p13)b r1, _readbits| addi d13, a3, Quantiser_scale| (p13)moviu d0, 1| andi d8, d0, macroblock_pattern| (p13)clr ac2 }
{ nop                 | bdr d1              | add d13, d13, d11   | bdt d0              | sgtiu ac7, p14, p12, d8, 0 }
{ nop                 | lbu a5, a4, pattern_code| seqiu ac7, p11, p15, d12, 0| nop      | nop                 }
{ nop                 | andi d8, d1, macroblock_intra| (p11)slli d2, d11, 1| copy a3, d0| nop                 }
{ nop                 | sgtiu a7, p1, p0, d8, 0| clr d11          | nop                 | nop                 }
{ set_lbci r12, block_count| (p11)sb d2, a4, IQ_value| (p1)moviu d11, block_count| nop  | nop                 }
;;(p13)



_cbp_loop1:
;cluster1: a5 << pattern_code,a7 << (sdata->MB_type & macroblock_intra) ? 1 : 0
;cluster2: a3 << MB_type
{ lbcb r12, _cbp_loop1| slli a5, a5, 1      | notp p6, p0         | lbu d0, a4, MB_type | nop                 }
{ notp p2, p0         | or a5, a5, a7       | notp p7, p0         | nop                 | nop                 }
{ (p9)sb r13, r14, Error_flag| (p15)copy a3, d13| notp p8, p0     | nop                 | nop                 }
{ notp p3, p0         | sb a5, a4, pattern_code| notp p9, p0      | andi d3, d0, macroblock_intra| nop        }
{ notp p4, p0         | (p15)lbu d14, a3, 0 | nop                 | nop                 | sgtiu ac7, p13, p0, d3, 0 }
{ notp p5, p0         | clr d0              | nop                 | (p12)lbu d0, a2, alternate_scan| nop      }
;



{ (p12)b _quant_selection| (p12)lbu d0, a4, pattern_code| nop     | (p12)lw a3, sp2, 20 | nop                 }
{ (p14)b r4, _Search_cbp| (p15)sb d14, a4, IQ_value| nop          | addi a5, a4, Quantize_matrix| (p12)moviu d1, 64 }
{ nop                 | (p12)bdt d11        | nop                 | (p12)bdr d8         | (p12)fmuluu d2, d0, d1 }
{ nop                 | nop                 | nop                 | (p12)addi a3, a3, Scan| nop               }
{ (p14)notp p15, p0   | (p14)sb d0, a4, pattern_code| nop         | (p12)add a3, a3, d2 | nop                 }
{ nop                 | (p12)bdr a3         | (p12)andi d8, d0, 0x3| (p12)bdt a3        | (p12)moviu ac2, 8   }
;;(p12)
{ nop                 | clr a7              | nop                 | nop                 | nop                 }
;;(p14)
;cluser1: d5 << MB_cbp,  a5 << 5
{ sgtiu r12, p15, p1, r13, 0| moviu a5, 5   | notp p14, p0        | lbu d0, a2, alternate_scan| moviu ac3, 1  }
_cbp_loop2:
{ (p15)br r3          | sub d8, a5, a7      | moviu ac5, 1        | lw a3, sp2, 20      | (p1)sltiu ac7, p14, p11, ac3, block_count }
{ (p14)b _cbp_loop2   | lbu d0, a4, pattern_code| sll ac6, ac5, d8| moviu d1, 64        | addi ac3, ac3, 1    }
{ notp p11, p0        | moviu d10, 1        | and ac6, d5, ac6    | notp p5, p0         | fmuluu d2, d0, d1   }
{ notp p2, p0         | sll d1, d10, a7     | (p1)sgtiu ac7, p11, p0, ac6, 0| addi a3, a3, Scan| notp p6, p0  }
{ notp p3, p0         | addi a7, a7, 1      | (p11)or d0, d0, d1  | add a3, a3, d2      | moviu d9, 0         }
{ notp p4, p0         | (p11)sb d0, a4, pattern_code| notp p8, p0 | (p11)addi d8, d8, 1 | clr d1              }
;;(p15)
{ notp p7, p0         | bdr a3              | andi d8, d0, 0x3    | bdt a3              | moviu ac2, 8        }
;;(p14)
_quant_selection:
{ notp p10, p0        | clr d9              | seqiu ac7, p1, p2, d0, 16| lbu d0, a4, pattern_code| moviu d9, 0x00300000 }
{ notp p11, p0        | lbu d10, a2, picture_structure| (p2)seqiu ac7, p2, p3, d0, 32| notp p12, p0| (p1)moviu d9, 0x00080100 }
{ notp p9, p0         | lbu d11, a4, dct_type| (p3)seqiu ac7, p3, p4, d0, 48| notp p14, p0| (p2)moviu d9, 0x00080140 }
{ notp p2, p0         | extractiu d1, d0, 4, 2| (p4)sgtiu ac7, p5, p6, d8, 0| (p3)moviu d9, 0x00100100| extractiu d1, d0, 4, 2 }
{ nop                 | nop                 | (p4)seqiu ac7, p12, p0, d10, Frame_picture| nop| nop            }
{ notp p15, p0        | nop                 | (p12)sgtiu ac7, p12, p0, d11, 0| nop      | nop                 }
{ (p12)notp p5, p0    | (p12)moviu d9, 0x00200000| (p12)sltiu ac7, p0, p15, d0, 16| nop | (p12)notp p6, p0    }
{ nop                 | (p15)moviu d9, 0x00280000| (p15)sltiu ac7, p0, p7, d0, 32| nop  | nop                 }
{ notp p15, p0        | (p7)moviu d9, 0x00300000| (p5)sltiu ac7, p2, p14, d1, 4| sw d9, a4, clip_start_offset| (p6)sltiu ac7, p8, p9, d1, 4 }
{ notp p7, p0         | (p12)sw d9, a4, clip_start_offset| (p14)sltiu ac7, p15, p0, d1, 8| (p8)moviu d9, 0x00100080| (p9)sltiu ac7, p10, p11, d1, 8 }
{ nop                 | (p2)moviu d9, 0x00200000| (p5)seqiu ac7, p7, p0, d1, 0| (p10)moviu d9, 0x00180080| orp p6, p8, p10 }
{ orp p5, p2, p15     | (p15)moviu d9, 0x00280000| nop            | (p11)moviu d9, 0x00200080| orp p6, p6, p11 }
{ orp p5, p5, p7      | (p7)moviu d9, 0x00100000| nop             | (p6)sw d9, a4, clip_start_offset| nop     }
{ nop                 | (p5)sw d9, a4, clip_start_offset| nop     | nop                 | nop                 }
;;*if(sdata->pattern_code!=0){
; % p1
;			//Table 7-5
;;*	Weight_matrix=(sdata->MB_type & macroblock_intra)
;%   ?p13 : p3
;;*		?(&shead->intra_quantiser_matrix[0]):(&shead->non_intra_quantiser_matrix[0]);

;;			for(j=0;j<64;j+=2){
;;				sdata->Quantize_matrix[j]=Weight_matrix[itable->Scan[pdata->alternate_scan][j]];
;;				sdata->Quantize_matrix[j+1]=Weight_matrix[itable->Scan[pdata->alternate_scan][j+1]];
;;			}
;;	}
;% p2
;scalar:
;cluster1:  a7<< *Weight_matrix, a5<< *sdata->Quantize_matrix, a3<< *itable->Scan[pdata->alternate_scan]
;           d0<<pattern_code, d1<<load_intra_quantiser_matrix, d2<<load_non_intra_quantiser_matrix
;cluster2:  a7<< *Weight_matrix, a5<< *sdata->Quantize_matrix, a3<< *itable->Scan[pdata->alternate_scan]

;;*****************Break_Point!!!!!!!!!
;{ nop 			      | orp p15,p15,p0          | nop 				       | nop 				          | nop				      }
;{ seqiu r10,p14,p0,r0,1350| nop 	              | nop 				       | nop 				          | nop  }
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p15,p14 		|(p14)moviu a7,0xb00a9000 | nop 				       | nop 				          | nop				      }
;{(p15)b _end2 	      |(p14)moviu d0,5566       | nop 				       | nop		                | nop				      }
;{(p14)bdt sp3	      |(p14)bdr a6              | nop 				       | nop 				          | nop				      }
;{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p12)sw d0,a7,0         | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    | nop 				        | notp p15,p0			 | nop 				          | nop				      };
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end2:
;;********************************************

{ notp p3, p13        | lbu d0, a4, pattern_code| nop             | (p13)addi a7, a1, intra_quantiser_matrix| nop }
{ notp p15, p0        | nop                 | clr d8              | (p3)addi a7, a1, non_intra_quantiser_matrix| nop }
{ nop                 | bdr a7              | nop                 | bdt a7              | moviu ac2, 2        }
{ nop                 | addi a5, a4, Quantize_matrix| seqiu ac7, p2, p1, d0, 0| addi a5, a4, Quantize_matrix| orp p7, p7, p0 }
{ (p2)b _block_loop   | (p2)sw d8, a4, clip_start_offset| notp p8, p0| addi a3, a3, 1   | nop                 }
_quantize_loop1:
{ nop                 | nop                 | nop                 | (p1)lbu a6, a3, 2+  | nop                 }
{ nop                 | (p1)lbu a6, a3, 2+  | nop                 | nop                 | (p1)sltiu ac7, p15, p8, ac2, 64 }
{ (p15)b _quantize_loop1| nop               | nop                 | nop                 | addi ac2, ac2, 2    }
{ nop                 | nop                 | nop                 | (p1)lbu d4, a6, a7  | nop                 }
{ nop                 | (p1)lbu d4, a6, a7  | nop                 | nop                 | clr ac4             }
;;(p2)
{ (p8)bdt r6          | (p8)bdr a6          | nop                 | (p7)addi a5, a5, 1  | nop                 }
{ nop                 | nop                 | nop                 | sb d4, a5, 2+       | notp p7, p0         }
{ nop                 | sb d4, a5, 2+       | nop                 | nop                 | nop                 }
;;(p15)
_block_loop:
;;for(i=0;i<block_count;i++)
;;		block(i,pbs,shead,pdata,itable,sdata);
;;	if(pdata->picture_coding_type==Dframe)  //D-picture>> Mpeg1
;;		buffer=(unsigned char)(readbits(pbs,1,shead));
;;//*************Output the current MB to YUV frame buffer
;;	Write_to_YUV(shead,gop,pdata,sdata,Fmem);
;;//***********************************
;cluster2: ac4 << i



{ b r4,_Block        | nop                 | nop                 | nop                 | nop                 }
{ nop                 | bdt a6              | nop                 | bdr a6              | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | lbu d0, a4, pattern_code| nop             }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;

;;*****************Break_Point!!!!!!!!!
;{ nop  			      | nop 				        | nop 				   | nop 				          | seqiu ac7,p15,p0,ac4,1}
;{ seqiu r10,p14,p0,r0,44| nop 	                 | nop 				       | nop 				          | nop                  }
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p15,p14 		|(p14)moviu a7,0xb00a9000 | nop 				       | nop 				          | nop				      }
;{(p15)b _end3 	      | nop				           | nop 				       | nop		                | nop				      }
;{(p14)bdt sp3	      |(p14)bdr a6              | nop 				       | nop 				          | nop				      }
;{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p14)sw d0,a7,0         | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    | nop 				        | notp p15,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;;
;{ nop 			      | copy a5,[cp0] 				| nop                  | nop                      | nop				     }
;{ bdr r7		      | bdt a5 				        | nop 				   | nop 				      | nop				   }
;{ nop  			      | nop 				        | nop 				   | nop 				      | nop				   }
;{ br r7			      | nop                         | moviu d0,0x1e002000  | nop                      | nop				     }
;{ nop 			      | moviu a5,GLOBAL_POINTER_ADDR| moviu d1,0x1e002180  | nop                      | nop				     }
;{ nop 			      | dsw d0,d1,a5,Print_Start_ADDR | nop                | nop                      | nop				     }
;{ nop 			      | nop      				    | nop                  | nop                      | nop				     }
;{ nop 			      | nop  	         	        | nop                  | nop                      | nop				     }
;{ nop  			      | nop 				        | nop 				   | nop 				      | nop				   }
;
;_end3:
;;********************************************

;MB_reg_Y<<r2, MB_reg_U<<a5 in cluster1, MB_reg_V<<a3 in cluster2
;Forward_pred_Y<<r4,  Forward_pred_U<<a7 in cluster1,  Forward_pred_V<<d3 in cluster2
;Frame_buffer_Y<<r5, Frame_buffer_U<<d11 in cluster1, Frame_buffer_V<<d11 in cluster2
{ nop  			      | nop 			    | nop 		          | lw a7,sp2,44        | sltiu ac7, p1, p2, ac4, 5}
{(p2)lw r11, sp3, 40  |(p2)lbu d1, a2, picture_coding_type | nop  | nop                 | nop                 }
{ (p1)b _block_loop   | nop                 | nop                 | lbu d15, a4, Ref_num| addi ac4, ac4, 1 }
{ nop                 |(p2)lhu d0, a4, half_flag_chroma_0_0 | notp p4, p0  | addi a7,a7,Ref_MB_0_Y | (p2)moviu ac0, 16 }
{ (p2)lbu r15, r11, Ref_num| nop            | notp p3, p0         | nop                 | nop                 }
{ nop                 | nop                 | (p2)seqiu ac7, p3, p4, d1, Dframe| (p2)lhu d0, a4, half_flag_0_0| nop }
{ (p3)b r1, _readbits | (p2)lw d10, a4, row_size_0|(p4)seqiu ac7, p0, p4, d1,Iframe| nop| nop }
{ (p4)b r5, _interpolation| bdr a7          | (p3)moviu d0, 1     | bdt a7              | clr ac2             }
;;(p1)
{ nop                 | nop                 | nop                 | (p4)lw a6, a4, Prediction_buf_0| clr ac4  }
{ (p4)clr r10         | (p4)copy d14, a4    | nop                 | (p4)lhu d0, a4, half_flag_0_0| nop        }
{ nop                 | nop                 | nop                 | (p4)lw d10, a4, row_start_0| nop          }
{ (p4)sb r10, r11, Ref_count| nop           | (p4)notp p10, p0    | nop                 | (p4)notp p11, p0    }
;;(p3)
{ (p4)moviu r12, EMDMAC_ADDR| (p4)lw a6, a4, Prediction_buf_0| (p4)moviu ac0, 16| nop   | orp p3, p3, p0      }
;;(p4)
{ lw r4,sp3,44        | nop                 | nop                 | moviu a3, GLOBAL_POINTER_ADDR | nop                 }
{ nop                 | lh d2, a4, mb_row   | nop                 | nop                 | nop                 }
{ addi r0, r0, 1      | addi a5,a4,MB_reg_Y | nop                 | lw d9, a3, YSize    | clr ac4             }
{ bdt r4 		      | bdr a7		        | nop 				  | bdr d3              | nop				   }
{ bdr r2              | bdt a5              | nop                 | lw d11, a3, Decode_ADDR   | nop              }
{ moviu r10, GLOBAL_POINTER_ADDR| lw d10, a1, horizontal_size| nop| lh d2, a4, mb_row   | nop                 }
{ sw r0, r10, MB_Count| addi a7, a7,Forward_pred_U| nop           | nop                 | srli ac3, d9, 2     }
{ lw r5, r10, Decode_ADDR| addi a5, a4, MB_reg_U| nop             | add d11, d11, d9    | addi d3,d3,Forward_pred_V}
{ nop                 | bdr d11             | nop                 | bdt d11             | nop                 }
_Write_to_YUV:
;;void Write_to_YUV(Seq_header *shead,Picture_data *pdata,Slice_data *sdata,Frame_memory *Fmem){
;;	unsigned int index,pos_x,pos_y;
;;	unsigned char row_size,column_size;
;;	unsigned short MB_size,offset,x,y,count;
;;	unsigned char *component,*interlaced,*pred;
;;	unsigned char row_start,chroma_flag,row_index;
;;	short *reg;

;;for(chroma_flag=0;chroma_flag<3;chroma_flag++){
;;*		pos_y=sdata->mb_row<<3;
;;*		pos_x=sdata->mb_column<<3;
;;*		row_size=column_size=8;
;;*		offset=shead->horizontal_size;
;;		MB_size=64;
;;*		if(chroma_flag<1){   //luma
;;*			pos_y<<=1;   //(mb_row<<3)<<1
;;*			pos_x<<=1;
;;			row_size<<=1;
;;			column_size<<=1;
;;*			reg=sdata->MB_reg.Y;
;;*			pred=Fmem->Forward_pred.Y;
;;*			component=Frame[shead->display_order].Y;
;;			MB_size<<=2;
;;*		}
;;*		else{               //chroma
;;*		offset>>=1;
;;*			if(chroma_flag==1){
;;*				component=Frame[shead->display_order].U;
;;*				reg=sdata->MB_reg.U;
;;*				pred=Fmem->Forward_pred.U;
;;			}
;;*		else{
;;*				component=Frame[shead->display_order].V;
;;*				reg=sdata->MB_reg.V;
;;*				pred=Fmem->Forward_pred.V;
;;*			}
;;*		}

;;		if(pdata->picture_structure!=Frame_picture){  //field-picture
;     % p1
;;*		pos_y<<=1;
;;*		row_size<<=1;
;;*		row_index=2;
;;*		row_start=(pdata->picture_structure==Top_field) ? 0 : 1;
; % ?p0 :p2
;;		}
;;		else{
;;*		row_index=1;
;;*	   row_start=0;
;;		}

;;*   for(x=0;x<MB_size;x++){
;;*		if((sdata->MB_type & macroblock_intra)==0)
; % p3
;;*		    reg[x]+=pred[x];
;;*	  if(reg[x]>255)
;;*		    reg[x]=255;
;;*	  else if(reg[x]<0)
;;*			reg[x]=0;
;;*	  pred[x]=(unsigned char)reg[x];
;;*	}

;;		count=0;
;		//*********Move 16x16 MB to external memory by the DMA HW!!/
;		//***internal->external....1D->2D
;		//start address: Forward[0~128 or 256]
;		//destination address: component[index~]
;		//SGC=SGO=0,DSC=8 or 16,DSO=row_index*offset
;		//BSZ=64 or 256
;;*   index=(pos_y+row_start)*offset+pos_x;
;;		for(y=row_start;y<row_size;y+=row_index){
;;			for(x=0;x<column_size;x++)
;;				component[index+x]=pred[count++];
;;			index+=(row_index*offset);
;		}
;		//*****************************************
;;	}
;;}

;DMA channel: ch1<< Y, ch2<<U, ch3<<V
;MB_reg_Y<<r2, MB_reg_U<<a5 in cluster1, MB_reg_V<<a3 in cluster2
;Forward_pred_Y<<r4,  Forward_pred_U<<a7 in cluster1,  Forward_pred_V<<d3 in cluster2
;Frame_buffer_Y<<r5, Frame_buffer_U<<d11 in cluster1, Frame_buffer_V<<d11 in cluster2

;scalar:r9<<pos_y, r10<<pos_x, r12<<offset,r13=(256+64+64)/8=384/8=48
;
;cluster1:d10<<offset, d4<<pos_y, d5<<pos_x, d0<<BSZ, ac2<<row_start
;         d1<<Forward_pred_YUV[n~n+3], d14+d15<<MB_reg_YUV[n~n+3],a6<< address of MB_regYUV[n], a1<<address of Forward_pred_YUV[n]
;cluster2:d10<<offset, d4<<pos_y, d5<<pos_x, ac2<<row_start, ac1<<row_index,ac2<<row_start,d1<<MB_type
;          d1<<Forward_pred_YUV[n+4~n+7],d14,d15<<MB_reg_YUV[n+4~n+7], a6<< address of MB_regYUV[n+4], a1<<address of Forward_pred_YUV[n+4]

;;*****************Break_Point!!!!!!!!!
;{ bdt r11            | bdr d1				        | nop 				       | nop 				    | nop				      }
;{ moviu r11,GLOBAL_POINTER_ADDR  | nop 		  | nop 				       | nop 				    | nop				      }
;{ lw r9,r11,MB_Count | nop                     | nop 				       | nop 				          | nop				      }
;{ nop                | nop 				        | nop 				       | nop 				    | nop				      }
;{ nop		      | nop   	                 | nop 				       | nop 				          | nop				      }
;{ seqiu r11,p12,p0,r9,27822| nop 	                 | nop 				       | nop 				          | orp p11,p11,p0      }
;{ andp p12,p12,p11	| nop 		              | nop                  | nop 				          | nop                  }
;{ notp p11,p12       | nop                     |(p12)moviu ac0,0x5566 |nop				          | nop				      }
;{(p11)b _end3 	      | nop                     | nop                  |nop 				          | nop				      }
;{ nop 			      |(p12)moviu a7,0xb00a9000 | nop                  | nop 				    | nop				      }
;{(p12)bdt r2	      |(p12)bdr d8              | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p12)sw d1,a7,4	        | nop 				       |nop           | nop				      }
;{(p12) moviu r3,1    |(p12)sw d8,a7,8          | notp p11,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p12,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end3:
;;********************************************
;{ moviu sr7,0x01015000 			     | nop 				            | nop 				| nop 				  | nop				   }

;{ br r3              | nop  				        | nop                  |nop				             |nop      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;


{ nop                | lbu d0,a2,Pipeline_skip_flag  | nop 		           | nop  	                   | nop				      }
{ bdr r11            | bdt a4			        | clr d4			       | nop  	                   | nop				      }
{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop                | nop 				        | sgtiu ac7,p1,p0,d0,0     | nop  	                   | nop				      }
{(p1)br r3           |(p1)sb d4,a2,Pipeline_skip_flag  | nop 			       | nop  	                   | nop				      }
;

{ bdr r12             | bdt d10             | moviu d0, 64        | bdr d10             | moviu d0, 64        }
{ bdr r10             | bdt d2              | dclr d4             | dclr d4             | add d11, d11, ac3   }
{ addi r2, r11, MB_reg_Y  | copy d8, d10    | inserti d4, d2, 8, 3| inserti d4, d2, 8, 3| srli d10, d10, 1    }

;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ seqiu r9,p1,p0,r11,0x1e000140                | nop 				        | nop 				       | nop  	                   | nop				      }
;{(p1)b test_end      | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;;
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;test_end:


{ andi r9, r10, 0xff  | lbu d13, a2, picture_structure| extractiu d5, d2, 8, 8| extractiu d5, d2, 8, 8| copy ac5, d10 }
{ slli r9, r9, 4      | lhu d14, a4, clip_start_offset| notp p2, p0| slli d5, d5, 3     | moviu ac1, 1        }
{ srli r10, r10, 8    | slli d5, d5, 3      | srli d10, d10, 1    | lbu d1, a4, MB_type | clr ac2             }
{ slli r10, r10, 4    | nop                 | seqiu ac7, p0, p1, d13, Frame_picture| lhu d14, a4, clip_start_offset| nop }
{ lbu r13, r11, clip_type| (p1)slli d4, d4, 1| (p1)seqiu ac7, p0, p2, d13, Top_field| copy a7, d3| (p1)moviu ac1, 2 }
{ bdt r4              | bdr a1              | slli d15, d14, 1    | bdr a1              | andi ac6, d1, macroblock_intra }
{ bdt r2              | bdr a6              | clr ac2             | bdr a6              | slli d15, d14, 1    }
{ (p1)slli r9, r9, 1  | add a1, a1, d14     | (p2)moviu ac2, 1    | add a1, a1, d14     | (p2)moviu ac2, 1    }
{ moviu r1, DSP0_DMA_BASE | add a6, a6, d15| copy ac4, d4        | add a6, a6, d15     | (p1)slli d4, d4, 1  }


;***********************
_DSP_DMA_polling:
{ lw r9,r1,DSP0_DMASR| nop 				        | nop 				       | nop  	                   | nop				      }
{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
{ andi r9,r9,0x0000fff0  | nop 				        | nop 				       | nop  	                   | nop				      }
{ seqiu r15,p0,p1,r9,0x00002220 | nop        	     | nop 				       | nop  	                   | nop				      }
;{ seqiu r15,p0,p1,r9,0x00002222 | nop                                      | nop                                  | nop                       | nop                                      }
{(p1) b _DSP_DMA_polling | nop 		            | nop 				       | nop  	                   | nop				      }
{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
{ sgtiu r11, p2, p0, r13, 0  | nop 	            | nop 				       | nop  	                   | nop				      }
;*************************


_saturation_loop:
{ moviu r15, 0x0000020F| (p2)lw d1, a1, 0   | slli ac3, d4, 1     | (p2)lw d1, a1, 4    | seqiu ac7, p3, p4, ac6, 0 }
{ moviu r2, 256       | (p2)dlw d14, a6, 16+| add ac3, ac3, ac2   | (p2)dlw d14, a6, 8  | add ac3, d4, ac2    }
{ moviu r12, 0x01000000| (p4)dclr d12       | fmuluu d6, ac3, d8  | addi a1, a1, 4      | (p4)dclr d12        }
{ lbcb r13, _saturation_loop| (p3)unpack4u d12, d1| add ac3, ac4, ac2| addi a6, a6, 16  | (p3)unpack4u d12, d1 }
{ slli r2, r2, 12     | add.d d3, d13, d14  | copy ac7, d5        | add.d d3, d13, d14  | copy ac7, d5        }
{ or r15, r15, r2     | limbucp d3, d3      | add.d d9, d12, d15  | limbucp d3, d3      | add.d d9, d12, d15  }
{ bdr r11             | bdt d6              | limbucp d2, d9      | limbucp d2, d9      | fmuluu ac4, ac1, ac5 }
{ moviu r1, DSP0_DMA_BASE| pack4 d1, d2, d3 | fmuluu d9, ac3, d10 | pack4 d1, d2, d3    | fmuluu d9, ac3, d10 }
{ add r11, r11, r10   | (p2)sw d1, a1, 8+   | add d9, d9, ac7     | (p2)sw d1, a1, 4+   | add d9, d9, ac7     }
;



{ add r5, r5, r11     | add a5, d9, d11     | moviu d12, 0x00800000| add a3, d9, d11    | copy d8, ac4        }
{ bdr r9              | bdr d8              | moviu d1, 0x0000020F| bdt d8              | moviu d1, 0x0000020F }
{ sw r4, r1, DSP0_DMASAR1| moviu a1, DSP0_DMA_BASE| nop           | moviu a1, DSP0_DMA_BASE| moviu d12, 0x00800000 }
{ slli r9, r9, 1      | sw a7, a1, DSP0_DMASAR2| or d12, d12, d8  | sw a7, a1, DSP0_DMASAR3| or d12, d12, d8  }
{ sw r5, r1, DSP0_DMADAR1| sw a5, a1, DSP0_DMADAR2| slli d0, d0, 12| sw a3, a1, DSP0_DMADAR3| slli d0, d0, 12 }
{ or r12, r12, r9     | sw d12, a1, DSP0_DMADSR2| or d1, d1, d0   | sw d12, a1, DSP0_DMADSR3| or d1, d1, d0   }
{ nop                 | sw d1, a1, DSP0_DMACTL2| nop              | sw d1, a1, DSP0_DMACTL3| nop              }
{ sw r12, r1, DSP0_DMADSR1| nop             | nop                 | nop                 | nop                 }

;{ moviu sr7,0x02015000 			     | nop 				            | nop 				| nop 				  | nop				   }




.if 1
{ br r3               | sw d1, a1, DSP0_DMACLR2| nop              | sw d1, a1, DSP0_DMACLR3| nop              }
{ sw r15, r1, DSP0_DMACTL1| sw d1, a1, DSP0_DMAEN2| nop           | nop                 | nop                 }
{ sw r15, r1, DSP0_DMACLR1| nop             | nop                 | sw d1, a1, DSP0_DMAEN3| nop               }
{ sw r15, r1, DSP0_DMAEN1| nop              | nop                 | moviu a3, GLOBAL_POINTER_ADDR | nop       }
{ bdt r6              | bdr a6              | nop                 | bdr a6              | nop                 }
{ bdt r14             | bdr a1              | clr d5              | bdr a1              | nop                 }
;
.endif

.if 0 
_DSP_DMA_polling_Trace:
{ lw r9,r1,DSP0_DMASR| nop                                      | nop                                  | nop                       | nop                                      }
{ nop                | nop                                      | nop                                  | nop                       | nop                                      }
{ nop                | nop                                      | nop                                  | nop                       | nop                                      }
{ seqiu r15,p0,p1,r9,0x00002222 | nop                                      | nop                                  | nop                       | nop                                      }
{(p1) b _DSP_DMA_polling_Trace | nop                      | nop                                      | nop                       | nop                                      }
{ nop                | nop                                      | nop                                  | nop                       | nop                                      }
{ nop                | nop                                      | nop                                  | nop                       | nop                                      }
{ nop                | nop                                      | nop                                  | nop                       | nop                                      }
{ nop                | nop                                      | nop                                  | nop                       | nop                                      }
{ nop                | nop                                      | nop                                      | nop                       | nop                                      }
;
.endif

.if 1
;{ br r3              | nop                                      | nop                                  | nop                       | nop                                      }
{ nop                | nop                                      | nop                                  | nop                       | nop                                      }
{ nop                | nop                                      | nop                                  | nop                       | nop                                      }
{ nop                | nop                                      | nop                                  | nop                       | nop                                      }
{ nop                | nop                                      | nop                                      | nop                       | nop                                      }
{ nop                | nop                                      | nop                                      | nop                       | nop                                      }
.endif




_Block:
;; void block(int i,Bitstream *pbs,Seq_header *shead,Picture_data *pdata
;;		   ,Init_table *itable,Slice_data *sdata){
;;	   unsigned char dct_value;
;;	   short dct_diff,half_range;
;;	   unsigned char color_index;
;;	   short *temp;
;;	   unsigned char x,y,offset,row_step,row_size,pos_x,pos_y,index,count;

;;*	 if(sdata->pattern_code & (1<<i)){
;   %p1
;;*		 if(sdata->MB_type & macroblock_intra){  //MB
;         % p3
;;*			 if(i<4){   //Y component
;              % p5=p5 && p3
;;*				  color_index=0;
;;*				  dct_value=Search_Dct_value(pbs,shead,9,6);   //2~9bits
;                % p11
;;*				  if(dct_value!=0){
;;*					       sdata->dc_dct_differential=(unsigned short)(readbits(pbs,dct_value,shead));
;;*				  }
;;*			 }
;;*			 else{
;              % p6=p6 && p3
;;*				  color_index=(i==4) ? 1 : 2;
;                                   % ? p7 : p8
;;*				  dct_value=Search_Dct_value(pbs,shead,10,7);  //2~10bits
;;*				  if(dct_value!=0){
;                % p11
;;*					     sdata->dc_dct_differential=(unsigned short)(readbits(pbs,dct_value,shead));
;;*				  }
;;*			 }
;			      //*********�D�X8x8 block��DC��
;;			     if(dct_value==0)
;              % p12
;;*				        dct_diff=0;
;;			     else{
;              % p11
;;*				        half_range=1<<(dct_value-1);
;;*				     if(sdata->dc_dct_differential>=half_range)
;                   % p9=p11 && p9
;;*					      dct_diff=sdata->dc_dct_differential;
;;*				     else
;                   % p10=p11 && p10
;;*					      dct_diff=(sdata->dc_dct_differential+1)-(half_range<<1);
;;*			      }
;;*			   sdata->QFS[0]=sdata->dc_dct_pred[color_index]+dct_diff;  //dc_dct_pred[cc]
;;*		      if(sdata->QFS[0]>((1<<(8+pdata->intra_dc_precision))-1))
;              % p11
;;*				        sdata->QFS[0]=(1<<(8+pdata->intra_dc_precision))-1;
;;*			      else if(sdata->QFS[0]<0)
;              % p13=p12 && p13
;;*				        sdata->QFS[0]=0;
;;*			      sdata->dc_dct_pred[color_index]=sdata->QFS[0];
;			      //***************************
;;*			  if(shead->Error_flag)
;              % p15
;;*				   return;
;;			      if(pdata->picture_coding_type!=Dframe)
;              % p14
;;				        VLD_finding(pbs,0,shead,pdata,sdata,1);  //AC component of 8x8 block >> Table B-14 or B-15
;;             else
;              % p13
;;                   VLD_finding(pbs,0,shead,pdata,sdata,0);  //AC component of 8x8 block >> Table B-14 or B-15
;;	        }
;;	        else
;          %  p4
;;			      VLD_finding(pbs,1,shead,pdata,sdata,1);  //  First DCT coefficent
;;	  }
;    % p2
;;else{
;;		for(x=0;x<64;x++)
;;			sdata->QF[x]=0;
;;	}
;cluster1 : ac2 << color_index*2, d13<<cachesz == dct_index
;cluster2 : ac4 << i (not change!!!),ac3 << table_index
{ nop                 | lbu d8, a4, MB_type | nop                 | nop                 | moviu d1, 1         }
{ nop                 | nop                 | nop                 | nop                 | sll d1, d1, ac4     }
{ nop                 | notp p5, p0         | nop                 | and d0, d0, d1      | seqiu ac7, p7, p8, ac4, 4 }
{ notp p3, p0         | notp p4, p0         | andi ac6, d8, macroblock_intra| nop       | seqiu ac7, p2, p1, d0, 0 }

.if 0
;;*****************Break_Point!!!!!!!!!
{ seqiu r11,p10,p0,r0,396 | nop 	              | nop 				       | nop 				          | seqiu ac7,p11,p0,ac4,0}
{ andp p10,p10,p11 	| nop 		              | nop 				       | nop 				          | nop                  }
{ notp p11,p10 		|(p10)moviu d0,0x33445566  | nop 				       | nop 				          | nop				      }
{(p11)b _end3 	        |(p10)moviu a7,0x24007500 | nop 				       | nop 				          | nop				      }
{ nop 			      |(p10)sw d0,a7,0          | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{(p10) moviu r3,1    | nop 				        | notp p11,p0			 | nop 				          | nop				      }
{ nop 			      | nop 				        | notp p10,p0 			 | nop 				          | nop				      }
;;
{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
_end3:
;;********************************************
.endif 



{ (p2)b _clear_QF     | bdt d8              | (p1)sgtiu ac7, p3, p4, ac6, 0| bdr d8     | notp p6, p0         }
{ (p4)b _block_DC_end | (p4)moviu a7, 1     | (p4)orp p14, p14, p0| (p4)lbu d2, a4, MB_type| (p3)sltiu ac7, p5, p6, ac4, 4 }
{ (p3)b r2, _Search_dct_value| andp p7, p7, p6| (p5)moviu ac2, 0  | addi a5, a4, QF     | andp p8, p8, p6     }
{ (p2)notp p14, p0    | (p5)moviu d13, 9    | (p7)moviu ac2, 2    | (p2)lbu d13, a1, Error_flag| (p5)moviu ac3, 6 }
{ (p2)set_lbci r10, 2 | (p6)moviu d13, 10   | (p8)moviu ac2, 4    | addi a5, a5, 8      | (p6)moviu ac3, 7    }
{ notp p13, p0        | addi a5, a4, QF     | (p2)dclr d0         | (p2)dclr d0         | (p4)clr ac6         }
;;(p2)
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;(p4)
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;(p3)
{ nop                 | nop                 | seqiu ac7, p12, p11, d5, 0| nop           | nop                 }
{ (p11)b r1, _readbits| nop                 | (p11)copy d0, d5    | nop                 | (p11)clr ac2        }
{ nop                 | bdt d5              | copy d12, ac2       | bdr a3              | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;			     if(dct_value==0)
;              % p12
;;*				        dct_diff=0;
;;			     else{
;              % p11
;;*				        half_range=1<<(dct_value-1);
;;*				     if(sdata->dc_dct_differential>=half_range)
;                   % p9=p11 && p9
;;*					      dct_diff=sdata->dc_dct_differential;
;;*				     else
;                   % p10=p11 && p10
;;*					      dct_diff=(sdata->dc_dct_differential+1)-(half_range<<1);
;;*			      }
;;*			   sdata->QFS[0]=sdata->dc_dct_pred[color_index]+dct_diff;  //dc_dct_pred[cc]
;;*		      if(sdata->QFS[0]>((1<<(8+pdata->intra_dc_precision))-1))
;              % p11
;;*				        sdata->QFS[0]=(1<<(8+pdata->intra_dc_precision))-1;
;;*			      else if(sdata->QFS[0]<0)
;              % p13=p12 && p13
;;*				        sdata->QFS[0]=0;
;;*			  sdata->dc_dct_pred[color_index]=sdata->QFS[0];

;;(p11)
;cluster1 : d12 << color_index*2, d13<<cachesz == dct_index
;cluster2 : ac4 << i (not change!!!),ac3 << table_index,d0 <<dct_diff,a3 << dct_value
;              ,d2 <<dc_dct_differential, d10<<half_range
{ (p9)sb r13, r14, Error_flag| (p11)bdt d5  | nop                 | (p11)bdr d2         | nop                 }
{ andp p15, p9, p0    | (p11)sh d5, a4, dc_dct_differential| nop  | (p11)addi a3, a3, (-1)| (p11)moviu d8, 1  }
{ notp p9, p0         | add a5, a4, d12     | notp p10, p0        | (p11)sll d10, d8, a3| copy ac5, d2        }
{ (p15) br r4         | bdt a5              | notp p15, p0        | bdr a7              | (p11)slt ac7, p10, p9, ac5, d10 }
{ nop                 | nop                 | nop                 | (p9)copy d0, d2     | (p10)addi ac5, ac5, 1 }
{ nop                 | nop                 | nop                 | lhu d3, a7, dc_dct_pred0| nop             }
{ nop                 | nop                 | nop                 | (p10)slli d10, d10, 1| (p12)moviu d0, 0   }
{ nop                 | nop                 | nop                 | lbu d11, a2, intra_dc_precision| (p10)sub d0, ac5, d10 }
{ nop                 | nop                 | nop                 | add d3, d3, d0      | moviu d13, 1        }
;;(p15)
{ nop                 | lbu d0, a2, picture_coding_type| nop      | copy d12, d3        | clr d7              }
{ nop                 | lbu d8, a4, MB_type | nop                 | sltiu d4, p13, p0, d3, 0| addi d11, d11, 8 }
{ nop                 | nop                 | nop                 | sh d3, a4, QFS      | sll d13, d13, d11   }
{ nop                 | nop                 | nop                 | sh d3, a7, dc_dct_pred0| addi d13, d13, (-1) }
{ nop                 | bdt d8              | nop                 | bdr d2              | sgt ac7, p11, p12, d12, d13 }
{ nop                 | nop                 | nop                 | (p11)sh d13, a4, QFS| andp p12, p12, p13  }
{ nop                 | addi a5, a4, QF     | nop                 | (p12)sh d13, a4, QFS| orp p15, p11, p12   }
{ orp p14, p14, p0    | nop                 | nop                 | addi a5, a4, QF+8   | (p12)copy d13, d7   }
{ nop                 | (p14)clr a7         | seqiu d1, p13, p0, d0, Dframe| (p15)sh d13, a7, dc_dct_pred0| clr ac6 }
_block_DC_end:

;;*****************Break_Point!!!!!!!!!
;{ trap 	        | nop 				      | nop 				| nop 				  | nop				   }
;;********************************************

;;*if(sdata->MB_type & macroblock_intra)
;;*		right_shift=4;
;;*	else
;;*		right_shift=5;
;;*for(m=0;m<64;m++)
;;*	sdata->QF[m]=0;
;;*if(Dframe_set==0)
;;*	goto _IS_IQ;
;;*	table_flag=((sdata->MB_type & macroblock_intra) && pdata->intra_vlc_format) ? 0 : 1;
;;*	n=(sdata->MB_type & macroblock_intra) ? 1: 0;
;;*End_of_block=0;

{ clr r9              | dclr d0             | notp p3, p0         | (p14)lbu d9, a2, intra_vlc_format| dclr d0 }
{ lbu r13, r14, Error_flag| nop             | notp p4, p0         | andi d10, d2, macroblock_intra| (p14)moviu ac3, 1 }
;;*else{
;;*		for(x=0;x<64;x++)
;;*			sdata->QF[x]=0;
;;*	}

;;******Saturation Part
;cluster1: d6,ac2<<0xf800f800,d7,ac3<<07ff07ff,ac5 << sum, a3 << address of QF[m],a7 << address of QF[m+4]
;cluster2: ac4<< i (not change!!),d6,d15<<0xf800f800,d7,ac3<<07ff07ff, a3 << address of QF[m+8],a7 << address of QF[m+12],ac5<<sum
;********************************************



_clear_QF:
{ notp p6, p0         | dsw d0, d1, a5, 16+ | notp p9, p0         | dsw d0, d1, a5, 16+ | (p14)sgtiu ac1, p3, p4, d10, 0 }
{ notp p7, p0         | dsw d0, d1, a5, 16+ | (p3)moviu ac3, 4    | dsw d0, d1, a5, 16+ | (p14)and d8, d9, d10 }
{ (p14)b _VLD_found   | dsw d0, d1, a5, 16+ | (p4)moviu ac3, 5    | dsw d0, d1, a5, 16+ | (p14)seqiu ac5, p1, p2, d8, 0 }
{ nop                 | dsw d0, d1, a5, 16+ | (p13)movi ac2, 0xf800f800| dsw d0, d1, a5, 16+| (p13)clr ac5    }
{ (p13)set_lbci r11, 32| dsw d0, d1, a5, 16+| (p13)moviu ac3, 0x07ff07ff| dsw d0, d1, a5, 16+| (p13)clr ac3   }
{ notp p3, p0         | dsw d0, d1, a5, 16+ | (p13)clr ac4        | dsw d0, d1, a5, 16+ | (p13)dclr d8        }
{ notp p4, p0         | dsw d0, d1, a5, 16+ | (p13)copy d6, ac2   | dsw d0, d1, a5, 16+ | nop                 }
{ notp p5, p0         | dsw d0, d1, a5, 16+ | (p13)copy d7, ac3   | dsw d0, d1, a5, 16+ | nop                 }
_block_to_MB:
;//*********Move the 8x8 block data done by IDCT into the 16x16 registers of MB_reg!!
;;*	if(shead->Error_flag)
;  % p13
;;*			return;
;;	if(i<4){
;  % p1
;;*		offset=4;
;;*		row_step=(pdata->picture_structure==Frame_picture && sdata->dct_type) ? 2 : 1;
;                  %p9=p11 && d12
;;*		temp=sdata->MB_reg.Y;
;;		switch (i){
;;			case 0:   //(0,0)
;;*				pos_y=0;
;;*				pos_x=0;
;;				break;
;;			case 1:   //(0,8)
;     %p5
;;*				pos_y=0;
;;*				pos_x=8;
;;				break;
;;			case 2:   //(8,0)<<frame DCT or (1,0)<<field DCT
;     %p6
;;*				pos_x=0;
;;*				pos_y=(pdata->picture_structure==Frame_picture && sdata->dct_type) ? 1 : 8;
;     % ? p9 : p10
;;				break;
;;			case 3:   //(8,0)<<frame DCT or (1,8)<<field DCT
;    %p7
;;*				pos_x=8;
;    % p8=p6 || p7
;;*				pos_y=(pdata->picture_structure==Frame_picture && sdata->dct_type) ? 1 : 8;
;;				break;
;;		}
;		//field DCT in frame picture
;;	}
;;	else{
;;*		offset=3;
;;*		row_step=1;
;   % p2
;;*		temp=(i==4) ? sdata->MB_reg.U : sdata->MB_reg.V;
;       % p3=1 << i=4, p4=1 << i=5
;;*		pos_y=0;
;;*		pos_x=0;
;			//4:2:0 can not be seperated into two-fields format
;;	}
;//**********Put the current block data into the MB register
;//**********which storing order is judged by frame or field DCT type
;;*	count=0;
;;*	row_size=8<<(row_step-1);

;;  index_temp=(pos_y<<offset)+pos_x;
;; for(y=0;y<row_size;y+=row_step){
;;		index=(y<<offset)+index_temp;
;;		for(x=0;x<8;x++){
;;       temp[index+x]=sdata->QF[count++];
;;    }
;;	}
;//*************************************************************

;scalar:
;cluster1: d0<<pos_y, d1<<pos_x, d9<< row_step, d8<< offset, d9<<dct_type,ac2 << count, d10<< row_size, ac2 << y,d12 << index
;          ,a3<< address of temp[index], d6<<index, ac3<<(row_step<<offset)
;cluster2: ac4 << i (not change!!!),d13 << Error_flag, d0<< picture_structure,  a5<< MB_reg_YUV,a3 << address of QF[n]]
;          ,d4,d5,d8,d9<< QF[n~n+8] ,d6<<index, d8<<offset, d9<<row_step, d5<<(row_step<<offset)
;{ moviu sr7,0x01015000 			      | nop 				        | nop 				       | nop 				          | nop				      }




{ sgtiu r11, p13, p0, r13, 0| moviu d8, 8   | dclr d0             | lbu d0, a2, picture_structure| sltiu ac7, p1, p2, ac4, 4 }
{ (p13)br r4          | lbu d7, a4, dct_type| clr ac2             | (p1)addi a6, a4, MB_reg_Y| (p2)seqiu ac7, p3, p4, ac4, 4 }
{ notp p10, p0        | (p1)moviu d8, 16    | clr d6              | (p3)addi a6, a4, MB_reg_U| (p1)seqiu ac7, p5, p0, ac4, 1 }
{ set_lbci r15, 4     | addi a3, a4, QF     | moviu d9, 1         | (p4)addi a6, a4, MB_reg_V| (p1)seqiu ac7, p7, p0, ac4, 3 }
{ orp p13, p5, p7     | bdr a6              | sgtiu ac7, p12, p0, d7, 0| bdt a6         | seqiu ac7, p11, p2, d0, Frame_picture }
{ (p1)andp p9, p11, p12| addi a5, a4, QF+8  | (p13)moviu d1, 8    | addi a3, a4, QF+16  | (p1)seqiu ac7, p6, p0, ac4, 2 }
{ (p1)notp p10, p9    | orp p8, p6, p7      | (p9)moviu d9, 2     | addi a5, a4, QF+24  | dclr d0             }
;;(p13)
{ andp p11, p8, p9    | dbdt d8, d9         | nop                 | dbdr d8             | clr d6              }
{ notp p1, p0         | (p11)moviu d0, 1    | copy ac0, d8        | (p11)moviu d0, 1    | andp p12, p8, p10   }
{ orp p2, p2, p0      | (p12)moviu d0, 8    | fmuluu ac3, d9, d8  | (p12)moviu d0, 8    | fmuluu ac3, d8, d9  }
_block_MB_loop:

;;*****************Break_Point!!!!!!!!!
;{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;{ seqiu r10,p14,p0,r0,0| nop 	                 | nop 				       | nop 				          | seqiu ac7,p15,p0,ac4,2  }
;{ seqiu r10,p11,p0,r15,2 			      | nop 				        | nop 				       | nop 				          | nop				      }
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ andp p14,p14,p11   | nop 				        | nop 				       | nop 				          | nop				      }
;{ notp p15,p14 		| nop                     | nop 				       | nop 				          | nop				      }
;{(p15)b _end4 	      | nop				           | nop 				       | nop		                | nop				      }
;{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p14)sw d0,a7,0         | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    | nop 				        | notp p15,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;;;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end4:
;;********************************************

{ nop                 | dlw d12, a3, 32+    | fmuluu ac5, d0, ac0 | (p13)moviu d1, 8    | copy ac0, d9        }
{ sgtiu r11, p0, p1, r15, 1| nop            | add ac5, ac5, d1    | dlw d12, a3, 32+    | add ac0, ac0, d0    }
{ lbcb r15, _block_MB_loop| dlw d14, a5, 32+| add d6, d6, ac5     | add d6, d6, d1      | fmuluu ac0, ac0, d8 }
{ (p1)br r4           | slli a7, d6, 1      | nop                 | dlw d14, a5, 32+    | add d6, d6, ac0     }
{ nop                 | dsw d12, d13, a6, a7| (p2)clr ac2         | slli a7, d6, 1      | (p2)clr ac2         }
{ nop                 | addi a7, a7, 8      | addi ac2, ac2, 2    | dsw d12, d13, a6, a7| addi ac2, ac2, 2    }
{ nop                 | dsw d14, d15, a6, a7| nop                 | addi a7, a7, 8      | nop                 }
{ notp p2, p0         | nop                 | fmuluu d6, ac3, ac2 | dsw d14, d15, a6, a7| fmuluu d6, ac3, ac2 }
;
{ (p1)bdt r6          | (p1)bdr a6          | nop                 | (p1)bdr a6          | nop                 }
;(p1)

;;*****************Break_Point!!!!!!!!!
;{ trap 	        | nop 				      | nop 				| nop 				  | nop				   }
;;********************************************




_Search_dct_value:
;;unsigned char Search_Dct_value(Bitstream *pbs,Seq_header *shead
;;							   ,unsigned char dct_index,unsigned char table_index){
;	//******TableB-12 >>2~9bits or TableB-13 >> 2~10bits
;;	unsigned short cache;
;;	unsigned char bit_offset;
;;	unsigned char BitLeft;

;;	cache=(unsigned short)(readbits(pbs,dct_index,shead)); //9bits
;;	BitLeft=pbs->BitLeftInCache;
;;	bit_offset=Table_Search(cache,dct_index,&(coef_token_table[table_index]),shead);
;;	pbs->BitLeftInCache=BitLeft+(dct_index-bit_offset);
;;	return (unsigned char)pair->value.val;
;;}

;cluster1: d13<< clumpsz ==  dct_index,d14 << clumpsz,ac2=d11 << i(not change!!)
;cluster2: ac3 << table_index: 6(table12) or 7(table13), ac5<< address of Picture_data,ac4 << i(not change

{ b r1, _readbits     | nop                 | copy d0, d13        | copy d5, a2         | clr ac2             }
{ bdt r2              | bdr a7              | copy d11, ac2       | nop                 | copy ac5, d5        }
{ nop                 | copy a5, a2         | nop                 | lw a2, sp2, 24      | nop                 }
{ nop                 | lw a2, sp, 24       | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;
{ b r1, _table_search | nop                 | copy ac2, d0        | lbu a3, a6, BitLeftInCache| seqiu ac7, p1, p2, ac3, 6 }
{ (p9)sb r13, r14, Error_flag| (p1)addi a2, a2, B12_startbit| nop | (p1)addi a2, a2, B12_startbit| nop        }
{ nop                 | (p2)addi a2, a2, B13_startbit| nop        | (p2)addi a2, a2, B13_startbit| nop        }
{ nop                 | lbu d14, a2, 0      | nop                 | nop                 | nop                 }
{ bdr r2              | bdt a7              | moviu d8, 1         | nop                 | nop                 }
{ clr r13             | nop                 | clr d15             | nop                 | clr ac2             }
;
;cluster2: ac2 << dct_index
{ br r2               | bdr d13             | nop                 | bdt a3              | nop                 }
{ nop                 | copy a2, a5         | nop                 | nop                 | nop                 }
{ sb r13, r14, Error_flag| nop              | add ac2, d13, ac2   | nop                 | nop                 }
{ nop                 | extractiu d5, d2, 6, 4| sub d13, ac2, d15 | nop                 | nop                 }
{ nop                 | sb d13, a6, BitLeftInCache| nop           | nop                 | copy d5, ac5        }
{ nop                 | nop                 | copy ac2, d11       | copy a2, d5         | nop                 }
;
_VLD_found:
;;void VLD_finding(Bitstream *pbs,unsigned char first,Seq_header *shead
;;				 ,Picture_data *pdata,Slice_data *sdata,Init_table *itable,unsigned char Mpeg2_set){
;;	unsigned char eob_not_read=1,table_flag;
;;	int m,n;
;//*********IS_IQ
;;	int sum;
;;	int Quantize_temp;
;;	unsigned char IQ_value,intra_dc_mult;
;;	unsigned char *Weight_matrix;
;;	short QF_temp;
;//***************
;;*	   if(Mpeg2_set==0)
;;*		     goto _IS_IQ;
;;*	  table_flag=((sdata->MB_type & macroblock_intra) && pdata->intra_vlc_format) ? 0 : 1;
;;*	  n=(sdata->MB_type & macroblock_intra) ? 1: 0;
;;*	  End_of_block=0;
;;* while(eob_not_read){
;   %p13
;;*	  if(table_flag){   //Table B-14 >> end of block=10
;       %p1
;;*			  Search_Dct_coeff_0(pbs,first,shead,sdata);
;;*			  first=0;
;;*		  }
;;*	  else						//Table B-15  >> end of block=0110
;       %p2
;;*			  Search_Dct_coeff_1(pbs,shead,sdata);
;;       if(shead->Error_flag || (End_of_block && n>0)){  //end of block
;        % p4= p15 || (p3 && p5)
;;*		    eob_not_read=0;
;;		   }
;;		   else{
;        % p6
;;*			    n+=sdata->Ent.run;

;;************Inverse Qiantization
;;             QF_temp=(sdata->Quantize_matrix[n]*sdata->IQ_value);
;;			      Quantize_temp=sdata->Ent.level*QF_temp;
;;			      if((sdata->MB_type & macroblock_intra)==0){
;;				        Quantize_temp<<=1;
;;				        if(sdata->Ent.level>0)
;;					          Quantize_temp+=QF_temp;
;;			     	     if(sdata->Ent.level<0)
;;					          Quantize_temp-=QF_temp;
;;			      }
;;			      Quantize_temp>>=right_shift;
;;			      if(sign_temp)
;;				     Quantize_temp=-Quantize_temp;
;;			      *(itable->IS_address[n])=(short)Quantize_temp;
;;			      n++;
;;***********************************
;;		  }

;;		  if(n>64){
;;*			    eob_not_read=0;
;;*			    shead->Error_flag=1;
;;		  }
;;	  }
;;	  if(shead->Error_flag)
;;*		  return;

;scalar: r13<<Error_flag,r4<<address of Init_table, r2<< address of IS_address
;cluster1:  a7 << first(not change!!),d5<<sign_temp,ac3<<right_shift
;cluster2: ac6 << end_of_block,ac3 <<eob_not_read,,ac1 << n, ac5 << table_flag,d6<<2 (not change!!),ac4<< i (not change!!)
;         ,d3<<sdata->IQ_value,d4<<address of sdata->quantize_matrix,d11<< macroblock_intra & MB_type
;p7 = (p6 && p5) || (p3 && p5)

;;*****************Break_Point!!!!!!!!!
;{ nop 			      | nop 				        | nop 				       | nop 				          | seqiu ac7,p11,p0,ac1,18}
;{ nop 	            | nop 				        | nop 				       | nop 				          |  seqiu ac7,p15,p0,ac4,2}
;{ seqiu r11,p14,p0,r0,44| nop 	              | nop 				       | nop 				          | nop                  }
;{ andp p14,p14,p11 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p15,p14 		|(p14)moviu a7,0xb00a9000 | nop 				       | nop 				          |(p14)copy d0,ac6      }
;{(p15)b _end3 	      |(p14)moviu d0,0x33445566 | nop 				       | nop		                | nop				      }
;{ nop                |(p14)bdr d5              | nop 				       |(p14)bdt d0		          | nop				      }
;{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p14)sw d5,a7,0         | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    |(p14)sw d0,a7,4           | notp p15,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;;
;{ nop 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end3:
;;********************************************

;;*****************Break_Point!!!!!!!!!
;{ trap 	        | nop 				      | nop 				| nop 				  | nop				   }
;;********************************************

;{ moviu sr7,0x01015000 	        | nop 				      | nop 				| nop 				  | nop				   }

{ notp p1, p0         | notp p2, p0         | clr ac5             | lbu d0, a4, MB_type | sgtiu ac7, p3, p4, ac3, 0 }
{ (p4)b _saturation_Mpeg2| (p4)lh d3, a4, QFS| notp p13, p0       | (p3)lbu d3, a4, IQ_value| (p3)sgtiu ac7, p1, p2, ac5, 0 }
{ (p1)b r5, _dct_coeff_0| (p4)lbu d2, a2, intra_dc_mult| (p4)notp p14, p0| (p3)addi d4, a4, Quantize_matrix| (p4)clr ac5 }
{ (p2)b r5, _dct_coeff_1| nop               | (p4)movi ac2, 0xf800f800| (p4)lbu d1, a1, constrained_parameter_flag| andi d11, d0, macroblock_intra }
{ (p3)lw r11,sp3, 12  | (p4)addi a3, a4, QF | (p4)moviu ac3, 0x07ff07ff| (p4)moviu d14, QF+16| (p4)sgtiu ac7, p13, p6, d11, 0 }
{(p3)lw r2, sp3, 20   | (p4)addi a7, a3, 8  | (p13)sll d2, d3, d2 | (p4)add a3, a4, d14 | (p4)clr d6          }
{ (p4)set_lbci r10, 4 | (p13)sh d2, a3, 0   | (p4)clr d11         | (p4)addi a7, a3, 8  | (p4)seqiu ac7, p1, p2, d1, 0 }
;;(p4)
{ lbu r8,r11,Pipeline_flag_B  | nop         | nop                 | nop                 | nop                 }
;;(p1)
{ addi r2, r2, IS_address  | nop            | nop                 | nop                 | nop                 }
;;(p2)

;;*****************Break_Point!!!!!!!!!
;{ trap 	        | nop 				      | nop 				| nop 				  | nop				   }
;;********************************************



;;       if(shead->Error_flag || (End_of_block && n>0)){  //end of block
;        % p4= p15 || (p3 && p5)
;;*		    eob_not_read=0;
;;		   }
;;		   else{
;        % p6
;;*			    n+=sdata->Ent.run;

;;************Inverse Qiantization
;;*            QF_temp=(sdata->Quantize_matrix[n]*sdata->IQ_value);
;;*		      Quantize_temp=sdata->Ent.level*QF_temp;
;;*		      if((sdata->MB_type & macroblock_intra)==0){
;              %p13
;;*			        Quantize_temp<<=1;
;;*			        if(sdata->Ent.level>0)
;                   %p7
;;*				          Quantize_temp+=QF_temp;
;;*		     	     if(sdata->Ent.level<0)
;                   %p8
;;*				          Quantize_temp-=QF_temp;
;;			      }
;;			      Quantize_temp>>=right_shift;
;;			      if(sign_temp)
;              %p1
;;				     Quantize_temp=-Quantize_temp;
;;			      *(itable->IS_address[n])=(short)Quantize_temp;
;;			      n++;
;;***********************************
;;		  }

;;		  if(n>64){
;       %p2
;;*			    eob_not_read=0;
;;*			    shead->Error_flag=1;
;;		  }
;;	  }
;;	  if(shead->Error_flag)
;;*		  return;

;scalar: r13<<Error_flag,r4<<address of Init_table, r2<< address of IS_address
;cluster1:  a7 << first(not change!!),d5<<sign_temp,ac3<<right_shift
;cluster2: ac6 << end_of_block,ac3 <<eob_not_read,,ac1 << n, ac5 << table_flag,d6<<2 (not change!!),ac4<< i (not change!!)
;         ,d3<<sdata->IQ_value,d4<<address of sdata->quantize_matrix,d11<< macroblock_intra & MB_type,ac2<<QF_temp
;p7 = (p6 && p5) || (p3 && p5)

;;*****************Break_Point!!!!!!!!!
;{ nop 			      | nop 				        | nop 				       | nop 				          | seqiu ac7,p11,p0,ac1,4}
;{ seqiu r11,p14,p0,r0,1350| nop 	              | nop 				       | nop 				          | seqiu ac7,p15,p0,ac4,0}
;{ andp p14,p14,p11 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p15,p14 		|(p14)moviu a7,0xb00a9000 | nop 				       | nop 				          |(p14)copy d0,ac6      }
;{(p15)b _end3 	      |(p14)moviu d0,0x33445566 | nop 				       | nop		                | nop				      }
;{ nop                |(p14)bdr d5              | nop 				       |(p14)bdt d0		          | nop				      }
;{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p14)sw d5,a7,0         | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    |(p14)sw d0,a7,4           | notp p15,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end3:
;;********************************************


{ seqiu r12, p13, p15, r13, 0 | notp p5, p0 | dclr d2             | lbu d0, a4, Ent_run | sgtiu ac7, p3, p10, ac6, 0 }
{ seqiu r12, p2,p13,r8,2     | lh d9, a4, Ent_level| orp p4, p3, p15     | moviu d13, 4         | (p3)sgtiu ac7, p5, p0, ac1, 0 }
{ (p2)addi r2,r2,256  | bdr d0              | notp p6, p4         | bdt d11             | dclr d8             }
{ (p4)b _VLD_found    | nop                 | notp p10, p0        |(p6)lh d7,a4,Ent_level | add d12, d0, ac1    }
{ notp p8,p0          | (p6)copy d2, d9     | notp p13,p0         | (p6)addi a5, d12, Quantize_matrix| (p4)sgtiu ac7, p10, p0, ac1, 64 }
{ notp p7, p0         | nop                 | (p6)seqiu ac7, p13, p0, d0, 0| (p6)lbu d5, a4, a5| (p6)add ac1, ac1, d0 }
{ bdt r2              |(p10)moviu d12, 1    | (p13)sgti ac7, p7, p0, d9, 0| bdr a7      | (p6)fmuluu d13, d13, ac1 }
{ bdr sp3             | bdt sp              | (p13)slti ac7, p8, p0, d9, 0|(p13)slli d7, d7, 1 | (p4)clr ac3       }
{ nop                 |(p10)sb d12, a1, Error_flag | copy d8, ac3 | add a7, a7, d13      | (p6)fmuluu ac2, d5, d3 }
;(p4)

;;*****************Break_Point!!!!!!!!!
;{ nop 			      | nop 				        | nop 				       | nop 				          | seqiu ac7,p11,p0,ac1,0x3}
;{ seqiu r11,p14,p0,r0,1350| nop 	              | nop 				       | nop 				          | seqiu ac7,p15,p0,ac4,0}
;{ andp p14,p14,p11 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p15,p14 		|(p14)moviu a7,0xb00a9000 | nop 				       | nop 				          |(p14)copy d0,ac6      }
;{(p15)b _end3 	      |(p14)moviu d0,0x3456 | nop 				       | nop		                | nop				      }
;{ nop                |(p14)bdr d5              | nop 				       |(p14)bdt d3		          | nop				      }
;{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p14)sw d5,a7,0         | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    |(p14)sw a0,a7,4           | notp p15,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end3:
;;********************************************

{ b _VLD_found        | bdt d8              | sgtiu ac7, p1, p0, d5, 0| bdr d12         | fmuluu d5, ac2, d7 }
{ clr r13             | nop                 | nop                 | lw a5, a7, 0        | (p7)add d5, d5, ac2 }
{ moviu r12, 1        | nop                 | nop                 | copy a3, d12        | (p8)sub d5, d5, ac2 }
{ nop                 | nop                 | nop                 | sra d1, d5, a3      | sgtiu ac7, p2, p0, ac1, 64 }
{ (p2)sb r12, r14, Error_flag| nop          | nop                 | (p1)neg d1, d1      | (p2)clr ac3         }
{ (p2)copy r13, r12   | nop                 | nop                 | sh d1, a5, 0        | addi ac1, ac1, 1    }
;
_IS_IQ:
;//*********IS_IQ
;	int sum;
;	int Quantize_temp;
;	unsigned char IQ_value,intra_dc_mult;
;	unsigned char *Weight_matrix;
;	short QF_temp;
;//***************

;**********************8
;*if(shead->Error_flag)
; % p15
;*		return;
;//*******Inverse Scan (IZ)**************
;	//Table 7-6Q
;;*if(pdata->q_scale_type==0)
;  % p3
;;*		IQ_value=sdata->MB_quantiser_scale_code<<1;
;;*	else
;  % p4
;;*		IQ_value=itable->Quantiser_scale[sdata->MB_quantiser_scale_code];
;;*	if(pdata->intra_dc_precision==0)      intra_dc_mult=3;
; *  % p1
;;*	else if(pdata->intra_dc_precision==1) intra_dc_mult=2;
; *  % p5
;;*	else if(pdata->intra_dc_precision==2) intra_dc_mult=1;
; *  % p7
;;*	else
;;*      intra_dc_mult=0;

;;	for(m=0;m<64;m++){
;;	   QFS_temp=*(itable->IS_address[m]);
;;*	if(m==0 && (sdata->MB_type & macroblock_intra))
;   % p9=p10 && p13
;;*	QFS_temp<<=intra_dc_mult;
;;		else{
;   % p11
;;			if(QFS_temp!=0){
;;       % p12= p12 && p11
;;*		   QF_temp=sdata->Quantize_matrix[m]*IQ_value;
;;*			Quantize_temp=QFS_temp*QF_temp;
;;*			if(sdata->MB_type & macroblock_intra){
;           % p13
;;*			right_shift=4;
;;*			}
;;				else{
;           % p6=p12 && p6
;;*				Quantize_temp<<=1;
;;*					if(QFS_temp>0)
;              % p8
;;*						Quantize_temp+=QF_temp;
;;*					else
;              % p10
;;*						Quantize_temp-=QF_temp;
;;*					right_shift=5;
;;				}
;;				if(Quantize_temp<0)
;           % p11
;;					Quantize_temp=-((abs)(Quantize_temp)>>right_shift);
;;				else
;           % p14
;;					Quantize_temp>>=right_shift;
;;				QFS_temp=(short)(Quantize_temp);
;;			}
;        % p5
;;		}
;;		sdata->QF[m]=QFS_temp;
;;	}
;***********************

;scalar: r13<<Error_flag

;cluster1: a3<< address of sdata->QF[m],a6 << address of sdata->QFS[m],a5 << address of itable->IS_address,d3<<QFS_temp
;          d2 << intra_dc_mult,ac2 << m, ,d11 << q_scale_type, d12<< intra_dc_precision,a7<< address of sdata->QFS[pdata->IZ_matrix[m]]
;
;cluster2: a5 << address of sdata->Quantize_matrix[m],a3<< address of sdata->QF[m]
;          , a6<< address of itable->Quantiser_scale, a7 << MB_quantiser_scale_code
;          ,d1 << Quantize_temp,d2 << IQ_value, d4<< sdata->Quantize_matrix[m], d8<< QF[m],
;           , ac1 << right_shift,  ac3 << QF_temp=sdata->Quantize_matrix[m]*IQ_value, ac4<< i (not change!!)
;{ seqiu r12,p0,p15,r13,0 | notp p12,p0         | nop                  |(p4)lbu d4,a5,1+          |(p13)moviu ac1,4	   }
;{ (p15)b _block_to_MB| notp p8,p0			     | clr ac2              |(p6)moviu d11,5 		    |(p6)moviu ac1,5		   }
;_IS_IQ_loop:
;{ notp p10,p0        | bdt d3			           | seqiu ac7,p11,p0,ac2,0| bdr d9		             | notp p15,p0		      }
;{ notp p1,p0         | addi a5,a5,4			     | andp p9,p13,p11      |(p13)moviu d11,4 		    |fmuluu ac3,d2,d4		}

;{(p9)b _IS_IQ_loop   | lw a7,a5,0  			     | addi ac2,ac2,1       | notp p11,p9              |fmul d1,d9,ac3 	     	}
;{ notp p5,p0         |(p9)sll d9,d3,d2		     |(p11)sltiu ac7,p1,p15,ac2,64|(p6)slli d1,d1,1    |(p6)sgti ac7,p8,p10,d9,0}
;{ nop                |(p9)sh d9,a3,2+  		  |(p11)seqi ac7,p5,p12,d3,0|(p9)addi a7,a7,2  	    |(p8)add d1,d1,ac3	   }
;;;(p15)
;{(p1)b _IS_IQ_loop   | lh d3,a7,0		        | notp p11,p0          |(p15)add a3,a4,d14        |(p10)sub d1,d1,ac3	   }
;{ clr r10            | notp p10,p0 	           |(p15)movi ac2,0xf800f800  | lbu d4,a5,1+		    |(p12)slti ac7,p11,p14,d1,0}
;{ notp p8,p0         |(p15)lbu d9,a1,constrained_parameter_flag | notp p12,p0 |(p5)sh d12,a7,2+  |(p11)abs d9,d1 	      }
;;;(p9)
;{ notp p1,p0         |(p15)addi a3,a4,QF       | (p15)moviu ac3,0x07ff07ff |(p11)sra d5,d9,d11   |(p14)sra d10,d1,ac1   }
;{ clr r10            |(p15)lh  d10,a7,0        | clr ac5              |(p14)sh d10,a7,2+         |(p11)sub d5,d7,d5     }
;{ notp p9,p0         | nop                     | (p15)seqiu ac7,p1,p2,d9,0 |(p11)sh d5,a7,2+     | notp p14,p0	         }
;;;(p1)
;{(p1)set_lbci r10,4  | addi a7,a3,8 			  | clr d11 				 | addi a7,a3,8 				 | dclr d8              }


;;*if(!shead->constrained_parameter_flag){  //only for Mpeg2
;    % p1
;	//*********Saturation
;;		for(m=0;m<64;m++){
;;			if(sdata->QF[m]>2047)
;;				sdata->QF[m]=2047;
;;			else if(sdata->QF[m]<-2048)
;;				sdata->QF[m]=-2048;
;;			sum+=sdata->QF[m];
;;		}
;	//***********mismatch control
;;		if((sum&1)==0)
; % p3=p3 && p1
;;			sdata->QF[63]^= 1;
;;	}
;;*else{
;    % p2
;;*		  for(m=0;m<64;m++){  //Mpeg1
;;*			    if(m>0 && (sdata->QF[m]&1)==0){
;               %  p4=p3 && p4  (p5=p3 && p5)
;;                if(sdata->QF[m]>0)
;               %p7(p8)
;					    sdata->QF[m]--;
;				     if(sdata->QF[m]<0)
;               %p9(p10)
;					   sdata->QF[m]++;
;;			      }
;;         }
;;	      for(m=0;m<64;m++){
;;			    if(sdata->QF[m]>2047);
;;				      sdata->QF[m]=2047;
;;			    else if(sdata->QF[m]<-2048)
;;				      sdata->QF[m]=-2048;
;;		    }
;;	  }

;_saturation_Dframe_DC:
;{ nop 			      | lbu d0,a4,MB_type         | nop 	                | nop 				          | nop				   }
;{ nop 			      | lbu d1,a2,intra_dc_mult   | nop 	                | nop 				          | nop				   }
;{ nop 			      | lh d2,a4,QFS 	          | nop                  | nop 				          | nop				   }
;{ nop 			      | nop 				      | andi ac7,d0,macroblock_intra| nop 			       | nop				   }
;{ nop                 | nop 				      | sgtiu ac4,p3,p0,ac7,0| nop 			             | nop				   }
;{ orp p1,p1,p0	      | nop 				      |(p3)sll d2,d2,d1      | nop 				          | nop				   }
;{ notp p2,p0          |(p3)sh d2,a4,QF	          | nop                  | nop 				          | nop				   }

_saturation_Mpeg2:

;;*****************Break_Point!!!!!!!!!
;{ seqiu r11,p14,p0,r0,1350| nop 	              | nop 				       | nop 				          | seqiu ac7,p15,p0,ac4,0}
;{ andp p14,p14,p11 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p15,p14 		|(p14)moviu a6,0xb00a9000 | nop 				       | nop 				          |(p14)copy d0,ac6      }
;{(p15)b _end2 	      |(p14)moviu d0,0x33445566 | nop 				       | nop		                | nop				      }
;{ nop                |(p14)bdr d5              | nop 				       |(p14)bdt d0		          | nop				      }
;{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p14)sw d5,a6,0         | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    |(p3)sw d0,a6,4           | notp p15,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end2:
;;********************************************

;cluster1: d6,ac2<<0xf800f800,d7,ac3<<07ff07ff,ac5 << sum, a3 << address of QF[m],a7 << address of QF[m+4]
;cluster2: ac4<< i (not change!!),d6,d15<<0xf800f800,d7,ac3<<07ff07ff, a3 << address of QF[m+8],a7 << address of QF[m+12],ac5<<sum

;{ b _saturation_end  | nop  				        | nop                  |nop				             |nop      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;

{ (p2)b _saturation_Mpeg1| (p1)dlw d4, a3, 0| (p1)add ac5, ac5, d11| (p1)mergea d3, d6  | movi d15, 0xf800f800 }
{ (p2)clr r10         | (p1)dlw d8, a7, 0   | copy d6, ac2        | (p1)add.d d10, d8, d9| moviu ac3, 0x07ff07ff }
{ (p2)set_lbci r11, 32| nop                 | copy d7, ac3        | (p1)dlw d4, a3, 0   | (p1)mergea d11, d10 }
{ notp p4, p0         | (p1)max.d d4, d6, d4| (p2)clr ac4         | (p1)dlw d8, a7, 0   | copy d7, ac3        }
{ notp p5, p0         | (p1)min.d d4, d4, d7| (p1)max.d d8, ac2, d8| copy d6, d15       | (p1)add ac5, ac5, d3 }
{ lbcb r10, _saturation_Mpeg2| (p1)max.d d5, d6, d5| (p1)min.d d8, d8, ac3| (p1)max.d d4, d6, d4| (p1)add ac5, ac5, d11 }
;(p2)
{ nop                 | (p1)min.d d5, d5, d7| (p1)max.d d9, ac2, d9| (p1)min.d d4, d4, d7| (p1)max.d d8, d15, d8 }
{ nop                 | (p1)dsw d4, d5, a3, 32+| (p1)min.d d9, d9, ac3| (p1)max.d d5, d6, d5| (p1)min.d d8, d8, ac3 }
{ nop                 | (p1)dsw d8, d9, a7, 32+| (p1)add.d d6, d4, d5| (p1)min.d d5, d5, d7| (p1)max.d d9, d15, d9 }
{ nop                 | (p1)mergea d3, d6   | (p1)add.d d10, d8, d9| (p1)dsw d4, d5, a3, 32+| (p1)min.d d9, d9, ac3 }
{ nop                 | (p1)mergea d11, d10 | (p1)add ac5, ac5, d3| (p1)dsw d8, d9, a7, 32+| (p1)add.d d6, d4, d5 }
;
{ (p1)b _saturation_end| (p1)addi a3, a4, QF| (p1)add d5, ac5, d11| (p1)mergea d3, d6   | (p1)add.d d10, d8, d9 }
{ nop                 | (p1) lh d2, a3, 126 | nop                 | (p1)mergea d11, d10 | (p1)add ac5, ac5, d3 }
{ nop                 | (p1)bdt d5          | nop                 | (p1)bdr d5          | (p1)add ac5, ac5, d11 }
{ nop                 | nop                 | nop                 | (p1)moviu d0, 1     | nop                 }
{ nop                 | (p1)xori d2, d2, 1  | nop                 | nop                 | (p1)add ac5, ac5, d5 }
{ nop                 | nop                 | nop                 | nop                 | (p1)andi ac5, ac5, 1 }
;(p1)

;;*else{
;    % p2
;		  if(sdata->MB_type & macroblock_intra)
;			m=1;
;		  else
;			m=0;
;;*		  for(;m<64;m++){  //Mpeg1
;;*			  if((sdata->QF[m]&1)==0){
;             %  p4=p3 && p4  (p5=p3 && p5)
;;                if(sdata->QF[m]>0)
;                 %p7(p8)
;					      sdata->QF[m]--;
;				      if(sdata->QF[m]<0)
;                 %p9(p10)
;					      sdata->QF[m]++;
;;			    }
;;         }
;;	      for(m=0;m<64;m++){
;;			    if(sdata->QF[m]>2047);
;;				      sdata->QF[m]=2047;
;;			    else if(sdata->QF[m]<-2048)
;;				      sdata->QF[m]=-2048;
;;		    }
;;	  }
_saturation_Mpeg1:
{ nop                 | addi a3, a4, QF     | nop                 | addi a3, a4, QF     | copy ac2, d15       }
{ nop                 | (p13)addi a3, a3, 2 | nop                 | (p13)addi a3, a3, 2 | nop                 }
_Mpeg1_loop1:
{ notp p4, p0         | lh d5, a3, 0        | sgtiu ac7, p3, p0, ac4, 0| addi a3, a3, 2 | nop                 }
{ set_lbci r10, 4     | notp p7, p0         | addi ac4, ac4, 2    | lh d5, a3, 0        | nop                 }
{ sltiu r12, p12, p0, r11, 2| notp p9, p0   | nop                 | nop                 | nop                 }
{ notp p5, p0         | notp p10, p0        | andi ac6, d5, 1     | nop                 | notp p11, p0        }
{ lbcb r11, _Mpeg1_loop1| copy d15, d5      | seqi ac7, p4, p0, ac6, 0| (p12)addi a5, a4, QF| andi ac6, d5, 1 }
{ notp p8, p0         | (p12)addi a5, a4, QF| (p4)sgti ac7, p7, p0, d5, 0| copy d15, d5 | seqi ac7, p5, p1, ac6, 0 }
{ nop                 | (p7)addi d5, d5, (-1)| (p4)slti ac7, p9, p0, d15, 0| (p12)addi a5, a5, 16| (p5)sgti ac7, p8, p1, d5, 0 }
{ nop                 | (p7)sh d5, a3, 0    | (p9)addi d15, d15, 1| (p8)addi d5, d5, (-1)| (p5)slti ac7, p10, p0, d15, 0 }
{ nop                 | (p9)sh d15, a3, 0   | nop                 | (p10)addi d5, d5, 1 | orp p11, p8, p10    }
{ nop                 | addi a3, a3, 4      | nop                 | sh d5, a3, 2+       | nop                 }
;
_Mpeg1_loop2:
{ nop                 | dlw d4, a5, 0       | nop                 | nop                 | nop                 }
{ nop                 | dlw d8, a7, 0       | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | dlw d4, a5, 0       | nop                 }
{ nop                 | max.d d4, d6, d4    | nop                 | dlw d8, a7, 0       | nop                 }
{ nop                 | min.d d4, d4, d7    | max.d d8, ac2, d8   | nop                 | nop                 }
{ lbcb r10, _Mpeg1_loop2| max.d d5, d6, d5  | min.d d8, d8, ac3   | max.d d4, d6, d4    | nop                 }
{ nop                 | min.d d5, d5, d7    | max.d d9, ac2, d9   | min.d d4, d4, d7    | max.d d8, ac2, d8   }
{ nop                 | dsw d4, d5, a5, 32+ | min.d d9, d9, ac3   | max.d d5, d6, d5    | min.d d8, d8, ac3   }
{ nop                 | dsw d8, d9, a7, 32+ | nop                 | min.d d5, d5, d7    | max.d d9, ac2, d9   }
{ nop                 | nop                 | nop                 | dsw d4, d5, a5, 32+ | min.d d9, d9, ac3   }
{ nop                 | nop                 | nop                 | dsw d8, d9, a7, 32+ | notp p1, p0         }
;
{ nop                 | addi a3, a4, QF     | nop                 | nop                 | nop                 }
{ nop                 | lh d2, a3, 126      | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
_saturation_end:


;*if(EOB==1 && sdata->QF[63]==0){
;%p9=p15 && p3
;*		sdata->IDCT_Mode=1;
;	}
;if(EOB==1 && sdata->QF[63]!=0){
; %p13=p15 && p4
;		Only_AC_Count++;
;		Only_AC_Count_flag=1;
;		sdata->IDCT_Mode=2;
;	}
;	if(EOB==2 && sdata->QF[63]==0){
;%p11=p2 && p3
;		Only_AC_Count++;
;		Only_AC_Count_flag=1;
;		sdata->IDCT_Mode=3;
;	}
;	if((EOB==2 && sdata->QF[63]!=0) || EOB==3){
;%p15=(p2 && p4) || p5
;		Only_AC2_Count++;
;		Only_AC2_Count_flag=1;
;		sdata->IDCT_Mode=4;
;	}
;	if(EOB>3 && EOB<=10 && sdata->QF[63]==0){
; %p12=p10 && p6 && p3
;		Only_AC2_Count++;
;		Only_AC2_Count_flag=1;
;		sdata->IDCT_Mode=5;
;	}
;	if(EOB>3 && ((EOB<=10 && sdata->QF[63]!=0) || EOB==11)){
; %p5=p10 && ((p6 && p4) || p7)
;		Only_5x5_Count++;
;		Only_5x5_Count_flag=1;
;		sdata->IDCT_Mode=6;
;	}
;	if(EOB==12 && sdata->QF[63]==0){
; %p4=p8 && p3
;		Only_5x5_Count++;
;		Only_5x5_Count_flag=1;
;		sdata->IDCT_Mode=7;
;	}
;if(sdata->IDCT_Mode==1){
;		sdata->block_in[0]=sdata->QF[0]*itable->scale[0];
;		sdata->block_in[0]+= 1<<12;
;		for(m=0;m<64;m++)
;			sdata->QF[m]=sdata->block_in[0]>>13;
;	}
;	else
;		idct_23002_2 (sdata->QF,itable,sdata);

;cluster2: ac1>>EOB
;cluster1: d2>>QF[63]

;p15>>EOB==1
;p2>>EOB=2
;p3>>sdata->QF[63]==0
;p4>>sdata->QF[63]!=0
;p5>>EOB=3
;p6>>EOB<=10
;p7>>EOB=11
;p8>>EOB=12
;p10>>EOB>3

;p9>>p15 && p3 >>Mode=1
;p13>>p15 && p4 >>Mode=2
;p11>>p2 && p3 >>Mode=3
;p15>>(p2 && p4) || p5 >>Mode4
;p12>>p10 && p3 && p6 >>Mode5
;p5>>p10 && ((p6 && p4) || p7) >>Mode6
;p4>> p8 && p3 >>Mode7

;p2=Mode2 || Mode3=p13 || p11
;p3=Mode4 || Mode5=p15 || p12
;p6=Mode6 || Mode7=p5 || p4
;p8=Mode3 || Mode4 ||Mode5 || Mode6 || Mode7=p11 || p3 || p6
;p1=Mode4 || Mode5 || Mode6 || Mode7
;p7=Mode5 || Mode6 || Mode7
;p10=Mode2 || Mode3 || Mode4 ||Mode5 || Mode6 || Mode7=p13 || p8

{ moviu r10, 4        | lw a6, sp, 20       | seqiu ac7, p3, p4, d2, 0| clr d8          | seqiu ac7, p15, p0, ac1, 1 }
{ andp p9, p15, p3    | addi a3, a4, QF     | andp p13, p15, p4   | addi a3, a4, QF+64  | seqiu ac7, p2, p0, ac1, 2 }
{ andp p11, p2, p3    | (p9)moviu d12, 1    | andp p12, p2, p4    | lw a6, sp2, 20      | seqiu ac7, p5, p0, ac1, 3 }
{ notp p14, p0        | addi a5, a4, block_in| (p9)slli d12, d12, 12| addi a5, a4, block_in+128| sgtiu ac7, p10, p0, ac1, 3 }
{ orp p15, p12, p5    | addi a7, a6, scale  | notp p2, p9         | (p13)addi a3, a4, QF+112| sgtiu ac7, p0, p6, ac1, 10 }
{ andp p12, p3, p6    | (p9)lh d13, a4, QF  | andp p5, p4, p6     | addi a7, a6, scale+64| seqiu ac7, p7, p0, ac1, 11 }
{ (p9)b r5, _idct_only_dc| (p9)lhu d14, a6, scale| andp p12, p12, p10| (p13)addi a7, a6, scale+112| seqiu ac7, p8, p0, ac1, 12 }
{ bdr r12             | bdt a1              | orp p5, p5, p7      | (p13)addi a5, a4, block_in+224| andp p4, p8, p3 }
{ bdr r9              | bdt a2              | andp p5, p5, p10    | addi a0, a4, block_in+224| (p1)seqiu ac7, p14, p0, ac5, 0 }
{ orp p2, p13, p11    | orp p3, p15, p12    | (p9)fmul d15, d14, d13| (p9)moviu d12, 1  | orp p6, p5, p4      }
{ (p3)moviu r10, 2    | (p14)sb d2, a3, 126 | orp p7, p12, p6     | (p9)slli d12, d12, 12| orp p1, p3, p6     }
{ (p2)moviu r10, 1    | (p9)bdt d15         | nop                 | (p9)bdr d15         | orp p8, p1, p11     }
;(p9)
{ (p6)moviu r10, 3    | addi a0, a4, block_in+192| dclr d10       | (p8)addi a3, a4, QF+16| orp p10, p13, p8  }
{ (p4)b r5, idct_23002_2| dsw d10, d11, a0, 8+| notp p14, p10     | (p8)addi a7, a6, scale+16| dclr d10       }
{ (p14)b r5, idct_23002_2| dsw d10, d11, a0, 8+| notp p9, p0      | (p8)addi a5, a4, block_in+32| nop         }
{ nop                 | (p10)dsw d10, d11, a0, 8+| notp p2, p0    | (p10)dsw d10, d11, a0, 8+| nop            }
{ nop                 | (p10)dsw d10, d11, a0, (-88)+| nop        | (p10)dsw d10, d11, a0, 8+| orp p2, p5, p12 }
{ (p2)b r5, idct_23002_2| (p10)dsw d10, d11, a0, 8+| nop          | (p10)dsw d10, d11, a0, 8+| nop            }
{ andp p8, p14, p0    | (p10)dsw d10, d11, a0, 8+| nop            | (p10)dsw d10, d11, a0, (-88)+| nop        }
;(p4)
{ (p4)b _idct_end     | (p10)dsw d10, d11, a0, 8+| nop            | (p10)dsw d10, d11, a0, 8+| nop            }
;(p14)
{ (p8)b _idct_end     | (p10)dsw d10, d11, a0, (-88)+| nop        | (p10)dsw d10, d11, a0, 8+| orp p9, p15, p11 }
{ (p9)b r5, idct_23002_2| (p10)dsw d10, d11, a0, 8+| nop          | (p10)dsw d10, d11, a0, 8+| nop            }
{ nop                 | (p10)dsw d10, d11, a0, 8+| nop            | (p10)dsw d10, d11, a0, (-88)+| nop        }
;(p2)
{ nop                 | (p10)dsw d10, d11, a0, 8+| nop            | (p10)dsw d10, d11, a0, 8+| nop            }
{ nop                 | (p10)dsw d10, d11, a0, (-88)+| nop        | (p10)dsw d10, d11, a0, 8+| nop            }
{ (p13)b r5, idct_23002_2| nop              | nop                 | (p10)dsw d10, d11, a0, 8+| nop            }
{ nop                 | nop                 | nop                 | (p10)dsw d10, d11, a0, (-88)+| nop        }
;(p9)
{ nop                 | nop                 | nop                 | (p10)dsw d10, d11, a0, 8+| nop            }
{ nop                 | nop                 | nop                 | (p10)dsw d10, d11, a0, 8+| nop            }
{ nop                 | nop                 | nop                 | (p10)dsw d10, d11, a0, 8+| nop            }
{ nop                 | nop                 | nop                 | (p10)dsw d10, d11, a0, 8+| nop            }
;(p13)

;;*****************Break_Point!!!!!!!!!
;{ nop 			      | copy a5,[cp0] 				| nop                  | nop                      | nop				     }
;{ bdr r7		      | bdt a5 				        | nop 				   | nop 				      | nop				   }
;{ nop  			      | nop 				        | nop 				   | nop 				      | nop				   }
;{ br r7			      | nop                         | moviu d0,0x1e000418  | nop                      | nop				     }
;{ nop 			      | moviu a5,GLOBAL_POINTER_ADDR| moviu d1,0x1e0004e0  | nop                      | nop				     }
;{ nop 			      | dsw d0,d1,a5,Print_Start_ADDR | nop                | nop                      | nop				     }
;{ nop 			      | nop      				    | nop                  | nop                      | nop				     }
;{ nop 			      | nop  	         	        | nop                  | nop                      | nop				     }
;{ nop  			      | nop 				        | nop 				   | nop 				      | nop				   }
;;********************************************

;{ b r5,idct_23002_2  | nop 				         | notp p3,p0 			   | nop 				         | nop                  }
;{ bdr r12 			 | bdt a1 				     | nop 				       | moviu d1,QF+64 		     |(p1)seqiu ac7,p3,p0,ac5,0}
;{ bdr r9 			 | bdt a2 				     | nop 				       | lw a6,sp2,20 				 | nop		            }
;{ nop                | lw a6,sp,20 			     | nop 				       | moviu d2,block_in+128       | nop				      }
;{ nop			     |(p3)sb d2,a3,126 		     | nop 				       | moviu d8,scale+64 		     | nop				      }
;{ nop                | nop 				         | nop 				       | nop 				         | nop				      }
;

;;*****************Break_Point!!!!!!!!!
;{ nop 			      | nop 				        | nop  | nop 				          | orp p11,p11,p0               }
;{ seqiu r11,p14,p0,r0,1| nop 	              | nop 				       | nop 				          | seqiu ac7,p15,p0,ac4,0}
;{ andp p14,p14,p11 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p15,p14 		|(p14)moviu a7,0xb00a9000 | nop 				       | nop 				          |(p14)copy d0,ac3      }
;{(p15)b _end1 	      |(p14)moviu d0,0x33445566 | nop 				       | nop		                | nop				      }
;{ nop                |(p14)bdr d5              | nop 				       |(p14)bdt d0		          | nop				      }
;{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p14)sw d5,a7,0         | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    |(p14)sw d0,a7,4           | notp p15,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end1:
;;********************************************

;;*****************Break_Point!!!!!!!!!
;{ nop 	        | nop 				      | nop 				| nop 				  | nop				   }
;{ trap 	        | nop 				      | nop 				| nop 				  | nop				   }
;;********************************************
_idct_end:
{ b _block_to_MB      | notp p3, p0         | nop                 | notp p4, p0         | nop                 }
{ bdt r12             | bdr a1              | notp p5, p0         | bdr a1              | nop                 }
{ bdt r6              | bdr a6              | notp p6, p0         | bdr a6              | nop                 }
{ lbu r13, r14, Error_flag| nop             | notp p7, p0         | nop                 | nop                 }
{ bdt r9              | bdr a2              | notp p9, p0         | bdr a2              | nop                 }
{ bdt r8              | bdr a0              | clr d5              | bdr a0              | nop                 }
;

;;if(sdata->IDCT_Mode==1){
;;		sdata->block_in[0]=sdata->QF[0]*itable->scale[0];
;;		sdata->block_in[0]+= 1<<12;
;;		for(m=0;m<64;m++)
;;			sdata->QF[m]=sdata->block_in[0]>>13;
;;	}
;c1:a3>>address of QF[0],d15<<block_in[0],d12<<(1<<12)
;c2:a3>>address of QF[32],d15<<block_in[0],d12<<(1<<12)
_idct_only_dc:
{ nop                 | add d15, d15, d12   | nop                 | add d15, d15, d12   | nop                 }
{ nop                 | nop                 | srli d15, d15, 13   | nop                 | srli d15, d15, 13   }
{ nop                 | nop                 | permh4 d12, d15, d15, 0, 0, 0, 0| nop     | permh4 d12, d15, d15, 0, 0, 0, 0 }
{ nop                 | dsw d12, d13, a3, 8+| nop                 | dsw d12, d13, a3, 8+| nop                 }
{ nop                 | dsw d12, d13, a3, 8+| nop                 | dsw d12, d13, a3, 8+| nop                 }
{ b _idct_end         | dsw d12, d13, a3, 8+| nop                 | dsw d12, d13, a3, 8+| nop                 }
{ nop                 | dsw d12, d13, a3, 8+| nop                 | dsw d12, d13, a3, 8+| nop                 }
{ nop                 | dsw d12, d13, a3, 8+| nop                 | dsw d12, d13, a3, 8+| nop                 }
{ nop                 | dsw d12, d13, a3, 8+| nop                 | dsw d12, d13, a3, 8+| nop                 }
{ nop                 | dsw d12, d13, a3, 8+| nop                 | dsw d12, d13, a3, 8+| nop                 }
{ nop                 | dsw d12, d13, a3, 8+| nop                 | dsw d12, d13, a3, 8+| nop                 }
;



_dct_coeff_0:
;;void Search_Dct_coeff_0(Bitstream *pbs,unsigned char first,Seq_header *shead,Slice_data *sdata){
;	//*****Table B-14
;;	unsigned short cache;
;;	unsigned char bit_offset;
;;	unsigned char BitLeft;
;;	unsigned char sign;

;;*cache=(unsigned short)(readbits(pbs,16,shead)); //16bits
;;*BitLeft=pbs->BitLeftInCache;
;;*if(cache & 0x8000){  //1000 0000 0000 0000
;  % p11
;;		if(first){    //  this code shall be only used for the first coefficient
;        % p2
;;			sdata->Ent.run=0;
;;			sdata->Ent.level=1;
;;			pbs->BitLeftInCache=BitLeft+(16-1);
;;			sign=(unsigned char)(readbits(pbs,1,shead));
;;		}
;;		else{        //this code shall be used for all other coefficients
;        % p3
;;       pbs->BitLeftInCache=BitLeft+(16-2);
;;			if(cache & 0x4000){  // 11s >> (run,level)=(0,1)   1100 0000 0000 0000
;        % p4
;;				sdata->Ent.run=0;
;;				sdata->Ent.level=1;
;;				sign=(unsigned char)(readbits(pbs,1,shead));
;;			}
;;			else{             //10 >> end of block
;        % p5
;;				End_of_block=1;
;;			}
;;		}
;;	}
;  % p12
;;	else if((cache>>10)==1){  //0000 01xx >> Escape_code
;  % p13
;;		sign=0;
;;		pbs->BitLeftInCache=BitLeft+(16-6);
;;		sdata->Ent.run=(unsigned char)(readbits(pbs,6,shead));  //6 bits
;;		if(!shead->constrained_parameter_flag){  //Mpeg2
;     % p2
;;			sdata->Ent.level=(short)(readbits(pbs,12,shead));  //12bits
;;			if(sdata->Ent.level & 0x0800){  //1000 0000 0000 >>negative
;;				sdata->Ent.level=(0x1000)-sdata->Ent.level;  //2's complement of level
;;				sign=1; //negative
;;			}
;;		}
;;		else{    //Mpeg1
;     % p3
;;			sdata->Ent.level=(short)(readbits(pbs,8,shead));
;;			if(sdata->Ent.level==0 || sdata->Ent.level==0x0080){ //0000 0000... or 1000 0000....>>16bits				                                           //+128~+255 or -128~-255
;;				if(sdata->Ent.level==0) //positive
;;					sdata->Ent.level=(short)(readbits(pbs,8,shead));
;;				else{                  //negative
;;					sign=1;
;;					sdata->Ent.level=(0x0100)-(short)(readbits(pbs,8,shead));    //2's complement of level
;;				}
;;			}
;;			else{                                 //8bits (+127~-127)
;;				if(sdata->Ent.level & 0x0080){  //1000 0000 0000 >>negative
;;					sdata->Ent.level=(0x0100)-sdata->Ent.level;  //2's complement of level
;;					sign=1; //negative
;;				}
;;			}
;;		}
;;	}
;;	else{
;  % p12
;;		bit_offset=Table_Search(cache,16,&(coef_token_table[8]),shead);
;;	   if(shead->Error_flag)
;			printf("Error for TableB-14_Entropy!!\n");
;;		else{
;;			sdata->Ent.run=(unsigned char)pair->value.val;
;;			sdata->Ent.level=(short)pair->value.level;
;;			pbs->BitLeftInCache=BitLeft+(16-bit_offset);
;;			sign=(unsigned char)(readbits(pbs,1,shead));
;;		}
;;	}
;;return sign;
;;}

;scalar: r13<< Error_flag
;cluster1: d5<< cache, d14<< cachesz, a2<<*entry, d8<< 1, d14<< clumpsz,a7 << first(not change!!),a5 << sign
;cluster2: a3<< bitleft, a2<<*entry, ac2<< count,ac6 << end_of_block(not change)
;ac3<< eob_not_read, ac1 << n, ac5 << table_flag,d11 << return address!!!!,d6<<2 (not change!!),ac4<<i(not change!!)
;p6=p2 or p4
;p14=p6 or p13
;p15=p2 or p4
{ b r1, _readbits     | nop                 | moviu d0, 16        | nop                 | clr ac2             }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;
{ notp p2, p0         | notp p3, p0         | andi d8, d5, 0x8000 | lbu a3, a6, BitLeftInCache| notp p5, p0   }
{ notp p13, p0        | srli d4, d5, 10     | sgtiu ac7, p11, p12, d8, 0| notp p4, p0   | moviu d0, 0         }
{ (p9)sb r13, r14, Error_flag| moviu d8, 1  | (p12)seqiu ac7, p13, p12, d4, 1| notp p5, p0| moviu d8, 1       }
{ nop                 | (p11)sgtiu d15, p2, p3, a7, 0| (p11)andi ac4, d5, 0x4000| addi a3, a3, 16| (p12)clr ac2 }
{ clr r13             | (p12)copy a5, a2    | (p3)sgtiu ac7, p4, p5, ac4, 0| (p12)copy a5, a2| (p2)moviu d15, 1 }
{ (p5)br r5           | (p12)lw a2, sp, 24  | (p12)moviu d13, 16  | orp p15, p4, p2     | (p3)moviu d15, 2    }
{ (p12)b r1, _table_search| (p12)clr d15    | (p11)moviu d0, 1    | (p12)lw a2, sp2, 24 | orp p14, p15, p13   }
{ (p14)b r1, _readbits| clr a7              | (p13)moviu d0, 6    | (p15)sb d0, a4, Ent_run| (p13)moviu d15, 6 }
{ orp p6, p11, p13    | (p12)addi a2, a2, B14_startbit| nop       | (p15)sh d8, a4, Ent_level| (p5)moviu ac6, 1 }
{ nop                 | (p12)lbu d14, a2, 0 | orp p10, p14, p3    | (p6)sub a3, a3, d15 | nop                 }
{ nop                 | nop                 | nop                 | (p10)sb a3, a6, BitLeftInCache| (p14)clr ac2 }
;;(p5)
{ nop                 | nop                 | nop                 | (p12)addi a2, a2, B14_startbit| nop       }
;;(p12)
{ (p12)sb r13, r14, Error_flag| (p12)bdt d15| (p12)extractiu d4, d2, 6, 10| (p12)bdr d15| nop                 }
;;(p14)
{ (p12)seqiu r12, p12, p0, r13, 0| (p12)copy a2, a5| (p12)extractiu d10, d2, 6, 4| (p12)copy a2, a5| notp p1, p0 }
{ (p9)sb r13, r14, Error_flag| nop          | notp p3, p0         | (p13)lbu d2, a1, constrained_parameter_flag| orp p10, p12, p13 }
{ (p10)b r1, _readbits| (p13)sb d5, a4, Ent_run| notp p2, p0      | (p12)sub a3, a3, d15| (p10)clr ac2        }
{ nop                 | (p12)sh d4, a4, Ent_level| notp p14, p0   | nop                 | notp p15, p0        }
{ nop                 | (p13)clr a5         | nop                 | (p11)lh d10, a4, Ent_level| (p13)seqiu ac7, p14, p15, d2, 0 }
{ (p11)br r5          | nop                 | (p12)moviu d0, 1    | (p12)sb a3, a6, BitLeftInCache| nop       }
{ (p11)lbu r13, r14, Error_flag| (p12)sb d10, a4, Ent_run| (p14)moviu d0, 12| nop       | nop                 }
{ nop                 | nop                 | (p15)moviu d0, 8    | nop                 | nop                 }
;;(p10)
{ nop                 | notp p2, p0         | (p14)andi ac4, d5, 0x800| nop             | orp p10, p12, p13   }
{ (p9)sb r13, r14, Error_flag| notp p3, p0  | (p15)copy ac4, d5   | (p10)notp p1, p0    | nop                 }
{ notp p4, p0         | (p13)sh d5, a4, Ent_level| (p14)sgtiu ac7, p2, p0, ac4, 0| nop  | notp p7, p0         }
;;(p11)

;;*****************Break_Point!!!!!!!!!
;{ nop 			      | nop 				        | nop 				       | nop 				          | seqiu ac7,p10,p0,ac1,0x21}
;{ seqiu r11,p14,p0,r0,478| nop 	              | nop 				       | nop 				          | seqiu ac7,p15,p0,ac4,0}
;{ andp p14,p14,p10 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p15,p14 		|(p14)moviu a7,0xb00a9000 | nop 				       | nop 				          | nop				      }
;{(p15)b _end2 	      |(p14)bdr d2              | nop 				       |(p14)bdt d9               | nop				      }
;{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p14)moviu d0,0x55667788 | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p11)sw d0,a7,0         | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    |(p14)sw d2,a7,4	        | notp p15,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end2:
;;********************************************

{ (p12)br r5          | nop                 | (p15)seqiu ac7, p3, p0, ac4, 0x80| (p12)lh d10, a4, Ent_level| notp p6, p0 }
{ nop                 | (p2)moviu d4, 0x1000| (p15)seqiu ac7, p6, p7, d5, 0| nop        | notp p1, p0         }
{ (p12)lbu r13, r14, Error_flag| (p2)moviu a5, 1| nop             | orp p4, p3, p6      | nop                 }
{ (p2)br r5           | (p2)sub d5, d4, d5  | andp p4, p4, p15    | nop                 | notp p5, p4         }
{ (p4)b r1, _readbits | andp p5, p5, p15    | nop                 | nop                 | nop                 }
{ andp p6, p4, p6     | nop                 | nop                 | nop                 | notp p8, p0         }
;;(p12)
{ (p2)lbu r13, r14, Error_flag| nop         | (p5)andi ac4, ac4, 0x80| andp p7, p4, p7  | nop                 }
{ nop                 | (p2)sh d5, a4, Ent_level| (p5)sgtiu ac7, p8, p0, ac4, 0| nop    | nop                 }
{ orp p11, p7, p8     | (p2)copy d5, a5     | (p5)andi ac5, d5, 0x80| nop               | nop                 }
;;(p2)
{ nop                 | (p11)moviu a5, 1    | (p4)moviu d0, 8     | nop                 | (p4)clr ac2         }
;;(p4)
{ br r5               | nop                 | (p11)moviu d4, 0x100| nop                 | nop                 }
{ (p9)sb r13, r14, Error_flag| (p11)sub d5, d4, d5| nop           | nop                 | nop                 }
{ nop                 | sh d5, a4, Ent_level| nop                 | nop                 | nop                 }
{ lbu r13, r14, Error_flag| nop             | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | copy d5, a5         | nop                 | nop                 | nop                 }
;
_dct_coeff_1:
;;void Search_Dct_coeff_1(Bitstream *pbs,Seq_header *shead,Slice_data *sdata){
;;	  unsigned short cache;
;;	  unsigned char bit_offset;
;;	  unsigned char BitLeft;
;;	  unsigned char sign;

;;*  cache=(unsigned short)(readbits(pbs,16,shead)); //16bits
;;*  BitLeft=pbs->BitLeftInCache;
;;	  if((cache>>12)==6){ //0110 xxxx>>end of block
;  %p11
;;		    pbs->BitLeftInCache=BitLeft+(16-4);
;;		    End_of_block=1;
;;	  }
;;	  else if((cache>>10)==1){  //0000 01... >> Escape_code
;    %p12
;;		    sign=0;
;;		    pbs->BitLeftInCache=BitLeft+(16-6);
;;		    sdata->Ent.run=(unsigned char)(readbits(pbs,6,shead)); //6 bits
;;		    sdata->Ent.level=(short)(readbits(pbs,12,shead));  //12bits
;;		    if(sdata->Ent.level & 0x0800){  //1000 0000 0000 >>negative
;;			      sdata->Ent.level=(0x1000)-sdata->Ent.level;  //2's complement of level
;;			      sign=1;
;;		    }
;;	  }
;;	  else{
;    %p13
;;		    bit_offset=Table_Search(cache,16,&(coef_token_table[9]),shead);
;;		    if(shead->Error_flag)
;;			      printf("Error for TableB-15_Entropy!!\n");
;;		    else{
;;			      sdata->Ent.run=(unsigned char)pair->value.val;
;;			      sdata->Ent.level=(short)pair->value.level;
;;			      pbs->BitLeftInCache=BitLeft+(16-bit_offset);
;;			      sign=(unsigned char)(readbits(pbs,1,shead));
;;		    }
;;	  }
;;   return sign;
;;}

;scalar: r13<< Error_flag
;cluster1: d5<< cache, d14<< cachesz, a2<<*entry, d8<< 1, d14<< clumpsz,a7 << first(not change!!),a5 << sign
;cluster2: a3<< bitleft, a2<<*entry, ac2<< count,ac4 << end_of_block(not change)
;ac3<< eob_not_read, ac1 << n, ac5 << table_flag,d11 << return address!!!!,d6<<2 (not change!!),ac4<<i(not change!!)

;;*****************Break_Point!!!!!!!!!
;{ nop 			      | nop 				        | nop 				       | nop 				          | seqiu ac7,p11,p0,ac1,26}
;{ nop 	            | nop 				        | nop 				       | nop 				          |  seqiu ac7,p15,p0,ac4,2}
;{ seqiu r11,p14,p0,r0,44| nop 	              | nop 				       | nop 				          | nop                  }
;{ andp p14,p14,p11 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ andp p14,p14,p15 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p15,p14 		|(p14)moviu a7,0xb00a9000 | nop 				       | nop 				          |(p14)copy d0,ac6      }
;{(p15)b _end3 	      |(p14)moviu d0,0x33445566 | nop 				       | nop		                | nop				      }
;{ nop                |(p14)bdr d5              | nop 				       |(p14)bdt d0		          | nop				      }
;{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p14)sw d5,a7,0         | nop 				       | nop 				          | nop				      }
;{(p14) moviu r3,1    |(p14)sw d0,a7,4           | notp p15,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p14,p0 			 | nop 				          | nop				      }
;;
;{ nop 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end3:
;;********************************************


{ b r1, _readbits     | nop                 | moviu d0, 16        | nop                 | clr ac2             }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;
{ (p9)sb r13, r14, Error_flag| srli d8, d5, 12| notp p1, p0       | lbu a3, a6, BitLeftInCache| nop           }
{ nop                 | srli d4, d5, 10     | seqiu ac7, p11, p1, d8, 6| notp p15, p0   | nop                 }
{ (p11)lbu r13, r14, Error_flag| nop        | seqiu ac7, p2, p3, d4, 1| nop             | (p11)moviu ac6, 1   }
{ (p11)br r5          | nop                 | andp p13, p1, p3    | addi a3, a3, 16     | andp p12, p1, p2    }
{ (p12)b r1, _readbits| (p13)copy a5, a2    | orp p14, p11, p12   | (p13)copy a5, a2    | (p12)moviu d8, 6    }
{ nop                 | (p13)lw a2, sp, 24  | (p12)moviu d0, 6    | nop                 | (p11)moviu d8, 4    }
{ (p13)b r1, _table_search| (p11)clr d5     | (p13)moviu d13, 16  | (p13)lw a2, sp2, 24 | nop                 }
{ nop                 | nop                 | (p13)clr d15        | (p14)sub a3, a3, d8 | nop                 }
{ (p13)clr r13        | (p13)addi a2, a2, B15_startbit| nop       | (p14)sb a3, a6, BitLeftInCache| nop       }
;;(p11)
{ nop                 | (p13)lbu d14, a2, 0 | nop                 | nop                 | nop                 }
;;(p12)
{ nop                 | nop                 | (p13)moviu d8, 1    | (p13)addi a2, a2, B15_startbit| clr ac2   }
{ (p13)clr r10        | (p12)sb d5, a4, Ent_run| (p12)moviu d0, 12| nop                 | nop                 }
;;(p13)
{ (p13)seqiu r12, p15, p0, r13, 0| (p13)bdt d15| nop              | (p13)bdr d10        | nop                 }
{ (p13)sb r13, r14, Error_flag| orp p10, p12, p15| nop            | (p13)copy a2, a5    | nop                 }
{ (p10)b r1, _readbits| (p13)copy a2, a5    | (p15)moviu d0, 1    | (p15)sub a3, a3, d10| (p10)clr ac2        }
{ nop                 | nop                 | nop                 | (p15)sb a3, a6, BitLeftInCache| nop       }
{ (p9)sb r13, r14, Error_flag| nop          | (p15)extractiu d10, d2, 6, 4| nop         | nop                 }
{ nop                 | (p15)sb d10, a4, Ent_run| (p15)extractiu d3, d2, 6, 10| nop     | nop                 }
{ nop                 | (p15)sh d3, a4, Ent_level| nop            | nop                 | nop                 }
{ nop                 | nop                 | notp p14, p0        | notp p11, p0        | nop                 }
;;(p10)
{ br r5               | moviu d4, 0x1000    | (p12)andi d12, d5, 0x800| nop             | nop                 }
{ (p9)sb r13, r14, Error_flag| (p15)copy a5, d5| (p12)seqiu ac7, p11, p14, d12, 0| nop  | nop                 }
{ nop                 | (p11)clr a5         | (p11)copy d3, d5    | nop                 | nop                 }
{ lbu r13, r14, Error_flag| (p14)moviu a5, 1| (p14)sub d3, d4, d5 | nop                 | nop                 }
{ nop                 | sh d3, a4, Ent_level| moviu d1, 0         | nop                 | nop                 }
{ nop                 | copy d5, a5         | nop                 | nop                 | nop                 }
;
_MB_addressing:
;;unsigned char Macroblock_addressing(Bitstream *pbs,Seq_header *shead){
;;	unsigned short cache;
;;	unsigned char bit_offset;
;;	unsigned char escape=0;
;;	unsigned char BitLeft;
;;	*cache=(unsigned short)(readbits(pbs,11,shead));
;;	*BitLeft=pbs->BitLeftInCache;
;	//*************************Mpeg1
;;	*if(shead->constrained_parameter_flag){
;  % p11
;;	*	while(cache==0xF){  //0000 0001 111  >> macroblock_stuffng
;_address_loop1:
;      % p12
;;	*		cache=(unsigned short)(readbits(pbs,11,shead));
;;	*		BitLeft=pbs->BitLeftInCache;
;;	*	}
;;	*}
;  % p13
;	//******************************
;;	*while(cache==0x8){  //0000 0001 000
;;	*	escape+=33;                               //macroblock_escape
;;	*	cache=(unsigned short)(readbits(pbs,11,shead));
;;	*	BitLeft=pbs->BitLeftInCache;
;;	*}
;;	bit_offset=Table_Search(cache,11,&(coef_token_table[0]),shead);
;;	if(shead->Error_flag)
;		printf("Error for MB_address_increment!!\n");
;;	else{
;;		pbs->BitLeftInCache=BitLeft+(11-bit_offset);
;;	}
;	//********************************8
;;	return (unsigned char)(pair->value.val)+escape;
;}
;scalar: r9<<constrained_parameter_flag
;cluster1: a7<<escape, d5<<cache
;cluster2: a3<<BitLeft,ac4 << address of Picture_data
{ b r1, _readbits     | nop                 | moviu d0, 11        | nop                 | clr ac2             }
{ nop                 | clr a7              | nop                 | lbu d9, a1, constrained_parameter_flag| nop }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | copy d5, a2         | copy ac5, d9        }
{ nop                 | copy a5, a2         | notp p12, p0        | notp p13, p0        | copy ac3, d5        }
;
{ nop                 | nop                 | nop                 | lbu a3, a6, BitLeftInCache| seqiu ac6, p11, p13, ac5, 1 }
{ (p9)sb r13, r14, Error_flag| nop          | (p11)seqiu ac7, p12, p13, d5, 0xF| nop    | nop                 }
_address_loop1:
{ (p12)b r1, _readbits| nop                 | (p12)moviu d0, 11   | nop                 | (p12)clr ac2        }
{ (p13)b _address_loop2_start| nop          | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;(p12)
{ nop                 | nop                 | (p12)seqiu ac7, p12, p13, d5, 0xF| nop    | nop                 }
;;(p13)
{ (p12)b _address_loop1| nop                | nop                 | lbu a3, a6, BitLeftInCache| nop           }
{ (p9)sb r13, r14, Error_flag| nop          | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;
_address_loop2_start:
;;	while(cache==0x8){  //0000 0001 000
;_address_loop_2:
;         %p12
;;		escape+=33;                               //macroblock_escape
;;		cache=(unsigned short)(readbits(pbs,11,shead));
;;		BitLeft=pbs->BitLeftInCache;
;;	}
{ nop                 | nop                 | seqiu ac7, p12, p13, d5, 0x8| nop         | nop                 }
_address_loop2:
{ (p12)b r1, _readbits| nop                 | (p12)moviu d0, 11   | nop                 | (p12)clr ac2        }
{ (p13)b _address_loop2_end| nop            | nop                 | nop                 | nop                 }
{ nop                 | (p12)addi a7, a7, 33| nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;;(p12)
{ nop                 | nop                 | (p12)seqiu ac7, p12, p13, d5, 0x8| nop    | nop                 }
;;(p13)
{ (p12)b _address_loop2| nop                | nop                 | lbu a3, a6, BitLeftInCache| nop           }
{ (p9)sb r13, r14, Error_flag| nop          | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;
_address_loop2_end:
;;	bit_offset=Table_Search(cache,11,&(coef_token_table[0]),shead);
;;	if(shead->Error_flag)
;		printf("Error for MB_address_increment!!\n");
;;	else{
;     % p1
;;		pbs->BitLeftInCache=BitLeft+(11-bit_offset);
;;	}
;	//********************************8
;;	return (unsigned char)(pair->value.val)+escape;

;cluster1: d15<<bit_offset, a2 << &(coef_token_table[0]), d2: pair[0..15],a7<<escape
;        ,d14<<clumpsz,d13<<cachesz,a3<<*table,a5 << address of picture_data,r13 << Error_flag
;cluster2:a3<<BitLeft,a2 << &(coef_token_table[0]),ac3 << address of picture_data
{ lbu r13, r14, Error_flag| lw a2, sp, 24   | nop                 | nop                 | nop                 }
{ b r1, _table_search | nop                 | moviu d13, 11       | lw a2, sp2, 24      | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | addi a2, a2, B1_startbit| nop             | nop                 | nop                 }
{ nop                 | lbu d14, a2, 0      | nop                 | addi a2, a2, B1_startbit| nop             }
{ nop                 | nop                 | clr d15             | nop                 | clr ac2             }
{ clr r13             | nop                 | moviu d8, 1         | nop                 | nop                 }
;
{ br r4               | bdt d15             | nop                 | bdr d15             | copy d5, ac3        }
{ seqiu r12, p1, p2, r13, 0| copy a2, a5    | extractiu d1, d2, 6, 4| copy a2, d5       | nop                 }
{ sb r13, r14, Error_flag| add d5, d1, a7   | nop                 | (p1)addi a3, a3, 11 | nop                 }
{ nop                 | nop                 | nop                 | (p1)sub a3, a3, d15 | nop                 }
{ nop                 | nop                 | nop                 | (p1)sb a3, a6, BitLeftInCache| nop        }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;
_MB_type:
;;unsigned char Macroblock_type(Bitstream *pbs,Seq_header *shead,Picture_data *pdata){
;;	unsigned char bit_offset;
;;	unsigned char bits;
;;	unsigned char BitLeft;
;;	*cache=(unsigned char)(readbits(pbs,8,shead)); //8bits
;;	*BitLeft=pbs->BitLeftInCache;
;	//*****Table B-2
;;	if(pdata->picture_coding_type!=Dframe){
;  %p1
;;		if(pdata->picture_coding_type==Iframe){
;     %p2
;;			bit_offset=Table_Search(cache,8,&(coef_token_table[1]),shead)
;;		}
;	//*******Table B-3
;;		else if(pdata->picture_coding_type==Pframe){
;     %p3
;;			bit_offset=Table_Search(cache,8,&(coef_token_table[2]),shead);
;;		}
;//*********Table B-4
;;		else{
;      % p4
;;			bit_offset=Table_Search(cache,8,&(coef_token_table[3]),shead);
;;		}

;;		if(!shead->Error_flag){
;;			pbs->BitLeftInCache=BitLeft+(8-bit_offset);
;;		}
;;	}
;;	else{    //*****Dframe
;  %p15
;;	*	pair->value.val=macroblock_intra;
;;	*	pbs->BitLeftInCache=BitLeft+(8-1);
;;	}
;;	return (unsigned char)pair->value.val;
;;}

;------SCT_FPGA_Trace
;{ trap                 | nop                 | nop                 | nop                 | nop                 }
;----------------------


{ b r1, _readbits     | nop                 | moviu d0, 8         | nop                 | clr ac2             }
{ bdt r3              | bdr a7              | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ lbu r3, r15, picture_coding_type| nop     | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | copy d5, a2         | nop                 }
{ nop                 | copy a5, a2         | nop                 | nop                 | copy ac3, d5        }
;

;------SCT_FPGA_Trace
;{ trap                 | nop                 | nop                 | nop                 | nop                 }
;----------------------


{ (p9)sb r13, r14, Error_flag| notp p2, p0  | nop                 | lbu a3, a6, BitLeftInCache| nop           }
{ seqiu r10, p15, p1, r3, Dframe| notp p3, p0| moviu d0, macroblock_intra| copy a5, a2  | nop                 }
{ (p15)br r4          | nop                 | (p1)inserti d2, d0, 6, 4| (p1)lw a2, sp2, 24| nop               }
{ (p1)seqiu r10, p2, p3, r3, Iframe| (p1)lw a2, sp, 24| (p15)extractiu d5, d2, 6, 4| notp p4, p0| nop         }
{ (p3)seqiu r10, p3, p4, r3, Pframe| (p15)sb d5, a4, MB_type| nop | (p15)addi a3, a3, 7 | nop                 }
{ bdr r3              | bdt a7              | nop                 | (p15)sb a3, a6, BitLeftInCache| nop       }
{ (p1)b r1, _table_search| (p2)addi a2, a2, B2_startbit| (p1)moviu d13, 8| (p2)addi a2, a2, B2_startbit| nop  }
{ clr r13             | (p3)addi a2, a2, B3_startbit| nop         | (p3)addi a2, a2, B3_startbit| nop         }
;;(p15)
{ nop                 | (p4)addi a2, a2, B4_startbit| nop         | (p4)addi a2, a2, B4_startbit| nop         }
{ nop                 | (p1)lbu d14, a2, 0  | nop                 | nop                 | nop                 }
{ nop                 | nop                 | (p1)clr d15         | nop                 | (p1)clr ac2         }
{ nop                 | nop                 | (p1)moviu d8, 1     | nop                 | nop                 }
;;(p1)
;r13<<Error_flag




{ br r4               | nop                 | nop                 | nop                 | nop                 }
{ seqiu r9, p5, p6, r13, 0| bdt d15         | nop                 | bdr d15             | nop                 }
{ (p6)sb r13, r14, Error_flag| copy a2, a5  | nop                 | (p5)addi a3, a3, 8  | nop                 }
{ nop                 | extractiu d5, d2, 6, 4| nop               | (p5)sub a3, a3, d15 | nop                 }
{ nop                 | sb d5, a4, MB_type  | nop                 | (p5)sb a3, a6, BitLeftInCache| copy d5, ac3 }
{ nop                 | nop                 | nop                 | copy a2, d5         | nop                 }
_Search_cbp:
;;unsigned char Search_cbp(Bitstream* pbs,Seq_header *shead){
;;	   unsigned short cache;
;;	   unsigned char bit_offset;
;;	   unsigned char BitLeft;
;;*	cache=(unsigned short)(readbits(pbs,9,shead)); //9bits
;;*	   BitLeft=pbs->BitLeftInCache;
;;*	bit_offset=Table_Search(cache,9,&(coef_token_table[4]),shead);
;;	   if(shead->Error_flag)
;       %p1
;;		  return 0;
;;	   else{
;       %p2
;;*		  pbs->BitLeftInCache=BitLeft+(9-bit_offset);
;;*		  return (unsigned char)pair->value.val;
;;	   }
;;}
;cluster1:d5 << cache, d15<<bit_offset
;cluster2:a3 << BitLeft
{ b r1, _readbits     | nop                 | moviu d0, 9         | copy d5, a2         | clr ac2             }
{ nop                 | nop                 | nop                 | nop                 | copy ac3, d5        }
{ nop                 | copy a5, a2         | nop                 | lw a2, sp2, 24      | nop                 }
{ nop                 | lw a2, sp, 24       | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;

;;*****************Break_Point!!!!!!!!!
;{ seqiu r11,p11,p0,r0,660| nop                     | nop 				       | nop 				          | nop				      }
;{(p11)moviu r15,0x55667788 | nop                     | nop 				       | nop 				          | nop				      }
;{ notp p11,p0        | nop                     | nop 				       | nop 				          | nop				      }
;{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
;{ seqiu r11,p11,p0,r0,660| nop 	              | nop 				       | nop 				          | orp p10,p10,p0}
;{ andp p11,p11,p10 	| nop 		              | nop 				       | nop 				          | nop                  }
;{ notp p10,p11 		|(p11)moviu a7,0xb00a9000 | nop 				       | nop 				          | nop				      }
;{(p10)b _end3 	      |(p11)moviu d0,0x55667886 | nop 				       | nop		                | nop				      }
;{ nop	               | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      | nop                     | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p11)sw d0,a7,0         | nop 				       | nop 				          | nop				      }
;{(p11) moviu r3,1    | nop 				        | notp p10,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p11,p0 			 | nop 				          | nop				      }
;;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end3:
;;********************************************

{ b r1, _table_search | addi a2, a2, B9_startbit| moviu d13, 9    | lbu a3, a6, BitLeftInCache| nop           }
{ (p9)sb r13, r14, Error_flag| lbu d14, a2, 0| nop                | addi a2, a2, B9_startbit| nop             }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | nop                 | nop                 | nop                 }
{ nop                 | nop                 | moviu d8, 1         | nop                 | nop                 }
{ clr r13             | nop                 | clr d15             | nop                 | clr ac2             }
;
{ br r4               | bdt d15             | nop                 | bdr d15             | nop                 }
{ seqiu r11, p2, p1, r13, 0| nop            | nop                 | addi a3, a3, 9      | nop                 }
{ sb r13, r14, Error_flag| nop              | (p1)moviu d5, 0     | (p2)sub a3, a3, d15 | nop                 }
{ nop                 | (p2)extractiu d5, d2, 6, 4| nop           | (p2)sb a3, a6, BitLeftInCache| copy d5, ac3 }
{ nop                 | copy a2, a5         | nop                 | copy a2, d5         | nop                 }
{ nop                 | nop                 | nop                 | clr d8              | nop                 }
_Combining_pred:
;void Combining_predictions(Picture_data *pdata,Slice_data *sdata,Frame_memory *Fmem){
;	int y,x;
;	unsigned short temp;
;	unsigned char YUV_temp;

;;*   if((sdata->MB_type & macroblock_motion_forward)==0){
;     %p2
;;*   	for(y=0;y<384;y+=2){
;;*			if(y<256){
;;*				x=y;
;;*				Fmem->Forward_pred.Y[x]=Fmem->Backward_pred.Y[x];
;;*				Fmem->Forward_pred.Y[x+1]=Fmem->Backward_pred.Y[x+1];
;;*			}
;;*			else if(y<320){
;;*				x=y-256;
;;*				Fmem->Forward_pred.U[x]=Fmem->Backward_pred.U[x];
;;*				Fmem->Forward_pred.U[x+1]=Fmem->Backward_pred.U[x+1];
;;*			}
;;*			else{
;;*				x=y-320;
;;*				Fmem->Forward_pred.V[x]=Fmem->Backward_pred.V[x];
;;*				Fmem->Forward_pred.V[x+1]=Fmem->Backward_pred.V[x+1];
;;*			}
;;*		}
;;*	}
;;*	else{
;     %p3
;;			for(y=0;y<384;y++){
;;				if(y<256){
;;					x=y;
;;					temp=Fmem->Forward_pred.Y[x]+Fmem->Backward_pred.Y[x];
;;				}
;;				else if(y<320){
;;					x=y-256;
;;					temp=Fmem->Forward_pred.U[x]+Fmem->Backward_pred.U[x];
;;				}
;;				else{
;;					x=y-320;
;;					temp=Fmem->Forward_pred.V[x]+Fmem->Backward_pred.V[x];
;;				}
;;          if((temp & 1)!=0)
;;						temp++;
;;				YUV_temp=temp>>1;
;;				if(y<256)
;;					Fmem->Forward_pred.Y[x]=YUV_temp;
;;				else if(y<320)
;;					Fmem->Forward_pred.U[x]=YUV_temp;
;;				else
;;					Fmem->Forward_pred.V[x]=YUV_temp;
;;			}
;;		}
;;}
;p2=1 <<sdata->MB_type & macroblock_motion_forward)==0
;p3=2 <<sdata->MB_type & macroblock_motion_forward)!=0
;
;r10 << 0~384/32=12, a5<< address of Backward_pred_YUV, a7<< address of Froward_pred_YUV
;d0 << x, d8<<y , d5<< 0

;;*****************Break_Point!!!!!!!!!
;{ moviu r11,GLOBAL_POINTER_ADDR  | nop 		  | nop 				       | nop 				    | nop				      }
;{ lw r9,r11,MB_Count | nop                     | nop 				       | nop 				          | nop				      }
;{ nop                | nop 				        | nop 				       | nop 				    | nop				      }
;{ nop 			      | nop   	                 | nop 				       | nop 				          | nop				      }
;{ seqiu r11,p12,p0,r9,2933| nop 	                 | nop 				       | nop 				          | orp p11,p11,p0      }
;{ andp p12,p12,p11	| nop 		              | nop                  | nop 				          | nop                  }
;{ notp p11,p12 		| nop  				        | nop                  |nop				          | nop				      }
;{(p11)b _end3 	      |(p15)moviu d0,0x55667788 | nop                  |nop 				          | nop				      }
;{ nop 			      |(p12)moviu a7,0xb00a9000 |(p12)copy d1,ac3      | nop 				    | nop				      }
;{(p12)bdt r10	      |(p12)bdr d8              | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p12)sw d1,a7,4	        | nop 				       |nop           | nop				      }
;{(p12) moviu r3,1    |(p12)sw d8,a7,8          | notp p11,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p12,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end3:
;;********************************************

{ sltiu r11, p0, p4, r10, 12| dlw d0, a5, 16+| nop                | (p3)dlw d8, a7, 0   | nop                 }
{ (p4)br r4           | (p3)dlw d8, a7, 0   | (p4)notp p2, p0     | dlw d0, a5, 16+     | (p4)notp p3, p0     }
{ (p2)b _Combining_pred| dlw d2, a5, 16+    | nop                 | (p3)dlw d10, a7, 16 | nop                 }
{ addi r10, r10, 1    | (p3)dlw d10, a7, 16 | (p3)unpack4u ac0, d0| dlw d2, a5, 16+     | (p3)unpack4u d12, d8 }
{ nop                 | (p2)dsw d0, d1, a7, 16+| (p3)unpack4u d12, d8| (p3)unpack4u d6, d9| (p3)unpack4u ac0, d0 }
{ nop                 | (p3)unpack4u d0, d1 | (p3)add.d ac0, ac0, d12| (p2)dsw d0, d1, a7, 16+| (p3)add.d ac0, ac0, d12 }
{ nop                 | (p2)dsw d2, d3, a7, 16+| (p3)unpack4u d6, d9| (p3)unpack4u d0, d1| (p3)add.d ac1, ac1, d13 }
{ nop                 | (p3)add.d d0, d0, d6| (p3)add.d ac1, ac1, d13| (p2)dsw d2, d3, a7, 16+| nop           }
;(p2)
{ nop                 | add.d d1, d1, d7    | unpack4u d14, d10   | (p3)add.d d0, d0, d6| unpack4u d14, d10   }
{ nop                 | unpack4u d12, d2    | andi ac2, ac0, 0x00000001| add.d d1, d1, d7| andi ac2, ac0, 0x00000001 }
{ nop                 | add.d d12, d12, d14 | andi ac3, ac0, 0x00010000| unpack4u d12, d2| andi ac3, ac0, 0x00010000 }
{ nop                 | add.d d13, d13, d15 | sgtiu ac7, p5, p0, ac2, 0| add.d d12, d12, d14| sgtiu ac7, p9, p1, ac2, 0 }
{ nop                 | unpack4u d2, d3     | sgtiu ac7, p6, p0, ac3, 0| add.d d13, d13, d15| sgtiu ac7, p10, p1, ac3, 0 }
{ nop                 | unpack4u d4, d11    | (p5)addi ac0, ac0, 1| unpack4u d2, d3     | (p9)addi ac0, ac0, 1 }
{ nop                 | add.d d2, d2, d4    | (p6)addi ac0, ac0, 0x10000| unpack4u d4, d11| (p10)addi ac0, ac0, 0x10000 }
{ nop                 | add.d d3, d3, d5    | andi ac2, ac1, 0x00000001| add.d d2, d2, d4| andi ac2, ac1, 0x00000001 }
{ nop                 | andi d6, d0, 0x00000001| andi ac3, ac1, 0x00010000| add.d d3, d3, d5| andi ac3, ac1, 0x00010000 }
{ nop                 | andi d7, d0, 0x00010000| sgtiu ac7, p5, p0, ac2, 0| andi d8, d0, 0x00000001| sgtiu ac7, p9, p1, ac2, 0 }
{ nop                 | andi d14, d12, 0x00000001| sgtiu ac7, p6, p0, ac3, 0| andi d9, d0, 0x00010000| sgtiu ac7, p10, p1, ac3, 0 }
{ nop                 | sgtiu a3, p7, p0, d6, 0| (p5)addi ac1, ac1, 1| andi d14, d12, 0x00000001| (p9)addi ac1, ac1, 1 }
{ nop                 | sgtiu a3, p8, p0, d7, 0| (p6)addi ac1, ac1, 0x10000| sgtiu a3, p11, p1, d8, 0| (p10)addi ac1, ac1, 0x10000 }
{ nop                 | sgtiu a3, p5, p0, d14, 0| (p7)addi d0, d0, 1| sgtiu a3, p12, p1, d9, 0| (p11)addi d0, d0, 1 }
{ nop                 | (p5)addi d12, d12, 1| (p8)addi d0, d0, 0x10000| sgtiu a3, p9, p0, d14, 0| (p12)addi d0, d0, 0x10000 }
{ nop                 | andi d15, d12, 0x00010000| andi ac2, d1, 0x00000001| andi d15, d12, 0x00010000| andi ac2, d1, 0x00000001 }
{ nop                 | sgtiu a3, p6, p0, d15, 0| andi ac3, d1, 0x00010000| sgtiu a3, p10, p1, d15, 0| andi ac3, d1, 0x00010000 }
{ nop                 | (p6)addi d12, d12, 0x10000| sgtiu ac7, p5, p0, ac2, 0| (p9)addi d12, d12, 1| sgtiu ac7, p11, p1, ac2, 0 }
{ nop                 | andi d14, d13, 0x00000001| sgtiu ac7, p6, p0, ac3, 0| (p10)addi d12, d12, 0x10000| sgtiu ac7, p12, p1, ac3, 0 }
{ nop                 | andi d15, d13, 0x00010000| (p5)addi d1, d1, 1| andi d14, d13, 0x00000001| (p11)addi d1, d1, 1 }
{ nop                 | sgtiu a3, p5, p0, d14, 0| (p6)addi d1, d1, 0x10000| andi d15, d13, 0x00010000| (p12)addi d1, d1, 0x10000 }
{ nop                 | sgtiu a3, p6, p0, d15, 0| andi d6, d2, 0x00000001| sgtiu a3, p9, p1, d14, 0| andi d6, d2, 0x00000001 }
{ nop                 | (p5)addi d13, d13, 1| andi d7, d2, 0x00010000| sgtiu a3, p10, p0, d15, 0| andi d7, d2, 0x00010000 }
{ nop                 | (p6)addi d13, d13, 0x10000| sgtiu ac7, p5, p0, d6, 0| (p9)addi d13, d13, 1| sgtiu ac7, p9, p1, d6, 0 }
{ nop                 | sgtiu a3, p6, p0, d7, 0| srli.d ac0, ac0, 1| (p10)addi d13, d13, 0x10000| srli.d ac0, ac0, 1 }
{ nop                 | (p5)addi d2, d2, 1  | srli.d ac1, ac1, 1  | sgtiu a3, p10, p0, d7, 0| srli.d ac1, ac1, 1 }
{ nop                 | (p6)addi d2, d2, 0x10000| pack4 d8, ac0, ac1| (p9)addi d2, d2, 1| pack4 d8, ac0, ac1  }
{ nop                 | sw d8, a7, 4+       | andi ac2, d3, 0x00000001| (p10)addi d2, d2, 0x10000| nop        }
{ nop                 | srli.d d12, d12, 1  | andi ac3, d3, 0x00010000| sw d8, a7, 4+   | andi ac2, d3, 0x00000001 }
{ nop                 | srli.d d13, d13, 1  | sgtiu ac7, p5, p0, ac2, 0| srli.d d12, d12, 1| andi ac3, d3, 0x00010000 }
{ nop                 | pack4 d8, d12, d13  | sgtiu ac7, p6, p0, ac3, 0| srli.d d13, d13, 1| sgtiu ac7, p9, p1, ac2, 0 }
{ nop                 | sw d8, a7, 12       | copy ac4, d3        | pack4 d8, d12, d13  | sgtiu ac7, p10, p0, ac3, 0 }
{ nop                 | srli.d d14, d0, 1   | (p5)addi ac4, ac4, 1| sw d8, a7, 12       | copy ac4, d3        }
{ (p3)b _Combining_pred| srli.d d15, d1, 1  | (p6)addi ac4, ac4, 0x10000| srli.d d14, d0, 1| (p9)addi ac4, ac4, 1 }
{ nop                 | pack4 d8, d14, d15  | srli.d d2, d2, 1    | srli.d d15, d1, 1   | (p10)addi ac4, ac4, 0x10000 }
{ nop                 | sw d8, a7, 16+      | srli.d ac4, ac4, 1  | pack4 d8, d14, d15  | srli.d d2, d2, 1    }
{ nop                 | nop                 | pack4 d0, d2, ac4   | sw d8, a7, 16+      | srli.d ac4, ac4, 1  }
{ nop                 | sw d0, a7, 12+      | nop                 | nop                 | pack4 d0, d2, ac4   }
{ nop                 | nop                 | nop                 | sw d0, a7, 12+      | nop                 }
;;

_interpolation:

;*******************Not change
;p13,p14
;cluster1: ac3<< flag2=1 << execute _mc_loop for twice!!, ac6 <<average_flag
;          ac0<<column_size,  ac1<<ref_y ,ac2 << row_step_ref, d9<<row_size
;          a7 << *ref_reg, a0<< *pred

;cluster2: ac1 << r , ac6<< t, a3<< *MV, a5 << *MV->vector[s][0] (or *MV->vector_chroma[s][0])
;          ac2<< row_start, ac3<< row_step, d8<< int_vec[1]|int_vec[0]
;*******************************

;scalar  :  r15<<address of picture_data
;cluster1:  d4<<index_ref, d5<< width_temp
;cluster2:  d9<< int_vec_chroma[1]|int_vec_chroma[0], a2<< *pred, a7<<*ref_reg,d4<<index_ref, d5<< width_temp
;           d12<<row_size, d13<<column_size,d14<< y, d15<<index

;%p1=1 <<half_flag[0]!=0
;%p2=1 <<half_flag[1]!=0
;%p3=1 <<chroma_flag=0
;%p8=1 <<mv_format=1
;%p10=1 <<picture_structure!=Frame_picture
;%p15=1 <<(sdata->MB_type & (macroblock_motion_forward | macroblock_motion_backward))!=0

;%p4=1 << (!p1) && (!p2) half_flag[0]=0, half_flag[1]=0
;%p5=1 << (!p1) && p2   half_flag[0]=0, half_flag[1]=1
;%p6=1 << p1 && (!p2)   half_flag[0]=1, half_flag[1]=0
;%p7=1 << p1 && p2      half_flag[0]=1, half_flag[1]=1
;%p11=1 << average_flag=1

;Slice_data   *sdata_op=sdata;
;Frame_memory *Fmem_op=Fmem;
;;*if(shead->constrained_parameter_flag==0 &&(pdata->picture_coding_type==Pframe || pdata->picture_coding_type==Bframe)){
;     %p1 && (p2 || p4)
;;*	if(pdata->pipeline_flag_B==0){  //first MB of picture
;      %p6
;;*		pdata->pipeline_flag_A=1;
;;*		pdata->pipeline_flag_B=2;

;;*		sdata2->PMV0[0][0]=sdata->PMV0[0][0];
;;*		sdata2->PMV0[0][1]=sdata->PMV0[0][1];
;;*		sdata2->PMV0[1][0]=sdata->PMV0[1][0];
;;*		sdata2->PMV0[1][1]=sdata->PMV0[1][1];
;;*		sdata2->PMV1[0][0]=sdata->PMV1[0][0];
;;*		sdata2->PMV1[0][1]=sdata->PMV1[0][1];
;;*		sdata2->PMV1[1][0]=sdata->PMV1[1][0];
;;*		sdata2->PMV1[1][1]=sdata->PMV1[1][1];

;;*		sdata2->slice_quantiser_scale_code=sdata->slice_quantiser_scale_code;
;;*		sdata2->dc_dct_pred[0]=sdata->dc_dct_pred[0];
;;*		sdata2->dc_dct_pred[1]=sdata->dc_dct_pred[1];
;;*		sdata2->dc_dct_pred[2]=sdata->dc_dct_pred[2];

;;*		return;
;;	}
;;*	else{
;    %p7
;;*		if(pdata->pipeline_flag_A==2){ //flag_A=2, flag_B=1
;       %p8
;;*			if(sdata->Mode_select!=1){
;            %p12
;;*				pdata->pipeline_flag_A=1;
;;*				pdata->pipeline_flag_B=2;
;;*				sdata2->PMV0[0][0]=sdata->PMV0[0][0];
;;*				sdata2->PMV0[0][1]=sdata->PMV0[0][1];
;;*				sdata2->PMV0[1][0]=sdata->PMV0[1][0];
;;*				sdata2->PMV0[1][1]=sdata->PMV0[1][1];
;;*				sdata2->PMV1[0][0]=sdata->PMV1[0][0];
;;*				sdata2->PMV1[0][1]=sdata->PMV1[0][1];
;;*				sdata2->PMV1[1][0]=sdata->PMV1[1][0];
;;*				sdata2->PMV1[1][1]=sdata->PMV1[1][1];

;;*				sdata2->slice_quantiser_scale_code=sdata->slice_quantiser_scale_code;
;;*				sdata2->dc_dct_pred[0]=sdata->dc_dct_pred[0];
;;*				sdata2->dc_dct_pred[1]=sdata->dc_dct_pred[1];
;;*				sdata2->dc_dct_pred[2]=sdata->dc_dct_pred[2];

;;*				sdata_op=sdata2;
;;*				Fmem_op =Fmem2;
;;			}
;;*			else{
;           %p13
;;*				sdata_op=sdata;
;;*				Fmem_op =Fmem;
;;			}
;;		}
;;*		else{                          //flag_A=1, flag_B=2
;        %p9
;;*			if(sdata2->Mode_select!=1){
;           %p14
;;*				pdata->pipeline_flag_A=2;
;;*				pdata->pipeline_flag_B=1;

;;*				sdata->PMV0[0][0]=sdata2->PMV0[0][0];
;;*				sdata->PMV0[0][1]=sdata2->PMV0[0][1];
;;*				sdata->PMV0[1][0]=sdata2->PMV0[1][0];
;;*				sdata->PMV0[1][1]=sdata2->PMV0[1][1];
;;*				sdata->PMV1[0][0]=sdata2->PMV1[0][0];
;;*				sdata->PMV1[0][1]=sdata2->PMV1[0][1];
;;*				sdata->PMV1[1][0]=sdata2->PMV1[1][0];
;;*				sdata->PMV1[1][1]=sdata2->PMV1[1][1];

;;*				sdata->slice_quantiser_scale_code=sdata2->slice_quantiser_scale_code;
;;*				sdata->dc_dct_pred[0]=sdata2->dc_dct_pred[0];
;;*				sdata->dc_dct_pred[1]=sdata2->dc_dct_pred[1];
;;*				sdata->dc_dct_pred[2]=sdata2->dc_dct_pred[2];

;;*				sdata_op=sdata;
;;*				Fmem_op =Fmem;
;			}
;;*			else{
;           %p15
;;*				sdata_op=sdata2;
;;*				Fmem_op =Fmem2;
;			}
;		}
;	}
;}
;scalar:   r12<<emdma_addr, r10<<0, r15<<Ref_num
;cluster1: d0<<half_flag_chroma_0_0, ac0<<16, d10<<row_size_0, a7<<(Frame_memory_ADDR + Ref_MB_0_Y)
;           , a6<<Prediction_buf_0, d14<<address of sdata_op,

;cluster2:  a7<<(Frame_memory_ADDR + Ref_MB_0_Y), a6<<Prediction_buf_0, ac0<<16, d0<<half_flag_0_0, d10<<row_start_0,

;p10<<0, p11<<0, p3<<1,

.if 1


{ notp p15,p0        | lbu d1,a1,constrained_parameter_flag  | nop         | lbu d1,a2,picture_coding_type  | nop				      }
{ notp p14,p0        | lbu d8,a2,Pipeline_flag_B| moviu d2,1    	       | nop  	                   | notp p8,p0			      }
{ notp p13,p0        | nop 				        | notp p12,p0    	       | lbu d8,a2,Pipeline_flag_A | notp p9,p0			      }
{ nop                | lw a5,sp,16              | seqiu ac7,p1,p10,d1,0    | nop  	                   | seqiu ac7,p2,p5,d1,Pframe}
{(p10)b _Mpeg1_Polling_loop | nop 		        | seqiu ac7,p6,p7,d8,0     | lw a5,sp2,28              | seqiu ac7,p4,p0,d1,Bframe}
{ orp p2,p2,p4       | lw a3,sp,28		        | notp p11,p10   	       | nop  	                   |(p7)seqiu ac7,p8,p9,d8,2  }
{ andp p1,p1,p2      |(p8)lbu d9,a5,Mode_select |(p10)notp p2,p0   	       |(p9)lw a3,sp2,16           | nop				      }
{(p11)notp p2,p1     | nop 				        | andp p6,p6,p1 	       |(p9)lbu d9,a5,Mode_select  | andp p8,p8,p1		      }
{(p2)b _interpolate_start |dlw d12,a5,PMV0_0_0  | andp p9,p9,p1            | nop  	                   | orp p4,p6,p8    	      }
;{(p2)b _Trace_Polling2 |dlw d12,a5,PMV0_0_0    | andp p9,p9,p1            | nop  	                   | orp p4,p6,p8    	      }
{ notp p10,p0        | dlw d4,a5,PMV1_0_0       | notp p11,p0              |(p9)dlw d12,a5,PMV0_0_0    | nop				      }
;(p10)
{ nop                |(p6)sb d2,a2,Pipeline_skip_flag |(p8)seqiu ac7,p13,p12,d9,1 |(p9)dlw d14,a5,PMV1_0_0  | moviu d2,0x0102     }
{ orp p5,p6,p12      |(p4)lbu d8,a5,slice_quantiser_scale_code | moviu d2,0x0201  |(p9)lbu d8,a5,slice_quantiser_scale_code |(p9)seqiu ac7,p15,p14,d9,1}
{ notp p10,p0        |(p5)dlw d6,a5,dc_dct_pred0| nop 				       |(p14)dlw d6,a5,dc_dct_pred0 | nop				      }
{ orp p13,p13,p14    |(p5)dsw d12,d13,a3,PMV0_0_0  |(p2)orp p8,p8,p0       |(p14)dsw d12,d13,a3,PMV0_0_0   | nop				  }
;;(p2)
{(p6)br r5           |(p5)dsw d4,d5,a3,PMV1_0_0 | nop    		           |(p14)dsw d14,d15,a3,PMV1_0_0   | nop				  }
{ orp p15,p15,p12    |(p5)sb d8,a3,slice_quantiser_scale_code | nop        |(p14)sb d8,a3,slice_quantiser_scale_code | nop		  }
{(p6)bdt r6          |(p6)bdr a6			    | nop 				       |(p6)bdr a6                 | nop				      }
{ nop                |(p5)sw d6,a3,dc_dct_pred0 | nop 				       |(p14)sw d6,a3,dc_dct_pred0 | nop				      }

{ nop                |(p5)sh d2,a2,Pipeline_flag_A | nop 			       |(p14)sh d2,a2,Pipeline_flag_A  | nop    		      }
{ nop                |(p5)sh d7,a3,dc_dct_pred2 | nop 				       |(p14)sh d7,a3,dc_dct_pred2 | nop				      }
;(p6)
{ nop                |(p13)sw a5,sp,40          |(p13)moviu d8,Frame_memory_ADDR |(p15)sw a5,sp2,40    |(p15)moviu d8,Frame_memory1_ADDR}
{ nop                |(p13)sw d8,sp,44          | nop 				       |(p15)sw d8,sp2,44          | nop				      }
{ lw r11,sp3,40      |(p13)copy a4,a5           | nop                      |(p15)copy a4,a5            |(p13)moviu d8,Frame_memory_ADDR}
{ nop                |(p15)bdr a4               | nop                      |(p15)bdt a4                | nop				      }
{ nop                |(p13)bdt a4               | nop 		               |(p13)bdr a4                | nop				      }
{ lbu r15,r11,Ref_num| nop                      | nop   	               | addi a7,d8,Ref_MB_0_Y     | nop				      }
{ nop                | copy d14, a4             | nop 				       | lw a6, a4, Prediction_buf_0 | nop				      }
{ nop                | lw d10, a4, row_size_0   | nop 				       | nop  	                   | nop				      }
{ seqiu r10,p11,p10,r15,0 | nop 		        | nop 				       | lhu d0, a4, half_flag_0_0 | nop				      }
{(p10)b _interpolate_start | dbdr a6		    | nop 				       | dbdt a6,a7                | nop				      }
{(p11)br r5          | nop 				        | nop 				       | lw d10, a4, row_start_0   | nop				      }
{ notp p10,p0        | lhu d0, a4, half_flag_chroma_0_0 | nop 	           | nop                       | nop				      }
{ notp p11,p0        | nop 				        | nop 				       | notp p8,p0                | nop				      }
{ clr r10  	         | nop 				        | nop 				       | nop 		               | nop				      }
{ sb r10,r11,Ref_count | nop     		        | nop 				       | nop 			           | nop				      }
;
{ nop 	             | nop 				        | nop 				       | nop 				       | nop				      }
;

.if 0
;;;*******Trace
{ seqiu r13,p15,p0,r0,1362  | nop 			     | nop 				       | nop  	                   | nop				      }
{ seqiu r13,p9,p0,r0,1363  | nop 			     | nop 				       | nop  	                   | nop				      }
{ moviu r13,306     | moviu a3,0x1e002300       | nop 				       | moviu a3,0x1e002698       | nop				      }
{ nop               |(p15)moviu a5,0x1e005000     | nop 				       |(p15)moviu a5,0x1e005398       | nop				      }
{ nop               |(p9)moviu a5,0x1e006000       | nop 				       |(p9)moviu a5,0x1e006398       | nop				      }
_Trace_loop:
{ lbcb r13,_Trace_loop | lbu d1,a3,1+           | nop 				       | lbu d1,a3,1+              | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ orp p15,p15,p9      | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               |(p15)sb d1,a5,1+		    | nop 				       |(p15)sb d1,a5,1+               | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ seqiu r9,p0,p1,r0,1363  | nop 			     | nop 				       | nop  	                   | nop				      }
;;
{(p1)b _jump        | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;;
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
_jump:
;;;***********
.endif


;;*******************************System DMA Status Polling!!!
_Mpeg1_Polling_loop:
{ nop               | lbu d15,a4,Ref_num        | nop 				       | nop  	                   | nop				      }
{ lw r9,r12,R054_DMASTAT | nop 	    	        | nop 				       | nop  	                   | nop				      }
{ notp p12,p0       | nop                       | nop 				       | nop                       | nop				      }
{ nop               | nop 				        | seqiu ac7,p10,p11,d15,0  | nop  	                   | nop    }
{ andi r9,r9,0x0f0f0f0f | nop 				        | nop 				       | nop  	                   | nop				      }
{(p11)seqiu r11,p0,p12,r9,0x02020202 | nop      | nop 				       | nop  	                   | nop				      }
{(p12)b _Mpeg1_Polling_loop  | nop 		        | nop                      | nop  	                   | nop				      }
{(p10)br r5         | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ notp p11,p0       | nop 				        | nop 				       | nop  	                   | nop				      }
{ notp p10,p0       | nop 				        | nop 				       | nop  	                   | nop				      }
;(p12)
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;;;***********
;

;{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;{ lw r9,r12,R200_DMASR  | nop 				    | nop 				       | nop         		    | notp p7,p0              }
;{ notp p12,p0        | nop 				        | nop 				       | lbu d14,a2,picture_coding_type | notp p5,p0      }
;{ nop                | nop 				        | nop                      | lbu d13,a4,Ref_num     | notp p1,p0              }
;{ seqiu r11,p0,p12,r9,0 | nop 			        | nop 				       | lbu d15,a5,Ref_num     | notp p6,p0       	      }
;{ nop                | lbu d1,a2,picture_structure| nop 		           | nop 				    | seqiu ac7,p2,p0,d14,Bframe}
;{ nop                | lbu d2,a4,prediction_type| notp p4,p0               | nop             	    | sgtiu ac7,p1,p0,d13,1}
;{ nop                | nop 				        | nop            		   | nop            	    |(p2)sgtiu ac7,p1,p0,d13,3}
;{ nop                | nop  		            | seqiu ac7,p6,p5,d1,Frame_picture| nop        	    |(p1)sgt ac7,p4,p1,d15,d13}
;{ nop                | nop  		            |(p5)seqiu ac7,p7,p0,d2,1  | notp p6,p0  		    | nop                     }
;{ nop                | nop  		            |(p5)seqiu ac7,p6,p0,d2,3  | nop 				    | nop                     }
;{ nop                | nop  		            | orp p7,p7,p6             | nop 				    | nop                     }
;{ nop                | nop  		            | orp p1,p1,p7             | nop 				    | nop                     }
;{ nop                | nop  		            | andp p12,p12,p1          | nop 				    | nop                     }
;{(p12)b _test_status_loop  | nop 			    | nop 		               | nop  	                | nop				      }
;.endif
;;**********************************


.endif
;;**********************************

;;*   if(pdata->picture_structure!=Frame_picture && r==1){
;     %p10 &&  p6
;			//field prediction, 16x8MC, or Dual-prime in field pictures
;			//Lower  16X8 MB decoding
;;*			row_start=8;
;		}
;;*	if((sdata->MB_type & (macroblock_motion_forward | macroblock_motion_backward))!=0){
;     % p15
;;*		half_flag[0]=((MV->vector_chroma[s][0]-(int_vec_chroma[0]<<1))!=0)? 1 : 0;
;;*		half_flag[1]=((MV->vector_chroma[s][1]-(int_vec_chroma[1]<<1))!=0)? 1 : 0;
;		}
;	sdata->average_flag[sdata->Ref_num]=average_flag;
;	sdata->Ref_num++;
;	}


;{ br r5              | nop  				        | nop                  |nop				             |nop      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;


;_Trace_Polling2:
;{ seqiu r11,p15,p0,r0,1363  | nop 			     | nop 				       | nop  	                   | nop				      }
;{ lw r9, r12, R200_DMASR    | nop 			    | nop 				       | nop  	                   | nop				      }
;{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;{ notp p12,p0       | nop 				        | nop 				       | nop  	                   | nop				      }
;{seqiu r11, p0, p12, r9, 0 | nop 			    | nop 				       | nop  	                   | nop				      }
;{(p12)b _Trace_Polling2 | nop     		        | nop 				       | nop  	                   | nop				      }
;{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;

_interpolate_start:


{ lw r9, r12, R054_DMASTAT| extractiu d1, d0, 8, 0| copy d15, ac0   | (p3)notp p2, p0     | (p3)extractiu d1, d0, 8, 0 }
{ seqiu r11, p15, p9, r10, 0| sltiu a5, p0, p4, d0, 0x100| extractiu ac2, d10, 8, 8| (p3)seqiu a0, p7, p1, d1, 0| extractiu ac2, d10, 8, 0 }
{ (p9)seqiu r11, p10, p11, r10, 1| (p9)seqiu a5, p0, p1, d1, 0| (p9)srli d15, d15, 1| (p15)copy a2, a6| (p15)sltiu ac7, p7, p2, d0, 0x100 }
{ seqiu r11, p0, p12, r9, 0| (p10)addi a7, a7, 584| addi ac4, d15, 1| (p15)copy d11, a7 | (p9)andp p2, p4, p9 }
;{ (p12)b _interpolate_start| (p11)addi a7, a7, 168| extractiu ac1, d10, 8, 24| (p10)addi d11, d11, 584| nop       }
{ nop                      | (p11)addi a7, a7, 168| extractiu ac1, d10, 8, 24| (p10)addi d11, d11, 584| nop       }
{ notp p5, p0         | bdt d15             | fmuluu d4, ac1, ac4 | bdr d13             | extractiu ac3, d10, 8, 8 }
{ nop                 | extractiu d9, d10, 8, 0| fmuluu d5, ac2, ac4| (p11)addi d11, d11, 168| (p9)seqiu ac7, p5, p0, ac2, 8 }
{ andp p4, p15, p0    | (p9)srli d9, d9, 1  | nop                 | (p10)addi a2, a2, 256| (p5)moviu ac2, 4   }
;{ notp p8,p12         | bdt d9              | notp p9, p1         | bdr d12             | nop                 }
{ orp p8,p8,p0        | bdt d9              | notp p9, p1         | bdr d12             | nop                 }
{ lw r1, sp3, 44      | copy d7, a7         | copy d11, d15       | (p11)addi a2, a2, 64| copy d14, ac2       }
;(p12)
_interpolate_loop:

;_Trace_Polling3:
;{ seqiu r11,p15,p0,r0,1363  | nop 			     | nop 				       | nop  	                   | nop				      }
;{ lw r9, r12, R200_DMASR    | nop 			    | nop 				       | nop  	                   | nop				      }
;{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;{ notp p12,p0       | nop 				        | nop 				       | nop  	                   | nop				      }
;{(p15)seqiu r11, p0, p12, r9, 0 | nop 			    | nop 				       | nop  	                   | nop				      }
;;{(p12)b _Trace_Polling3 | nop     		        | nop 				       | nop  	                   | nop				      }
;{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;


.if 0
;;*******Trace
{ seqiu r11,p5,p0,r0,1362  | nop    	        | nop 				       | nop  	                   | nop				      }
{ seqiu r11,p7,p0,r0,1363  | nop 			     | nop 				       | nop  	                   | nop				      }
_Trace_Polling:
{ lw r9, r12, R200_DMASR    | nop 			    | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;{seqiu r11, p0, p12, r9, 0 | nop 			    | nop 				       | nop  	                   | nop				      }
;{(p12)b _Trace_Polling | nop     		        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;
{ moviu r13,39      | moviu a3,0x1e002300       | nop 				       | moviu a3,0x1e002698       | nop				      }
{ nop               |(p5)moviu a0,0x1e009000       | nop 				       |(p5)moviu a0,0x1e009398       | nop				      }
{ nop               |(p7)moviu a0,0x1e00a000       | nop 				       |(p7)moviu a0,0x1e00a398       | nop				      }
_Trace_loop2:
{ lbcb r13,_Trace_loop2 | dlw d2,a3,8+          | nop 				       | dlw d2,a3,8+              | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ orp p5,p5,p7      | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               |(p5)dsw d2,d3,a0,8+	    | nop 				       |(p5)dsw d2,d3,a0,8+        | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ seqiu r11,p0,p6,r0,1363  | nop 			     | nop 				       | nop  	                   | nop				      }
;
{(p6)b _jump2        | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }
;
{ nop               | nop 				        | nop 				       | nop  	                   | nop				      }

_jump2:
;;***********
.endif

{ notp p12, p2        | dbdt d4, d5         | andp p5, p9, p2     | dbdr d4             | fmuluu d15, d14, d13 }
{ andp p8, p4, p0     | (p8)add a7, d7, d4  | andp p7, p1, p2     | add a6, a2, d15     | andp p6, p1, p12    }
{ andp p4, p9, p12    | bdr a6              | extractiu ac6, d10, 8, 16| bdt a6         | copy ac0, d11       }
;(p12)
;;*****************Break_Point!!!!!!!!!
;{ seqiu r10,p0,p11,r13,0x55667788| nop 	                 | nop 				       | nop 				          | nop       }
;{(p11)b _end3 		   | nop  				        | nop                  |nop				             |nop      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end3:
;;********************************************

;;*****************Break_Point!!!!!!!!!
;{ moviu r11,GLOBAL_POINTER_ADDR  | nop 		  | nop 				       | nop  	                   | nop				      }
;{ lw r9,r11,MB_Count | nop                     | nop 				       | nop 	 	 	             | nop				      }
;{ nop                | nop 				        | nop 				       | nop  	                   | nop				      }
;{ seqiu r11,p11,p0,r12,3 | nop 				     | nop 				       | nop 				          | nop				      }
;{ nop                | nop 				        | nop                  | nop  	                   |(p11)seqiu ac7,p11,p0,ac6,1}
;{ seqiu r11,p12,p0,r9,1439| nop 	              | nop 				       | nop                      | nop       }
;;{ andp p12,p12,p14   | nop 				        | nop 				       | nop  	                   | nop				      }
;{ andp p12,p12,p11	|nop                      | nop                  | nop 				          | nop                  }
;{ nop 			      |nop                      | nop 				       |(p12)srai.d d10,d10,1      | nop				      }
;{   nop 			      |nop                      | nop                  |(p12)srai.d d10,d10,1       |(p12)copy d0,ac2      }
;{  nop 			      |(p12)bdr d3              | nop 				       |(p12)bdt d9               | nop	               }
;{    nop 			   |(p6)moviu d6,0x44556677  | nop 				    |nop                       | nop				      }
;{ notp p11,p12 	   |(p12)bdr d2   	        | nop                  |(p12)bdt d0 	          | nop				      }
;{(p11)b _end1        |(p12)moviu a6,0xb00a9000 | nop                  |nop 				          | nop				      }
;{ nop 			      |(p12)sw d6,a6,0          | nop                  | nop 				    | nop				      }
;{ nop 			      |(p12)sw d3,a6,4         | nop 				       | nop 				          | nop				      }
;{ nop 			      |nop                     | nop 				       |nop           | nop				      }
;{(p12) moviu r3,1    |nop                      |        notp p11,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p12,p0 			 | nop 				          | nop				      }
;
;{ trap               | nop 				        | nop 				       | nop 				          | nop				   }
;_end1:
;;********************************************

;{ moviu sr7,0x02015000                | nop 				        | nop 				       | nop  	                   | nop				      }

;cluster1 : d0<< ref_reg[3~0], d2<< pred[3~0], a6<<*pred[index+x], a7<<*ref_reg[index_ref+x], a4<<*ref_reg[index_ref+x+width_temp]
;cluster2 : d0<< ref_reg[7~4], d2<< pred[7~4], a6<<*pred[index+x], a7<<*ref_reg[index_ref+x], a4<<*ref_reg[index_ref+x+width_temp]

;;*	width_temp=row_step_ref*(column_size+1);
;;*	index_ref=ref_y*(column_size+1);

;;*   for(y=row_start;y<row_size;y+=row_step){
;;*		index=y*column_size;
;;*		for(x=0;x<column_size;x++){
;;*			if(!half_flag[0]){
;;*				if(!half_flag[1])   //no half-pel
;              %p4
;;*					inter_temp=ref_reg[index_ref+x];

;;					else //y-axis half-pel
;              %p5
;;*					inter_temp=(ref_reg[index_ref+x]+ref_reg[index_ref+x+width_temp]+1)>>1;
;				}
;;*			else{
;;*				if(!half_flag[1]) //x-axis half-pel
;              %p6
;;*					inter_temp=(ref_reg[index_ref+x]+ref_reg[index_ref+x+1]+1)>>1;

;;*				else  //x-axis,y-axis half-pel
;              %p7
;;						inter_temp=(ref_reg[index_ref+x]+ref_reg[index_ref+x+1]
;;								+ref_reg[index_ref+x+width_temp]+ref_reg[index_ref+x+width_temp+1]+2)>>2;
;* 			}

;;*			if(average_flag){
;           %p11
;;*				sum_temp=pred[index+x]+inter_temp;
;;*				pred[index+x]=(sum_temp+1)>>1;
;				}
;;*			else
;;*				pred[index+x]=(unsigned char)inter_temp;
;			}
;;*		index_ref+=(row_step_ref)*(column_size+1);
;		}
_inter_p4:


;--------SCT_FPGA_Trace

.if 0 
{ nop                 | lnw d0, a7, 8+      | notp p12,p0         | addi a6, a6, 4      | nop                 }
{ nop                 | nop                 | orp p9,p9,p0        | addi a7, a7, 4      | nop                 }
{ nop                 | nop                 | orp p15,p15,p0      | lnw d0, a7, 8+      | notp p11, p0        }

_p4_loop2:
{ (p15)b _p4_loop2    | (p12)unpack4u a0, d0  | notp p11, p15          | lw d2, a6, 0        | add d15, d4, ac0 }
{ (p11)b _DEMO_END2   | (p12)addi.d d6, a0, 1 | (p12)unpack4u ac4, d2  | add a5, a7, d5      | addi ac0, ac0, 8    }
{ nop                 | (p9)sw d0, a6, 8+     | nop                    | addi a7,d15,12      | (p12)unpack4u ac4, d0 }
{ notp p15,p0         |  lnw d0, a7, 8+       | (p12)add.d ac4, d6, ac4| (p12)unpack4u a0, d2| (p12)addi.d d6, ac4, 1 }
{(p15) b _DEMO_END    | (p12)addi.d d8, a1, 1 | (p12)srli.d d6, ac4, 1 |(p9)sw d0, a6, 8+    | (p12)addi.d d8, ac5, 1 }
{ notp p15,p0         | notp p8,p0            |(p12)add.d d8,d8,ac5    | lnw d0, a7, 8+      |(p12)unpack4u ac4,d2     }
;{ nop                 | notp p8,p0            |(p12)add.d d8,d8,ac5    | lnw d0, a7, 8+      |(p12)unpack4u ac4,d2     }
;(p15)
{ nop                 | nop                 | nop                 |  nop                 | nop                  }
;(p11)
{ nop                 | nop                 | nop                  | nop                  | nop                 }
{ nop                 | nop                 | nop                  | nop                  | nop                 }
{ nop                 | nop                 | nop                  | nop                  | nop                 }
;(p15)
_DEMO_END:
{ nop                    | moviu a6,0x24007500                  | moviu d0,0x45456666                | moviu a6,0x24007500                           | copy d4,ac0               }
{ nop                    | sw d0,a6,0                           | nop                                  | sw d4,a6,4                           | nop                                  }
{ trap                   | nop                                  | nop                                  | nop                           | nop                                  }
_DEMO_END2:
{ nop                    | moviu a6,0x24007500                  | moviu d0,0x12126666                | moviu a6,0x24007500                           | copy d4,ac0               }
{ nop                    | sw d0,a6,0                           | nop                                  | sw a7,a6,4                           | nop                                  }
{ trap                   | nop                                  | nop                                  | nop                           | nop                                  }
.endif


;------------------------------------------------


{ (p5)b _inter_p5     | lnw d0, a7, 8+      | seqiu ac7, p9, p12, ac6, 0| addi a6, a6, 4| add d7, d4, ac0     }
{ (p6)b _inter_p6     | lw d2, a6, 0        | andp p9, p9, p4     | addi a7, d7, 4      | andp p12, p12, p4   }
{ (p7)b _inter_p7     | add a4, a7, d5      | andp p15, p8, p9    | lnw d0, a7, 8+      | notp p11, p0        }

_inter_p4_loop:
{ (p15)b _inter_p4_loop| (p12)unpack4u a0, d0| (p9)notp p11, p15  | lw d2, a6, 0        | (p4)add d15, d4, ac0 }
{ (p11)b _interpolate_end| (p12)addi.d d6, a0, 1| (p12)unpack4u ac4, d2| add a5, a7, d5 | addi ac0, ac0, 8    }
;{ nop                 | (p9)sw d0, a6, 8+   | nop                 | (p4)addi a7, d15, 12| (p12)unpack4u ac4, d0 }
{ nop                 | (p9)sw d0, a6, 8+   | nop                 | nop                 | (p12)unpack4u ac4, d0 }
;(p5)
{ andp p15,p8,p12     | (p4)lnw d0, a7, 8+  | (p12)add.d ac4, d6, ac4| (p12)unpack4u a0, d2| (p12)addi.d d6, ac4, 1 }
;(p6)
{(p15)b _inter_p4_loop  | (p12)addi.d d8, a1, 1| (p12)srli.d d6, ac4, 1| (p9)sw d0, a6, 8+| (p12)addi.d d8, ac5, 1 }
;(p7)
{ notp p15,p0          | notp p8, p0         | (p12)add.d d8, d8, ac5| lnw d0, a7, 8+    | (p12)unpack4u ac4, d2 }
;(p15)
{ nop                 | (p12)lw a0, a6, 8   | (p12)srli.d d1, d8, 1| (p12)add.d d6, d6, a0| (p12)add.d d8, d8, ac5 }
;(p11)
{ nop                 | nop                 | (p12)pack4 d6, d6, d1| (p12)srli.d d6, d6, 1| (p12)srli.d ac7, d8, 1 }
{ nop                 | sw d6, a6, 8+       | nop                 | nop                 | (p12)pack4 d6, d6, ac7 }
{ nop                 | (p12)copy d2, a0    | nop                 | sw d6, a6, 8+       | nop                 }
;(p15)



_interpolate_end:


;------------SCT_FPGA_Trace
;{trap | nop | nop | nop | nop}
;-----------------------------

;;*****************Break_Point!!!!!!!!!
;{ moviu r11,GLOBAL_POINTER_ADDR  | nop 		  | nop 				       | nop 				          | nop				      }
;{ lw r9,r11,MB_Count | nop                     | nop 				       | nop 				          | nop				      }
;{ nop                | nop 				        | nop 				       | nop 				          | nop				      }
;{ seqiu r11,p5,p0,r12,1| nop 				        | nop 				       | nop 				          | nop				      }
;{ seqiu r11,p12,p0,r9,1439| nop 	              | nop 				       | nop 				          | seqiu ac7,p11,p0,ac6,0}
;{ andp p12,p12,p5	   | nop 		              | nop                  | nop 				          |nop      }
;{ andp p12,p12,p11   | andp p5,p9,p2           | nop 				       | nop 				          | nop				      }
;{ notp p11,p12 		|(p12)bdr a6		        | nop                  |(p12)bdt a6  	          |(p12)copy d1,ac2      }
;{(p11)b _end3 	      |(p12)moviu a5,0xb00a200c | nop                  | nop	                   | nop				      }
;{ nop 			      |(p12)moviu a7,0xb00a9000 |(p12)copy d1,ac5      | nop 				          | nop				      }
;{ nop 			      |(p12)lw d2,a6,-4         | nop                  | nop 				          | nop				      }
;{ nop 			      |(p12)sw d3,a7,4	        | nop 				       |nop           | nop				      }
;{(p12) moviu r3,1    |(p12)sw a6,a7,8          | notp p11,p0			 | nop 				          | nop				      }
;{ nop 			      |(p12)sw d2,a7,12	        | notp p12,p0 			 | nop 				          | nop				      }
;;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end3:
;;********************************************

{ bdt r1               | bdr a1             | addi ac4, d11, 1    | bdr a1              | add d14, d14, ac3   }
{ sgtiu r11, p0, p4, r10, 0| notp p9,p1     | fmuluu ac4, ac4, ac2| lbu d7, a4, MB_type | slt ac7, p11, p12, d14, d12 }
{ (p11)b _interpolate_loop| addi a0, d14, 16| add d4, d4, ac4     | lbu d15, a4, Ref_count| notp p5, p0       }
{ (p12)addi r10, r10, 1|  bdt a0            | notp p15, p0        | bdr a0              | (p12)moviu d14, 920 }
{ (p12)seqiu r11, p12, p15, r10, 3|(p12)bdr a7   | (p11)orp p8, p8, p0 |(p12)bdt d11    | andi d6, d7, macroblock_motion_backward }
{ (p15)b _interpolate_start| (p12)lhu d0, a0, half_flag_chroma_0_0| notp p10, p0| (p12)addi a7,a1,Ref_MB_0_Y| (p12)addi d15, d15, 1 }
{ (p12)addi r15, r15, (-1)| (p15)copy a0, d14| notp p11, p0       | (p12)lw a6, a0, Prediction_buf_0| (p12)fmuluu d2, d14, d15 }
{ (p12)sgtiu r11, p10, p11, r15, 0| (p12)lw d10, a0, row_size_0| nop| (p12)add a7, a7, d2| notp p3, p0        }
;;(p11)
{ (p10)b _interpolate_start| (p15)lhu d0, a0, half_flag_chroma_0_0| andp p4, p2, p0| (p10)lhu d0, a0, half_flag_0_0| (p11)sgtiu ac7, p3, p5, d6, 0 }
{ (p12)clr r10        | (p10)dbdr a6        | (p10)notp p11, p0   | (p10)dbdt a6, a7    | (p11)andp p2, p5, p0 }
{ (p10)moviu r12, EMDMAC_ADDR | nop         | nop                 | (p10)lw d10, a0, row_start_0| (p3)clr d0  }
;(p15)
{(p5)br r5            | (p3)copy a7,a1      | (p3)clr d8          | (p3)addi a7, a1,8   | (p3)clr d8 }
{(p3)b r4, _Combining_pred | (p10)copy d14, a0| (p3)clr d0        | (p12)sb d15, a4, Ref_count| (p10)orp p3, p3, p0 }
{ (p11)bdt r6         | (p11)bdr a6         | (p3)clr d5          | (p11)bdr a6         | notp p10, p0        }
;(p10)
{ bdt sp3             | bdr a0              | notp p15, p0        | bdr a0              | nop                 }
{ bdt r14             | bdr a1              | nop                 | bdr a1              | (p3)andi d6, d7, macroblock_motion_forward }
{ nop                 | lw a4,sp,40	        | nop 				  | nop 				| nop				      }
;(p5)
{ copy r4, r5         | addi a5, a7, Backward_pred_Y| nop         | addi a5, a7, Backward_pred_Y| seqiu ac7, p2, p3, d6, 0 }
;(p3)
_inter_p5:
;cluster1 : d0<< ref_reg[3~0], d2<< pred[3~0], a6<<*pred[index+x], a7<<*ref_reg[index_ref+x], a4<<*ref_reg[index_ref+x+width_temp]
;cluster2 : d0<< ref_reg[7~4], d2<< pred[7~4], a6<<*pred[index+x], a7<<*ref_reg[index_ref+x], a4<<*ref_reg[index_ref+x+width_temp]
{ nop                 | addi a4, a4, (-8)   | seqiu ac7, p9, p12, ac6, 0| addi a5, a5, (-8)| nop              }
_inter_p5_loop:

{ andp p15, p8, p9    | lnw d1, a4, 8+      | unpack4u ac4, d0    | notp p11, p0        | nop                 }
{ (p9)notp p11, p15   | (p12)unpack4u d2, d2| addi.d d8, ac5, 1   | lnw d1, a5, 8+      | unpack4u ac4, d0    }
{ nop                 | lnw d15, a7, 8+     | addi.d d6, ac4, 1   | (p12)unpack4u d2, d2| addi.d d8, ac5, 1   }
{ nop                 | unpack4u a0, d1     | (p15)notp p8, p0    | lnw d15, a7, 8+     | addi.d d6, ac4, 1   }
{ (p15)b _inter_p5_loop| add.d d6, d6, a0   | nop                 | unpack4u a0, d1     | andp p15, p8, p12   }
{ (p11)b _interpolate_end| add.d d8, d8, a1 | srli.d ac4, d6, 1   | add.d d8, d8, a1    | (p2)addi.d d2, d2, 1 }
{ (p12)notp p11, p15  | (p12)addi.d d2, d2, 1| srli.d ac5, d8, 1  | add.d d6, d6, a0    | srli.d ac5, d8, 1   }
{ (p9)notp p11, p0    | (p12)addi.d d3, d3, 1| (p9)pack4 d8, ac4, ac5| copy d0, d15     | srli.d ac4, d6, 1   }
{ (p15)b _inter_p5_loop| (p9)sw d8, a6, 8+  | (p12)add.d d6, ac4, d2| (p12)addi.d d3, d3, 1| (p9)pack4 d8, ac4, ac5 }
{ (p11)b _interpolate_end| copy d0, d15     | (p12)add.d ac5, ac5, d3| (p9)sw d8, a6, 8+| (p12)add.d d6, ac4, d2 }
;(p15)
{ nop                 | (p12)srli.d d15, d6, 1| (p12)srli.d ac5, ac5, 1| (p12)lw d2, a6, 8| (p12)add.d ac5, ac5, d3 }
;(p11)
{ nop                 | (p12)lw d2, a6, 8   | (p12)pack4 d8, d15, ac5| (p12)srli.d d15, d6, 1| (p12)srli.d ac5, ac5, 1 }
{ nop                 | (p12)sw d8, a6, 8+  | (p15)notp p8, p0    | nop                 | (p12)pack4 d8, d15, ac5 }
{ nop                 | nop                 | nop                 | (p12)sw d8, a6, 8+  | nop                 }
;(p15)
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;(p11)



;_end_p5:
;{ nop	               | moviu a6,0xb00a9000     | nop 				       | moviu a6,0xb00a9010      | nop				   }
;{ nop	               | sw a7,a6,0		        | nop		             | sw a7,a6,0		          |  nop              }
;{ nop	               | dsw d0,d1,a6,8          | nop 				       | dsw d0,d1,a6,8           | nop				   }
;{ nop	               | nop 				        | nop 				       | nop 				          | nop				   }
;{ nop	               | nop 				        | nop 				       | nop 				          | nop				   }
;{ nop	               | nop 				        | nop 				       | nop 				          | nop				   }
;{ trap               | nop 				        | nop 				       | nop 				          | nop				   }

_inter_p6:
;d5 << width_temp
;cluster1 : d0<< ref_reg[3~0], d2<< pred[3~0], a6<<*pred[index+x], a7<<*ref_reg[index_ref+x], a4<<*ref_reg[index_ref+x+1]
;cluster2 : d0<< ref_reg[7~4], d2<< pred[7~4], a6<<*pred[index+x], a7<<*ref_reg[index_ref+x], a4<<*ref_reg[index_ref+x+1]
{ nop                 | addi a4, a7, (-7)   | seqiu ac7, p9, p12, ac6, 0| addi a5, a7, (-7)| nop              }
_inter_p6_loop:
{ andp p15, p8, p9    | lnw d1, a4, 8+      | unpack4u ac4, d0    | notp p11, p0        | nop                 }
{ (p9)notp p11, p15   | (p12)unpack4u d2, d2| addi.d d8, ac5, 1   | lnw d1, a5, 8+      | unpack4u ac4, d0    }
{ nop                 | lnw d15, a7, 8+     | addi.d d6, ac4, 1   | (p12)unpack4u d2, d2| addi.d d8, ac5, 1   }
{ nop                 | unpack4u a0, d1     | (p15)notp p8, p0    | lnw d15, a7, 8+     | addi.d d6, ac4, 1   }
{ (p15)b _inter_p6_loop| add.d d6, d6, a0   | nop                 | unpack4u a0, d1     | andp p15, p8, p12   }
{ (p11)b _interpolate_end| add.d d8, d8, a1 | srli.d ac4, d6, 1   | add.d d8, d8, a1    | (p12)addi.d d2, d2, 1 }
;{(p11)b _end_p6      | add.d d8,d8,a1          | srli.d ac4,d6,1      | add.d d8,d8,a1           |(p12)addi.d d2,d2,1}
{ (p12)notp p11, p15  | (p12)addi.d d2, d2, 1| srli.d ac5, d8, 1  | add.d d6, d6, a0    | srli.d ac5, d8, 1   }
{ (p9)notp p11, p0    | (p12)addi.d d3, d3, 1| (p9)pack4 d8, ac4, ac5| copy d0, d15     | srli.d ac4, d6, 1   }
{ (p15)b _inter_p6_loop| (p9)sw d8, a6, 8+  | (p12)add.d d6, ac4, d2| (p12)addi.d d3, d3, 1| (p9)pack4 d8, ac4, ac5 }
{ (p11)b _interpolate_end| copy d0, d15     | (p12)add.d ac5, ac5, d3| (p9)sw d8, a6, 8+| (p12)add.d d6, ac4, d2 }
;(p15)
{ nop                 | (p12)srli.d d15, d6, 1| (p12)srli.d ac5, ac5, 1| (p12)lw d2, a6, 8| (p12)add.d ac5, ac5, d3 }
;(p11)
{ nop                 | (p12)lw d2, a6, 8   | (p12)pack4 d8, d15, ac5| (p12)srli.d d15, d6, 1| (p12)srli.d ac5, ac5, 1 }
{ nop                 | (p12)sw d8, a6, 8+  | (p15)notp p8, p0    | nop                 | (p12)pack4 d8, d15, ac5 }
{ nop                 | nop                 | nop                 | (p12)sw d8, a6, 8+  | nop                 }
;(p15)
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;(p11)

;_end_p6:
;;;*****************Break_Point!!!!!!!!!
;{ moviu r11,GLOBAL_POINTER_ADDR  | nop 		  | nop 				       | nop 				          | nop				      }
;{ lw r9,r11,MB_Count | nop                     | nop 				       | nop 				          | nop				      }
;{ nop                | nop 				        | nop 				       | nop 				          | nop				      }
;{ seqiu r11,p11,p0,r12,1 | nop 				     | nop 				       | nop 				          | nop				      }
;{ seqiu r11,p12,p0,r9,407| nop 	              | nop 				       | nop 				       | nop       }
;{ andp p12,p12,p11	| nop 		              | nop                  | nop 				          | nop                  }
;{ notp p11,p12 		| nop  				        | nop                  |nop				          | nop				      }
;{(p11)b _interpolate_end |nop | nop                  |nop 				          | nop				      }
;{ nop 			      |nop | nop     | nop 				    | nop				      }
;{ nop 			      |nop         | nop 				       | nop 				          | nop				      }
;{ nop 			      |nop        | nop 				       |nop           | nop				      }
;{(p12) moviu r3,1    |nop          | notp p11,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p12,p0 			 | nop 				          | nop				      }
;
;;********************************************
;{ nop	               | moviu a6,0xb00a9000     | nop 				       | moviu a6,0xb00a9020      | nop				   }
;{ nop	               | sw a0,a6,0		        | nop		             | sw a0,a6,0		          |  nop              }
;{ nop	               | sw a1,a6,4              | nop 				       | sw a1,a6,4               | nop				   }
;{ nop	               | sw a4,a6,8		        | nop 				       | sw a4,a6,8 				    | nop				   }
;{ nop	               | sw a7,a6,12		        | nop 				       | sw a7,a6,12  	          | copy d14,ac4      }
;{ nop	               | sw d8,a6,16		        | nop 				       | sw d14,a6,16  	          | copy d15,ac5      }
;{ nop	               | nop 				        | nop 				       | sw d15,a6,20             | nop				   }
;{ nop	               | nop 				        | nop 				       | nop 				          | nop				   }
;{ nop	               | nop 				        | nop 				       | nop 				          | nop				   }
;{ trap               | nop 				        | nop 				       | nop 				          | nop				   }

_inter_p7:
;cluster1 : d0<< ref_reg[3~0], d2<< pred[3~0], a6<<*pred[index+x]
;           , a7<<*ref_reg[index_ref+x],   a0<<*ref_reg[index_ref+x+width_temp]
;           , a4<<*ref_reg[index_ref+x+1], a1<<*ref_reg[index_ref+x+width_temp+1]
;cluster2 : d0<< ref_reg[7~4], d2<< pred[7~4], a6<<*pred[index+x],
;           , a7<<*ref_reg[index_ref+x],   a0<<*ref_reg[index_ref+x+width_temp]
;           , a4<<*ref_reg[index_ref+x+1], a1<<*ref_reg[index_ref+x+width_temp+1]
{ nop                 | addi a0, a4, (-8)   | seqiu ac7, p9, p12, ac6, 0| addi a0, a5, (-8)| nop              }
{ nop                 | addi a1, a0, 1      | nop                 | addi a1, a0, 1      | nop                 }
{ bdr r9              | addi a4, a7, (-7)   | nop                 | bdt d4              | nop                 }
_inter_p7_loop:
{ andp p15, p8, p9    | lnw d1, a0, 8+      | unpack4u ac4, d0    | addi a5, a7, (-7)   | unpack4u ac4, d0    }
{ notp p11, p0        | (p12)unpack4u d2, d2| addi.d ac4, ac4, 2  | lnw d1, a0, 8+      | addi.d ac4, ac4, 2  }
{ nop                 | lnw d12, a1, 8+     | addi.d ac5, ac5, 2  | (p12)unpack4u d2, d2| addi.d ac5, ac5, 2  }
{ nop                 | (p15)notp p8, p0    | unpack4u d0, d1     | lnw d12, a1, 8+     | nop                 }
{ nop                 | lnw d4, a4, 8+      | add.d ac4, ac4, d0  | nop                 | unpack4u d0, d1     }
{ nop                 | unpack4u d12, d12   | add.d ac5, ac5, d1  | lnw d4, a5, 0       | add.d ac4, ac4, d0  }
{ nop                 | lnw d15, a7, 8+     | add.d ac4, ac4, d12 | unpack4u d8, d12    | add.d ac5, ac5, d1  }
{ (p9)notp p11, p15   | unpack4u d0, d4     | add.d ac5, ac5, d13 | lnw d15, a7, 8+     | add.d ac4, ac4, d8  }
{ bdt r9              | bdr d4              | add.d ac4, ac4, d0  | unpack4u d0, d4     | add.d ac5, ac5, d9  }
{ (p15)b _inter_p7_loop| copy d0, d15       | add.d ac5, ac5, d1  | andp p15, p8, p12   | add.d ac4, ac4, d0  }
{ (p11)b _interpolate_end| (p12)addi.d d2, d2, 1| srli.d ac4, ac4, 2| copy d0, d15      | add.d ac5, d1, ac5  }
;{(p11)b _end_p7      |(p12)addi.d d2,d2,1      | srli.d ac4,ac4,2     | copy d0,d15  	          | add.d ac5,ac5,d1	}
{ (p12)notp p11, p15  | (p12)addi.d d3, d3, 1| srli.d ac5, ac5, 2 | (p12)addi.d d2, d2, 1| srli.d ac4, ac4, 2 }
{ (p9)notp p11, p0    | bdt d9              | (p9)pack4 d8, ac4, ac5| bdr d12           | srli.d ac5, ac5, 2  }
{ (p15)b _inter_p7_loop| (p9)sw d8, a6, 8+  | (p12)add.d d15, ac4, d2| (p12)addi.d d3, d3, 1| (p9)pack4 d8, ac4, ac5 }
{ (p11)b _interpolate_end| nop              | (p12)add.d ac7, ac5, d3| (p9)sw d8, a6, 8+| (p12)add.d d15, ac4, d2 }
;(p15)
{ nop                 | (p12)srli.d d15, d15, 1| (p12)srli.d ac7, ac7, 1| (p12)lw d2, a6, 8| (p12)add.d ac5, ac5, d3 }
;(p11)
{ nop                 | (p12)lw d2, a6, 8   | (p12)pack4 d8, d15, ac7| (p12)srli.d d15, d15, 1| (p12)srli.d ac5, ac5, 1 }
{ nop                 | (p12)sw d8, a6, 8+  | nop                 | nop                 | (p12)pack4 d8, d15, ac5 }
{ nop                 | nop                 | (p15)notp p8, p0    | (p12)sw d8, a6, 8+  | nop                 }
;(p15)
{ nop                 | nop                 | nop                 | nop                 | nop                 }
;(p11)

;_end_p7:
;{ nop	               | moviu a6,0xb00a9000     | nop 				       | moviu a6,0xb00a9020      | nop				   }
;{ nop	               | sw a0,a6,0		        | nop		             | sw a0,a6,0		          |  nop              }
;{ nop	               | sw a1,a6,4              | nop 				       | sw a1,a6,4               | nop				   }
;{ nop	               | sw a4,a6,8		        | nop 				       | sw a4,a6,8 				    | nop				   }
;{ nop	               | sw a7,a6,12		        | nop 				       | sw a7,a6,12  	          | copy d14,ac4      }
;{ nop	               | sw d8,a6,16		        | nop 				       | sw d14,a6,16  	          | copy d15,ac5      }
;{ nop	               | nop 				        | nop 				       | sw d15,a6,20             | nop				   }
;{ nop	               | nop 				        | nop 				       | nop 				          | nop				   }
;{ nop	               | nop 				        | nop 				       | nop 				          | nop				   }
;{ trap               | nop 				        | nop 				       | nop 				          | nop				   }

;{ br r4 			      | nop 				        | nop                  | nop 				          | nop				   }
;{ nop 			      | nop 				        | nop                  | nop 				          | nop				   }
;{ nop 			      | nop 				        | nop                  | nop 				          | nop				   }
;{ nop 			      | nop 				        | nop                  | nop 				          | nop				   }
;{ nop   	            | nop			              | nop 				       | nop 				          | nop				   }
;{ nop                | nop 				        | nop 				       | nop 				          | nop				   }
.endp	Slice
;----------------------------------------

;-----------mc.s--------------
.proc	mc
.global	mc
mc:


;{ br r4 	            | nop 				        | nop 				       | nop 				          | nop				      }
;{ nop 	            | nop 				        | nop 				       | nop 				          | nop				      }
;{ nop 	            | nop 				        | nop 				       | nop 				          | nop				      }
;{ nop 	            | nop 				        | nop 				       | nop 				          | nop				      }
;{ nop 	            | nop 				        | nop 				       | nop 				          | nop				      }
;{trap 	            | nop 				        | nop 				       | nop 				          | nop				      }

.if 0
;;*****************Break_Point!!!!!!!!!
{ moviu r11,GLOBAL_POINTER_ADDR  | nop 		  | nop 				       | nop 				    | nop				      }
{ lw r9,r11,MB_Count | nop                     | nop 				       | nop 				          | nop				      }
{ nop                | nop 				        | nop 				       | nop 				    | nop				      }
{ nop 			      | nop   	                 | nop 				       | nop 				          | nop				      }
{ seqiu r11,p12,p0,r9,396| nop 	                 | nop 				       | nop 				          | orp p11,p11,p0      }
{ notp p11,p12 		| nop  				        | nop                  |nop				          | nop				      }
{(p11)b _end5 	      |(p15)moviu d0,0x55667788 | nop                  |nop 				          | nop				      }
{ nop 			      |(p12)moviu a7,0x24007500 |(p12)copy d1,ac3      | nop 				    | nop				      }
{(p12)bdt r10	      |(p12)bdr d8              | nop 				       | nop 				          | nop				      }
{ nop 			      |(p12)sw d1,a7,4	        | nop 				       |nop           | nop				      }
{(p12) moviu r3,1    |(p12)sw d8,a7,8          | notp p11,p0			 | nop 				          | nop				      }
{ nop 			      | nop 				        | notp p12,p0 			 | nop 				          | nop				      }
;;
{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
_end5:
;;********************************************
.endif

;scalar: r6<<pbs, r14<<shead,
;cluster1,2: a1<<shead, a2<< pdata, a4<<sdata, a6<<pbs
;cluster2: a3 << MB_type
{ lw r6,sp3,4        | lw a6,sp,4   	        | nop 				       | lw a6,sp2,4		          | nop				   }
{ lw r14,sp3,8       | lw a4,sp,44 				| nop 				       | lw a4,sp2,44  	          | nop				   }
{ nop                 | lw a2,sp,16  	        | nop 				       | lw a2,sp2,16	          | nop				   }
{ nop 			      | lw a1,sp,8		        | nop 				       | lw a1,sp2,8              | nop				   }
;
;;*if(sdata->Mode_select<2){
; % p1
;		sdata->field_select=sdata->motion_vertical_field_select[0][i];
;;*		Prediction_search(i,&sdata->MV0,0,0,shead,gop,pdata,sdata,Fmem);  //7.6.4
;}
;;*	else{
; % p2
;;*		if(sdata->motion_vector_count==1){
;     %p3
;;*			if((sdata->mv_format==1) && (sdata->dmv!=1)){
;            %p5 && p6
;;*				sdata->motion_vertical_field_select[0][i]=(unsigned char)(readbits(pbs,1,shead));
;;*				sdata->field_select=sdata->motion_vertical_field_select[0][i];
;;*			}
;;*		motion_vector(0,i,pbs,shead,gop,pdata,sdata,Fmem);
;;*			if(shead->Error_flag)
;        %p15
;;*				return;
;;*		}
;;*		else{
;     %p4
;;*			sdata->motion_vertical_field_select[0][i]=(unsigned char)(readbits(pbs,1,shead));
;;*			sdata->field_select=sdata->motion_vertical_field_select[0][i];
;;*		motion_vector(0,i,pbs,shead,gop,pdata,sdata,Fmem);
;;*			if(shead->Error_flag)
;        %p15
;;*				return;
;;*			sdata->motion_vertical_field_select[1][i]=(unsigned char)(readbits(pbs,1,shead));
;;*			sdata->field_select=sdata->motion_vertical_field_select[1][i];
;;*			motion_vector(1,i,pbs,shead,gop,pdata,sdata,Fmem);
;;*			if(shead->Error_flag)
;        %p15
;;*				return;
;;		}
;cluster1: d0<<motion_vector_count, d1<< mv_format, d13<< s, ac4<< flag=1:Has executed Prediction_search program
;         , ac3<< flag2=1 << execute _mc_loop for twice!!
;cluster2: d0<<Mode_select, d1<<dmv, ac1 << r
{ notp p12,p0        | lbu d0,a4,motion_vector_count | nop 	          | lbu d0,a4,Mode_select    | notp p15,p0  	   }
{ notp p7,p0         | lbu d1,a4,mv_format     | nop 				       | lbu d1,a4,dmv            | nop				   }
{ notp p5,p0	      | notp p11,p0             | clr ac3  		       | lw d9,sp2,0     	          | nop				   }
{ notp p6,p0	      | nop 				        | seqiu ac7,p3,p4,d0,1 | nop 				      | sltiu ac7,p1,p2,d0,2}
{(p1)b _prediction_search| nop	              |(p3)seqiu ac7,p5,p0,d1,1 |(p1)addi a3,a4,MV0_vector_0_0|(p3)seqiu ac7,p8,p6,d1,1}
{(p1)copy r5,r4	   | andp p4,p4,p2	        |(p1)clr ac6 	           |(p1)add a5,a4,d9              |(p2)andp p5,p5,p6  }
{(p2)orp p12,p3,p4   | andp p3,p3,p2	        |(p4)moviu ac3,2       |(p1)lbu d9,a5,motion_vertical_field_select_0_0 |(p2)orp p11,p5,p4}
_mc_loop:
{(p11)b r1,_readbits | nop 				        |(p11)moviu d0,1       | nop 				          |(p11)clr ac2  	   }
{ nop 			      |(p11)lw d13,sp,0	        | nop 				   | nop 				          |(p1)clr ac1		   }
{(p11)bdt r6          |(p11)bdr a6		        | nop                  |(p1)sb d9,a4,field_select     | nop				   }
;;(p1)
{ nop 			      | nop 				        | nop                  | nop 				          | nop				   }
{ nop   	            | nop			              | nop 				       | nop 				          | nop				   }
{ nop                | nop 				        | nop 				       | nop 				          | nop				   }
;;(p11)
{(p12)b r2,_motion_vector | nop                | notp p1,p0           | notp p2,p0 		          | nop  	            }
{(p9)sb r13,r14,Error_flag| nop                |(p11)seqiu ac7,p2,p1,ac3,1| nop 				       | clr ac1				}
{ nop                |(p1)addi a5,d13,motion_vertical_field_select_0_0 | nop 	| nop 	          | nop			      }
{ nop 			      |(p2)addi a5,d13,motion_vertical_field_select_1_0 | nop 	| nop 				 |(p2)moviu ac1,1	   }
;;(p1)


{ nop 			      |(p11)sb d5,a4,a5         | nop                  | nop 				          | nop				   }
{ nop 			      |(p11)sb d5,a4,field_select | nop 				    | nop 				          | nop				   }
;;(p12)

;;*****************Break_Point!!!!!!!!!
;{ moviu r11,GLOBAL_POINTER_ADDR  | nop 		  | nop 				       | nop 				    | nop				      }
;{ lw r9,r11,MB_Count | nop                     | nop 				       | nop 				          | nop				      }
;{ nop                | nop 				        | nop 				       | nop 				    | nop				      }
;{ nop 			      | nop   	                 | nop 				       | nop 				          | nop				      }
;{ seqiu r11,p12,p0,r9,719| nop 	                 | nop 				       | nop 				          | orp p11,p11,p0      }
;{ notp p11,p12 		| nop  				        | nop                  |nop				          | nop				      }
;{(p11)b _end3 	      |(p15)moviu d0,0x55667788 | nop                  |nop 				          | nop				      }
;{ nop 			      |(p12)moviu a7,0xb00a9000 |(p12)copy d1,ac3      | nop 				    | nop				      }
;{(p12)bdt r10	      |(p12)bdr d8              | nop 				       | nop 				          | nop				      }
;{ nop 			      |(p12)sw d1,a7,4	        | nop 				       |nop           | nop				      }
;{(p12) moviu r3,1    |(p12)sw d8,a7,8          | notp p11,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p12,p0 			 | nop 				          | nop				      }
;;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end3:
;;********************************************

{(p15)br r4 			| lbu d0,a4,prediction_type  | sgtiu ac7,p11,p0,ac3,1| nop 				       | notp p12,p15		}
{ andp p12,p12,p11   | notp p4,p0    	        |(p15)clr d5           | lw d0,a4,PMV0_0_0        | notp p10,p11	   }
{(p12)b _mc_loop     | notp p7,p0              |(p12)addi ac3,ac3,(-1)| notp p3,p0  	          | nop				   }
{(p12)orp p11,p11,p0 | lbu d1,a2,picture_structure |(p10)seqiu ac7,p3,p4,d0,2| lbu d8,a4,MB_type | notp p8,p0        }
{(p3)br r4           | nop		                 |(p4)seqiu ac7,p8,p0,d0,1|(p3)sw d0,a4,PMV1_0_0   | notp p6,p0		   }
{ notp p5,p0	      | lbu d8,a2,concealment_motion_vectors |(p4)seqiu ac7,p7,p0,d0,0| nop       |(p10)notp p11,p0   }
;;(p15)
{ notp p1,p0         | dlw d4,a4,PMV0_0_0      |(p4)seqiu ac7,p5,p6,d1,Frame_picture|(p3)notp p10,p0 | andi ac2,d8,macroblock_intra}
{ andp p6,p6,p8      | dlw d6,a4,PMV1_0_0 	  | andp p5,p5,p7        | andi d2,d8,macroblock_motion_forward |(p4)sgtiu ac7,p9,p10,ac2,0}
;;(p12)
;//**Table 7-9/7-10 updating of MV predictors in frame/field pictures
;;*if(sdata->prediction_type==2){
; % p3
;;*   sdata->PMV1[0][0]=sdata->PMV0[0][0];
;;*   sdata->PMV1[0][1]=sdata->PMV0[0][1];
;;		}
;;*else if((pdata->picture_structure==Frame_picture && sdata->prediction_type==0)
;;*			|| (pdata->picture_structure!=Frame_picture && sdata->prediction_type==1)){
; % p4 && ((p5 && p7)||(p6 && p8))
;;*		if(sdata->MB_type & macroblock_intra){
;    % p9
;;*			if(pdata->concealment_motion_vectors==0){
;        %p1
;;*				sdata->PMV0[0][0]=sdata->PMV0[0][1]=sdata->PMV0[1][0]=sdata->PMV0[1][1]=0;
;;*				sdata->PMV1[0][0]=sdata->PMV1[0][1]=sdata->PMV1[1][0]=sdata->PMV1[1][1]=0;
;;*			}
;;*			else{
;        %p2
;;*				sdata->PMV1[0][0]=sdata->PMV0[0][0];
;;*				sdata->PMV1[0][1]=sdata->PMV0[0][1];
;;*			}
;;*		}
;;*		else{
;     %p10
;;*			if(sdata->MB_type & macroblock_motion_forward){
;        %p15
;;				sdata->PMV1[0][0]=sdata->PMV0[0][0];
;;				sdata->PMV1[0][1]=sdata->PMV0[0][1];
;;			}
;;*			if(sdata->MB_type & macroblock_motion_backward){
;        %p11
;;				sdata->PMV1[1][0]=sdata->PMV0[1][0];
;;				sdata->PMV1[1][1]=sdata->PMV0[1][1];
;;			}
;;		}
;;	}
;cluster1: d8<<concealment_motion_vectors, d4 d5<<PMV0, d6 d7<<PMV1
;cluster2: d8<<MB_type

;;*****************Break_Point!!!!!!!!!
;{ moviu r11,GLOBAL_POINTER_ADDR  | nop 		  | nop 				       | nop 				    | nop				      }
;{ lw r9,r11,MB_Count | nop                     | nop 				       | nop 				          | nop				      }
;{ nop                | nop 				        | nop 				       | nop 				    | nop				      }
;{ nop 			      | nop   	                 | nop 				       | nop 				          | nop				      }
;{ seqiu r11,p12,p0,r9,675| nop 	                 |  orp p11,p11,p0  | nop 				          |nop       }
;{ andp p12,p12,p11	| nop 		              | nop                  | nop 				          | nop                  }
;{ notp p11,p12 		| nop  				        | nop                  |nop				          | nop				      }
;{(p11)b _end1 	      |(p10)moviu d0,0x55667788 | nop                  |nop 				          | nop				      }
;{ nop 			      |(p12)moviu a7,0xb00a9000 |(p12)copy d1,ac3      | nop 				    | nop				      }
;{nop	      |(p12)bdr d8              | nop 				       |(p12)bdt d8 				          | nop				      }
;{ nop 			      |(p12)sw d0,a7,4	        | nop 				       |nop           | nop				      }
;{(p12) moviu r3,1    |(p12)sw d8,a7,8          | notp p11,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p12,p0 			 | nop 				          | nop				      }
;;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end1:
;;********************************************

{ orp p5,p5,p6       |(p3)clr d5			        |(p9)seqiu ac7,p1,p2,d8,0|(p10)sgtiu d7,p15,p0,d2,0| andi ac2,d8,macroblock_motion_backward}
{(p4)br r4           | nop	                    | andp p1,p1,p5        | dclr d0			          |(p10)sgtiu ac7,p11,p0,ac2,0}
;;(p3)
{ nop                | nop 				        | andp p2,p2,p5        |(p1)dsw d0,d1,a4,PMV0_0_0 | andp p15,p15,p5   }
{ nop 			      | nop                     |(p10)notp p2,p0       |(p1)dsw d0,d1,a4,PMV1_0_0 | andp p11,p11,p5   }
{ nop                |(p11)sw d5,a4,PMV1_1_0   | orp p2,p2,p15 		 | nop 				          | nop				   }
{ nop  	            |(p2)sw d4,a4,PMV1_0_0    | nop 				       | nop 				          | nop				   }
{ nop 			      | clr d5 				     | notp p15,p0	       | nop 				          | nop				   }
;

;void motion_vector(int r,int s,Bitstream *pbs,Seq_header *shead,GOP_data *gop
;				   ,Picture_data *pdata,Slice_data *sdata,Frame_memory *Fmem){
;	typedef struct {
;	short opposite_vec[2][2];
;	signed char dmvector[2];
;	} Dual_primed_reg;
;	int t;
;	unsigned char temp,temp2;
;	short f_value,high,low,range;
;	short (*PMV)[2],delta,prediction;
;	Dual_primed_reg Dual_reg={0};
;	MV_data *MV;

;;*   MV=(r==0) ? &sdata->MV0 : &sdata->MV1;
;;	for(t=0;t<2;t++){
;;*		motion_code=Search_Motion_code(pbs,shead);    //1~11bits
;;*		if(shead->Error_flag)
;;*				return;
;;	*	if((pdata->f_code[s][t]!=1) && (motion_code!=0))
;        %p15=p1 && p2
;;*			motion_residual=(unsigned char)(readbits(pbs,(unsigned char)(pdata->f_code[s][t]-1),shead));
;;		if(sdata->dmv==1)
;     %p11
;;			Dual_reg.dmvector[t]= ((readbits(pbs,1,shead)==0) ? 0 : ((readbits(pbs,1,shead)==0) ? 1 : -1));
;                                                                        % ?p1:p2
_motion_vector:
;*******************Not change
;cluster1: ac3<< flag2=1 << execute _mc_loop for twice!!
;cluster2: ac1 << r ,ac6<<t
;*******************************

;cluster1: d11<< motion_code, d12<< [s][t]
;cluster2: a3<< *MV, d10<<[s][t]
{ nop                | nop 				        | nop 				       | addi a3,a4,MV0_vector_0_0| seqiu ac7,p0,p1,ac1,0}
{ nop 			      | nop 				        | nop 				       |(p1)addi a3,a4,MV1_vector_0_0 | clr ac6				}
_motion_loop:
;signed char Search_Motion_code(Bitstream *pbs,Seq_header *shead){
;	unsigned short cache;
;	unsigned char bit_offset;
;	unsigned char BitLeft;
;;	cache=(unsigned short)(readbits(pbs,11,shead)); //11bits
;;	BitLeft=pbs->BitLeftInCache;
;;	bit_offset=Table_Search(cache,11,&(coef_token_table[5]),shead);
;;	if(shead->Error_flag){
;  %p15
;;		printf("Error for motion_type!!\n");
;;		return 0;
;	}
;;	else{
;  %p2
;;		pbs->BitLeftInCache=BitLeft+(11-bit_offset);
;;		if(pair->value.val>16)
;     %p3
;;			return (signed char)(16-pair->value.val);
;;		else
;     %p4
;;			return (signed char)pair->value.val;
;	}



;;*************Search_Motion_Code*************
{ b r1,_readbits 	   | nop 				        | moviu d0,11 			 | copy d5,a2 				    | clr ac2				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | copy ac5,d5				}
{ nop 			      | nop 				        | nop 				       | lw a2,sp2,28 				 | nop				      }
{ nop 			      | lw a7,sp,28 				  | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;
{ b r1,_table_search | copy d0,a2              | moviu d13,11 			 | lbu d11,a6,BitLeftInCache| nop				      }
{(p9)sb r13,r14,Error_flag | addi a2,a7,B10_startbit  | copy ac1,d0   | addi a2,a2,B10_startbit  | nop				      }
{ nop 			      | lw d0,sp,0		        | clr d15 		       | nop 				          | nop				      }
{ nop 			      | lbu d14,a2,0  			  | nop 				       | nop 				          | nop				      }
{ nop 			      | nop                     | moviu d8,1 			 | nop 				          | nop				      }
{ clr r13 			   | moviu d11,2		        | copy ac0,d0			 | nop 				          | clr ac2				   }
;
{ sgtiu r11,p15,p2,r13,0 | bdt d15             | moviu ac2,16         | bdr d15  	             | copy d5,ac6				}
{(p15)br r2          | bdr a3  	              |(p2)extractiu d8,d2,6,4 | bdt d5 			       | notp p4,p0  	      }
{ sb r13,r14,Error_flag	| lw a2,sp,16          |fmuluu d5,ac0,d11     | notp p3,p0               | addi d11,d11,11      }
{ nop 			      | add d0,a3,d5            |(p2)sgtiu ac7,p3,p4,d8,16  |(p2)sub d11,d11,d15  | nop				      }
{ nop 			      | addi a3,d0,f_code00     |(p15)clr d11          |(p2)sb d11,a6,BitLeftInCache | copy d5,ac5  	   }
{ nop                | lbu d1,a2,a3            |(p3)sub d11,ac2,d8    | copy a2,d5 				    | nop				      }
{ nop 			      | nop                     |(p4)copy d11,d8       | lbu d0,a4,dmv            | nop				   }
;(p15)**********************************************

;;*****************Break_Point!!!!!!!!!
;{ moviu r11,GLOBAL_POINTER_ADDR  | nop 		  | nop 				       | nop 				    | nop				      }
;{ lw r9,r11,MB_Count | nop                     | nop 				       | nop 				          | nop				      }
;{ nop                | nop 				        | nop 				       | nop 				    | nop				      }
;{ nop 			      | nop   	                 | nop 				       | nop 				          | nop				      }
;{ seqiu r11,p12,p0,r9,17571| nop 	                 | nop 				       | nop 				          | orp p11,p11,p0      }
;{ andp p12,p12,p11	| nop 		              | nop                  | nop 				          | nop                  }
;{ notp p11,p12 		| nop  				        | nop                  |nop				          | nop				      }
;{(p11)b _end1 	      |nop                      | nop                  |nop 				          |(p12)copy d0,ac1     }
;{ nop 			      |(p12)moviu a7,0xb00a9000 |(p12)copy d1,ac1      | nop 				    | nop				      }
;{(p12)bdt r10	      |(p12)bdr d8              | nop 				       |(p12)bdt d0 				          | nop				      }
;{ nop 			      |(p12)sw d1,a7,4	        | nop 				       |nop           | nop				      }
;{(p12) moviu r3,1    |(p12)sw d8,a7,8          | notp p11,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p12,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end1:
;;********************************************

{ nop 			      | copy d12,d0             | seqi ac7,p0,p2,d11,0 | nop			             | nop				   }
{ nop 			      | lw a5,sp,0              | seqiu ac7,p0,p1,d1,1 | nop 				       | nop				   }
{ andp p15,p1,p2     | bdt d12				    | nop 				       | bdr d10			             | seqiu ac7,p11,p0,d0,1}
{(p15)b r1,_readbits | orp p3,p11,p15          |(p15)addi d0,d1,(-1)  | notp p12,p11	          |(p15)clr ac2  	   }
{ notp p3,p3         | add a5,a5,a2	        | nop 				       | nop 				          | nop				   }
{(p3)b _mv_computation| lbu d13,a5,full_pel_vector_0 | nop			       | nop		                | nop				   }
{(p3)notp p12,p0     | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | bdt d13			        | nop 				       | bdr d11 				          | nop				   }
;(p15)



{(p11)b r1,_readbits | nop 				        |(p11)moviu d0,1       | nop 				          |(p11)clr ac2 	   }
{(p12)b _mv_computation| nop                   |(p15)copy d13,d5      | nop		                | copy ac3,d11				   }
;(p3)
{(p9)sb r13,r14,Error_flag| nop 				     | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;(p11)
{ nop 			      | nop 				        | seqiu ac7,p1,p11,d5,0 | nop 				          | nop				   }
;(p12)
{(p11)b r1,_readbits | notp p2,p0	           |(p11)moviu d0,1 		 | notp p3,p0	             |(p11)clr ac2		   }
{ nop                 | nop 				        | nop 				       | nop 				          |(p1)seqiu ac7,p2,p3,ac6,0}
{(p9)sb r13,r14,Error_flag|(p2)sb d5,a4,dmvector_0  | nop 				 | nop 				          | nop				   }
{ nop 			      |(p3)sb d5,a4,dmvector_1  | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
{ nop 			      | nop 				        | nop 				       | nop 				          | nop				   }
;(p11)


;	//******************Compute the real values of motion vectors
;;*	PMV=(r==0) ? sdata->PMV0 : sdata->PMV1;
;      % ? p5 : p6
;;*	f_value=1<<(pdata->f_code[s][t]-1);
;;*	high=f_value<<4;
;;*		low=-high;
;;*		range=high<<1;
;;*		high--;

;;*	if(f_value==1 || motion_code==0)
;            % p3
;;*			delta=motion_code;
;;*	else{
;        % p15
;;*			delta=(abs(motion_code)-1)*f_value+motion_residual+1;
;;*			if(motion_code<0)
;            % p5
;;*			delta=-delta;
;;*	}
;;*	prediction=PMV[s][t];
;;*		if(sdata->mv_format==1 && t==1 && pdata->picture_structure==Frame_picture)
;     %  p10=p8 && p7 && p9
;;*			prediction>>=1;
;;*		MV->vector[s][t]=prediction+delta;

;;*		if(MV->vector[s][t]<low)           //<low
;;*			MV->vector[s][t]+=range;
;;*		if(MV->vector[s][t]>high) //>high
;;**			MV->vector[s][t]-=range;

;;*		PMV[s][t]=MV->vector[s][t];
;;*		if(sdata->mv_format==1 && t==1 && pdata->picture_structure==Frame_picture)
;      %p10
;;*			PMV[s][t]<<=1;
;	//*******************
;*******************Not change
;cluster1: ac3<< flag2=1 << execute _mc_loop for twice!!
;cluster2: ac1 << r, ac6<<t
;*******************************

;cluster1: d11<< motion_code, d12<< [s][t], d13<<motion_residual, d0<<delta,
;cluster2: a3<< *MV, a7<<*PMV, d1<<f_value, d8<<high,d9<<low, d11<<range, d10<<[s][t], d4<<prediction

_mv_computation:
{ notp p2,p0         | nop   		           | notp p1,p0           | add a5,a2,d10            | seqiu ac7,p12,p7,ac6,0}
{ andp p4,p7,p11     | moviu d8,1              |(p11)seqiu ac7,p1,p2,d5,0| lbu d0,a5,f_code00    | seqiu ac7,p5,p6,ac1,0}
{ lbu r13,r14,Error_flag |(p11)moviu a5,dmvector_0 |(p1)copy d2,d8    |(p5)addi a7,a4,PMV0_0_0   | add d10,d10,d10   }
{ notp p5,p0         |(p4)moviu a5,dmvector_1  |(p2)neg d2,d8	       |(p6)addi a7,a4,PMV1_0_0   | moviu d8,1		   }
{ notp p3,p15        |(p11)sb d2,a4,a5         |(p15)slti ac7,p5,p0,d11,0 | add a7,a7,d10        | addi d13,d0,(-1)  }
{ nop 			      | lbu d3,a4,mv_format     |(p15)abs d8,d11       | sll d1,d8,d13           | sgtiu ac7,p6,p0,ac3,0}
{ nop 			      | lbu d6,a2,picture_structure|(p15)addi d8,d8,(-1) | add a5,a3,d10          | slli d8,d1,4      }
{ nop 			      |(p15)bdr d9  		        |(p3)copy d0,d11       |(p15)bdt d1		          | neg d9,d8         }
{ nop                | seqiu a7,p8,p0,d3,1     |(p15)addi d13,d13,1   | lh d4,a7,0               | slli d11,d8,1     }
{ andp p10,p7,p8     | seqiu a7,p9,p11,d6,Frame_picture|(p15)fmul ac2,d8,d9   |(p7)lbu d1,a4,prediction_type| notp p3,p0}
{ andp p10,p10,p9    |(p7)lbu d14,a4,MB_type    |(p15)add d0,ac2,d13   | addi d8,d8,(-1) 			 | notp p4,p0        }
{ notp p15,p0        | nop 				        | orp p10,p10,p6       | nop 				          | nop				   }
{ notp p6,p0        |(p5)neg d0,d0 	        |(p7)moviu ac5,macroblock_motion_forward| notp p8,p0 |(p10)srai d4,d4,1  }
{ sgtiu r11,p15,p2,r13,0| bdt d0 				  |(p7)ori ac5,ac5,macroblock_motion_backward| bdr d0 |(p7)seqiu ac7,p3,p4,d1,2}
{(p15)br r2  	      |(p3)bdr a3               |(p4)and d14,d14,ac5     |(p3)bdt a3   		       | notp p5,p0  	   }
{ clr r13		      |(p3)lh d15,a4,dmvector_0 |(p4)sgtiu ac7,p5,p6,d14,0| add d15,d0,d4         | notp p7,p0		   }
{(p5)copy r5,r2      | nop                     |(p15)notp p12,p0      | nop                      | slt ac7,p1,p0,d15,d9}
{ andp p9,p9,p3      |(p15)notp p5,p0	        |(p3)clr d7  	       |(p3)lbu d0,a2,top_field_first| sgt ac7,p2,p0,d15,d8}
{ (p12)b _motion_loop|(p3)unpack4 d2,d15   |(p11)seqiu ac7,p7,p8,d6,Top_field| nop 		 |(p1)add d15,d15,d11}
{(p5)b _prediction_search | nop                | nop                  | nop 				          |(p2)sub d15,d15,d11}
;(p15)
{(p6)br r2           | andp p7,p7,p3           | nop                  | sh d15,a5,0  	          |(p12)addi ac6,ac6,1}
{ andp p8,p8,p3      |(p3)copy d15,d3          | nop                  | notp p1,p0 				    |(p10)slli d15,d15,1}
{ nop 			      |(p3)lw d0,a3,0           | notp p2,p0          | sh d15,a7,0  	          | sgtiu ac7,p6,p0,ac3,0}
{ nop                | nop                     |(p5)clr ac6           |(p6)sh d15,a5,0   	          |(p9)sgtiu ac7,p1,p2,d0,0}
;;(p12)
{ nop                | nop       		        | nop 				       | nop 				          | nop				      }
;(p5)
{ nop                | nop 				        |(p3)sgt.l ac5,p6,p0,d0,d7 | nop 				       | nop				      }
{ nop                | nop 				        |(p3)sgt.h ac6,p6,p0,d0,d7 | nop 				       | nop				      }
{ nop                | nop 				        |(p3)pack4 ac7,ac6,ac5 | nop 				          | nop				      }
{ nop                | nop 				        |(p3)add.d d14,d0,ac7  | nop 				          | nop				      }
{ nop                |(p3)srai.d d14,d14,1     | nop 				       | nop 				          | nop				      }

;;*if(sdata->prediction_type==2){
;  % p3
;;*	temp=(MV->vector[0][0]>0) ? 1 : 0;
;;*	temp2=(MV->vector[0][1]>0)? 1 : 0;
;;*	sdata->opposite_vec[0][0]=sdata->opposite_vec[1][0]=((MV->vector[0][0]+temp)>>1)+sdata->dmvector[0];
;;*	sdata->opposite_vec[0][1]=sdata->opposite_vec[1][1]=((MV->vector[0][1]+temp2)>>1)+sdata->dmvector[1];
;;*	if(pdata->picture_structure==Frame_picture){
;     %p9
;;*		sdata->opposite_vec[0][1]++;
;;*		sdata->opposite_vec[1][1]--;
;;*		if(pdata->top_field_first==1){
;        %p1
;;*			sdata->opposite_vec[0][0]+=MV->vector[0][0];  //top->bottom
;;*			sdata->opposite_vec[0][1]+=MV->vector[0][1];
;;			}
;;*		else{
;        %p2
;;*			sdata->opposite_vec[1][0]+=MV->vector[0][0];   //bottom->top
;;*			sdata->opposite_vec[1][1]+=MV->vector[0][1];
;;			}
;;*		for(t=0;t<4;t++){
;;*			if(t<2){  //prediction with same parity
;;*				if(t==0)//top->top
;              %p3
;;*					sdata->field_select=r=0;
;;*				else   //bottom->bottom
;              %p4
;;*					sdata->field_select=r=1;
;;				}
;;*			else{  //prediction with opposite parity
;;*				if(t==2){ //bottom->top
;              %p5
;;*					sdata->field_select=1;
;;						r=0;
;;*					MV->vector[0][0]=sdata->opposite_vec[1][0];
;;*					MV->vector[0][1]=sdata->opposite_vec[1][1];
;;					}
;;*				else{    //top->bottom
;              %p6
;;*					sdata->field_select=0;
;;*					r=1;
;;*					MV->vector[0][0]=sdata->opposite_vec[0][0];
;;*					MV->vector[0][1]=sdata->opposite_vec[0][1];
;;					}
;;				}
;;*			temp=(r==sdata->field_select) ? 0 : 1;
;;*			Prediction_search(s,MV,r,temp,shead,gop,pdata,sdata,Fmem);  //7.6.4
;;			}
;;		}
;;*	else{
;     %p11
;;*		if(pdata->picture_structure==Top_field)   //bottom->top
;        % p7
;;*		sdata->opposite_vec[0][1]--;
;;*		else
;        %p8                               //top->bottom
;;*		 sdata->opposite_vec[0][1]++;
;;*		for(t=0;t<2;t++){
;;*			if(t==0)   //with same parity
;           %p8
;;*				sdata->field_select=(pdata->picture_structure==Top_field)? 0 : 1 ;
;;*			else{   //with opposite parity
;           %p12
;;*				sdata->field_select=(pdata->picture_structure==Top_field)? 1 : 0 ;
;;*				MV->vector[0][0]=sdata->opposite_vec[0][0];
;;*				MV->vector[0][1]=sdata->opposite_vec[0][1];
;;				}
;;*			Prediction_search(s,MV,r,(unsigned char)(t),shead,gop,pdata,sdata,Fmem);  //7.6.4
;;			}
;;		}
;;	}
;;	else{
;  %p4
;;*	if(sdata->MB_type & (macroblock_motion_forward | macroblock_motion_backward))
;      %p5
;;*		Prediction_search(s,MV,r,0,shead,gop,pdata,sdata,Fmem);  //7.6.4
;;	}

;*******************Not change
;cluster1: ac3<< flag2=1 << execute _mc_loop for twice!!
;cluster2: ac1 << r, a3<< *MV
;*******************************
;cluster1:d0<< MV->vector[0][1]; MV->vector[0][0], ac6<<average_flag
;cluster2:

;;*****************Break_Point!!!!!!!!!
;{ moviu r11,GLOBAL_POINTER_ADDR  | nop 		  | nop 				       | nop 				    | nop				      }
;{ lw r9,r11,MB_Count | nop                     | nop 				       | nop 				          | nop				      }
;{ nop                | nop 				        | nop 				       | nop 				    | nop				      }
;{ nop 			      | nop   	                 | nop 				       | nop 				          | nop				      }
;{ seqiu r11,p12,p0,r9,2897| nop 	                 | nop 				       | nop 				          | orp p11,p11,p0      }
;{ andp p12,p12,p11	| nop 		              | nop                  | nop 				          | nop                  }
;{ notp p11,p12 		| nop  				        | nop                  |nop				          |(p12)moviu ac6,1      }
;{(p11)b _end1 	      |nop                      | nop                  |nop 				          |(p12)copy d0,ac6    }
;{ nop 			      |(p12)moviu a7,0xb00a9000 |(p12)copy d1,ac1      | nop 				    | nop				      }
;{(p12)bdt r10	      |(p12)bdr d8              | nop 				       |(p12)bdt d0 				          | nop				      }
;{ nop 			      |(p12)sw d1,a7,4	        | nop 				       |nop           | nop				      }
;{(p12) moviu r3,1    |(p12)sw d8,a7,8          | notp p11,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p12,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end1:
;;********************************************

{ orp p10,p8,p9      | notp p5,p0  		        | add.d d14,d14,d15    | notp p6,p0		          | clr ac6   		   }
{(p9)set_lbci r10,4  | sw d14,a4,opposite_vec_0_0|	nop   	          | clr d0 				       | orp p12,p11,p9	   }
{(p11)set_lbci r10,2 | sw d14,a4,opposite_vec_1_0|(p9)copy d13,d0     | moviu d1,1		          | nop               }
{ notp p3,p0         | clr d9 				     | unpack2 d2,d14       | nop			             | notp p4,p0  	   }
{ nop 			      | nop 				        |(p9)addi d8,d3,(-1)   | lbu d2,a2,picture_structure| nop				   }
{ nop 			      |(p9)sh d8,a4,opposite_vec_1_1|(p7)addi d0,d3,(-1)| nop 				          | nop 	            }
{ nop 			      |(p2)permh2 d14,d14,d8,0,2|(p10)addi d0,d3,1     | nop			             | nop				   }
{ notp p8,p0	      |(p1)permh2 d14,d2,d0,0,2 | nop 				       | nop 				          | nop	            }
{ nop                |(p12)sh d0,a4,opposite_vec_0_1|(p9)add.d d15,d14,d13 | nop 		          |(p11)orp p8,p8,p0  }
{ nop	               |(p2)sw d15,a4,opposite_vec_1_0| clr d0   		 | nop   	                |(p9)orp p3,p3,p0   }
{ notp p12,p0        |(p1)sw d15,a4,opposite_vec_0_0| moviu d1,1		 | nop				          | notp p1,p0        }



_dual_prime_loop:
{ orp p15,p6,p12     |(p9)orp p7,p4,p5  	     |(p8)clr ac6           | nop                      |(p11)seqiu d3,p3,p4,d2,Top_field}
{ b r5,_prediction_search |(p9)orp p2,p3,p5	  |(p12)moviu ac6,1      |(p15)lw d8,a4,opposite_vec_0_0|(p8)not d3,d3	}
{(p9)orp p10,p3,p6	|(p1)moviu d9,1           |(p7)moviu d0,1        |(p5)lw d8,a4,opposite_vec_1_0 |(p11)notp p1,p0}
{(p9)orp p10,p10,p7  | copy d8,d0		        | nop                  |(p11)andi d3,d3,0x1       |(p11)notp p2,p0    }
{(p11)notp p10,p0    |(p10)sb d0,a4,field_select|(p10)seq ac7,p1,p0,d8,d9| orp p15,p15,p5        |(p1)moviu ac1,1		}
{ nop 			      | nop                     |(p10)not ac6,ac7      |(p15)sw d8,a3,0 		    |(p2)clr ac1			}
{ nop 			      | nop 				        |(p10)andi ac6,ac6,0x1 |(p11)sb d3,a4,field_select| nop               }
;



{ lbcb r10,_dual_prime_loop | notp p3,p0  	  | nop 				       | lbu d2,a2,picture_structure| addi ac6,ac6,1  }
{ seqiu r11,p1,p2,r10,0| notp p4,p0		        | nop 				       | notp p5,p0		          | copy d6,ac6 	   }
{(p1)br r2	         | bdr d6				        | notp p8,p0 	       | bdt d6			          | nop		         }
{ notp p6,p0	      | nop 				        | notp p12,p0          | nop 				          | seqiu ac7,p9,p11,d2,Frame_picture}
{ nop 			      | clr d0 				     |(p9)seqiu ac7,p4,p0,d6,1| clr d0 				    |(p9)seqiu ac7,p6,p7,d6,3}
{(p9)orp p1,p4,p6 	| clr d9		              |(p9)seqiu ac7,p5,p0,d6,2| nop    	             |(p11)seqiu ac7,p12,p7,d6,1}
;
{ nop       	      | nop			        | nop 				       | nop 				          | nop				   }
{ notp p15,p0        | nop 				        | nop 				       | nop 				          | nop				   }
;

;void Prediction_search(int s,MV_data* MV,int r,unsigned char average_flag
;		,Seq_header *shead,GOP_data *gop,Picture_data *pdata,Slice_data *sdata,Frame_memory *Fmem){
;	//********7.6.4 Forming Predictions

;	Frame_buf *reference;
;	short *Vector;
;	unsigned short 	width_temp,row_temp;
;	unsigned char *ref,*pos;
;	short int_vec[2],int_vec_chroma[2];
;	unsigned char x,y;
;	unsigned short row,column,width,index;
;	unsigned int pos_temp;
;	//************************************
;	unsigned char column_size_temp,row_size_temp;
;	unsigned char *destination;
;	int j;

;//************Determine which is the reference frame
;;*if(pdata->increment_flag>1 || (sdata->MB_type & (macroblock_motion_forward | macroblock_motion_backward))!=0){
;  %p1=p1 || p15
;		//*******Compute the motion vectors of chroma
;;*	if(MV->vector[s][0]<0)
;     %p7
;;*		MV->vector_chroma[s][0]=-((abs)(MV->vector[s][0])>>1);
;;*	else
;;*		MV->vector_chroma[s][0]=MV->vector[s][0]>>1;
;;*	if(MV->vector[s][1]<0)
;;    %p9
;;*		MV->vector_chroma[s][1]=-((abs)(MV->vector[s][1])>>1);
;;*	else
;;*		MV->vector_chroma[s][1]=MV->vector[s][1]>>1;

;;*   if(s==0){ //Forward prediction
;     % p3=p3 && p1
;;*		sdata->prediction_buf[sdata->Ref_num]=&Fmem->Forward_pred;

;;*	   if(!gop->field_count_flag  && pdata->picture_coding_type==Pframe
;        % p15 && p6 && ( (p8 && p10) || (p11 && p12) )
;;*			&& ((pdata->picture_structure==Bottom_field && sdata->field_select==0)
;;*			|| (pdata->picture_structure==Top_field && sdata->field_select==1))){
;;*			reference=Ref_back;
;			}
;;*		else
;;*			reference=Ref_front;
;		}
;;*	else{    //Backward prediction
;     %p5
;;*		sdata->prediction_buf[sdata->Ref_num]=&Fmem->Backward_pred;
;;*		reference=Ref_back;
;		}
;	}
;;*else{
;  % p2
;;*	if(s==0){ //Forward prediction
;     %p4=p3 && p2
;;*		sdata->prediction_buf[sdata->Ref_num]=&Fmem->Forward_pred;
;;*		reference=Ref_front;
;		}
;;*	else{    //Backward prediction
;     %p5
;;*		sdata->prediction_buf[sdata->Ref_num]=&Fmem->Backward_pred;
;;*		reference=Ref_back;
;		}
;	}

;*******************Not change
;p13,p14
;scalar : r10 << loop_count
;cluster1: ac3<< flag2=1 << execute _mc_loop for twice!!, ac6 <<average_flag, a3<<prediction, a6<<reference
;cluster2: ac1 << r , ac6<< t, a3<< *MV, a5 << *MV->vector[s][0~1],
;*******************************
_prediction_search:
;;*****************Break_Point!!!!!!!!!
;{ moviu r11,GLOBAL_POINTER_ADDR  | nop 		  | nop 				       | nop 				    | nop				      }
;{ lw r9,r11,MB_Count | nop                     | nop 				       | nop 				          | nop				      }
;{ nop                |(p5)moviu d0,0x55667788  | nop 				       | nop 				    | nop				      }
;{ nop 			      | nop 				        | nop 				       | nop 				          | nop				      }
;{ seqiu r11,p12,p0,r9,1350| nop               | nop 				       | nop 				          | seqiu ac7,p11,p0,ac6,1       }
;{ andp p12,p12,p11	| nop 		              | nop                  | nop 				          | nop                  }
;{ notp p11,p12 		| nop  				        | nop                  |nop				          | nop				      }
;{(p11)b _end3 	      |nop | nop                  |nop 				          | nop				      }
;{ nop 			      |(p12)moviu a7,0xb00a9000 |(p12)copy d1,ac6      | nop 				    | nop				      }
;{ nop 			      |(p12)sw d0,a7,0          |(p12)add.d d8,d14,d15 | nop 				          | nop				      }
;{ nop 			      |(p12)sw d15,a7,4	        | nop 				       |nop           | nop				      }
;{(p12) moviu r3,1    |(p12)sw d8,a7,8          | notp p11,p0			 | nop 				          | nop				      }
;{ nop 			      | nop 				        | notp p12,p0 			 | nop 				          | nop				      }
;
;{ trap 	            | nop 				        | nop 				       | nop 				          | nop				      }
;_end3:
;;********************************************


;{ moviu sr7,0x02015000                | nop 				        | nop 				       | nop  	                   | nop				      }

{ notp p7,p0	      | lbu d0,a2,increment_flag| moviu ac2,macroblock_motion_forward| lw d8,sp2,0| moviu ac2,4  	   }
{ notp p8,p0	      | lbu d8,a4,MB_type       | ori ac2,ac2,macroblock_motion_backward| lw a6,sp2,12| notp p11,p0   }
{ notp p9,p0	      | lw a3,sp,48             | clr ac1		       | lbu d10,a2,picture_coding_type| notp p12,p0  }
{ notp p10,p0	      | moviu a7,GLOBAL_POINTER_ADDR| sgtiu ac7,p1,p0,d0,1 | lbu d11,a4,field_select  | fmuluu d3,ac2,d8 }
{ notp p6,p0	      | lbu d1,a2,picture_structure| and ac2,ac2,d8    | add a5,a3,d3	          | seqiu ac7,p3,p5,d8,0}
{ andp p4,p3,p0      |(p5)addi a3,a3,Backward_pred_Y | seqiu ac7,p0,p15,ac2,0| lh d0,a5,0  	    | seqiu ac7,p6,p2,d10,Pframe}
{ orp p1,p1,p15      |(p5)addi a6,a7,Ref_Back_ADDR | moviu ac2,1      | lh d9,a5,2		          | seqiu ac7,p10,p12,d11,0}
{ notp p2,p1	      | lw a2,sp,48            | seqiu ac7,p8,p0,d1,Bottom_field | lbu d6,a6,field_count_flag | andp p3,p3,p1   }
{ andp p4,p4,p2      | lhu d0,a4,mb_row        | seqiu ac7,p11,p0,d1,Top_field|(p1)slti d7,p7,p9,d0,0| clr ac2       }
{ notp p2,p0	      |(p4)addi a6,a7,Ref_Front_ADDR| andp p8,p8,p10   |(p7)abs d0,d0             |(p1)slti ac7,p9,p0,d9,0}
{ andp p11,p11,p12   | lw d8,a1,horizontal_size| notp p10,p0	       |(p9)abs d9,d9             | srli d0,d0,1      }
{ orp p8,p8,p11      | lbu d9,a4,mv_format     | extractiu ac0,d0,8,8 |(p7)neg d0,d0 				 | srli d9,d9,1      }
{ andp p6,p6,p8      | notp p7,p0 				  | andi ac7,d0,0xff     |(p1)sh d0,a5,8  	          |(p9)neg d9,d9      }
{ andp p6,p6,p3      | seqiu d10,p7,p10,d1,Frame_picture| pack4 d0,ac0,ac7 |(p1)sh d9,a5,10         |(p3)seqiu ac7,p2,p0,d6,0}
{ andp p6,p6,p2      |(p3)addi a6,a7,Ref_Front_ADDR | seqiu ac7,p8,p0,d9,1| nop 				       | moviu ac3,1		   }
{ bdt r6             |(p6)addi a6,a7,Ref_Back_ADDR  | andp p9,p7,p8	 | bdr a6    		          |seqiu ac7,p1,p0,ac1,1}



;//************************Half-pel interpolation!!!
;;*row=sdata->mb_row<<4;
;;*column=sdata->mb_column<<4;
;;*column_size=16;
;;*width=shead->horizontal_size;
;;*row_start=ref_y=0;
;;*row_step=row_step_ref=1;
;	//************Setting the access data according to the prediciton mode!!
;;*if(sdata->mv_format==1){  //progressive_sequence must be zero!!
;  %p8
;;*	row_step_ref=2;
;;*	if(sdata->field_select==1) //bottom->
;     %p12
;;*		ref_y=1;
;;*	if(pdata->picture_structure==Frame_picture){  //field prediction or Dual-primed in frame pictures
;     %p9=p7 && p8
;;*		row_step=2;
;;*		if(r==1)               //current field is bottom field
;        %p2=p9 && p1
;;*			row_start=1;
;;		}
;;	}
;   //******************************************
;;*for(chroma_flag=0;chroma_flag<3;chroma_flag++){
;;*	if(chroma_flag==0){ //Y-component
;     %p3
;;*		row_size=16;
;;*		ref_reg=Fmem->Ref_MB[sdata->Ref_num].Y;
;;*		pred=prediction->Y;
;  		//ref=reference->Y;
;;*		Vector=MV->vector[s];
;		}
;;*   else{
;     %p4
;;*		if(chroma_flag==1){
;        %p5
;  			//row>>=1;
;  			//column>>=1;
;;          row_size>>=1;
;;*			column_size>>=1;
;;*			width>>=1;
;;*			ref_reg=Fmem->Ref_MB[sdata->Ref_num].U;
;;*			pred=prediction->U;
;  			//ref=reference->U;
;  			//Vector=MV->vector_chroma[s];
;			}
;;*		else{
;        %p6
;;*			ref_reg=Fmem->Ref_MB[sdata->Ref_num].V;
;;*			sdata->Ref_num++;
;;*			pred=prediction->V;
;; 			//ref=reference->V;
;			}
;		}
;;*   if(chroma_flag==0){
;     %p3
;;*		int_vec[0]=int_vec[1]=int_vec_chroma[0]=int_vec_chroma[1]=0;
;;*		half_flag[0]=half_flag[1]=0;
;;*		if((sdata->MB_type & (macroblock_motion_forward | macroblock_motion_backward))!=0){
;        %p11=p15 && p3
;;*			int_vec[0]=Vector[0]>>1;
;;*   		int_vec[1]=Vector[1]>>1;
;;*		   half_flag[0]=((Vector[0]-(int_vec[0]<<1))!=0)? 1 : 0;
;;*			half_flag[1]=((Vector[1]-(int_vec[1]<<1))!=0)? 1 : 0;
;
;;*         int_vec_chroma[0]=int_vec[0]>>1;
;;*			if(Vector[0]<0 && (Vector[0] & 1)!=0 && (MV->vector_chroma[s][0] & 1)==0 )
;           %p7 && p4 && p5
;;*				int_vec_chroma[0]++;
;;*			int_vec_chroma[1]=int_vec[1]>>1;
;;*			if(Vector[1]<0 && (Vector[1] & 1)!=0 && (MV->vector_chroma[s][1] & 1)==0 )
;           %p9 && p12 && p6
;;*				int_vec_chroma[1]++;
;;			}
;
;;*      row_temp=row_size+2;
;;*		if(pdata->picture_structure!=Frame_picture && sdata->prediction_type!=3)
;        %p11=p10 && p9
;;*		    row_temp=(row_size+1)<<1;
;;*		if(sdata->prediction_type==3 && r==0)
;        %p12 && p4
;;*			row_size>>=1;   //16X8 MC only do half of MB_size!!
;
;********EMDMA Multi-channel Linked List*******************
;;       for(j=0;j<3;j++){
;;				if(j==0){
;;					row_size_temp=row_size;
;;					width_temp=width;
;;					column_size_temp=column_size;
;;					ref=reference->Y;
;;					destination=ref_reg;
;;				}
;;				else if(j==1){
;;					row_temp=(row_temp>>1)+1;
;;					row_size_temp>>=1;
;;					int_vec[0]=int_vec_chroma[0];
;;					int_vec[1]=int_vec_chroma[1];
;;					row>>=1;
;;					column>>=1;
;;					width_temp>>=1;
;					column_size_temp>>=1;
;					ref=reference->U;
;;					destination=Fmem->Ref_MB[sdata->Ref_num].U;
;;				}
;;				else{
;;					ref=reference->V;
;;					destination=Fmem->Ref_MB[sdata->Ref_num].V;
;;				}
;;				if(j<2){
;;             if((sdata->MB_type & (macroblock_motion_forward | macroblock_motion_backward))!=0
;;						&& sdata->mv_format==1)
;              %p8=p15 && p8
;;						int_vec[1]<<=1;
;; 			   pos_temp=(row+int_vec[1])*width_temp+int_vec[0]+column;
;;					if(pdata->picture_structure!=Frame_picture){
;              %p10
;;						pos_temp+=(row*width_temp);
;;						if(r==1)  //Lower part of 16x8 MC!!!!
;                 %p7
;;							pos_temp+=(row_size_temp*width_temp);
;					}
;				}
;;				pos=ref+pos_temp;
;;				for(y=0;y<row_temp;y++){
;;					index=y*(column_size_temp+1);
;;					for(x=0;x<(column_size_temp+1);x+=2){
;;						if(x==column_size_temp)
;;							destination[index+x]=pos[x];
;;						else{
;;							destination[index+x]=pos[x];
;;							destination[index+x+1]=pos[x+1];
;;						}
;;					}
;;					pos+=width_temp;
;;				}
;;			}



;*******************Not change


;p13,p14
;cluster1: ac3<< flag2=1 << execute _mc_loop for twice!!, ac6 <<average_flag, a3<<prediction, d7<<reference
;cluster2: ac1 << r , ac6<< t, a3<< *MV, a5 << *MV->vector[s][0] (or *MV->vector_chroma[s][0])
;*******************************

;cluster1: d0<< column|row, ac0<<column_size, d8<<width, ac1<<ref_y ,ac2 << row_step_ref, d9<<row_size
;          a7 << *ref_reg, a3<< *pred, a6<< *ref, d14<< row_temp, d6<< pos_temp, a2<<address of Frame_store_memory
;cluster2: ac2<< row_start, ac3<< row_step, d8<< int_vec[1]|int_vec[0]
;            ,d9<< int_vec_chroma[1]|int_vec_chroma[0], d7 <<prediction_type



;%p1=1 <<half_flag[0]!=0
;%p2=1 <<half_flag[1]!=0
;%p3=1 <<chroma_flag=0
;%p8=1 <<mv_format=1
;%p10=1 <<picture_structure!=Frame_picture
;%p15=1 <<(sdata->MB_type & (macroblock_motion_forward | macroblock_motion_backward))!=0
{ andp p12,p12,p8    | moviu d9,16              |(p8)moviu ac2,2       |  andp p2,p1,p9           |(p9)moviu ac3,2    }
;{ moviu r12,M2_DMA_TEMP_ADDR | lbu d15,a4,Ref_num    |(p12)moviu ac1,1      | moviu a2,M2_DMA_TEMP_ADDR     |(p2)moviu ac2,1    }
{ moviu r12,EMDMAC_ADDR | lbu d15,a4,Ref_num    |(p12)moviu ac1,1      | moviu a2,EMDMAC_ADDR     |(p2)moviu ac2,1    }



;------SCT_FPGA_Trace
;{trap | nop |nop |nop |nop}
;----------------------



;;*******************************System DMA Status Polling!!!
.if 1
{ clr r15            | nop 				         | moviu ac5,DMA_step_size| nop 				       | nop				      }
_Move_frame_loop:
{ lw r9,r12,R054_DMASTAT  | moviu d7,0x02       | moviu ac4,8            | nop 				       | nop				      }
{ notp p12,p0        | moviu a7,0x0f	         | fmuluu d1,ac4,d15      | nop	                | nop				      }
{ nop                | sll a7,a7,d1  	         | fmuluu d2,ac5,d15      | nop	                | nop				      }
{ bdr r15            | bdt a7			 | sll d7,d7,d1           | nop 				       | nop				      }
{ bdr r11            | bdt d7 			 | moviu d1,DMA_LLST_ADDR | nop	                | nop				      }
{ and r9,r9,r15      | nop 	   		 | add d1,d1,d2 	       | moviu a2,EMDMAC_ADDR  | moviu ac7,DMA_step_size     }
{ seq r11,p1,p12,r9,r11 | bdt d2                | nop        		       | bdr d2                | moviu ac4,0x1D800000  }
{(p12)b _Move_frame_loop| bdt d1 		| nop           	       | bdr d1                | moviu ac5,0x19000000  }
{(p1)moviu r12,M2_DMA_TEMP_ADDR      | nop                      | nop                    | add a2,a2,d2          | srli ac7,ac7,1    }
{ nop                | nop              	| nop 				       | nop                   | or d8,d1,ac4        }
{ nop                | nop                      | nop 				       | sw d8,a2,R08C_LLST0   | or d1,d1,ac5	     }
{ nop                | nop 			| nop 				       | addi a2,a2,(-DMA_LLST_OFFSET)   | add d1,d1,ac7            }
{ nop                | nop 			| nop 				       | sw d1,a2,LLST_U_080   | nop				      }
;;(p12)
.endif
;;**********************************


;------SCT_FPGA_Trace
;{ trap                 | nop                 | nop                 | nop                 | nop                 }
;----------------------


;p3=1 >> chroma_flag=0->chroma_flag=1 >> Y->U
;p5=1 >> chroma_flag=1->chroma_flag=2 >> U->V
;p6=1 >> chroma_flag=2->chroma_flag=0 >> V->Y

_Half_pel_loop:
{ lw r15,sp3,48      | nop 				        | notp p1,p0  		    | moviu a2,M2_DMA_TEMP_ADDR 	 | notp p9,p0        }
{ notp p4,p0         | moviu a5,EMDMAC_ADDR    | moviu ac4,920        | lw d1,a5,0               | dclr d8          }
{ notp p12,p0        | addi a7,a2,Ref_MB_0_Y   | moviu ac5,DMA_step_size | lbu d7,a4,prediction_type| notp p7,p0        }
{ bdt r15            | slli.d d0,d0,4          | moviu ac0,16         | bdr a7                   | andp p11,p15,p0   }
{ addi r15,r15,Ref_MB_0_V | notp p6,p0         | fmuluu d1,d15,ac4    | lw d2,a5,8               |(p11)srai.d d8,d1,1         }
{ bdr r13            | bdt d1                  | fmuluu d13,d15,ac5   | bdr d11                  |(p11)slli.d ac4,d8,1        }
{ notp p2,p0         | add a7,a7,d1            | addi ac4,ac0,1       | addi a7,a7,Ref_MB_0_U    |(p11)unpack2 d14,d1   }
{ lbu r9,r14,frame_16x16_flag | add a5,a5,d13  |(p10)slli d1,d0,1     |(p11)slti d13,p7,p0,d14,0 |(p11)sub.d ac5,d1,ac4  }
{ bdr r11            | bdt d13                 | srli ac5,ac0,1       |(p11)slti d13,p9,p0,d15,0 |(p11)unpack2 d4,ac5    }
;
{ notp p5,p0         | sw a7,a5,R074_DAR0      | addi ac5,ac5,1       |(p7)andi d14,d14,1        |(p11)seqi ac7,p0,p1,d4,0    }
{ add r12,r12,r11    | lw d6,a6,0              | copy d14,ac4         |(p9)andi d15,d15,1        |(p11)seqi ac7,p0,p2,d5,0    }
;;(p4)
{ add r15,r15,r13    | lw d10,a1,horizontal_size | moviu ac7,17       |(p11)unpack2 d2,d2        |(p11)srai.d d9,d8,1}
{ lw r11,r14,horizontal_size |(p10)permh2 d0,d0,d1,2,1 | andp p8,p8,p15 |(p7)andi d2,d2,1        |(p7)seqi ac7,p0,p4,d14,0}
;{ sw r15,r12,R0C4_DAR6 | copy d7,d13           | slli ac7,ac7,4       |(p9)andi d3,d3,1 	     |(p9)seqi ac7,p0,p12,d15,0}
{ sw r15,r12,LLST_V_0B4 | copy d7,d13       | slli ac7,ac7,4       |(p9)andi d3,d3,1 	     |(p9)seqi ac7,p0,p12,d15,0}
{ nop                | bdr d1  		           | permh2 d11,d10,ac7,0,2 | bdt d8	    	     |(p4)seqi ac7,p5,p0,d2,0}
{ srli r11,r11,1     | dbdt d6,d7              | addi ac7,d9,2        | dbdr d0                  |(p12)seqi ac7,p6,p0,d3,0}

;;*********Additional mechanism for 16x16 pictures*************
;;*************************************************************
;{ nop                | nop 	                    | sltiu ac4,p12,p0,d10,17  | nop 				    | nop				      }
;{ sltiu r15,p4,p0,r11,9  |(p12)movi.h d11,0x0100| nop 				       | nop 				    | nop				      }
;;*************************************************************

{ ori r11,r11,0x900000| sw d11,a5,R078_SGR0    | unpack2u d2,d1       |(p5)addi d10,d9,1         | seqiu ac7,p12,p9,d7,3}

;;*********Additional mechanism for 16x16 pictures************
;;*************************************************************
;{(p4)movi.h r11,0x0080   | nop                  | nop 				  | nop 				    | nop				      }
;;***************************************************************


;------SCT_FPGA_Trace
;{ trap                 | nop                 | nop                 | nop                 | nop                 }
;----------------------



{ andp p3,p10,p9     |(p8)add.d d4,d0,d3       | addi ac4,d9,1        | dlw d2,a1,Image_size     | seqiu ac7,p4,p7,ac1,0}
;{ sw r11,r12,R0C8_SGR6 | slli d1,d2,16         |(p3)slli ac7,ac4,1    | add a2,a2,d1             |(p5)permh2 d9,d9,d10,2,1    }
{ nop                   | slli d1,d2,16         |(p3)slli ac7,ac4,1    | add a2,a2,d1             |(p5)permh2 d9,d9,d10,2,1    }
{ andp p12,p12,p4    | add.d d1,d1,d0          | fmuluu d14,d14,ac7   | lw d5,a1,horizontal_size |(p6)addi d9,d9,0x00010000}
{ lw r15,sp3,44      | bdr d12                 | slli d5,d14,12       | bdt d9                   | add d4,d0,d2    }
;{ sw r11,r12,R0A8_SGR5 | ori d5,d5,0x00000107  |(p12)srli d9,d9,1     | add a7,a7,d11            | add d7,d4,d3	   }
{ sw r11,r12,LLST_U_078 | ori d5,d5,0x00000907  |(p12)srli d9,d9,1     | add a7,a7,d11            | add d7,d4,d3	   }
{ andp p7,p7,p10     | dbdt d1,d4              | srli ac7,ac7,1       | dbdr d14  		         | unpack2u d2,d8  }
{ nop                |(p7)bdt d9               | addi ac7,ac7,1       |(p7)bdr d12               | fmul d3,d3,d5  }
;{ nop                |  srli.d d14,d10,1       | fmuluu ac4,ac5,ac7   | sw a7,a2,R0A4_DAR5       |(p8)inserti d14,d15,16,0  }
{ nop                |  srli.d d14,d10,1       | fmuluu ac4,ac5,ac7   | sw a7,a2,LLST_U_074      |(p8)inserti d14,d15,16,0  }
{ addi r12,r12,DMA_LLST_OFFSET| sw d5,a5,R080_CTL0      | srli d13,d9,1        |(p7)add.d d14,d14,d12     | copy ac7,d5      }
{ sw r11,r12,R088_CLR0 | srli.d d11,d0,1       | slli d4,ac4,12       | clr d11                  | srli d1,d14,16   }
;{ sw r11,r12,R0B8_CLR5 | ori d4,d4,0x00000107  |(p7)add.d d11,d11,d13 | add d1,d1,d0			 | fmuluu ac7,ac7,d14 }
{ nop                   | ori d4,d4,0x00000907  |(p7)add.d d11,d11,d13 | add d1,d1,d0			 | fmuluu ac7,ac7,d14 }
;{ seqiu r13,p7,p0,r9,0 | sw d4,a5,R0B0_CTL5    | unpack2u ac4,d12     |(p1)ori d11,d11,0x00000001| add ac7,ac7,d3     }
{ nop                 | addi a5,a5,(-DMA_LLST_OFFSET)  | nop 				  | nop 				     | nop				      }
{ seqiu r13,p7,p0,r9,0  | sw d4,a5,LLST_U_07C   | unpack2u ac4,d12     |(p1)ori d11,d11,0x00000001| add ac7,ac7,d3     }
;{ lw r13,sp3,16      | sw d4,a5,R0D0_CTL6      |(p8)add.d d11,d11,ac5 |(p2)ori d11,d11,0x00000100| add d1,d1,ac7     }
{ nop                 | andi d4,d4,0xfffff7ff   | nop 				     | addi a2,a2,DMA_LLST_OFFSET  | nop				      }
{ lw r13,sp3,16       | sw d4,a5,LLST_V_0B8     |(p8)add.d d11,d11,ac5 |(p2)ori d11,d11,0x00000100| add d1,d1,ac7     }
{ notp p1,p0         | unpack2u d12,d11         | moviu ac7,16         | sw d1,a2,R070_SAR0       | seqiu ac7,p6,p0,ac1,1  }
{ notp p2,p0         | dbdr d4  		            | add.d d8,d12,ac5  	  | dbdt d4,d7               | andp p6,p6,p10         }
{ bdt r13            | bdr a2  		            | add.d d2,d13,ac4     |(p11)lw d10,a5,8          |(p6)moviu ac2,8         }
;{ clr r13            | add a0,d4,d2  	         | fmul d8,d8,d14       |(p7)sw d1,a2,R084_EN0     | slli.d d12,d9,1        }
{ clr r13             | add a0,d4,d2  	         | fmul d8,d8,d14       | nop                      | slli.d d12,d9,1        }
;{ sw r11,r12,R0D8_CLR6 | add a0,a0,d8  	       | add d10,d5,d2		  | lw a2,sp2,16             | copy d13,ac2           }
{ nop                | add a0,a0,d8  	         | add d10,d5,d2		  | lw a2,sp2,16             | copy d13,ac2           }
;{ lbu r9,r15,Ref_num | sw a0,a5,R0A0_SAR5      | add d6,d10,d8   	  | sub d1,d10,d12           | nop            	      }
{ lbu r9,r15,Ref_num  | sw a0,a5,LLST_U_070     | add d6,d10,d8   	  | sub d1,d10,d12           | nop            	      }
;{(p7)br r5           | sw d6,a5,R0C0_SAR6      | fmuluu d5,d15,ac7    | unpack2 d2,d1            | inserti d13,ac3,8,8     }


;------SCT_FPGA_Trace
;{ trap                 | nop                 | nop                 | nop                 | nop                 }
;----------------------

;{nop                  | sw d6,a5,LLST_V_0B0     | fmuluu d5,d15,ac7    | unpack2 d2,d1            | inserti d13,ac3,8,8     }
{(p7)br r5            | sw d6,a5,LLST_V_0B0     | fmuluu d5,d15,ac7    | unpack2 d2,d1            | inserti d13,ac3,8,8     }
;{(p7)sw r11,r12,R0B4_EN5| add a5,a4,d5    	   | inserti d9,ac2,8,8   | copy d4,d13              |(p11)seqiu ac7,p0,p1,d2,0  }
;{(p7)sw r11,r12,R0D4_EN6| bdt a5   	       | inserti d9,ac6,8,16  | bdr a5                   |(p11)seqiu ac7,p0,p2,d3,0  }
{(p7)sw r11,r12, R084_EN0| add a5,a4,d5    	   | inserti d9,ac2,8,8   | copy d4,d13              |(p11)seqiu ac7,p0,p1,d2,0  }
;{nop                     | add a5,a4,d5            | inserti d9,ac2,8,8   | copy d4,d13              |(p11)seqiu ac7,p0,p1,d2,0  }
{ addi r12,r12,(-DMA_LLST_OFFSET) | bdt a5   	       | inserti d9,ac6,8,16  | bdr a5                   |(p11)seqiu ac7,p0,p2,d3,0  }
{(p7)addi r9,r9,1    | sw a3,a5,Prediction_buf_0 | inserti d9,ac1,8,24| moviu a7,EMDMAC_ADDR     |(p1)ori d11,d11,0x00010000 }
{ bdt sp3            | bdr sp                  | nop                  | sw d4,a5,row_start_0     |(p2)ori d11,d11,0x01000000}
{ sb r9,r15,Ref_num  | sw d9,a5,row_size_0  | nop                  | sw d11,a5,half_flag_0_0  | notp p15,p0       }
;(p7)


;------SCT_FPGA_Trace
;{ trap                 | nop                 | nop                 | nop                 | nop                 }
;----------------------


;;*********Additional mechanism for 16x16 pictures************
;;*************************************************************
{ moviu r11,0x00040907| moviu a7,M2_DMA_TEMP_ADDR   | nop 				  | moviu d0,0x00100907      | nop				      }
;{ sw r11,r12,R0B0_CTL5| addi d0,a3,256         | nop 				  | sw d0,a7,R090_CTL4       | nop				      }
;{ br r5               | sw a3,a7,R084_DAR4     | addi d8,d0,64   	  | nop 				     | nop				      }
;{ nop                | sw d0,a7,R0A4_DAR5      | nop 				  | nop 				     | nop				      }
;{ nop                | sw d8,a7,R0C4_DAR6      | nop 				  | nop 				     | nop				      }
;{ sw r11,r12,R0D0_CTL6 | nop                   | nop 				  | nop 				     | nop				      }
;{ sw r11,r12,R0B4_EN5 | nop                     | nop 				  | sw d0,a7,R094_EN4        | nop				      }
;{ sw r11,r12,R0D4_EN6 | nop                     | nop 				  | nop 				     | nop				      }
{ sw r11,r12,LLST_U_07C| addi d0,a3,256         | nop 				  | sw d0,a7,R080_CTL0 | nop				      }
{ br r5               | moviu a5,EMDMAC_ADDR    | addi d8,d0,64   	  | nop 				     | nop				      }
{ andi r11,r11,0xfffff7ff | sw d0,a7,LLST_U_074  | nop 	     | nop 				     | nop				      }
{ sw r11,r12,LLST_V_0B8| sw d8,a7,LLST_V_0B4  | nop 				  | nop 				     | nop				      }
{ nop                | sw a3,a5,R074_DAR0      | nop 				  | nop 				     | nop				      }
{ nop                | nop                     | nop 				  | sw d0,a7,R084_EN0        | nop				      }
{ nop                | nop                     | nop 				  | nop 				     | nop				      }
;;***************************************************************


.endp	mc
;-----------------------------
