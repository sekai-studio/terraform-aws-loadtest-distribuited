#!/bin/bash

sudo yum update -y
sudo yum install -y pcre2-devel.x86_64 python gcc python3-devel tzdata curl unzip bash htop

# LOCUST
export LOCUST_VERSION="2.15.1"
sudo pip3 install locust==$LOCUST_VERSION
sudo pip3 install "urllib3 <=1.26.15"
pip3 install apispec==6.3.0 click==8.1.7 itsdangerous==2.1.2 Werkzeug alembic==1.12.1 boto3==1.29.0  croniter==2.0.1 dataclasses-json==0.6.3 flask-apispec==0.11.4 Flask-Cors==4.0.0 Flask-JWT-Extended==4.5.3 flask-mailman==1.0.0 flask-marshmallow Flask-Migrate flask-redis Flask-SQLAlchemy Flask freezegun geoip2 google-auth marshmallow marshmallow-sqlalchemy marshmallow-dataclass[union] marshmallow-union psycopg2-binary==2.9.9 pytest-cov==4.1.0 pytest-dependency==0.5.1 pytest-order==1.1.0 pytest==7.4.3 requests==2.31.0 sentry-sdk[flask]==1.35.0 shortuuid==1.0.11 SQLAlchemy==2.0.23 gunicorn==21.2.0 python-dotenv pytest-xdist filelock deepdiff Flask-Caching
export PRIVATE_IP=$(hostname -I | awk '{print $1}')
echo "PRIVATE_IP=$PRIVATE_IP" >> /etc/environment

source ~/.bashrc

mkdir -p ~/.ssh
echo 'Host *' > ~/.ssh/config
echo 'StrictHostKeyChecking no' >> ~/.ssh/config

touch /tmp/finished-setup
