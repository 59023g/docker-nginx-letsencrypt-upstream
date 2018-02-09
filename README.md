#### Infrastructure

Docker compose config for proxy upstream node servers behind SSL ( Let's Encrypt ) Nginx on Debian Jessie. Personally I am not a huge Docker fan and err on the side of bash scripts and/or Lambda, but this may be valuable to you.

#### Stack:
* debian/jessie
* docker
* nginx ( Let's Encrypt )
* node


#### Let's Encrypt:
* make sure .env file is set-up
* after its been built and up via docker-compose, install certs via `docker-compose exec nginx /etc/nginx/ssl/certbot.sh -v` ( see below )


#### Install
```
#!/bin/bash

. make.sh
docker-compose build
docker-compose up -d
# install certs
docker-compose exec nginx /etc/nginx/ssl/certbot.sh -v
```

#### Todo:
* Cron task for cert updates


#### Thanks:
https://github.com/diresi
