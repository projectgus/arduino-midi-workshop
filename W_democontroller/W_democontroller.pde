#include "ardumidi.h"
#include "Bounce.h"

// Constants

const byte DEBOUNCE_TIME = 5; // Button has to stay changed for this many milliseconds
const byte CHANNEL = 0;

// Controller hardware layout. All constants, don't change while sketch is running.

const byte button_pins[] =  { 3, 2 };           // what digital inputs are the buttons wired to?
const byte button_notes[] = { MIDI_C, MIDI_D }; // what notes should the buttons play? 
const byte num_buttons = sizeof(button_pins);

const byte BUTTON_DOWN = HIGH; // swap these depending on whether your digital inputs go high or low when button is down
const byte BUTTON_UP = LOW;


const byte analog_pins[]       = { 1, 0, 5 }; // knob, knob, slider in this case
const byte analog_controller[] = { 1, 2, 3 }; // MIDI "controller number" for each input

const byte num_analog = sizeof(analog_pins);


// Controller state. Changes as the sketch runs.

Bounce button_bounce[] = { Bounce(button_pins[0], DEBOUNCE_TIME), // Bounce handles debouncing each button
                           Bounce(button_pins[1], DEBOUNCE_TIME)
                         };
byte last_analog[num_analog]; // Last MIDI controller value we saw come in from the analog input

// Code

void setup() {
   for(int i = 0; i < num_buttons; i++) {
     pinMode(button_pins[i], INPUT); 
     if(BUTTON_DOWN == LOW) {
       digitalWrite(button_pins[i], HIGH); // internal pullups on inputs
     }  
 }
   Serial.begin(115200);
}

void debug_dump() {
   for(int i = 0; i < num_buttons; i++) {
     Serial.print(digitalRead(button_pins[i]) == BUTTON_DOWN);
     Serial.print(" "); 
   }
   for(int i = 0; i < num_analog; i++) {
     Serial.print(analogRead(analog_pins[i]));
     Serial.print(" "); 
   }
   Serial.println();
}


void loop() {
  check_buttons();
  check_analog_inputs();
}

void check_buttons()
{
  for(int i = 0; i < num_buttons; i++) {
    if(button_bounce[i].update()) {  
       // Something changed (debounced already)
       if(button_bounce[i].read() == BUTTON_DOWN) {
         midi_note_on(CHANNEL, button_notes[i], 127);          
       }
       else {
         midi_note_off(CHANNEL, button_notes[i], 127);                   
       }   
    }
  }  
}

void check_analog_inputs()
{
   for(int i = 0; i < num_analog; i++) {
      int rawinput = analogRead(analog_pins[i]);
      byte midival = map(rawinput, 0, 1023, 0, 127); // map to midi controller range 
      if(midival != last_analog[i]) {
         midi_controller_change(CHANNEL, analog_controller[i], midival);
         last_analog[i] = midival;
      }
 }
}

