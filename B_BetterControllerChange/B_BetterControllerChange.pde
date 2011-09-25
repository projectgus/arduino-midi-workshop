/*
 * The previous MIDI controller change continually sends controller change messages
 * which overloads the computer a bit, and is generally a waste.
 *
 * In this sample, we keep track of the current controller value and only send a message
 * when it changes
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
 
 
/******************************************************************* 
 *
 * Global variables
 * 
 * These are values we keep around for the whole life of the sketch
 * as it runs
 */
 
 byte last_midival;
 
 
 /******************************************************************* 
 *
 * Sketch Program
 */
 
 void setup() {
   Serial.begin(115200); 
   last_midival = 128; // Question for you: Why do we do this?
 }
 
 void loop() {
   // Get the analog value on the input pin, store it as 'rawval'
   int rawval = analogRead(PIN); // Returns value 0-1023

   // Map the range to a MIDI controller range, store it as 'midival'
   byte midival = map(rawval, 0, 1023, 0, 127); // MIDI controller values are 0-127

   if(midival != last_midival) {
     // Send midival as a MIDI controller change message
     midi_controller_change(CHANNEL, CONTROLLER, midival);
     last_midival = midival;
   }
 }

