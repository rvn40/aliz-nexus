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



> **Note**: The automation scripts are not fully automated scripts since some steps is unable to be done automatically. It is also not easy if you plan to redeploy this script in your own infrastructure because there are many parts should customize with your own infrastructure properties. Meanwhile you can check the link below to checkout my deployment.

To check the example of deployment that I have been done just click this url https://mgmt.fourtyspace.com/ and https://nexusapp.fourtyspace.com/

username: admin password: admin



# CI/CD question??

Continuous integration - theoretical question

It is possible, that we have to modify the previously created files, for example because of a new Nexus version. We want this to automatically be deployed to a test environment after we made the changes on Git. 
Please describe in a few words, how would you satisfy this need.

Yes it is possible. To do that it is depend on the ci/cd tools that you use. For instance, I usually use gitlab-ci to do that. So, I just need to create gitlab-ci file and write down the instruction in that file. Below is the example of my ci/cd script in gitlab that I already implement on my own blog. There are three stages there start from "build-ci". This stage for building the base docker image. Second stage is "build" to give tags the image and push it to gitlab registry. The last stage is "deploy". Its like the name in this stage deploying of my blog is occure.

```
image: docker:17.04

services:
  - docker:dind

stages:
  - build-ci
  - build
  - deploy

variables:
  REGISTRY_URL: "registry.gitlab.com"
  IMAGE_PATH: ${REGISTRY_URL}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}:tmp
  IMAGE_BRANCH_PATH: ${REGISTRY_URL}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}:${CI_COMMIT_REF_NAME}_${CI_COMMIT_BEFORE_SHA}
  IMAGE_STABLE_PATH: ${REGISTRY_URL}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}:stable
  IMAGE_LATEST_PATH: ${REGISTRY_URL}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}:latest

before_script:
  - echo $REGISTRY_URL
  - echo $IMAGE_PATH
  - echo $IMAGE_BRANCH_PATH
  - echo $IMAGE_STABLE_PATH
  - echo $IMAGE_LATEST_PATH
  - echo $CI_BUILD_TOKEN

build-ci:
  stage: build-ci
  script:
    - docker login -u gitlab-ci-token -p $CI_BUILD_TOKEN $REGISTRY_URL
    - docker build --pull -t $IMAGE_PATH .
    - docker push $IMAGE_PATH

# Add every branch name to this stages
build:
  stage: build
  script:
    - docker login -u gitlab-ci-token -p $CI_BUILD_TOKEN $REGISTRY_URL
    - docker pull $IMAGE_PATH
    - docker tag $IMAGE_PATH $IMAGE_BRANCH_PATH
    - docker push $IMAGE_BRANCH_PATH
  dependencies:
    - build-ci
  only:
    - master

build-latest:
  stage: build
  script:
    - docker login -u gitlab-ci-token -p $CI_BUILD_TOKEN $REGISTRY_URL
    - docker pull $IMAGE_PATH
    - docker tag $IMAGE_PATH $IMAGE_LATEST_PATH
    - docker push $IMAGE_LATEST_PATH
  only:
    - master

deploy-latest:
  stage: deploy
  script:
    - docker login -u gitlab-ci-token -p $CI_BUILD_TOKEN $REGISTRY_URL
    #- docker run $IMAGE_LATEST_PATH ansible --version
    #- docker run $IMAGE_LATEST_PATH ansible-playbook main.yml --syntax-check -vvv
    - docker run $IMAGE_LATEST_PATH ansible-playbook main.yml  -vvvv
  only:
    - master


```
 