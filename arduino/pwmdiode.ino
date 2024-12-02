// Pin assignments
const int pwmPin = 9;       // PWM output pin
const int voltagePin = A1;  // Analog pin to measure voltage across the diode
const int currentPin = A3;  // Analog pin to measure voltage across the sense resistor
// Constants
const float VCC = 5.0;          // Arduino operating voltage
const int PWM_RESOLUTION = 255; // 8-bit PWM resolution
const float R_SENSE = 2.0;    // Sense resistor value in ohms
void setup() {
  pinMode(pwmPin, OUTPUT);
  Serial.begin(9600); // Initialize serial communication
}
void loop() {
  for (int dutyCycle = 0; dutyCycle <= PWM_RESOLUTION; dutyCycle++) {
    analogWrite(pwmPin, dutyCycle); // Set PWM duty cycle
    delay(10);                      // Small delay to stabilize
    // Read the voltage across the diode
    int voltageRaw = analogRead(voltagePin);
    float voltage = (voltageRaw / 1023.0) * VCC;
    // Read the voltage across the sense resistor
    int currentRaw = analogRead(currentPin);
    float currentVoltage = (currentRaw / 1023.0) * VCC;
    float current = currentVoltage / R_SENSE; // Calculate current using Ohm's law
    // Print the results
    Serial.print('(');
    Serial.print(voltage);
    Serial.print(",");
    Serial.print(current);
    Serial.print(')');
    Serial.println(",");
    delay(100); // Small delay for stable readings
  }
  delay(2000); // Pause before starting again
}
