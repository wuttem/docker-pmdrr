# docker-python-mysql-dynamo-redis
Docker Container with Preinstalled Python/SQL/Dynamo/Redis/Rabbit
Based on Ubuntu 16.04

## Packages installed

 - [Python](https://www.python.org/) 2.7
 - [MySQL](https://www.mysql.com/) 
 - [Redis](http://www.redis.io/) 
 - [DynamoDb](https://aws.amazon.com/dynamodb/)
 - [RabbitMq](https://www.rabbitmq.com/)

## Bitbucket Pipeline Configuration `bitbucket-pipelines.yml`

Example: Start all services, install python dependenciesw and start testsuite


```YAML
image: mths/docker-python-mysql-dynamo-redis
pipelines:
  default:
    - step:
        script:
          - service mysql start
          - service redis-server start
          - service dynamo-server start
          - service rabbitmq-server start
          - mysql -h localhost -u root -proot -e "CREATE DATABASE mydb;"
          - python setup.py install
          - py.test
```
