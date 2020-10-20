### Build Image
```shell
docker build -t ${REGISTRY}/redhat/ubi/ubi7:7.9 .
```

### Tag Latest Image
```shell
docker tag r${REGISTRY}/redhat/ubi/ubi7:7.9 ${REGISTRY}/redhat/ubi/ubi7:latest
```

### Push to Docker Registry
```shell
docker push ${REGISTRY}/redhat/ubi/ubi7
```