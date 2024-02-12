#!/bin/bash

sudo yum update -y
sudo yum install -y pcre2-devel.x86_64 python gcc python3-devel tzdata curl unzip bash htop

# LOCUST
export LOCUST_VERSION="2.15.1"
sudo pip3 install locust==$LOCUST_VERSION
sudo pip3 install "urllib3 <=1.26.15"
sudo pip3 install apispec==6.3.0 click==8.1.7 itsdangerous==2.1.2 Werkzeug==3.0.1 alembic==1.12.1 boto3==1.29.0 celery==5.3.5 croniter==2.0.1 dataclasses-json==0.6.3 flask-apispec==0.11.4 Flask-Cors==4.0.0 Flask-JWT-Extended==4.5.3 flask-mailman==1.0.0 flask-marshmallow==0.15.0 Flask-Migrate==4.0.5 flask-redis==0.4.0 Flask-SQLAlchemy==3.1.1 Flask==3.0.0 freezegun==1.2.2 geoip2==4.7.0 google-auth==2.23.4 locust==2.18.3 marshmallow==3.20.1 marshmallow-sqlalchemy==0.29.0 marshmallow-dataclass[union]==8.6.0 marshmallow-union==0.1.15.post1 psycopg2-binary==2.9.9 pytest-cov==4.1.0 pytest-dependency==0.5.1 pytest-order==1.1.0 pytest==7.4.3 requests==2.31.0 sentry-sdk[flask]==1.35.0 shortuuid==1.0.11 SQLAlchemy==2.0.23 gunicorn==21.2.0 python-dotenv==1.0.0 pytest-xdist==3.5.0 filelock==3.13.1 deepdiff==6.7.1 Flask-Caching==2.1.0 || true
export PRIVATE_IP=$(hostname -I | awk '{print $1}')
echo "PRIVATE_IP=$PRIVATE_IP" >> /etc/environment

source ~/.bashrc

mkdir -p ~/.ssh
echo 'Host *' > ~/.ssh/config
echo 'StrictHostKeyChecking no' >> ~/.ssh/config

sudo iptables -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -i eth0 -p tcp --dport 8080 -j ACCEPT
sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080

touch /tmp/finished-setup
