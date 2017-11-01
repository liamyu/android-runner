FROM gitlab/gitlab-runner:latest
LABEL maintainer="liam.yuonline@gmail.com"

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    ANDROID_HOME="/home/liam/env/android-sdk" \
    PATH=$PATH:$ANDROID_HOME:$JAVA_HOME'/bin':$ANDROID_HOME'/tools/bin' \    
    GITLAB_RUNNER_USER=gitlab-runner \
    GITLAB_RUNNER_HOME_DIR="/home/liam/gitlab_runner" \
    GITLAB_RUNNER_DATA_DIR="${GITLAB_RUNNER_HOME_DIR}/data"

RUN apt-get update \
    && apt-get -y install software-properties-common \
    && add-apt-repository -y ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get -y install openjdk-8-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget --quiet --output-document=android-sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
    && apt-get update \
    && apt-get -y install zip \
    && apt-get clean \
    && mkdir -p /home/liam/env/android-sdk/ \
    && unzip android-sdk-tools.zip -d /home/liam/env/android-sdk/ \
    && rm android-sdk-tools.zip \
    && /var/lib/dpkg/info/ca-certificates-java.postinst configure \
    && /home/liam/env/android-sdk/tools/bin/sdkmanager --update

RUN mkdir -p $ANDROID_HOME/licenses \
    && echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > "$ANDROID_HOME/licenses/android-sdk-license" \
    && echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license" \
    && /home/liam/env/android-sdk/tools/bin/sdkmanager "platform-tools" \
    && /home/liam/env/android-sdk/tools/bin/sdkmanager "build-tools;26.0.2"\
    && /home/liam/env/android-sdk/tools/bin/sdkmanager "platforms;android-25" "platforms;android-26" \
    && /home/liam/env/android-sdk/tools/bin/sdkmanager "extras;google;m2repository" "extras;android;m2repository"

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

VOLUME ["${GITLAB_RUNNER_DATA_DIR}"]
WORKDIR "${GITLAB_RUNNER_HOME_DIR}"
ENTRYPOINT ["/sbin/entrypoint.sh"]
