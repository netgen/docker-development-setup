instructions from here: https://docs.netgen.io/projects/lds/en/latest/ubuntu/ssl.html

After generation of certificates, run one of the following.

## Ubuntu

```
sudo cp root.crt /usr/local/share/ca-certificates
sudo update-ca-certificates
```

## Manjaro / Arch

```
sudo trust anchor --store root.crt
sudo update-ca-trust
```

## MacOS

```
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain root.crt
```
