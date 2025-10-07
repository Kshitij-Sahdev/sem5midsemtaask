FROM nginx:alpine
RUN apk add openssl && mkdir -p /etc/nginx/certs
WORKDIR /etc/nginx/certs
RUN openssl req -x509 -nodes -days 365 -subj "/CN=localhost" -newkey rsa:2048 -keyout key.pem -out cert.pem
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
