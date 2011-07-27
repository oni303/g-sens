/***************************************************************************
 * Atmel AVR USART Library for GCC
 * Version: 1.0
 * 
 * Works with AVR MCUs equiped with USART hardware (ATmega series). 
 * Does not work with older UART's or USI of ATtiny series.
 * Tested with ATmega8.
 * 
 * Uses USART Receive Complete Interrupt. Disabling Global Interrupts
 * after usart initialization disables data receive.
 *
 * Jaakko Ala-Paavola 2003/06/28
 * http://www.iki.fi/jap email:jap@iki.fi
 */

#include <avr/io.h>
#include <avr/signal.h>
#include <avr/interrupt.h>
#include <string.h>
#include "usart.h"

char usart_buffer[USART_BUFFER_SIZE];
unsigned char usart_buffer_pos_first = 0, usart_buffer_pos_last = 0;
volatile unsigned char usart_buffer_overflow = 0;

void usart_init(unsigned char baud_divider) {

  // Baud rate selection
  UBRRH = 0x00;       
  UBRRL = baud_divider;

  // USART setup
  UCSRA = 0x02;        // 0000 0010
                       // U2X enabled
  UCSRC = 0x86;        // 1000 0110
                       // Access UCSRC, Asyncronous 8N1
  UCSRB = 0x98;        // 1001 1000
                       // Receiver enabled, Transmitter enabled
                       // RX Complete interrupt enabled
  sei();               // Enable interrupts globally
}

void usart_putc(char data) {
    while (!(UCSRA & 0x20)); // Wait untill USART data register is empty
    // Transmit data
    UDR = data;
}

void usart_puts(char *data) {
  int len, count;
  
  len = strlen(data);
  for (count = 0; count < len; count++) 
    usart_putc(*(data+count));
}

char usart_getc(void) {
  // Wait untill unread data in ring buffer
  if (!usart_buffer_overflow)
    while(usart_buffer_pos_first == usart_buffer_pos_last);
  usart_buffer_overflow = 0;
  // Increase first pointer
  if (++usart_buffer_pos_first >= USART_BUFFER_SIZE) 
    usart_buffer_pos_first = 0;
  // Get data from the buffer
  return usart_buffer[usart_buffer_pos_first];
}

unsigned char usart_unread_data(void) {
  if (usart_buffer_overflow)
    return USART_BUFFER_SIZE;
  if (usart_buffer_pos_last > usart_buffer_pos_first)
    return usart_buffer_pos_last - usart_buffer_pos_first;
  if (usart_buffer_pos_last < usart_buffer_pos_first)
    return USART_BUFFER_SIZE-usart_buffer_pos_first 
      + usart_buffer_pos_last;
  return 0;
}

SIGNAL(SIG_UART_RECV) {
  // Increase last buffer 
  if (++usart_buffer_pos_last >= USART_BUFFER_SIZE)
    usart_buffer_pos_last = 0;
  if (usart_buffer_pos_first == usart_buffer_pos_last) 
    usart_buffer_overflow++;
  // Put data to the buffer
  usart_buffer[usart_buffer_pos_last] = UDR;
}
