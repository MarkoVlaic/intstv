#include <DHT.h>
#include <MQTTPubSubClient.h>
#include <WiFi.h>

#define DHTPIN 4     // Pin which is connected to the DHT sensor.
#define DHTTYPE DHT11   // DHT 11

DHT dht(DHTPIN, DHTTYPE);

// Update these with your network credentials
const char* ssid = "Vlaic";
const char* password = "magarac123";
const char* mqtt_server = "192.168.1.8"; 

WiFiClient espClient;
MQTTPubSubClient client;

// discovery data
bool discovery_sent = false;
char* light_discovery_json = "{"
"  \"name\": \"ESP light\","
"  \"unique_id\": \"light\","
"  \"device_class\": \"illuminance\","
"  \"state_topic\": \"homeassistant/sensor/illuminance/state\","
"  \"unit_of_measurement\": \"%\","
"  \"suggested_display_precision\": 1,"
"  \"device\": {"
"    \"identifiers\": ["
"      \"light000\""
"    ],"
"    \"name\": \"light sensor\","
"    \"manufacturer\": \"Example light sensors Ltd.\","
"    \"model\": \"mihael\","
"    \"serial_number\": \"mihael\","
"    \"hw_version\": \"1.01a\","
"    \"sw_version\": \"2024.1.0\""
"  }"
"}";

char* dht_temp_discovery_json = "{"
"  \"name\": \"temperature\","
"  \"unique_id\": \"esp_temperature\","
"  \"device_class\": \"temperature\","
"  \"state_topic\": \"homeassistant/sensor/dht/state\","
"  \"unit_of_measurement\": \"%\","
"  \"suggested_display_precision\": 1,"
"  \"device\": {"
"    \"identifiers\": ["
"      \"dht000\""
"    ],"
"    \"name\": \"dht sensor\","
"    \"manufacturer\": \"Example dht sensors Ltd.\","
"    \"model\": \"mihael\","
"    \"serial_number\": \"mihael\","
"    \"hw_version\": \"1.01a\","
"    \"sw_version\": \"2024.1.0\""
"  }"
"}";

char* dht_hum_discovery_json = "{"
"  \"name\": \"humidity\","
"  \"unique_id\": \"esp_humidity\","
"  \"device_class\": \"humidity\","
"  \"state_topic\": \"homeassistant/sensor/dht/state\","
"  \"unit_of_measurement\": \"%\","
"  \"suggested_display_precision\": 1,"
"  \"device\": {"
"    \"identifiers\": ["
"      \"dht000\""
"    ],"
"    \"name\": \"dht sensor\","
"    \"manufacturer\": \"Example dht sensors Ltd.\","
"    \"model\": \"mihael\","
"    \"serial_number\": \"mihael\","
"    \"hw_version\": \"1.01a\","
"    \"sw_version\": \"2024.1.0\""
"  }"
"}";

// discovery functionality
void send_discovery() {
    Serial.println("send mqtt discovery");
    client.publish("homeassistant/sensor/light/config", light_discovery_json, false, 1);
    client.publish("homeassistant/sensor/dht_temp/config", dht_temp_discovery_json, false, 1);
    client.publish("homeassistant/sensor/dht_hum/config", dht_hum_discovery_json, false, 1);
    discovery_sent = true;
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.isConnected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("arduinoClient")) {
      Serial.println("connected");
      send_discovery();
    } else {
      Serial.print("failed, error code=");
      Serial.print(client.getLastError());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  delay(10);
  dht.begin();

  // Connect to Wi-Fi
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  espClient.connect(mqtt_server, 1883);
  client.begin(espClient);
}

void loop() {
  if (!client.isConnected()) {
    reconnect();
  }
  client.update();

  if(!discovery_sent) {
    //send_discovery();  
  }

  // Reading temperature and humidity
  /*float h = dht.readHumidity();
  float t = dht.readTemperature();

  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  // Publish the temperature and humidity values to MQTT broker
  char tempStr[8];
  dtostrf(t, 1, 2, tempStr);
  Serial.print("h: ");
  Serial.print(h);
  Serial.print(" t: ");
  Serial.println(t);
  //client.publish("home/temperature", tempStr);

  char humStr[8];
  dtostrf(h, 1, 2, humStr);
  //client.publish("home/humidity", humStr);*/

  // Wait a few seconds between measurements.
  delay(2000);
}
