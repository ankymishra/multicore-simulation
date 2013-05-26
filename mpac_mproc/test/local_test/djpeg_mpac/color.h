/****************************************************************
 *  Contents    :   Utilities for jfif view
 *  Author      :   Pierre Guerrier, March 1998, ported to
 *                  the minimips platform by
 *                  Mathijs Visser, November 2003.
 ****************************************************************/

#ifndef COLOR_H
#define COLOR_H

/* Ensure number is >=0 and <=255			   */
#define Saturate(n)	((n) > 0 ? ((n) < 255 ? (n) : 255) : 0)

/*---------------------------------------*/
/* rules for color conversion:	         */
/*  r = y		+1.402	v	 */
/*  g = y -0.34414u	-0.71414v	 */
/*  b = y +1.772  u			 */
/* Approximations: 1.402 # 7/5 = 1.400	 */
/*		.71414 # 357/500 = 0.714 */
/*		.34414 # 43/125	= 0.344	 */
/*		1.772  = 443/250	 */
/*---------------------------------------*/
/* Approximations: 1.402 # 359/256 = 1.40234 */
/*		.71414 # 183/256 = 0.71484 */
/*		.34414 # 11/32 = 0.34375 */
/*		1.772 # 227/128 = 1.7734 */
/*----------------------------------*/
void color_conversion(unsigned char *ColorBuffer);

#endif
