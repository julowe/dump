//JKL hacking of mindfulness buzzer for feather 32u4
//20200529

//different buzz patterns at end of sketch as comments


//TODO input method for tracking one stat (eg water tracker?)
//TODO method to reset timers (for start of hour or start of activity)
//TODO use millis() ? {Returns the number of milliseconds passed since the Arduino board began running the current program. This number will overflow (go back to zero), after approximately 50 days.}

const uint32_t
  onTime   =  1 * 1000L, // Vibration motor run time, in seconds * 1000 to get milliseconds
  interval = 6 * 1000L; // Time between reminders, in seconds * 1000 to get milliseconds

const uint32_t offTime = interval - onTime; // Duration motor is off, ms

//using adafruit sleepydog library which does WDT (Watch Dog Timer) stuff for me
  // Set full power-down sleep mode and go to sleep.
  //  set_sleep_mode(SLEEP_MODE_PWR_DOWN);

uint16_t          maxSleepInterval;  // Actual ms in '8-ish sec' WDT interval
volatile uint32_t sleepTime     = 1; // Total milliseconds remaining in sleep
volatile uint16_t sleepInterval = 1; // ms to subtract in current WDT cycle
volatile uint8_t  tablePos      = 0; // Index into WDT configuration table

//JKL pin with resistor
const int pinResistor = 10; //pin 10 for feather 32u4 breakout 

void setup() {

  // LED shenanigans.  Rather that setting pin 1 to an output and using
  // digitalWrite() to turn the LED on or off, the internal pull-up resistor
  // (about 10K) is enabled or disabled, dimly lighting the LED with much
  // less current.
//  pinMode(pinResistor, INPUT);               // LED off to start
  pinMode(pinResistor, OUTPUT);


//TODO figure out what we can shut off on feather 32u4 - or if adafruit sleepydog already does all that...

  // AVR peripherals that are NEVER used by the sketch are disabled to save
  // tiny bits of power.  Some have side-effects, don't do this willy-nilly.
  // If using analogWrite() to for different motor levels, timer 0 and/or 1
  // must be enabled -- for power efficiency they could be turned off in the
  // ubersleep() function and re-enabled on wake.
//  power_adc_disable();             // Knocks out analogRead()
//  power_timer1_disable();          // May knock out analogWrite()
//  power_usi_disable();             // Knocks out TinyWire library
//  DIDR0 = _BV(AIN1D) | _BV(AIN0D); // Digital input disable on analog pins
  // Timer 0 isn't disabled yet...it's needed for one thing first...

  
}



void loop() {

  buzz_double_soft_ramp_up_slower_fade();

  delay(1000L*60L*1L);
  
  buzz_soft_ramp_up_slower_fade();

  delay(1000L*60L*1L);
  
  buzz_soft_ramp_up_slower_fade();

  delay(1000L*60L*1L);
    
  buzz_soft_ramp_up_slower_fade();

  delay(1000L*60L*1L);

  
//  analogWrite(pinResistor, 0);
//  delay(offTime);

  //JKL comment out to keep awake
//  ubersleep(offTime);       // Delay while off

}

//custom buzz pattern
void buzz_soft_ramp_up_slower_fade() {
  //soft ramp up and slower fade
  analogWrite(pinResistor, 100);
  delay(50);
  analogWrite(pinResistor, 112);
  delay(50);
  analogWrite(pinResistor, 125);
  delay(50);
  analogWrite(pinResistor, 138);
  delay(50);
  analogWrite(pinResistor, 150);
  delay(300);
  analogWrite(pinResistor, 138);
  delay(100);
  analogWrite(pinResistor, 125);
  delay(100);
  analogWrite(pinResistor, 112);
  delay(100);
  analogWrite(pinResistor, 100);
  delay(100);
  analogWrite(pinResistor, 0);
  delay(500); 
}

//custom buzz pattern
void buzz_double_soft_ramp_up_slower_fade() {
  //double peak soft ramp up and slower fade
  analogWrite(pinResistor, 100);
  delay(50);
  analogWrite(pinResistor, 112);
  delay(50);
  analogWrite(pinResistor, 125);
  delay(50);
  analogWrite(pinResistor, 138);
  delay(50);
  analogWrite(pinResistor, 150);
  delay(300);
  analogWrite(pinResistor, 138);
  delay(50);
  analogWrite(pinResistor, 125);
  delay(50);
  analogWrite(pinResistor, 112);
  delay(50);
  analogWrite(pinResistor, 100);
  delay(50);
  analogWrite(pinResistor, 112);
  delay(50);
  analogWrite(pinResistor, 138);
  delay(50);
  analogWrite(pinResistor, 150);
  delay(300);
  analogWrite(pinResistor, 138);
  delay(100);
  analogWrite(pinResistor, 125);
  delay(100);
  analogWrite(pinResistor, 112);
  delay(100);
  analogWrite(pinResistor, 100);
  delay(100);
  analogWrite(pinResistor, 0);
  delay(500);
}



