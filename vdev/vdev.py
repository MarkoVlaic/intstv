import paho.mqtt.client as mqtt
import argparse
import json
import sys
from random import random
import time
import copy

def mqtt_connect(args):
  client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
  client.loop_start()
  print(f'connecting to mqtt broker at {args.host}:{args.port}')
  try:
    client.connect(args.host, args.port)
  except:
    print('connection failed')
    sys.exit(1)

  return client

def default_handler(args):
  print('invoke with one of the commands: add')

def add_handler(args):
  client = mqtt_connect(args)
  confs = []

  if args.type == 'dht':
    temp_conf = {
      'name': 'temperature',
      'unique_id': f'virt_dht_temp{args.id}',
      'device_class': 'temperature',
      'state_topic': f'homeassistant/sensor/dht_virt{args.id}/state',
      'value_template': '{{ value_json.temperature }}',
      'unit_of_measurement': '°C',
      'suggested_display_precision': 1,
      'device': {
        'identifiers': [
          f'virt_dht{args.id}'
        ],
        'name': f'virtual dht sensor {args.id}'
      }
    }

    hum_conf = copy.deepcopy(temp_conf)
    hum_conf['name'] = 'humidity'
    hum_conf['unique_id'] = f'virt_dht_hum{args.id}'
    hum_conf['device_class'] = 'humidity'
    hum_conf['value_template'] = '{{value_json.humidity}}'
    hum_conf['unit_of_measurement'] = '%'

    confs.append(temp_conf)
    confs.append(hum_conf)
  else:
    light_conf = {
      'name': 'light',
      'unique_id': f'virt_light{args.id}',
      'device_class': 'illuminance',
      'state_topic': f'homeassistant/sensor/light_virt{args.id}/state',
      'unit_of_measurement': '%',
      'suggested_display_precision': 1,
      'device': {
        'identifiers': [
          f'virt_light{args.id}'
        ],
        'name': f'virtual light sensor {args.id}'
      }
    }
    confs.append(light_conf)

  for (i, conf) in enumerate(confs):
    topic = f'homeassistant/sensor/virt_{args.type}{args.id}{i}/config'
    status = client.publish(topic, json.dumps(conf), qos=1, retain=True)
    status.wait_for_publish()

  client.loop_stop()

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

def run_handler(args):
  client = mqtt_connect(args)
  reading_generator = dht_reading_generator if args.type == 'dht' else light_reading_generator
  topic = f'homeassistant/sensor/{args.type}_virt{args.id}/state'

  while True:
    try:
      reading = reading_generator()
      print(f'send reading {reading}')
      status = client.publish(topic, reading, qos=1)
      status.wait_for_publish()

      if args.mode == 'single':
        break

      time.sleep(args.interval)
    except KeyboardInterrupt:
      break
  
  client.loop_stop()

def remove_handler(args):
  client = mqtt_connect(args)
  topics = []
  if args.type == 'dht':
    topics.append(f'homeassistant/sensor/virt_{args.type}{args.id}0/config')
    topics.append(f'homeassistant/sensor/virt_{args.type}{args.id}1/config')  
  else:
    topics.append(f'homeassistant/sensor/virt_{args.type}{args.id}0/config')
  
  for topic in topics:
    status = client.publish(topic, '', qos=1)
    status.wait_for_publish()

  client.loop_stop()

def main():
  sensor_types = ['dht', 'light']

  parser = argparse.ArgumentParser(description='Simulates a smart temperature and humidity or light sensor')
  parser.add_argument('-t', '--type', required=True, choices=sensor_types)
  parser.add_argument('-a','--host', help='address of broker host', default='127.0.0.1')
  parser.add_argument('-p', '--port', help="port of broker host", default="1883", type=int)
  parser.set_defaults(handler=default_handler)

  subparsers = parser.add_subparsers(help='Command to run. To see individual command help type <cmd> -h (e.g. vdev.py add -h)')

  parser_add = subparsers.add_parser('add')
  parser_add.add_argument('-i', '--id', help='id of the new device', required=True, type=int)
  parser_add.set_defaults(handler=add_handler)
  
  run_modes = ['loop', 'single']
  parser_run = subparsers.add_parser('run')
  parser_run.add_argument('-i', '--id', help='id of the device to remove', required=True, type=int)
  parser_run.add_argument('-m', '--mode', help='Single mode sends one reading and stops the device. Loop mode loops until interrupted.', choices=run_modes, default='loop')
  parser_run.add_argument('-n', '--interval', help='how many seconds to wait between sending readings in loop mode.', default=5, type=int)
  parser_run.set_defaults(handler=run_handler)

  parser_remove = subparsers.add_parser('remove')
  parser_remove.add_argument('-i', '--id', help='id of the new device', required=True, type=int)
  parser_remove.set_defaults(handler=remove_handler)


  args = parser.parse_args()
  args.handler(args)

if __name__ == '__main__':
  main()

