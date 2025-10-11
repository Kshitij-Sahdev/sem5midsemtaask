#!/bin/bash
mkdir -p modules/loadbalancer
cd modules/loadbalancer

openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes \
    -subj "/CN=localhost"

openssl pkcs12 -export -out self-signed-cert.pfx -inkey key.pem -in cert.pem \
    -password pass:Password123

cd ../..
echo "Cert generated: modules/loadbalancer/self-signed-cert.pfx (Password123)"
