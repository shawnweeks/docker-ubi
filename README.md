### Build Image
```shell
docker build -t registry.cloudbrocktec.com/redhat/ubi/ubi7:7.8 .
docker tag registry.cloudbrocktec.com/redhat/ubi/ubi7:7.8 registry.cloudbrocktec.com/redhat/ubi/ubi7:latest
```

### Push to Docker Registry
```shell
docker push registry.cloudbrocktec.com/redhat/ubi/ubi7
```