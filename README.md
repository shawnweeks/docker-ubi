### Build Image
```shell
docker build -t ${REGISTRY}/redhat/ubi/ubi8:8.3 .
```

### Push to Docker Registry
```shell
docker push ${REGISTRY}/redhat/ubi/ubi8
```