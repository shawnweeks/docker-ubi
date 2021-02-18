ARG BASE_REGISTRY=registry1.dsop.io
ARG BASE_IMAGE=ironbank/redhat/ubi/ubi8
ARG BASE_TAG=8.3

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as build

ARG DOD_ROOT_BUNDLE_ZIP="certificates_pkcs7_v5-6_dod.zip"
ARG DOD_WCF_BUNDLE_ZIP="certificates_pkcs7_v5-9_wcf.zip"
ARG CARMY_WCF_CERT="carmy-wcf-root-ca-1.pem"

COPY [ "${DOD_ROOT_BUNDLE_ZIP}", "${DOD_WCF_BUNDLE_ZIP}", "${CARMY_WCF_CERT}", "/tmp/" ]

# Have to disable SSL Verification so that I can install the
# packages required to update the SSL Certificates
RUN echo 'sslverify=false' >> /etc/yum.conf && \
    yum install -y unzip openssl && \
    unzip /tmp/${DOD_ROOT_BUNDLE_ZIP} -d /tmp && \
    unzip /tmp/${DOD_WCF_BUNDLE_ZIP} -d /tmp && \
    openssl pkcs7 -in /tmp/*/*DoD.pem.p7b -print_certs > /tmp/cert.pem && \
    openssl pkcs7 -in /tmp/*/*WCF.pem.p7b -print_certs >> /tmp/cert.pem && \
    awk 'split_after==1{n++;split_after=0} /-----END CERTIFICATE-----/ {split_after=1} {print > "/etc/pki/ca-trust/source/anchors/dod_cert_" n ".pem"}' /tmp/cert.pem && \
    cp /tmp/${CARMY_WCF_CERT} /etc/pki/ca-trust/source/anchors/


FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

COPY --from=build /etc/pki/ca-trust/source/anchors/* /etc/pki/ca-trust/source/anchors/

RUN update-ca-trust extract && \
    yum install -y python3 python3-jinja2 && \    
    yum clean all