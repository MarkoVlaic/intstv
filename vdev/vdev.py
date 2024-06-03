import paho.mqtt.client as mqtt
import argparse
import json
import sys
from random import random
import time

sensor_types = ['dht', 'light']

parser = argparse.ArgumentParser(description='Simulates a smart temperature and humidity or light sensor')
parser.add_argument('-t', '--type', required=True, choices=sensor_types)
parser.add_argument('-a','--host', help='address of broker host', default='127.0.0.1')
parser.add_argument('-p', '--port', help="port of broker host", default="1883", type=int)
parser.add_argument('-o', '--topic', help='mqtt topic on which the readings are published', default='homeassistant/sensor')
args = parser.parse_args()

type = args.type
host = args.host
port = args.port
topic = args.topic

client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
print(f'connecting to mqtt broker at {host}:{port}')
try:
  client.connect(host, port)
except:
  print('connection failed')
  sys.exit(1)

sensor_topic = f'{topic}/{type}_virt'
config_topic = f'{sensor_topic}/config'

dht_conf_temp = {
  "name": "virtual dht temperature",
  "state_topic": sensor_topic,
  "unique_id": "virt_dht_temp",
  "device_class": "temperature",
  "value_template": "{{ value_json.temperature }}",
  # "device": {
  #   "name": "temperature and humidity sensor",
  #   "identifiers": [
  #     "dht"
  #   ]
  # },
  "unit_of_measurement": "°C",
  "force_update": True
}

dht_conf_hum = {
  "name": "virtual dht humidity",
  "state_topic": sensor_topic,
  "unique_id": "virt_dht_hum",
  "device_class": "humidity",
  "value_template": "{{ value_json.humidity }}",
  # "device": {
  #   "name": "temperature and humidity sensor",
  #   "identifiers": [
  #     "dht"
  #   ]
  # },
  "unit_of_measurement": "%",
  "force_update": True
}

def dht_reading_generator():
  temp = random() * 100
  hum = random() * 100
  data = {
    "temperature": temp,
    "humidity": hum
  }
  return json.dumps(data)

client.loop_start()

if type != 'dht':
  print('only dht supported')
  sys.exit(2)

payload_generator = None

if type == 'dht':
  print('pub')
  status = client.publish(config_topic, json.dumps(dht_conf_temp), qos=1, retain=True)
  status.wait_for_publish()
  #status = client.publish(config_topic, json.dumps(dht_conf_hum), qos=1, retain=True)
  status.wait_for_publish()

  payload_generator = dht_reading_generator 

while True:
  try:
    payload = payload_generator()
    print(f'publish {payload}')
    client.publish(sensor_topic, payload)
    time.sleep(5)
  except KeyboardInterrupt:
    print('stopping virtual device')
    break

client.loop_stop()