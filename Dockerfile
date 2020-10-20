ARG BASE_REGISTRY=registry1.dsop.io
ARG BASE_IMAGE=ironbank/redhat/ubi/ubi7
ARG BASE_TAG=7.9

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as build

ARG DOD_ROOT_BUNDLE_ZIP="certificates_pkcs7_v5-6_dod.zip"
ARG DOD_WCF_BUNDLE_ZIP="certificates_pkcs7_v5-9_wcf.zip"

COPY [ "${DOD_ROOT_BUNDLE_ZIP}", "${DOD_WCF_BUNDLE_ZIP}", "/tmp/" ]

RUN yum install -y unzip openssl && \
    unzip /tmp/${DOD_ROOT_BUNDLE_ZIP} -d /tmp && \
    unzip /tmp/${DOD_WCF_BUNDLE_ZIP} -d /tmp && \
    openssl pkcs7 -in /tmp/*/*DoD.pem.p7b -print_certs > /tmp/cert.pem && \
    openssl pkcs7 -in /tmp/*/*WCF.pem.p7b -print_certs >> /tmp/cert.pem && \
    awk 'split_after==1{n++;split_after=0} /-----END CERTIFICATE-----/ {split_after=1} {print > "/etc/pki/ca-trust/source/anchors/dod_cert_" n ".pem"}' /tmp/cert.pem


ARG BASE_REGISTRY=registry1.dsop.io
ARG BASE_IMAGE=ironbank/redhat/ubi/ubi7
ARG BASE_TAG=7.9

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}
COPY --from=build /etc/pki/ca-trust/source/anchors/* /etc/pki/ca-trust/source/anchors/

RUN update-ca-trust extract