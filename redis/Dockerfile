# Base image
FROM debian:jessie

MAINTAINER Michael Pierce <hi@mep.im>

# Update the repository and install Redis Server
RUN apt-get update && apt-get install -y redis-server=2.8.17

# Expose Redis port 6379
EXPOSE 6379

# Run Redis Server
ENTRYPOINT  ["/usr/bin/redis-server"]
