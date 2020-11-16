//JKL hacking of mindfulness buzzer for feather 32u4
//20200529


//TODO input method for tracking one stat (eg water tracker?)
//TODO method to reset timers (for start of hour or start of activity)
//TODO use millis()

const uint32_t
  onTime   =  1 * 1000L, // Vibration motor run time, in seconds * 1000 to get milliseconds
  interval = 6 * 1000L; // Time between reminders, in seconds * 1000 to get milliseconds

const uint32_t offTime = interval - onTime; // Duration motor is off, ms


//// This sketch spends nearly all its time in a low-power sleep state...
//#include <avr/power.h>
//#include <avr/sleep.h>

// The chip's 'watchdog timer' (WDT) is used to wake up the CPU when needed.
// WDT runs on its own 128 KHz clock source independent of main CPU clock.
// Uncalibrated -- it's "128 KHz-ish" -- thus not reliable for extended
// timekeeping.  To compensate, immediately at startup the WDT is run for
// one maximum-duration cycle (about 8 seconds...ish) while keeping the CPU
// awake, the actual elapsed time is noted and used as a point of reference
// when calculating sleep times.  Still quite sloppy -- the WDT only has a
// max resolution down to 16 ms -- this may drift up to 30 seconds per hour,
// but is an improvement over the 'raw' WDT clock and is adequate for this
// casual, non-medical, non-Mars-landing application.  Alternatives would
// require keeping the CPU awake, draining the battery much quicker.

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

//JKL comment out to keep awake
//  // The aforementioned watchdog timer calibration...
//  uint32_t t = millis();                       // Save start time
//  noInterrupts();                              // Timing-critical...
//  MCUSR &= ~_BV(WDRF);                         // Watchdog reset flag
//  WDTCSR  =  _BV(WDCE) | _BV(WDE);              // WDT change enable
//  WDTCSR  =  _BV(WDIE) | _BV(WDP3) | _BV(WDP0); // 8192-ish ms interval
//  interrupts();
//  while(sleepTime);                            // Wait for WDT
//  maxSleepInterval  = millis() - t;            // Actual ms elapsed
//  maxSleepInterval += 64;                      // Egyptian constant
//  power_timer0_disable();  // Knocks out millis(), delay(), analogWrite()
  
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
  
//  analogWrite(pinResistor, 0);
//  delay(offTime);


  //JKL comment out to keep awake
//  ubersleep(offTime);       // Delay while off

}

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


//JKL comment out to keep awake

//// WDT timer operates only in specific intervals based on a prescaler.
//// CPU wakes on each interval, prescaler is adjusted as needed to pick off
//// the longest setting possible on each pass, until requested milliseconds
//// have elapsed.
//const uint8_t cfg[] PROGMEM = { // WDT config bits for different intervals
//  _BV(WDIE) | _BV(WDP3) |                         _BV(WDP0), // ~8192 ms
//  _BV(WDIE) | _BV(WDP3)                                    , // ~4096 ms
//  _BV(WDIE) |             _BV(WDP2) | _BV(WDP1) | _BV(WDP0), // ~2048 ms
//  _BV(WDIE) |             _BV(WDP2) | _BV(WDP1)            , // ~1024 ms
//  _BV(WDIE) |             _BV(WDP2) |             _BV(WDP0), //  ~512 ms
//  _BV(WDIE) |             _BV(WDP2)                        , //  ~256 ms
//  _BV(WDIE) |                         _BV(WDP1) | _BV(WDP0), //  ~128 ms
//  _BV(WDIE) |                         _BV(WDP1)            , //   ~64 ms
//  _BV(WDIE) |                                     _BV(WDP0), //   ~32 ms
//  _BV(WDIE)                                                  //   ~16 ms
//}; // Remember, WDT clock is uncalibrated, times are "ish"
//
//void ubersleep(uint32_t ms) {
//  if(ms == 0) return;
//  tablePos      = 0;                   // Reset WDT config stuff to
//  sleepInterval = maxSleepInterval;    // longest interval to start
//  configWDT(ms);                       // Set up for requested time
//  set_sleep_mode(SLEEP_MODE_PWR_DOWN); // Deepest sleep mode
//  sleep_enable();
//  while(sleepTime && (tablePos < sizeof(cfg))) sleep_mode();
//  noInterrupts();                      // WDT off (timing critical)...
//  MCUSR &= ~_BV(WDRF);
//  WDTCSR  = 0;
//  interrupts();
//}
//
//static void configWDT(uint32_t newTime) {
//  sleepTime = newTime; // Total sleep time remaining (ms)
//  // Find next longest WDT interval that fits within remaining time...
//  while(sleepInterval > newTime) {
//    sleepInterval /= 2;                          // Each is 1/2 previous
//    if(++tablePos >= sizeof(cfg)) return;        // No shorter intervals
//  }
//  uint8_t bits = pgm_read_byte(&cfg[tablePos]);  // WDT config bits for time
//  noInterrupts();                                // Timing-critical...
//  MCUSR &= ~_BV(WDRF);
//  WDTCSR  =  _BV(WDCE) | _BV(WDE);                // WDT change enable
//  WDTCSR  =  bits;                                // Interrupt + prescale
//  interrupts();
//}
//
//ISR(WDT_vect) { // Watchdog timeout interrupt
//  configWDT(sleepTime - sleepInterval); // Subtract, setup next cycle...
//}
