# installer-ansible-for-aws
Installer of ansible2.3 with python2

## Requirements
- pyenv
- python 2.7.13
- ansible2.4.0.0

### pip
- ansible
- awscli
- boto
- boto3
- botocore
- configparser

## Usage

```
$ /bin/sh setup.sh {name of virtualenv}
```

## Dockerfile

```Dockerfile
FROM centos:7

# ansible
RUN yum clean all && \
    yum -y install epel-release && \
    yum -y install PyYAML \
    python-jinja2 \
    python-httplib2 \
    python-keyczar \
    python-paramiko \
    python-setuptools \
    python-pip \
    ansible
```
