import paho.mqtt.client as mqtt
import argparse
import json
import sys
from random import random
import time

def load_discovery_confs(type):
  with open(f'{type}_discovery_conf.json', 'r') as f:
    data = json.load(f)
    if isinstance(data, list):
      return data
    
    return [data]

def dht_reading_generator():
  temp = random() * 100
  hum = random() * 100
  data = {
    "temperature": temp,
    "humidity": hum
  }
  return json.dumps(data)

def light_reading_generator():
  return random() * 100

def start_mqtt_connection(host, port):
  client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
  client.loop_start()
  print(f'connecting to mqtt broker at {host}:{port}')
  try:
    client.connect(host, port)
  except:
    print('connection failed')
    sys.exit(1)

  return client

def publish_discovery_data(client, type):
  confs = load_discovery_confs(type)
  # change this
  if type == 'dht':
    status = client.publish('homeassistant/sensor/dht_virt_temp/config', json.dumps(confs[0]), qos=1)
    status.wait_for_publish()
    status = client.publish('homeassistant/sensor/dht_virt_hum/config ', json.dumps(confs[1]), qos=1)
    status.wait_for_publish()
  elif type == 'light':
    status = client.publish('homeassistant/sensor/light_virt/config', json.dumps(confs[0]), qos=1)

  return confs[0]['state_topic']

sensor_types = ['dht', 'light']

parser = argparse.ArgumentParser(description='Simulates a smart temperature and humidity or light sensor')
parser.add_argument('-t', '--type', required=True, choices=sensor_types)
parser.add_argument('-a','--host', help='address of broker host', default='127.0.0.1')
parser.add_argument('-p', '--port', help="port of broker host", default="1883", type=int)
args = parser.parse_args()

type = args.type
host = args.host
port = args.port

client = start_mqtt_connection(host, port)
state_topic = publish_discovery_data(client, type)

payload_generator = dht_reading_generator if type == 'dht' else light_reading_generator

while True:
  try:
    payload = payload_generator()
    print(f'publish {payload}')
    client.publish(state_topic, payload)
    time.sleep(5)
  except KeyboardInterrupt:
    print('stopping virtual device')
    break

client.loop_stop()