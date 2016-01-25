59023c - Infrastructure

Docker compose config for node and redis behind nginx on debian jessie.

Stack:
* debian/jessie
* docker
* nginx
* node
* redis
* express


Dependencies:

* all that docker stuff  

To Start:

if no machine has been built: `docker-machine create --driver virtualbox <name>`
else: `docker-machine start default`  

`docker-compose up`

