//JKL hacking of mindfulness buzzer for feather 32u4
//20200529

//different buzz patterns at end of sketch as comments
//using interrupt as here https://tholken.wordpress.com/tag/feather-32u4/


//TODO method to reset timers (for start of hour *or* start of activity)
//TODO use millis() ? {Returns the number of milliseconds passed since the Arduino board began running the current program. This number will overflow (go back to zero), after approximately 50 days.}

#include <Adafruit_SleepyDog.h>

#define VBATPIN A9
   


const int 
  pinResistor = 10, //pin 10 for feather 32u4 breakout grid with resistor to motor
  interruptPin = 2;  //Adalogger uses Pin3 for INT0
  
const float
  debouncing_time = 1000, //Debouncing Time in Milliseconds
//  sleepTimeMins = 1, //just for less math later
  sleepTimeMins = 15, //just for less math later
  sleepTime = sleepTimeMins * 60 * 1000L, // Total milliseconds remaining in sleep (minutes * 60 seconds * 1000ms)
  lowBatteryLevel = 3.7;

//yeah, lazy casts
volatile float 
  sleepTimeRemaining = sleepTime,
  maxSleepMS = 7000, //feather 32u4 is 8000ms max sleep time, making this close.
  last_micros, // Hold what time it is....
  hoursPassed = 0,
  buzzCount = 0,
  waterDrank = -1; //bite me
  
volatile bool
  intervalEnd = false,
  interrupted = false;


//Debugging options here
const bool 
  debugSerialOutput = false,
  debugStatusLED = false; //led on without serial write will have the led illuminate dimly for the briefest of intervals. hard to see but there.


void setup() {
  // For boards with "native" USB support (e.g. not using an FTDI chip or
  // similar serial bridge), Serial connection may be lost on sleep/wake,
  // and you might not see the "I'm awake" messages. Use the onboard LED
  // as an alternate indicator -- the code turns it on when awake, off
  // before going to sleep.
  
  pinMode(pinResistor, OUTPUT); //for vibrate motor

  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH); // Show we're awake [also that we have yet to fall through the while(!Serial)]
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
  
  if (debugStatusLED) {
    digitalWrite(LED_BUILTIN, HIGH); // Show we're awake
  }

  //attach an interrupt to a PIN
  attachInterrupt(digitalPinToInterrupt(interruptPin), debounceInterrupt, RISING);

  if (debugSerialOutput) {
    USBDevice.attach();
    delay(5000); //serial print doesnt seem to work wihtout some delays
    while(!Serial);
    Serial.flush();
    Serial.print("I'm awake now after initial sleep test! I slept for ");
    Serial.print(maxSleepMS, 0);
    Serial.println(" milliseconds.");
    Serial.println();
    Serial.flush();
  }
  interrupted = false; //reset after first triggering
  buzz_double_soft_ramp_up_slower_fade(); //give us a nice buzz
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
  waterDrank++;
}


//
// MAIN LOOP
//

