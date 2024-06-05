# Virtual esp32 device
# Installation
```
$ python -m pip install requirements.txt
```

## Usage
```console
$ python vdev.py -h
usage: vdev.py [-h] -t {dht,light} [-a HOST] [-p PORT] {add,run,remove} ...

Simulates a smart temperature and humidity or light sensor

positional arguments:
  {add,run,remove}      Command to run. To see individual command help type <cmd> -h (e.g. vdev.py add -h)

optional arguments:
  -h, --help            show this help message and exit
  -t {dht,light}, --type {dht,light}
  -a HOST, --host HOST  address of broker host
  -p PORT, --port PORT  port of broker host

```

## Subcommands
Devices are referenced by their `id`.

```console
$ python vdev.py add -h
usage: vdev.py add [-h] -i ID

optional arguments:
  -h, --help      show this help message and exit
  -i ID, --id ID  id of the new device
```

```console
$ python vdev.py run -h
usage: vdev.py run [-h] -i ID [-m {loop,single}] [-n INTERVAL]

optional arguments:
  -h, --help            show this help message and exit
  -i ID, --id ID        id of the device to remove
  -m {loop,single}, --mode {loop,single}
                        Single mode sends one reading and stops the device. Loop mode loops until interrupted.
  -n INTERVAL, --interval INTERVAL
                        how many seconds to wait between sending readings in loop mode.
```

```console
$ python vdev.py remove -h
usage: vdev.py remove [-h] -i ID

optional arguments:
  -h, --help      show this help message and exit
  -i ID, --id ID  id of the new device
```

## Examples
Add a new `dht` device with `id` 0:
```console
$ python vdev.py --type dht add --id 0
```

Run a `light` device with id 4 in a loop with interval 3:
```console
$ python vdev.py --type light run --id 4 --interval 3
```

Remove a `dht` device with id 42:
```console
$ python vdev.py --type dht remove --id 42
```
