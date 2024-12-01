// Arduino LDR and LED Control Code

const int LDR_PIN = A0; // Analog input pin for LDR sensor
const int LED_PIN = 9; // PWM output pin for LED

const int TARGET_LDR_VALUE = 190; // Desired LDR value (adjust this to your desired constant level)
void setup() {

 pinMode(LDR_PIN, INPUT);
 pinMode(LED_PIN, OUTPUT);

}
void loop() {
 int ldrValue = analogRead(LDR_PIN); // Read LDR sensor value (0-1023)

 // Calculate the error between the current LDR value and the target value
 int error = ldrValue - TARGET_LDR_VALUE; 

 // Calculate the brightness adjustment based on the error
 int brightnessAdjustment = error * 2; // Adjust gain as needed for finer control
 // Calculate the new brightness value, starting with a default brightness
 int brightness = 128 + brightnessAdjustment; 
 // Constrain the brightness value to ensure it stays within the valid range (0-255)
 brightness = constrain(brightness, 0, 255);

// Set the brightness of the LED using the calculated brightness value
 analogWrite(LED_PIN, brightness); 

}
