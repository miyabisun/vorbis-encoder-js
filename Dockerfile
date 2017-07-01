FROM apiaryio/emcc
MAINTAINER miyabisun (miyabi.ooh@gmail.com)

RUN apt-get update && apt-get install -y curl \
  && apt-get -y clean \
  && apt-get -y autoclean \
  && apt-get -y autoremove

VOLUME ["/src"]
WORKDIR /src

