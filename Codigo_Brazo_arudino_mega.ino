int valorJoystick[5];
String SumaDeValores;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
}

void loop() {
  // put your main code here, to run repeatedly:
  
  valorJoystick[0] = analogRead(A0);
  valorJoystick[1] = analogRead(A1);
  valorJoystick[2] = analogRead(A2);
  valorJoystick[3] = analogRead(A3);
  valorJoystick[4] = analogRead(A4);
  SumaDeValores = "0," + String(valorJoystick[0]) + "," + String(valorJoystick[1]) + "," + String(valorJoystick[2]) + "," + String(valorJoystick[3]) + "," + String(valorJoystick[4]) + "\n";
  Serial.print(SumaDeValores);
  delay(100);
}