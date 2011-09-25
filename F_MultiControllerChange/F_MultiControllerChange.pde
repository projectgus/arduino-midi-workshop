/*
 * This sketch is just like BetterControllerChange, only it monitors 3 
 * analog input pins simultaneously.
 *
 * To do this, we have to introduce a new concept - arrays.
 */
 
#include "ardumidi.h"

/******************************************************************* 
 *
 * Constants
 *
 * Set things like pin numbers and MIDI channels here, so it's easier 
 * to read your sketch later 
 */
 
 // The number of controller inputs to monitor
 const int NUM_INPUTS = 3;
 
 // The "analog in" pins that the knob/slider potentiomers are each plugged into
 const int PINS[] = { A0, A1, A5 };

 // The MIDI channel to use
 const int CHANNEL = 0;
 
 // The controller numbers to send on
 const int CONTROLLERS[] = { 0, 1, 2};
 
 
/******************************************************************* 
 *
 * Global variables
 * 
 * These are values we keep around for the whole life of the sketch
 * as it runs
 */
 
 // Last time we only needed to keep one value, now we keep 3 (NUM_INPUTS means 3 here)
 byte last_midivals[NUM_INPUTS];
 
 
 /******************************************************************* 
 *
 * Sketch Program
 */
 
 void setup() {
   Serial.begin(115200); 

  // To access an item (called an 'element') in an array, we use square brackets like this:
   last_midivals[0] = 128;
   last_midivals[1] = 128;
   last_midivals[2] = 128;
 }
 
 void loop() {

   for(int i = 0; i < NUM_INPUTS; i++) { // This means to "loop" through each value, first setting variable 'i' to 0, then 1, then 2

      // Get the raw value for this pin 
      int rawval = analogRead(PINS[i]);

      // Map the range to a MIDI controller range, store it as 'midival'
      byte midival = map(rawval, 0, 1023, 0, 127); // MIDI controller values are 0-127

      if(midival != last_midivals[i]) {
       // Send midival as a MIDI controller change message, using the controller we set for this pin
       midi_controller_change(CHANNEL, CONTROLLERS[i], midival);
       last_midivals[i] = midival;
      }
   }
 }

