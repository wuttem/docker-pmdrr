FROM ubuntu:16.04

#ENV LC_ALL en_US.UTF-8
#ENV LANGUAGE en_US:en
ENV DEBIAN_FRONTEND noninteractive

RUN echo 'deb http://www.rabbitmq.com/debian/ testing main' | tee /etc/apt/sources.list.d/rabbitmq.list
RUN apt-get update \
 && apt-get -y --no-install-recommends install apt-utils \
 && echo "mysql-server mysql-server/root_password password root" | debconf-set-selections \
 && echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get install -qq -y --allow-unauthenticated --no-install-recommends ca-certificates mysql-server libmysqlclient-dev git build-essential wget unzip curl mysql-client python-dev python python-pip nano redis-server default-jdk rabbitmq-server openssh-client libpq-dev
RUN pip install --upgrade pip \
 && pip install setuptools \
 && pip install pytest mock MySQL-python redis

COPY dynamo-server /etc/init.d/dynamo-server
RUN mkdir -p /opt/dynamo \
 && cd /opt/dynamo \
 && /usr/bin/curl -L https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_latest.tar.gz | /bin/tar xz \
 && echo "/usr/bin/java -Djava.library.path=/opt/dynamo/DynamoDBLocal_lib -jar /opt/dynamo/DynamoDBLocal.jar -sharedDb --inMemory" > startDynamo.sh \
 && chmod +x startDynamo.sh \
 && chmod 755 /etc/init.d/dynamo-server \
 && cd ~
# Install the Google Cloud SDK.

ENV HOME /
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components app-engine-java app-engine-python app kubectl alpha beta gcd-emulator pubsub-emulator cloud-datastore-emulator app-engine-go bigtable

# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Disable updater completely.
# Running `gcloud components update` doesn't really do anything in a union FS.
# Changes are lost on a subsequent run.
RUN sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /google-cloud-sdk/lib/googlecloudsdk/core/config.json

RUN mkdir /.ssh
ENV PATH /google-cloud-sdk/bin:$PATH
VOLUME ["/.config"]
CMD ["/bin/bash"]
