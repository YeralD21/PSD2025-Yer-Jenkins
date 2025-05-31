FROM jenkins/jenkins:lts

USER root

# Instala dependencias necesarias
RUN apt-get update && \
    apt-get install -y wget unzip openjdk-17-jdk xz-utils

# Instala Android SDK Command Line Tools
ENV ANDROID_SDK_ROOT=/opt/android-sdk
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip /tmp/cmdline-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools && \
    mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest

ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools

# Instala algunos componentes del SDK (puedes agregar más si necesitas)
RUN yes | sdkmanager --licenses
RUN sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" "ndk;27.0.12077973"

# (Opcional) Instala Flutter
ENV FLUTTER_HOME=/opt/flutter
RUN wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.32.1-stable.tar.xz -O /tmp/flutter.tar.xz && \
    tar xf /tmp/flutter.tar.xz -C /opt && \
    rm /tmp/flutter.tar.xz
ENV PATH=$PATH:$FLUTTER_HOME/bin

USER jenkins 