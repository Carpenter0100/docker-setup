FROM nginx:alpine

# install software
RUN apk update \
    && apk add --update --no-cache openssl

# generate certs
RUN mkdir -p /etc/nginx/ssl \
    && openssl genrsa -out "/etc/nginx/ssl/selfsigned.key" 2048 \
    && openssl req -new -key "/etc/nginx/ssl/selfsigned.key" -out "/etc/nginx/ssl/selfsigned.csr" -subj "/CN=selfsigned/O=pws/C=DE" \
    && openssl x509 -req -days 365 -in "/etc/nginx/ssl/selfsigned.csr" -signkey "/etc/nginx/ssl/selfsigned.key" -out "/etc/nginx/ssl/selfsigned.crt" \
    && openssl dhparam -out "/etc/nginx/ssl/dhparam.pem" 2048 \
    && chown -R root:root /etc/nginx/ssl \
    && chmod -R 600 /etc/nginx/ssl

CMD ["nginx"]

EXPOSE 80 443
