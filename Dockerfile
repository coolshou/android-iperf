FROM ubuntu:16.04
LABEL maintainer="threeheadedknight@protonmail.com"

RUN apt-get -y update -qq && \
    apt-get -y upgrade -qq && \
    apt-get -y install -qq make bash git unzip wget curl openjdk-8-jdk build-essential autoconf nano tree file && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG API_VERSION=26
ARG SDK_VERSION=4333796
ARG NDK_VERSION=r19

ENV ANDROID_SDK_VERSION ${SDK_VERSION}
ENV ANDROID_SDK_HOME /opt/android-sdk
ENV ANDROID_SDK_FILENAME sdk-tools-linux-${ANDROID_SDK_VERSION}
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/${ANDROID_SDK_FILENAME}.zip

RUN wget --no-check-certificate -q ${ANDROID_SDK_URL} && \
    mkdir -p ${ANDROID_SDK_HOME} && \
    unzip -q ${ANDROID_SDK_FILENAME}.zip -d ${ANDROID_SDK_HOME} && \
    rm -f ${ANDROID_SDK_FILENAME}.zip

ENV PATH=${PATH}:${ANDROID_SDK_HOME}/tools:${ANDROID_SDK_HOME}/tools/bin:${ANDROID_SDK_HOME}/platform-tools

RUN yes | sdkmanager --licenses > /dev/null && \
    yes | sdkmanager "platforms;android-${API_VERSION}" > /dev/null

ENV ANDROID_NDK_VERSION ${NDK_VERSION}
ENV ANDROID_NDK_HOME /opt/android-ndk
ENV ANDROID_NDK_FILENAME android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64
ENV ANDROID_NDK_URL https://dl.google.com/android/repository/${ANDROID_NDK_FILENAME}.zip

RUN wget --no-check-certificate -q ${ANDROID_NDK_URL} && \
    mkdir -p ${ANDROID_NDK_HOME} && \
    unzip -q ${ANDROID_NDK_FILENAME}.zip && \
    mv ./android-ndk-${ANDROID_NDK_VERSION}/* ${ANDROID_NDK_HOME} && \
    rm -f ${ANDROID_NDK_FILENAME}.zip

ENV PATH=${PATH}:${ANDROID_NDK_HOME}

ENV NDK_PROJECT_PATH=/tmp

# Config files

RUN mkdir -p /tmp/jni
COPY /jni/Android.mk /tmp/jni
COPY /jni/Application.mk /tmp/jni

# iPerf 2.0.13

# RUN cd /tmp && \
#     wget --no-check-certificate -q https://astuteinternet.dl.sourceforge.net/project/iperf2/iperf-2.0.13.tar.gz && \
#     tar -zxvf iperf-2.0.13.tar.gz && \
#     rm -f iperf-2.0.13.tar.gz

# COPY /iperf-2.0.13/* /tmp/iperf-2.0.13/
# RUN cd /tmp/iperf-2.0.13 && \
#     autoconf && \
#     ./configure CFLAGS="-static" CXXFLAGS="-static"

# iPerf 2.1.8

# RUN cd /tmp && \
#     wget --no-check-certificate -q https://nav.dl.sourceforge.net/project/iperf2/iperf-2.1.8.tar.gz && \
#     tar -zxvf iperf-2.1.8.tar.gz && \
#     rm -f iperf-2.1.8.tar.gz

# COPY /iperf-2.1.8/* /tmp/iperf-2.1.8/
# RUN cd /tmp/iperf-2.1.8 && \
#     autoconf && \
#     ./configure CFLAGS="-static" CXXFLAGS="-static"

# iPerf 3.10.1

# RUN cd /tmp && \
#     wget --no-check-certificate -q https://downloads.es.net/pub/iperf/iperf-3.10.1.tar.gz && \
#     tar -zxvf iperf-3.10.1.tar.gz && \
#     rm -f iperf-3.10.1.tar.gz

# COPY /iperf-3.10.1/* /tmp/iperf-3.10.1/
# RUN cd /tmp/iperf-3.10.1 && \
#     ./fix.sh && \
#     ./configure CFLAGS="-static" CXXFLAGS="-static" LDFLAGS="-static" --enable-static --disable-shared --enable-static-bin

# iPerf 3.11

# RUN cd /tmp && \
#     wget --no-check-certificate -q https://downloads.es.net/pub/iperf/iperf-3.11.tar.gz && \
#     tar -zxvf iperf-3.11.tar.gz && \
#     rm -f iperf-3.11.tar.gz

# COPY /iperf-3.11/* /tmp/iperf-3.11/
# RUN cd /tmp/iperf-3.11 && \
#     ./fix.sh && \
#     ./configure CFLAGS="-static" CXXFLAGS="-static" LDFLAGS="-static" --enable-static --disable-shared --enable-static-bin

# iPerf 3.12

RUN cd /tmp && \
    wget --no-check-certificate -q https://downloads.es.net/pub/iperf/iperf-3.12.tar.gz && \
    tar -zxvf iperf-3.12.tar.gz && \
    rm -f iperf-3.12.tar.gz

COPY /iperf-3.12/* /tmp/iperf-3.12/
RUN cd /tmp/iperf-3.12 && \
    ./fix.sh && \
    ./configure

# Compile

RUN ndk-build clean

RUN ndk-build NDK_APPLICATION_MK=/tmp/jni/Application.mk

RUN tree /tmp/libs
