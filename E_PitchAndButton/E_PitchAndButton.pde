/*
 * Just to mix things up a bit, let's try using a button and a knob together.
 *
 * The knob will still send a MIDI note, but the controller determines the pitch
 *
 *
 * Challenge: change this sketch so the button sends a MIDI note, and the controller sends an unrelated
 * MIDI controller change signal
 */
 
#include "ardumidi.h"
#include "Bounce.h"

/******************************************************************* 
 *
 * Constants
 *
 * Set things like pin numbers and MIDI channels here, so it's easier 
 * to read your sketch later 
 */
 
 // The "digital in" pin that the button is wired to
 const int BUTTON_PIN = 2;

 // The "analog in" pin with the knob wired to it
 const int KNOB_PIN = A0;

 // The MIDI channel to use
 const int CHANNEL = 0;
 
 // The base note to send when the button is pressed
 const int BASE_NOTE = MIDI_C;
 
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
  
 Bounce button(BUTTON_PIN, DEBOUNCE_TIME); // <--- this variable Bounces holds all the info for debouncing the button 

 int note; // what note are pressing?
  
 /******************************************************************* 
 *
 * Sketch Program
 */
 
void setup() {
  Serial.begin(115200); 
  pinMode(BUTTON_PIN, INPUT);
}
 
void loop()  { 
   boolean has_changed = button.update(); // <-- Update returns 'true' if the value has really changed since last time
   
   if(has_changed) {
     boolean new_value = button.read(); // Value is 'true' for button down, 'false' for button up
     if(new_value) {
        int raw_value = analogRead(KNOB_PIN); // Read the knob
        note = map(raw_value, 0, 1023, BASE_NOTE, BASE_NOTE+23); // Map to a chromatic scale, double octave      
        midi_note_on(CHANNEL, note, VELOCITY); 
     } else {
        midi_note_off(CHANNEL, note, VELOCITY); 
     }
   }
}

