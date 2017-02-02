FROM ubuntu:trusty
MAINTAINER Rischan Mafrur <rischanlab@gmail.com>

WORKDIR /
RUN apt-get update -y && apt-get install -y \
    software-properties-common \
    python-software-properties \
    build-essential \
    python-dev \
    python-sqlalchemy \
    sqlite3 \
    libproj-dev \
    git \
    python-pip \
    libxml2-dev \
    libxslt1-dev \
    wget \
    zlib1g-dev \
    libgeos-dev \
    libgeos++-dev


WORKDIR /pycsw
RUN mkdir /pycsw/XML
RUN pip install -e .
RUN pip install -r requirements-standalone.txt

COPY default.cfg default.cfg

RUN pycsw-admin.py -c setup_db -f default.cfg
RUN pycsw-admin.py -c load_records -f default.cfg -p /pycsw/XML/

EXPOSE 8000
CMD ["python", "/pycsw/pycsw/wsgi.py"]
