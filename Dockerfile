# Dockerfile to run a Serviio Media Server
# 	Serviio is a free media server. It allows you to stream your media files (music, video or images) to renderer 
# 	devices (e.g. a TV set, Bluray player, games console or mobile phone) on your connected home network.
# 	For more information see http://serviio.org/ 

FROM ubuntu:14.04
MAINTAINER lukasz.czerpak

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
# To get rid of error messages like "debconf: unable to initialize frontend: Dialog":
#RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

VOLUME /opt/serviio/log
VOLUME /opt/serviio/library
VOLUME /tmp

# extra repository for oracle java 8
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get -q update

# auto accept oracle jdk license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections

# upgrade and install packages
RUN apt-get -qy --force-yes dist-upgrade
RUN apt-get install -qy --force-yes ca-certificates curl wget dcraw libmp3lame0 librtmp0 libx264-142 libass4 libav-tools oracle-java8-installer

# apt clean
RUN apt-get clean

# get a copy of the current download page, extract the download link from it and uncompress to /opt/serviio directory
RUN mkdir -p /opt/serviio
RUN wget --quiet -O - http://serviio.org/download | grep -oEm 1 "<a href=\".*(linux.tar.gz)\"" | cut -d\" -f2 | xargs wget --quiet -O - | tar -zxvf - -C /opt/serviio --strip 1

# link ffmpeg to the new avconv
RUN ln -s /usr/bin/avconv /usr/bin/ffmpeg
RUN sed -i 's/-Dffmpeg.location=ffmpeg -Ddcraw.location=dcraw/-Dffmpeg.location=\/usr\/bin\/ffmpeg -Ddcraw.location=\/usr\/bin\/dcraw/g' /opt/serviio/bin/serviio.sh

# attempt to perform initial serviio configuration
RUN /opt/serviio/bin/serviio.sh & echo "Waiting 1 minute for serviio to do it's first run configuration, then attempt to set default password..." && sleep 60 && curl --include --request PUT --header "Content-Type: application/xml" --header "Accept: application/xml | application/json" --data-binary '<remoteAccess><remoteUserPassword>serviio123</remoteUserPassword><preferredRemoteDeliveryQuality>MEDIUM</preferredRemoteDeliveryQuality><portMappingEnabled>false</portMappingEnabled></remoteAccess>' http://localhost:23423/rest/remote-access && sleep 2

# serviio requires TCP port 8895 and UDP 1900 for content and 23423 for rest api
EXPOSE 23423:23423/tcp 8895:8895/tcp 1900:1900/udp

# launch serviio
WORKDIR /opt/serviio
CMD /opt/serviio/bin/serviio.sh
