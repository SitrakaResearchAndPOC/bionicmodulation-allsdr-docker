# bionicmodulation-allsdr-docker
This is roadmap for dockerized modulation using many sdrs and voice support  on docker
sdr could be  : 
* pluto sdr an his variant (zynq compatible)
* usrp
* hackrf
* bladerf for future plan
# Install all dependecies
```
apt update
```

```
apt install docker.io docker-compose git
```
# Download all file

```
git clone https://github.com/SitrakaResearchAndPOC/bionicmodulation-allsdr-docker.git
```
# Pre-install
```
cd bionicmodulation-allsdr-docker
```
```
docker-compose down
```
```
docker-compose down --volumes --remove-orphans
```
```
docker-compose build --no-cache
```
# Installation
```
docker-compose up -d
```
# Verification
```
docker-compose ps
```
# Testing
```
mkdir gnuradio
```
All autorise on gnuradio
```
chmod -R 777 ./gnuradio
```
All autorise usb : 
```
chmod -R 777 /dev/bus/usb
```

```
xhost +; docker-compose exec bionicmodulation bash
```
```
exit
```
## PLUG AND TEST FOR USRP :
```
docker-compose exec bionicmodulation uhd_usrp_probe
```
## PLUG AND TEST FOR HACKRF 
```
docker compose exec bionicmodulation hackrf-info
```
## PLUG AND TEST FOR PLUTOSDR 
* For network
```
docker-compose exec bionicmodulation ping pluto.local
```
* For usb
```
docker-compose exec bionicmodulation ping pluto.local.usb
```
## PLUG AND TEST FOR BLADERF
```
bladeRF-cli -l
```
## LAUNCHING GNURADIO : 
```
xhost +; docker-compose exec bionicmodulation gnuradio-companion
```

# FOR PRUNE PROJECT 
```
docker system prune -f
```

