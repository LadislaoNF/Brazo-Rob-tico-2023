#include "WiFi.h"
#include "AsyncUDP.h"

String incoming;
int arm=0;

uint8_t datos[255];
const char * ssid = "Virgilio";
const char * password = "password";


AsyncUDP udp;


void setup() {
    Serial.begin(115200);
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password);
    if (WiFi.waitForConnectResult() != WL_CONNECTED) {
        Serial.println("WiFi Failed");
        while(1) {
            delay(1000);
        }
    }
    if(udp.listen(1234)) {
        Serial.print("UDP Listening on IP: ");
        Serial.println(WiFi.localIP());
        udp.onPacket([](AsyncUDPPacket packet) {
            if(packet.length()<255){
              memcpy(datos,packet.data(),255);
            }
            
            Serial.write(packet.data(),packet.length());
            //We need to listen for: Arm and fingers
        
        });
    } 
}

// int(X) es para float
// X.toInt() es para string


void loop() {



}