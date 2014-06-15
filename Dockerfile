# Dockerfile to run a Serviio Media Server
# 	Serviio is a free media server. It allows you to stream your media files (music, video or images) to renderer 
# 	devices (e.g. a TV set, Bluray player, games console or mobile phone) on your connected home network.
# 	For more information see http://serviio.org/ 

FROM ubuntu:latest
MAINTAINER hedgehog.ninja

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive


# serviio requires TCP port 8895 and UDP 1900 for content and 23423 for rest api
EXPOSE 23423/tcp 8895/tcp 1900/udp

# the folder 
VOLUME ["/mediafiles"]

# required packages
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install curl wget libav-tools
RUN apt-get -y --no-install-recommends install default-jre

#link ffmpeg to the new avconv
RUN ln -s /usr/bin/avconv /usr/bin/ffmpeg

# get a copy of the current download page
RUN wget --output-document=/tmp/download.html http://serviio.org/download
# extract the download link from it for the linux.tar.gz and download to /tmp/serviio-latest.tar.gz 
RUN grep -oEm 1 "<a href=\".*(linux.tar.gz)\"" /tmp/download.html | cut -d\" -f2 | xargs wget --output-document=/tmp/serviio-latest.tar.gz


# create /serviio
RUN mkdir /serviio
# extract to the serviio dir & rename
RUN tar -zxvf /tmp/serviio-latest.tar.gz -C /serviio
# rename the current version folder to serviio
RUN ls /serviio/ | xargs echo "/serviio/" | sed 's/ //' | xargs -I {} mv {} "/serviio/serviio" 

# attempt to 
RUN /serviio/serviio/bin/serviio.sh & echo "Waiting 1 minute for serviio to do it's first run configuration, then attempt to set sharedFolder to /mediafiles..." && sleep 60 && curl --include --request PUT --header "Content-Type: application/xml" --header "Accept: application/xml | application/json" --data-binary '<repository><sharedFolders><sharedFolder><folderPath>/mediafiles</folderPath><supportedFileTypes><fileType>AUDIO</fileType><fileType>IMAGE</fileType><fileType>VIDEO</fileType></supportedFileTypes><descriptiveMetadataSupported>false</descriptiveMetadataSupported><scanForUpdates>true</scanForUpdates><accessGroupIds><id>1</id></accessGroupIds></sharedFolder></sharedFolders> <searchHiddenFiles>false</searchHiddenFiles><searchForUpdates>true</searchForUpdates><automaticLibraryUpdate>true</automaticLibraryUpdate><automaticLibraryUpdateInterval>5</automaticLibraryUpdateInterval><onlineRepositories></onlineRepositories><maxNumberOfItemsForOnlineFeeds>10</maxNumberOfItemsForOnlineFeeds><onlineFeedExpiryInterval>24</onlineFeedExpiryInterval><onlineContentPreferredQuality>LOW</onlineContentPreferredQuality></repository>' http://localhost:23423/rest/repository && sleep 2

# launch serviio
WORKDIR /serviio/serviio
CMD /serviio/serviio/bin/serviio.sh

