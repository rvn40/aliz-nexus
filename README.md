# aiz-nexus

Nexus applications in order to complete AIZ interview

What would you need to prepare in order to executing this script?

- Ansible server, installed with :
    - ansible2.9
    - gcloud
    - python2.7, python3.6, python-pip, python3-pip
    - python libraries e.g. boto==2.49.0, boto3==1.11.1, docker-py==1.10.6, pexpect==4.7.0, apache-libcloud==2.8.0, requests==2.22.0, google-auth==1.10.1, docker==4.1.0

- cloudflare ssl self-signed
- public dns registerd in cloudflare
- nginx configuration file ready-to-use
- gcp servicesaccount in json. Full access would be fine you can revoke it after this scripts executed
- rancher2 cli and kubectl

What would you need to prepare in order to  deploy nexus app?

- custom docker image of nexus3 with plugin already installed
    - https://hub.docker.com/r/sonatype/nexus3/
    - https://github.com/sonatype-nexus-community/nexus-blobstore-google-cloud

- docker registry for docker image (in this case I will use gitlab)

