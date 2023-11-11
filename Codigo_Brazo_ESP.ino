#include "WiFi.h"
#include "AsyncUDP.h"
#include <WiFiUdp.h>
uint8_t datos[255]= "0";
const char * ssid = "Virgilio";
const char * password = "password";
String input;
String datostotal;
AsyncUDP udp;
String kinect;
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
    if(udp.listen(2222)) {
        Serial.print("UDP Listening on IP: ");
        Serial.println(WiFi.localIP());
        udp.onPacket([](AsyncUDPPacket packet) {
            if(packet.length()<255){
              memcpy(datos,packet.data(),255);
            }
            datos[packet.length()] = '\0';
            kinect = (char *)datos;
            
            //Serial.write(packet.data(),packet.length());
            //Serial.println();
            //We need to listen for: Arm and fingers
        });
    }
//En la imagen de pinout dice que 1 y 3 son Tx-Rx 0??
//Y los pines 17-16 son Tx-Rx 2???
//Bueno, a adaptar, no queda otra.

Serial.begin(115200);

}

// int(X) es para float
// X.toInt() es para string

void loop() {
  if(Serial.available()>0)
  {
  //  Serial.write(Serial2.read());  
  //input=Serial2.read();
    
    input = Serial.readStringUntil('\n');
    enviardata();
  }
}

void enviardata(){
  
 datostotal = kinect + "," + input + "\n";
 
 //udp.sendTo(datostotal.c_str(),IPAddress(192,168,20,224),1234);
 udp.broadcastTo(datostotal.c_str(), 1234);
 //udp.beginPacket("192,168.20.224", serverPort);
 //udp.write() 
 //udp.endPacket();
 //udp.close();
 Serial.print(datostotal);
}