void loop() {

  if (intervalEnd) {

    //reset end of interval boolean
    intervalEnd = false;

    //reset sleep/reminder interval
    sleepTimeRemaining = sleepTime;

    //add time passed to hours passed
    hoursPassed = hoursPassed +  sleepTimeMins/60; //divide by 60 to get decimal part of hours elapsed in one interval

    //buzz long or short?
    if (buzzCount == 0) { //long
      buzzCount++;
        buzz_double_soft_ramp_up_slower_fade();
  
    } else { //short
      buzzCount++;
      buzz_soft_ramp_up_slower_fade();
      if (buzzCount >= 60/sleepTimeMins) { //change '4' to (60/sleepTimeMins) ? ehhh but then if you pick a value that doesnt divide 60 you get some weird results. of just make all vars floats...
        buzzCount = 0;
      }
    }


  if (hoursPassed > waterDrank) {
    //angry buzz if not drinking enough water
    buzz_angry();
    if (debugSerialOutput) {
      Serial.println("DRINK MORE WATER!");
      delay(5000); //serial print doesnt seem to work wihtout some delays
      Serial.flush();
    }
  }

  
  if (debugSerialOutput) {
    Serial.flush();
    delay(1000);
    Serial.print("I've buzzed ");
    Serial.print(buzzCount, 0);
    Serial.println(" times so far this hour.");
    Serial.print("And ");
    Serial.print(hoursPassed, 0);
    Serial.println(" hours have passed since last reset.");
    Serial.flush();
    delay(5000);
  }

} //end of "intervalEnd" if statement
  

  if (debugSerialOutput) {
    Serial.println("Going to sleep in one second...");
    Serial.flush();
    delay(1000);
    USBDevice.detach();
  }
  
  if (debugStatusLED) {
    digitalWrite(LED_BUILTIN, LOW); // Show we're asleep
  }

  float sleepMS; //declare so can use later on in loop

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

  if (debugStatusLED) {
    digitalWrite(LED_BUILTIN, HIGH); // Show we're awake again
  }



  // subtract recent sleep interval from total sleep time
  sleepTimeRemaining = sleepTimeRemaining - sleepMS;

  float measuredvbat = analogRead(VBATPIN);
  measuredvbat *= 2;    // we divided by 2, so multiply back
  measuredvbat *= 3.3;  // Multiply by 3.3V, our reference voltage
  measuredvbat /= 1024; // convert to voltage

  if (measuredvbat <= lowBatteryLevel) {
    digitalWrite(LED_BUILTIN, HIGH); //turn on LED to show low battery level
  }

  if (debugSerialOutput) {
    // Try to reattach USB connection on "native USB" boards (connection is
    // lost on sleep). Host will also need to reattach to the Serial monitor.
    // Seems not entirely reliable, hence the LED indicator fallback.
    #if defined(USBCON) && !defined(USE_TINYUSB)
      USBDevice.attach();
    #endif

    while(!Serial);
    delay(5000);
    Serial.print("I'm awake now! I slept for ");
    Serial.print(sleepMS, 0);
    Serial.println(" milliseconds.");

    Serial.print("VBat: " ); 
    Serial.println(measuredvbat);
    
    Serial.print("I have ");
    Serial.print(sleepTimeRemaining, 0);
    Serial.println(" milliseconds left to sleep.");

    Serial.print("and drank ");
    Serial.print(waterDrank, 0);
    Serial.println(" glasses.");
    if (interrupted) {
      Serial.println("Interrupt Button Pressed");
      delay(5000); //serial print doesnt seem to work without some delays
    }
    
    Serial.flush();
    delay(1000);
  }

  if (interrupted) {
    interrupted = false;
    //anything else to do after an interrupt?

    //save light state (if battery low or other future uses?)
    int stateLED = digitalRead(LED_BUILTIN);
    
    //flash number of times for glasses drank - waterDrank
    for (int i = 1; i <= waterDrank; i++) {
      digitalWrite(LED_BUILTIN, HIGH); //turn on LED for glass drank
      delay(500); //leave on for 500ms
      digitalWrite(LED_BUILTIN, LOW); //turn off LED
      delay(250); //leave off for 500ms
    }

    //pause
    delay(1500); //flash break for x ms

    //flash for hours passed - hoursPassed
    float TEMPhoursPassed = 1;
    if (hoursPassed > 1) {
      TEMPhoursPassed = hoursPassed;
    }
    for (int i = 1; i <= TEMPhoursPassed; i++) {
      digitalWrite(LED_BUILTIN, HIGH); //turn on LED for hour passed
      delay(500); //leave on for 500ms
      digitalWrite(LED_BUILTIN, LOW); //turn off LED
      delay(250); //leave off for 500ms
    }
    
    //pause
    delay(2000); //flash break for x ms

    //return to previous LED state
    digitalWrite(LED_BUILTIN, stateLED);
  }

}

//
//
// BUZZ FUNCTIONS AND PATTERNS
//
//

//TODO allow input to scale time length of buzz

//custom buzz pattern
void buzz_angry() {
  //sharp buzzes
  analogWrite(pinResistor, 255);
  delay(150);
  analogWrite(pinResistor, 0);
  delay(150);
  analogWrite(pinResistor, 255);
  delay(500);
  analogWrite(pinResistor, 0);
  delay(100);
  analogWrite(pinResistor, 255);
  delay(500);
  analogWrite(pinResistor, 0);
  delay(100);  
  analogWrite(pinResistor, 255);
  delay(500);
  analogWrite(pinResistor, 0);
  delay(150);
  analogWrite(pinResistor, 255);
  delay(150);
  analogWrite(pinResistor, 0);
}


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
