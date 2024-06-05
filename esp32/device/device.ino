#include <DHT.h>
#include <MQTTPubSubClient.h>
#include <WiFi.h>

#define DHTPIN 4     // Pin which is connected to the DHT sensor.
#define DHTTYPE DHT11   // DHT 11
#define LIGHT_SENSOR_PIN 36 

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
"   \"value_template\": \"{{ value_json.temperature }}\","
"  \"unit_of_measurement\": \"°C\","
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
"  \"value_template\": \"{{ value_json.humidity }}\","
"  \"unit_of_measurement\": \"%\","
"  \"suggested_display_precision\": 1,"
"  \"device\": {"
"    \"identifiers\": ["
"      \"dht000\""
"    ],"
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

// maybe calculate size properly with sprintf
// not today
char reading_buf[256];

void loop() {
  if (!client.isConnected()) {
    reconnect();
  }
  client.update();

  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();

  if (isnan(humidity) || isnan(temperature)) {
    Serial.println("Failed to read from DHT sensor!");
    delay(2000);
    return;
  }

  int analogValue = analogRead(LIGHT_SENSOR_PIN);
  float light_percent = ((analogValue * 1.0f - 1023) / 1023) * 100.0f;
  
  sprintf(reading_buf, "{ \"temperature\": %f, \"humidity\": %f}", temperature, humidity);
  client.publish("homeassistant/sensor/dht/state", reading_buf, false, 1);
  sprintf(reading_buf, "%f", light_percent);
  client.publish("homeassistant/sensor/illuminance/state", reading_buf, false, 1);

  delay(2000);
}
