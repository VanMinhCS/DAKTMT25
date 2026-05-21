#include <Arduino.h>
#include <AccelStepper.h>

#define EN_PIN    16
#define STEP_PIN  17
#define DIR_PIN   18

AccelStepper stepper(
  AccelStepper::DRIVER,
  STEP_PIN,
  DIR_PIN
);

int baseSpeed = 500;
int currentSpeed = baseSpeed;

void setup() {
  Serial.begin(115200);
  pinMode(EN_PIN, OUTPUT);
  digitalWrite(EN_PIN, LOW);
  stepper.setMaxSpeed(100000);
  stepper.setSpeed(currentSpeed);
  Serial.print("OK");
}

void loop() {
  if (Serial.available() > 0) {
    char c = static_cast<char>(Serial.read());
    if (c == '0') {
      currentSpeed = -currentSpeed;
      stepper.setSpeed(currentSpeed);
    }
    else if (c == '-') {
      baseSpeed -= 50;
      if (currentSpeed < 0) currentSpeed = -baseSpeed;
      else currentSpeed = baseSpeed;
      stepper.setSpeed(currentSpeed);
    }
    else if (c == '+') {
      baseSpeed += 50;
      if (currentSpeed < 0) currentSpeed = -baseSpeed;
      else currentSpeed = baseSpeed;
      stepper.setSpeed(currentSpeed);
    }
    else if (c == 's') {
      currentSpeed = 0;
      stepper.setSpeed(currentSpeed);
    }
  }
  stepper.runSpeed();
}