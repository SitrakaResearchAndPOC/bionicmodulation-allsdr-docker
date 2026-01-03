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
RUN apt-get update -o Acquire::Retries=5 -o Acquire::http::Timeout=30 && \
    apt-get install -y \
    gnuradio \
    gqrx-sdr \
    hackrf \
    cubicsdr \
    inspectrum \
    rtl-sdr \
    ffmpeg \
    vlc \
    gr-osmosdr \
    uhd-host \
    soapysdr-module-all \
    soapy* \
    gr-iio \
    libiio-utils \
    libiio-dev \
    gnss-sdr \
    rtklib \
    rtklib-qt \
    flatpak \
    limesuite \
    multimon \
    gpredict \
    gr-fosphor \
    net-tools \
    pavucontrol \
    pulseaudio \
    pulseaudio-utils \
    git \
    wget \
    unzip \
    nano \
    firefox \
    iputils-ping\
    python3 \
    python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
    
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
