/*
 * =====================================================================================
 *
 *       Filename:  main.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  12.07.2009 23:17:28 CEST
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:   (), 
 *        Company:  
 *
 * =====================================================================================
 */
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "usart.h"
#include "adc.h"
int main(void){
	uint8_t i=2 , j=16;
	int x=0, y=0 ,z=0, ruck=0;
	double betr[2];
	int old=0 , vz=0;
	double betr2[30];
	char bla[20];
	char bla2[7];
	usart_init(USART_BAUDRATE(9600,1));
	sei();
	usart_puts ("Hello\r\n");
	//DDRD=1;
	DDRC=0;
	//DDRD|=(1<<6);
	DDRD=0;
	DDRD|=(1<<4)|(1<<3);
	PORTD=0;
	while(1){
		//i--;
		//PORTB|=(1<<1);
	//	PORTB&=~(1<<2);
	//	PORTB&=~(1<<1);
		//PORTD|=(1<<2);
		x=(ReadChannel(0));
		y=(ReadChannel(1));
		z=(ReadChannel(2));
		//PORTD&=~(1<<2);
		//betr[i]=sqrt((x*x)+(y*y)+(z*z));
		sprintf(bla,"%u,%u,%u\n\r",x,y,z);
		usart_puts(bla);
	/*	if(i==0){
			
			i=2;
			j--;
			betr2[j]=betr[0];
			if(j==0){
				j=16;
				for (int k=14;k>=0;k--){
					betr2[k+1]-=betr2[k];
				}
				betr2[0]=0;
				for (int k=15;k>=1;k--){
					betr2[0]+=betr2[k];
				}
				betr2[0]/=16;


				//if(betr2[9]<20&& old==1&&vz==0){
				if(betr2[0]>0){
				//	PORTD&=~(1<<3);
				//	PORTD|=(1<<4);
					vz=1;
					old=0;
				}
				
				//if(betr2[9]<20&& old==0&&vz==0){
				else{
				//	PORTD&=~(1<<4);
				//	PORTD|=(1<<3);
					old=1;
					vz=1;
				}

				//if(betr2[9]>100 &&vz ==1){
				//	vz=0;
				//}	
				//sprintf(bla,"%6d\n",betr2[9]);
				//sprintf(bla2,"%f\n",betr[0]);
				//usart_puts(bla2);
			}
		}
	*/
	}
}

