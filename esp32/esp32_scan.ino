#include <Wire.h>
#include <Adafruit_MLX90614.h>
#include <WiFi.h>
#include <HTTPClient.h>

#define SDA_PIN 13
#define SCL_PIN 14

Adafruit_MLX90614 mlx = Adafruit_MLX90614();

const char* ssid = "Sabiha";
const char* password = "12345678";
const char* backendUrl = "https://cattlevision-ai-backend.onrender.com/iot/reading";

void setup() {
  Serial.begin(115200);
  Wire.begin(SDA_PIN, SCL_PIN);

  WiFi.begin(ssid, password);
  while(WiFi.status()!=WL_CONNECTED){delay(500); Serial.print(".");}
  Serial.println("WiFi Connected");

  if(!mlx.begin()){Serial.println("MLX90614 not found"); while(1);}
}

void loop(){
  float ambient = mlx.readAmbientTempC();
  float object = mlx.readObjectTempC();

  if(WiFi.status()==WL_CONNECTED){
    HTTPClient http;
    http.begin(backendUrl);
    http.addHeader("Content-Type","application/json");
    String payload="{\"temperature\":"+String(object,1)+
                   ",\"ambient\":"+String(ambient,1)+
                   ",\"deviceId\":\"ESP32-CAM-01\"}";
    int code = http.POST(payload);
    if(code>0) Serial.println(http.getString());
    else Serial.println("POST error "+String(code));
    http.end();
  }

  delay(5000); // 5 sec interval
}