# Issue RSA private key + public key pair

### Generate an RSA private key, of size 2048

```bash
openssl genrsa -out jwt-private.pem 2048
```

### Extract the public key from the key pair, which can be used in a certificate
```bash
openssl rsa -in jwt-private.pem -outform PEM -pubout -out jwt-public.pem
```