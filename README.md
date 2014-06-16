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

	docker run -d -p 23423:23423 -p 8895:8895 -p 1900:1900 -v /home/user/mediaFiles:/mediafiles hedgehog.ninja/serviio


Note
--------------------

Serviio does take a few minutes to start up when first run.

The container as default will use a volume mapped to /mediafiles as the location for media and will search it for video, images and music.

You can use serviio's client tools, serviio-console.sh is shipped with serviio or serviidroid (on adndroid) to change the search paths etc.


