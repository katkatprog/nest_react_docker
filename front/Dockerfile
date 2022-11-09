FROM node:16
ARG FRONT_WORKDIR
WORKDIR ${FRONT_WORKDIR}
# ENV DOCKERIZE_VERSION v0.6.1
ENV TZ Asia/Tokyo
RUN apt update
RUN apt install -y wget vim
RUN echo "set encoding=utf-8" >> ~/.vimrc
# RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
#     && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
#     && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz