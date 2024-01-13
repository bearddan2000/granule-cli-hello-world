FROM ubuntu:22.04 

ENV LC_ALL "en_US.UTF-8"

ENV GIT_REPO https://github.com/rzuckerm/granule-docker-image.git

WORKDIR /workspace

RUN apt update

RUN apt install -y git wget unzip locales python3

RUN git clone $GIT_REPO docker-image

RUN mv docker-image/GRANULE_* /tmp/

RUN mv docker-image/issue-230-workaround /usr/local/bin/

RUN locale-gen $LC_ALL

WORKDIR /tmp

RUN GRANULE_VERSION=$(cat /tmp/GRANULE_VERSION) \
    && wget -O granule.zip https://github.com/granule-project/granule/releases/download/v$GRANULE_VERSION/granule-v$GRANULE_VERSION-linux_x86_64.zip

RUN unzip granule.zip && \
    mv granule*/* /usr/local/bin

WORKDIR /code

COPY bin .

CMD "./run.sh"