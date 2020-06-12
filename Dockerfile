FROM ubuntu:20.04

ADD winbox64.exe /winbox/

RUN apt-get update
RUN apt-get install -y ca-certificates wget
RUN apt-get install -y software-properties-common

RUN wget -O - https://dl.winehq.org/wine-builds/winehq.key | apt-key add -
RUN add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' 

RUN dpkg --add-architecture i386 
RUN apt-get update

RUN apt install --install-recommends -y winehq-stable

ENV DISPLAY :0