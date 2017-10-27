FROM gitlab/gitlab-runner:latest
LABEL maintainer="liam.yuonline@gmail.com"

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" ANDROID_HOME="/home/liam/env/android-sdk" PATH=$PATH:$ANDROID_HOME:$JAVA_HOME:$JAVA_HOME"/bin" PATH=$PATH:$ANDROID_HOME:"/tools/bin"

RUN apt-get update \
    && apt-get -y install software-properties-common \
    && add-apt-repository ppa:webupd8team/java \
    && apt-get -y install openjdk-8-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget --quiet --output-document=android-sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
    && apt-get update \
    && apt-get -y install zip \
    && mkdir /home/liam/env/android-sdk/ \
    && unzip /tmp/android-sdk-tools.zip -d /home/liam/env/android-sdk/ \
    && sdkmanager --update

RUN sdkmanager "platform-tools" \
    && sdkmanager "build-tools;26.0.2"\
    && sdkmanager "platforms;android-21" "platforms;android-22" "platforms;android-23" "platforms;android-24" "platforms;android-25" "platforms;android-26" \
    && sdkmanager "extras;google;m2repository" "extras;android;m2repository"
