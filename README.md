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

```
docker-machine create --driver virtualbox <name>
docker-machine start <name> 
docker-compose up```

