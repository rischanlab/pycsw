FROM alpine:3.4
MAINTAINER Rischan Mafrur <rischanlab@gmail.com>

WORKDIR /
RUN apk add --no-cache \
  #linux-headers \
  build-base \
  git \
  python \
  python-dev \
  py-pip \
  libxslt-dev \
  libxml2-dev \
  #py-libxml2 \
  && git clone https://github.com/geopython/pycsw.git

RUN apk add --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
  geos


WORKDIR /pycsw
RUN mkdir /pycsw/XML
RUN pip install -e .
RUN pip install -r requirements-standalone.txt

COPY default.cfg default.cfg

RUN pycsw-admin.py -c setup_db -f default.cfg
RUN pycsw-admin.py -c load_records -f default.cfg -p /pycsw/XML/

EXPOSE 8000
CMD ["python", "/pycsw/pycsw/wsgi.py"]
