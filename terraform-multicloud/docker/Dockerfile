FROM nginx:alpine

RUN apk add --no-cache openssl && mkdir -p /etc/nginx/certs
WORKDIR /etc/nginx/certs

# self-signed cert (browser warning expected)
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout key.pem -out cert.pem \
    -subj "/C=US/ST=State/L=City/O=Student/CN=localhost"

COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN echo '<html><body><h1>nginx with SSL</h1><p>deployment successful</p></body></html>' > /usr/share/nginx/html/index.html

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
