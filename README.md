### Download Files
```shell
wget https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/certificates_pkcs7_v5-6_dod.zip
wget https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/certificates_pkcs7_v5-10_wcf.zip
wget https://s3.amazonaws.com/amazoncloudwatch-agent/redhat/amd64/latest/amazon-cloudwatch-agent.rpm
```

### Build Image
```shell
docker build -t ${REGISTRY}/redhat/ubi/ubi8:8.3 .
```

### Push to Docker Registry
```shell
docker push ${REGISTRY}/redhat/ubi/ubi8
```
