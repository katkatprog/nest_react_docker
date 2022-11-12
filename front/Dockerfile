FROM node:16-alpine
ARG FRONT_WORKDIR
WORKDIR ${FRONT_WORKDIR}
ENV TZ Asia/Tokyo
RUN apk update
RUN apk upgrade
RUN apk add git vim
