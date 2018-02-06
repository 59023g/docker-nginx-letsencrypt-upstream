# init and renew letsencrypt:

FROM nginx:1.11.3-alpine

RUN apk update \
    && apk add --no-progress \
            bash certbot openssl  \
    && rm /var/cache/apk/* \
    && echo "preparing certbot webroot" \
    && mkdir -p /var/lib/certbot \
    && echo "generating initial self-signed certificate" \
    && mkdir -p /etc/nginx/ssl/example.net/ \
    && openssl req -x509 -nodes -newkey rsa:4096 \
           -keyout /etc/nginx/ssl/example.net/privkey.pem \
           -out /etc/nginx/ssl/example.net/fullchain.pem \
           -subj "/CN=example.net" \
    && ln -sf /etc/nginx/ssl/example.net /etc/nginx/ssl/latest

COPY default.conf /etc/nginx/conf.d/default.conf
COPY certbot.sh /etc/nginx/ssl/

RUN chmod 777 -R /etc/nginx/ssl/certbot.sh
