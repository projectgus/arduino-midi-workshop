/*
 * This button is like SimpleButton, but "debounced" so it only sends one note each time the
 * button is held down
 */
 
#include "ardumidi.h"
#include "Bounce.h" // <--------- debouncing library, one of many ways to debounce

/******************************************************************* 
 *
 * Constants
 *
 * Set things like pin numbers and MIDI channels here, so it's easier 
 * to read your sketch later 
 */
 
 // The "digital in" pin that the button is wired to
 const int PIN = 3;

 // The MIDI channel to use
 const int CHANNEL = 0;
 
 // The note to send when the button is pressed
 const int NOTE = MIDI_C;
 
 // The "velocity" of the button hit (range can be 1-127)
 const int VELOCITY = 127;
 
 // How long do we need to hold a value before it's debounced?
 const int DEBOUNCE_TIME = 5;
 
 /*******************************************************************
  * 
  * Global variables
  *
  * Things we want to store for the entire life of the program
  */
  
 Bounce button(PIN, DEBOUNCE_TIME); // <--- this variable Bounces holds all the info for debouncing the PIN 
  
 /******************************************************************* 
 *
 * Sketch Program
 */
 
 void setup() {
   Serial.begin(115200); 
   pinMode(PIN, INPUT);
 }
 
 void loop() {
   
   boolean has_changed = button.update(); // <-- Update returns 'true' if the value has really changed since last time
   
   if(has_changed) {
     boolean new_value = button.read(); // Value is 'true' for button down, 'false' for button up
     if(new_value) {
        midi_note_on(CHANNEL, NOTE, VELOCITY); 
     } else {
        midi_note_off(CHANNEL, NOTE, VELOCITY); 
     }
   }
}

