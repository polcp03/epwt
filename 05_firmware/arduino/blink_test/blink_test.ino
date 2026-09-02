// Sketch de verificacion de la cadena de compilacion.
// No hace nada util: solo demuestra que arduino-cli compila para ESP32.
#include <Arduino.h>

// La placa generica esp32:esp32:esp32 no define LED_PIN.
static const uint8_t LED_PIN = 2;

static const uint32_t LOOP_PERIOD_MS = 500;
static uint32_t last_tick = 0;

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  const uint32_t now = millis();
  if (now - last_tick >= LOOP_PERIOD_MS) {
    last_tick = now;
    digitalWrite(LED_PIN, !digitalRead(LED_PIN));
    Serial.printf("t=%lu ms\n", (unsigned long)now);
  }
}
