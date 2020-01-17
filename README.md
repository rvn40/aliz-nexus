# aiz-nexus

Nexus applications in order to complete AIZ interview

What would you need to prepare in order to executing this script? Before we start, I would like to explain about the stacks that I used and the requirements that we need. About the stacks, I used GCP services in these scripts for cloud infrastructure platform specifically like VPC, subnetwork, firewall rules, and VM. I will deploy Kubernetes cluster inside those VM and use ansible as configuration management tools. In this case, we also need active public dns record to deploying our app. That’s why, I use cloudflare as my dns record management since my active domain already registered there. I am going to use gitlab for the docker image registry and code repository online. Last one is I am going to use rancher2 to help me maintain kubernetes cluster. So, that’s all our open source tools that we need for deploying our app right now.
About the requirements, we have to prepare several things, such as:
-  Configuration management server (recommended ubuntu18) that already installed :
    - Ansible 2.9
    - Python2.7 and python3.6
    - Python libraries e.g. boto, boto3, pexpect, apache-libcloud, requests, google-auth, docker
    - Gcloud SDK
- Rancher-cli
- Kubectl
- Cloudflare single-signed certificates
- Gcp service account (Just give it full access, you can revoke it if you want after running these scripts)
- Ssh rsa-key (you can create it using rsa-key-gen in terminal but please edit the pub key using gcp format“username:ssh-rsa xxxxx….xxx username” )
- custom docker image of nexus3 with plugin already installed
    - https://hub.docker.com/r/sonatype/nexus3/
    - https://github.com/sonatype-nexus-community/nexus-blobstore-google-cloud


The whole processes will take several steps but, in general, I divided into four main phases. The first phase called cloud-deployment phase, the second one is Kubernetes cluster creation, the third one is docker image creation, and the last one is Kubernetes deployment phase. 

In this repository there are several scripts you can use but you can not just use it because these scripts has been created only for my environment. You need to make some configuration in order to use it.

    - Ansible server/machine installation bash script ==> "systems/import/bash/gcloud_installation.sh" and "systems/import/bash/ansible_requirements.txt" (always put in one directory)
    - "Aliz-nexus-images" directory contain all script to create docker image.
    - "deploycloud-playbook.yml"    =>  ansible playbook script to deploying cloud infrastructures
    - "buildk8cluster-playbook.yml" =>  ansible playbook script to build kubernetes cluster in deployed infrastructures
    - "deployk8workload-playbook.yml"   =>  ansible playbook script to deploy kubernetes deployment

> **Note**: The automation scripts are not fully automated scripts since some steps is unable to be done automatically.

To check the example of deployment that I have been done just click this url https://k8mgmtnexus.fourtyspace.com/

username: admin password: admin
 