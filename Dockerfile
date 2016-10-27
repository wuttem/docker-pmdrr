FROM ubuntu:16.04

#ENV LC_ALL en_US.UTF-8
#ENV LANGUAGE en_US:en
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get -y --no-install-recommends install apt-utils \
 && echo "mysql-server mysql-server/root_password password root" | debconf-set-selections \
 && echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get install -qq -y --no-install-recommends ca-certificates mysql-server libmysqlclient-dev git build-essential wget curl mysql-client python-dev python python-pip nano redis-server default-jdk
RUN pip install --upgrade pip \
 && pip install setuptools \
 && pip install pytest mock MySQL-python redis
WORKDIR /opt/dynamo
COPY dynamo-server /etc/init.d/dynamo-server
RUN mkdir -p /opt/dynamo \
 && /usr/bin/curl -L http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest | /bin/tar xz \
 && echo "/usr/bin/java -Djava.library.path=/opt/dynamo/DynamoDBLocal_lib -jar /opt/dynamo/DynamoDBLocal.jar -sharedDb --inMemory" > startDynamo.sh \
 && chmod +x startDynamo.sh \
 && chmod 700 /etc/init.d/dynamo-server