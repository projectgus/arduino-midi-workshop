/*
 * Kind of like the DigitalReadSerial example, this sketch sends a MIDI note
 * whenever you press a button
 */
 
#include "ardumidi.h"

/******************************************************************* 
 *
 * Constants
 *
 * Set things like pin numbers and MIDI channels here, so it's easier 
 * to read your sketch later 
 */
 
 // The "digital in" pin that the button is wired to
 const int PIN = 2;

 // The MIDI channel to use
 const int CHANNEL = 0;
 
 // The note to send when the button is pressed
 const int NOTE = MIDI_C;
 
 // The "velocity" of the button hit (range can be 1-127)
 const int VELOCITY = 127;
 
  
 /******************************************************************* 
 *
 * Sketch Program
 */
 
 void setup() {
   Serial.begin(115200); 
   pinMode(PIN, INPUT);
   digitalWrite(PIN, HIGH);
 }
 
 void loop() {
   byte b; // <-- a local variable to hold the value of the button input
   
   // While the button is released, wait for it to be pressed
   do {
     b = digitalRead(PIN);
   } while(b == LOW);

   // It's been pressed! So send a "MIDI note on" message
   midi_note_on(CHANNEL, NOTE, VELOCITY);
   
   // Now wait for the button to be released
   do {
     b = digitalRead(PIN);
   } while(b == HIGH);

   // OK, it's been lifted. So send a "MIDI note off" message
   midi_note_off(CHANNEL, NOTE, VELOCITY);
}

