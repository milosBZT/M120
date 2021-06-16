FROM node:lts-alpine

# Silent apt package manager and configure timezone
ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="Europe/Zurich"

RUN apk update
RUN apk add git
RUN apk add --no-cache openssh
RUN apk add bash

COPY 
# very dirty copies private key file into container
# ADD id_rsa /root/.ssh/id_rsa
# RUN chmod 700 /root/.ssh/id_rsa
# RUN cat /root/.ssh/id_rsa
# RUN touch /root/.ssh/known_hosts
# RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
# RUN git clone git@github.com:evr0p/bsc-proj.git /root/project

WORKDIR /root/project/frontend
RUN npm install
EXPOSE 8080
CMD npm run serve