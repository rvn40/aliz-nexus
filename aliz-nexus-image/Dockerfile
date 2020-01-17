FROM sonatype/nexus3:3.20.0

ENV NEXUS_INSTALL_DIR=/opt/sonatype/nexus
ENV GOOGLE_APPLICATION_CREDENTIALS=${NEXUS_INSTALL_DIR}/serviceaccounts/nexus-gcs-blobstore.json

RUN mkdir -p ${NEXUS_INSTALL_DIR}/serviceaccounts

ADD nexus-gcs-blobstore.json ${NEXUS_INSTALL_DIR}/serviceaccounts

COPY nexus-blobstore-google-cloud-*-bundle.kar ${NEXUS_INSTALL_DIR}/deploy/

CMD ["sh", "-c", "${SONATYPE_DIR}/start-nexus-repository-manager.sh"]