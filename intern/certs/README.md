#DockerHub certs on nodes

## Generate crt and key files

```
mkdir -p certs
openssl req \
   -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key \
   -x509 -days 365 -out certs/domain.crt
```
