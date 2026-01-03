FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Step 1 : garder les dépôts en HTTP pour pouvoir installer ca-certificates
# (optionnel si sources.list contient déjà du HTTP)
RUN sed -i 's|https://archive.ubuntu.com|http://archive.ubuntu.com|g' /etc/apt/sources.list && \
    sed -i 's|https://security.ubuntu.com|http://security.ubuntu.com|g' /etc/apt/sources.list

# Step 2 : mise à jour initiale et installation des certificats
RUN apt-get update && apt-get install -y ca-certificates && apt-get clean && rm -rf /var/lib/apt/lists/*

# Step 3 : forcer maintenant HTTPS dans les sources
RUN sed -i 's|http://archive.ubuntu.com|https://archive.ubuntu.com|g' /etc/apt/sources.list && \
    sed -i 's|http://security.ubuntu.com|https://security.ubuntu.com|g' /etc/apt/sources.list

# Step 4 : mise à jour + installation complète
# Step : mise à jour + installation complète
# Mise à jour des sources ubuntu archivées + fix Check-Valid-Until
RUN apt-get update -o Acquire::Retries=5 -o Acquire::http::Timeout=30

# Installing software dependencies
RUN apt-get install -y -o Acquire::Retries=5 --no-install-recommends\ 	
	git  wget unzip nano cmake build-essential libboost-all-dev libfftw3-dev libusb-1.0-0-dev\
	python3-dev python3-numpy python3-mako python3 python3-pip software-properties-common

# Adding ppa bladerf:  
RUN add-apt-repository ppa:bladerf/bladerf

# Remake update
# Mise à jour des sources ubuntu archivées + fix Check-Valid-Until
RUN apt-get update -o Acquire::Retries=5 -o Acquire::http::Timeout=30

## Installing driver uhd
RUN apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
    udev \
    uhd-host 

## Installing hackrf & rtl sdr & LimeSDR
RUN apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
    hackrf \
    rtl-sdr \ 
    limesuite 

## Installing driver PlutoSDR
RUN apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
    gr-iio \
    libiio-utils \
    libiio-dev \
    net-tools \
    iputils-ping

## Installing driver Bladerf 
RUN apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
	bladerf\
	bladerf-firmware-fx3\
	bladerf-fpga-hostedx115\
	bladerf-fpga-hostedx40\
	bladerf-fpga-hostedxa4\
	bladerf-fpga-hostedxa9\
	libbladerf-dev\
	libbladerf-doc\
	libbladerf-udev\
	libbladerf1\
	libbladerf2\
	soapysdr-module-bladerf\
	soapysdr0.6-module-bladerf



## Installing hamdradio
RUN apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
    gnuradio \
    gnuradio-dev\
    gr-osmosdr \
    soapysdr-module-all \
    soapy* \
    rtklib \
    rtklib-qt \
    gr-fosphor 




## Installing hamdradio
RUN apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
    gqrx-sdr \
    cubicsdr \
    inspectrum \
    gnss-sdr 



RUN apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
    	ffmpeg \
    	vlc \
    	flatpak \
    	multimon \
    	gpredict \
    	pavucontrol \
    	pulseaudio \
    	pulseaudio-utils \
	firefox	
    
# Cleaning cache 
RUN apt-get clean && rm -rf /var/lib/apt/lists/*       
    

# Autorisation des usb
# RUN chmod -R 666 /dev/bus/usb
    
# Téléchargement des images UHD
RUN /usr/lib/uhd/utils/uhd_images_downloader.py || true

# Création utilisateur non-root
RUN useradd -ms /bin/bash user

# Créer dossier partagé GNU Radio
RUN mkdir -p /home/user/gnuradio && chown -R user:user /home/user/gnuradio

USER user

ENV LIBGL_ALWAYS_SOFTWARE=1
ENV PULSE_SERVER=unix:/run/user/1000/pulse/native


WORKDIR /home/user
#RUN cd /tmp && \
#    git clone https://github.com/nuand/gr-bladerf.git && \
#    cd gr-bladerf && \
#    mkdir build && cd build && \
#    cmake .. && \
#    make -j$(nproc) && \
#    make install && \
#    ldconfig

# Téléchargement projet FM Transmitter
RUN wget https://media.githubusercontent.com/media/SitrakaResearchAndPOC/fork_fm_transmitter/main/FM_Transmitter.zip && \
    unzip FM_Transmitter.zip && \
    rm FM_Transmitter.zip && \
    cd FM_Transmitter && \
    wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/BionicModulationDocker/refs/heads/main/emetteur-fm-uhd.grc
    
RUN  git clone https://github.com/patel999jay/ADALM-Pluto-File-Transfer.git

RUN git clone https://github.com/erstrom/gnuradio-projects.git

RUN git clone https://github.com/luanspl/OFDM_GNURadio_USRP.git
    

CMD ["/bin/bash"]
