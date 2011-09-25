/*
 * Simple MIDI controller change signal
 *
 * Like the AnalogReadSerial Examples sketch, but sends MIDI data
 */
 
#include "ardumidi.h"

/******************************************************************* 
 *
 * Constants
 *
 * Set things like pin numbers and MIDI channels here, so it's easier 
 * to read your sketch later 
 */
 

 // The "analog in" pin that the knob/slider potentiomer is plugged into
 const int PIN = A0;

 // The MIDI channel to use
 const int CHANNEL = 0;
 
 // The controller number to send on
 const int CONTROLLER = 1;
 
 
/*
 * Setup
 */
 
 void setup() {
   Serial.begin(115200); 
 }
 
 void loop() {
   // Get the analog value on the input pin, store it as 'rawval'
   int rawval = analogRead(PIN); // Returns value 0-1023

   // Map the range to a MIDI controller range, store it as 'midival'
   byte midival = map(rawval, 0, 1023, 0, 127); // MIDI controller values are 0-127

   // Send midival as a MIDI controller change message
   midi_controller_change(CHANNEL, CONTROLLER, midival);
  
  // Pause briefly (10ms) so we don't spam the computer into oblivion by sending messages over and over
  delay(10); 
 }

