FROM node:lts-alpine

# Silent apt package manager and configure timezone
ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="Europe/Zurich"

RUN apk update
RUN apk add git
RUN apk add --no-cache openssh
RUN apk add bash

COPY project /root/project
WORKDIR /root/project

RUN npm install
EXPOSE 8080
CMD npm run serve
