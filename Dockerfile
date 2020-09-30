ARG BASE_REGISTRY=registry1.dsop.io
ARG BASE_IMAGE=ironbank/redhat/ubi/ubi7
ARG BASE_TAG=7.8

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as build

ARG DOD_PKI_BUNDLE_URL="https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/certificates_pkcs7_v5-6_dod.zip"
ARG DOD_WCF_BUNDLE_URL="https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/unclass-certificates_pkcs7_v5-9_wcf.zip"

COPY ironbank.repo /etc/yum.repos.d/ironbank.repo

RUN yum install -y unzip openssl && \
    curl -s ${DOD_PKI_BUNDLE_URL} --output /tmp/dod_pki.zip && \
    unzip /tmp/dod_pki.zip -d /tmp && \
    curl -s ${DOD_WCF_BUNDLE_URL} --output /tmp/dod_wcf.zip && \
    unzip /tmp/dod_wcf.zip -d /tmp && \
    openssl pkcs7 -in /tmp/*/*DoD.pem.p7b -print_certs > /tmp/cert.pem && \
    openssl pkcs7 -in /tmp/*/*WCF.pem.p7b -print_certs >> /tmp/cert.pem && \
    awk 'split_after==1{n++;split_after=0} /-----END CERTIFICATE-----/ {split_after=1} {print > "/etc/pki/ca-trust/source/anchors/dod_cert_" n ".pem"}' /tmp/cert.pem

ARG BASE_REGISTRY=registry1.dsop.io
ARG BASE_IMAGE=ironbank/redhat/ubi/ubi7
ARG BASE_TAG=7.8

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

COPY --from=build /etc/yum.repos.d/ironbank.repo /etc/yum.repos.d/ironbank.repo
COPY --from=build /etc/pki/ca-trust/source/anchors/* /etc/pki/ca-trust/source/anchors/