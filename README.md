### Download Files
```shell
wget https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/certificates_pkcs7_v5-6_dod.zip
wget https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/certificates_pkcs7_v5-10_wcf.zip
```

### Build Image
```shell
docker build -t ${REGISTRY}/redhat/ubi/ubi8:8.3 .
```

### Push to Docker Registry
```shell
docker push ${REGISTRY}/redhat/ubi/ubi8
```
