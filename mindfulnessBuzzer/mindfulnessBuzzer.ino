//JKL hacking of mindfulness buzzer for feather 32u4
//20200529

//different buzz patterns at end of sketch as comments


//TODO input method for tracking one stat (eg water tracker?)
//TODO method to reset timers (for start of hour *or* start of activity)
//TODO use millis() ? {Returns the number of milliseconds passed since the Arduino board began running the current program. This number will overflow (go back to zero), after approximately 50 days.}

#include <Adafruit_SleepyDog.h>

const uint32_t
  onTime   =  1 * 1000L, // Vibration motor run time, in seconds * 1000 to get milliseconds
  interval = 6 * 1000L, // Time between reminders, in seconds (and then * 1000 to get milliseconds)
//  sleepTime = 1 * 60 * 1000L; // Total milliseconds remaining in sleep (minutes * 60 seconds * 1000ms)
  sleepTime = 15 * 60 * 1000L; // Total milliseconds remaining in sleep (minutes * 60 seconds * 1000ms)
  //TODO interval and sleeptime should be the same amount..

//const uint32_t offTime = interval - onTime; // Duration motor is off, ms

//using adafruit sleepydog library which does WDT (Watch Dog Timer) stuff for me
  // Set full power-down sleep mode and go to sleep.
  //  set_sleep_mode(SLEEP_MODE_PWR_DOWN);


volatile uint32_t sleepTimeRemaining = sleepTime;

volatile uint16_t maxSleepMS = 7000; //feather 32u4 is 8000ms max sleep time, making this close.
volatile bool intervalEnd = true; //start at true so we get a long (or 'top of the hour/round') buzz
volatile int buzzCount = 0;

//JKL pin with resistor to motor
const int pinResistor = 10; //pin 10 for feather 32u4 breakout grid

long debouncing_time = 1000; //Debouncing Time in Milliseconds
// Hold what time it is....
volatile unsigned long last_micros;
volatile int water = -1; //bite me
 
// Setup the Pins to use.
const byte interruptPin = 3;  //Adalogger uses Pin3 for INT0

volatile bool interrupted = false;
const bool debugSerialOutput = true;

void setup() {

  // LED shenanigans.  Rather that setting pin 1 to an output and using
  // digitalWrite() to turn the LED on or off, the internal pull-up resistor
  // (about 10K) is enabled or disabled, dimly lighting the LED with much
  // less current.
//  pinMode(LEDpinResistor, INPUT);               // LED off to start



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

//
// new sketch
//

    // For boards with "native" USB support (e.g. not using an FTDI chip or
  // similar serial bridge), Serial connection may be lost on sleep/wake,
  // and you might not see the "I'm awake" messages. Use the onboard LED
  // as an alternate indicator -- the code turns it on when awake, off
  // before going to sleep.
  
  pinMode(pinResistor, OUTPUT); //for vibrate motor

  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH); // Show we're awake
  pinMode(interruptPin, INPUT_PULLUP);   // enable the Pull up resistor for interrupt button pin

  if (debugSerialOutput) {
    Serial.begin(115200);
    while(!Serial); // wait for Arduino Serial Monitor (native USB boards)
    Serial.println("Testing to see max sleep interval...");
    Serial.println();
    Serial.flush();
    
    delay(5000);
    USBDevice.detach();
  }
  
  digitalWrite(LED_BUILTIN, LOW); // Show we're asleep
  //run sleep() with no input and save result as max sleep time interval
  maxSleepMS = Watchdog.sleep();
  digitalWrite(LED_BUILTIN, HIGH); // Show we're awake

  //attach an interrupt to a PIN
  attachInterrupt(digitalPinToInterrupt(interruptPin), debounceInterrupt, RISING);

  if (debugSerialOutput) {
    USBDevice.attach();
    delay(5000); //serial print doesnt seem to work wihtout some delays
    while(!Serial);
    Serial.flush();
    Serial.print("I'm awake now after initial sleep test! I slept for ");
    Serial.print(maxSleepMS, DEC);
    Serial.println(" milliseconds.");
    Serial.println();
    Serial.flush();
//    delay(1000);
  }
  interrupted = false; //reset after first triggering
}

void debounceInterrupt(){
  if((long)(micros() - last_micros) >= debouncing_time * 1000) {
    doInterrupt();           // do the Work
    last_micros = micros();  // Remember when we did it
  }
}

