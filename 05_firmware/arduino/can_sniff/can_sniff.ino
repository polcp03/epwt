// can_sniff - throwaway hardware bring-up test. Not the logger.
// Goal: prove the ESP32 <-> MCP2515 <-> VESC wiring is alive.
// Listen-only: never ACKs, so a wrong bitrate cannot disturb the VESC bus.

#include <SPI.h>
#include <mcp_can.h>

const uint8_t PIN_CS = 5;

MCP_CAN can(PIN_CS);

unsigned long frameCount = 0;
unsigned long lastReport = 0;

void setup() {
  Serial.begin(115200);
  delay(1000);

  // MCP_ANY = accept every ID, no filtering. MCP_8MHZ = the module's crystal.
  if (can.begin(MCP_ANY, CAN_500KBPS, MCP_8MHZ) != CAN_OK) {
    Serial.println("MCP2515 init FAILED - check SPI wiring and 3V3 supply");
    while (true) { delay(1000); }
  }

  can.setMode(MCP_LISTENONLY);
  Serial.println("MCP2515 ready - 500 kbit/s, listen-only. Waiting for frames...");
}

void loop() {
  if (can.checkReceive() == CAN_MSGAVAIL) {
    unsigned long id = 0;
    byte ext = 0;
    byte len = 0;
    byte buf[8];

    if (can.readMsgBuf(&id, &ext, &len, buf) == CAN_OK) {
      frameCount++;
      Serial.printf("ID 0x%08lX %s DLC %u |", id, ext ? "EXT" : "STD", len);
      for (byte i = 0; i < len; i++) {
        Serial.printf(" %02X", buf[i]);
      }
      Serial.println();
    }
  }

  // Heartbeat every 2 s so silence is distinguishable from a hung sketch.
  if (millis() - lastReport > 2000) {
    lastReport = millis();
    if (frameCount == 0) {
      Serial.printf("...no frames yet (RX errors: %u)\n", can.errorCountRX());
    }
    frameCount = 0;
  }
}
