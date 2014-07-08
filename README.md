docker-serviio
==============

A docker.io container for Serviio Media Server (http://serviio.org/)

Serviio Media Server is a free DLNA/UPNP compliant media server written in Java by Petr Nejedly.  
If you like Serviio please support it and consider buying a license for the pro features.


Building and running the container image
----------------------------------------

Clone this repo and cd into the cloned directory

Run the following docker command to build the image:

	docker build -t hedgehog.ninja/serviio .

When the image is built start up the image with the following command replacing **'/home/user/mediaFiles'** with the path where your media files reside:

	docker run -d --net=host -v /home/user/mediaFiles:/mediafiles hedgehog.ninja/serviio


Notes
--------------------

The docker file exposes all the correct ports, as required for serviio, however the UPNP port 1900/udp although open does not advertise to other devices on the lan.  If you know the cause of this and how to fix it then please let me know.

In the meantime, you can run the container with --net=host (requires docker version 0.11.0) but read the next excerpt from the docker commandline help 

-----------------------------------------
>	--net=host  : Use the host network stack inside the container.  
>	Note: the host mode gives the container full access to local system services such as D-bus and is therefore considered insecure.

-----------------------------------------




Serviio does take a few minutes to start up when first run.

The container as default will use a volume mapped to /mediafiles as the location for media and will search it for video, images and music.

You can use serviio's client tools, serviio-console.sh is shipped with serviio or serviidroid (on android) to change the search paths etc.


