docker-serviio
==============

A docker.io container for Serviio Media Server (http://serviio.org/)

Serviio Media Server is a free DLNA/UPNP compliant media server written in Java by Petr Nejedly.  
If you like Serviio please support it and consider buying a license for the pro features.

It's contribution to excellent HedgehogNinja's work (https://github.com/HedgehogNinja/docker-serviio). This version supports Serviio 1.5 which requires Java 8 to work. 


Building and running the container image
----------------------------------------

Clone this repo and cd into the cloned directory

Run the following docker command to build the image:

	docker build -t lukasz.czerpak/serviio .

When the image is built start up the image with the following command replacing directories with corresponding the paths on your system:

	docker run -d --net=host -v /tmp:/tmp -v /home/user/serviio/log:/opt/serviio/log -v /home/user/serviio/library:/opt/serviio/library -v /home/user/store:/store --name serviio lukasz.czerpak/serviio


Notes
--------------------

The docker file exposes all the correct ports, as required for serviio, however the UPNP port 1900/udp although open does not advertise to other devices on the lan.  If you know the cause of this and how to fix it then please let me know.

In the meantime, you can run the container with --net=host (requires docker version 0.11.0) but read the next excerpt from the docker commandline help 

-----------------------------------------
>	--net=host  : Use the host network stack inside the container.  
>	Note: the host mode gives the container full access to local system services such as D-bus and is therefore considered insecure.

-----------------------------------------

/tmp mapping allows Serviio to use external volume for temporary transcoding files which 
/opt/serviio/log and /opt/serviio/library mappings keep logs and your library outside of the container so you will not lose your settings on docker-serviio upgrades.
/store mapping is just an example as default Serviio configuration doesn't contain any folders.

Serviio does take a few minutes to start up when first run.

Once you get Serviio up and running inside Docker container, you should use Serviio Console or fantastic webui (https://github.com/SwoopX/Web-UI-for-Serviio) to set up folders and some internal parameters.

Installation script sets remote password to 'serviio123'.