void doInterrupt() {
  //interrupt will mess with saving output # of sleep function
  interrupted = true;
  water++;
}

void loop() {

//  buzz_double_soft_ramp_up_slower_fade();
//
//  delay(1000L*60L*1L);
//  
//  buzz_soft_ramp_up_slower_fade();
//
//  delay(1000L*60L*1L);
//  
//  buzz_soft_ramp_up_slower_fade();
//
//  delay(1000L*60L*1L);
//    
//  buzz_soft_ramp_up_slower_fade();
//
//  delay(1000L*60L*1L);

  if (intervalEnd) {
    if (debugSerialOutput) {
      Serial.flush();
      delay(1000);
      Serial.println("Sleep interval COMPLETED! Doing something and then going back to sleep.");
      Serial.print("I've buzzed ");
      Serial.print(buzzCount, DEC);
      Serial.println(" times so far this go round.");
      Serial.flush();
      delay(5000);
    }

    //reset end of interval boolean
    intervalEnd = false;

    //reset sleep/reminder interval
    sleepTimeRemaining = sleepTime;

    //buzz long or short?
    if (buzzCount == 0) { //long
      buzzCount++;
        buzz_double_soft_ramp_up_slower_fade();
  
    } else { //short
      buzzCount++;
      buzz_soft_ramp_up_slower_fade();
      if (buzzCount == 4) {
        buzzCount = 0;
      }
    }

//TODO TODO TODO
//

    //angry buzz if not drinking enough water
    //if cups water < hours elapsed 
       //then angry buzz (Every 15 minutes)
  }

  if (debugSerialOutput) {
    Serial.println("Going to sleep in one second...");
    Serial.flush();
    delay(1000);
    USBDevice.detach();
  }
  
  // To enter low power sleep mode call Watchdog.sleep() like below
  // and the watchdog will allow low power sleep for as long as possible.
  // The actual amount of time spent in sleep will be returned (in 
  // milliseconds).
  digitalWrite(LED_BUILTIN, LOW); // Show we're asleep

  
  int sleepMS; //declare so can use later on in loop

  //test time left to sleep against interval
  if (sleepTimeRemaining > maxSleepMS) {
    sleepMS = Watchdog.sleep(maxSleepMS);
  } else {
    intervalEnd = true; //fallback way to say overall sleep/reminder interval has elapsed
    sleepMS = Watchdog.sleep(sleepTimeRemaining);
  }


  //
  // Code resumes here on wake.
  //

  digitalWrite(LED_BUILTIN, HIGH); // Show we're awake again

  if (interrupted) {
    if (debugSerialOutput) {
      USBDevice.attach();
      delay(5000); //serial print doesnt seem to work wihtout some delays
      while(!Serial);
      Serial.println("Interrupt Button Pressed");
      Serial.flush();
      delay(5000); //serial print doesnt seem to work wihtout some delays
    }
    interrupted = false;
  }

  // subtract recent sleep interval from total sleep time
  sleepTimeRemaining = sleepTimeRemaining - sleepMS;

  if (debugSerialOutput) {
    // Try to reattach USB connection on "native USB" boards (connection is
    // lost on sleep). Host will also need to reattach to the Serial monitor.
    // Seems not entirely reliable, hence the LED indicator fallback.
//  #if defined(USBCON) && !defined(USE_TINYUSB)
    USBDevice.attach();
//  #endif

    while(!Serial);
    delay(5000);
    Serial.print("I'm awake now! I slept for ");
    Serial.print(sleepMS, DEC);
    Serial.println(" milliseconds.");
//    Serial.println();
    
    Serial.print("I have ");
    Serial.print(sleepTimeRemaining, DEC);
    Serial.println(" milliseconds left to sleep.");

//prob not here but for testing
    Serial.print("and drank ");
    Serial.print(water, DEC);
    Serial.println(" glasses.");

    
    Serial.flush();
    delay(1000);
  }

  
//  analogWrite(pinResistor, 0);
//  delay(offTime);

  //JKL comment out to keep awake
//  ubersleep(offTime);       // Delay while off

}


//TODO allow input to scale time length of buzz
//custom buzz pattern
void buzz_soft_ramp_up_slower_fade() { //default 1000ms
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
void buzz_double_soft_ramp_up_slower_fade() { //default 2000ms
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
