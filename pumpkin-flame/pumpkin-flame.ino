/*
 * PIR sensor tester
 */
 
int ledPin = 13;                // choose the pin for the LED
int buttonPin = 7;
int signalPIRpin = 5;
int inputPin = 2;               // choose the input pin (for PIR sensor)
int pirState = LOW;             // we start, assuming no motion detected
int val = 0;                    // variable for reading the pin status

// variables will change:
int buttonState = 0;         // variable for reading the pushbutton status

void setup() {
  pinMode(ledPin, OUTPUT);      // declare LED as output
  pinMode(signalPIRpin, OUTPUT);      // declare signal PIR as output
  pinMode(inputPin, INPUT);     // declare sensor as input
  
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);
 
  Serial.begin(9600);
}
 
void loop(){
  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);

  // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
  if (buttonState == HIGH) {
    // turn LED on:
    digitalWrite(ledPin, HIGH);
    digitalWrite(signalPIRpin, HIGH);
//    analogWrite(signalPIRpin, 100);

  } else {
    // turn LED off:
    digitalWrite(ledPin, LOW);
    digitalWrite(signalPIRpin, LOW);
//    analogWrite(signalPIRpin, 0);
  }

  //
  //
  
  val = digitalRead(inputPin);  // read input value
  if (val == HIGH) {            // check if the input is HIGH
    digitalWrite(ledPin, HIGH);  // turn LED ON
    digitalWrite(signalPIRpin, HIGH);
    delay(500);
    digitalWrite(ledPin, LOW); // turn LED OFF
    digitalWrite(signalPIRpin, LOW);
    if (pirState == LOW) {
      // we have just turned on
      Serial.println("Motion detected!");
      // We only want to print on the output change, not state
      pirState = HIGH;
    }
  }
//  } else {
//    digitalWrite(ledPin, LOW); // turn LED OFF
//    digitalWrite(signalPIRpin, LOW);
//    if (pirState == HIGH){
//      // we have just turned of
//      Serial.println("Motion ended!");
//      // We only want to print on the output change, not state
//      pirState = LOW;
//    }
//  }
}