//JKL refernce vibration levels
//  analogWrite(pinResistor, 50); //can *maybe* barely discern motor is actuating with finger on  it
//  delay(1000);
//  analogWrite(pinResistor, 0);
//  delay(500);
//  analogWrite(pinResistor, 100); //juuuust barely feel with finger on motor
//  delay(1000);
//  analogWrite(pinResistor, 0);
//  delay(500);
//  analogWrite(pinResistor, 150); //audible and feelable
//  delay(1000);
//  analogWrite(pinResistor, 0);
//  delay(500);
//  analogWrite(pinResistor, 200); //audible and feelable
//  delay(1000);
//  analogWrite(pinResistor, 0);
//  delay(500);
//  analogWrite(pinResistor, 255); //audible and feelable
//  delay(1000);
//  analogWrite(pinResistor, 0);
//  delay(500);

  //JKL pattern experiments

//  //simple ramp up
//  analogWrite(pinResistor, 100);
//  delay(100);
//  analogWrite(pinResistor, 125);
//  delay(100);
//  analogWrite(pinResistor, 150);
//  delay(300);
//  analogWrite(pinResistor, 0);
//  delay(500);
//
//  //stronger ramp up
//  analogWrite(pinResistor, 100);
//  delay(50);
//  analogWrite(pinResistor, 125);
//  delay(50);
//  analogWrite(pinResistor, 150);
//  delay(50);
//  analogWrite(pinResistor, 175);
//  delay(50);
//  analogWrite(pinResistor, 200);
//  delay(300);
//  analogWrite(pinResistor, 0);
//  delay(500);
//
//  //soft ramp up and down
//  analogWrite(pinResistor, 100);
//  delay(100);
//  analogWrite(pinResistor, 125);
//  delay(100);
//  analogWrite(pinResistor, 150);
//  delay(300);
//  analogWrite(pinResistor, 125);
//  delay(100);
//  analogWrite(pinResistor, 100);
//  delay(100);
//  analogWrite(pinResistor, 0);
//  delay(500);
//
//  //soft ramp up and slower fade
//  analogWrite(pinResistor, 100);
//  delay(50);
//  analogWrite(pinResistor, 112);
//  delay(50);
//  analogWrite(pinResistor, 125);
//  delay(50);
//  analogWrite(pinResistor, 138);
//  delay(50);
//  analogWrite(pinResistor, 150);
//  delay(300);
//  analogWrite(pinResistor, 138);
//  delay(100);
//  analogWrite(pinResistor, 125);
//  delay(100);
//  analogWrite(pinResistor, 112);
//  delay(100);
//  analogWrite(pinResistor, 100);
//  delay(100);
//  analogWrite(pinResistor, 0);
//  delay(500);
//
//  //stronger ramp up and down
//  analogWrite(pinResistor, 100);
//  delay(50);
//  analogWrite(pinResistor, 125);
//  delay(50);
//  analogWrite(pinResistor, 150);
//  delay(50);
//  analogWrite(pinResistor, 175);
//  delay(50);
//  analogWrite(pinResistor, 200);
//  delay(300);
//  analogWrite(pinResistor, 175);
//  delay(50);
//  analogWrite(pinResistor, 150);
//  delay(50);
//  analogWrite(pinResistor, 125);
//  delay(50);
//  analogWrite(pinResistor, 100);
//  delay(50);
//  analogWrite(pinResistor, 0);
//  delay(500);
//  
//  //stronger ramp up and slower fade
//  analogWrite(pinResistor, 100);
//  delay(50);
//  analogWrite(pinResistor, 125);
//  delay(50);
//  analogWrite(pinResistor, 150);
//  delay(50);
//  analogWrite(pinResistor, 175);
//  delay(50);
//  analogWrite(pinResistor, 200);
//  delay(300);
//  analogWrite(pinResistor, 175);
//  delay(100);
//  analogWrite(pinResistor, 150);
//  delay(100);
//  analogWrite(pinResistor, 125);
//  delay(100);
//  analogWrite(pinResistor, 100);
//  delay(100);
//  analogWrite(pinResistor, 0);
//  delay(500);
//
//  analogWrite(pinResistor, 255);
//  delay(200);
//  analogWrite(pinResistor, 0);
//  delay(200);
//  analogWrite(pinResistor, 255);
//  delay(600);
//  analogWrite(pinResistor, 0);
//  delay(3000);
