# docker-python-mysql-dynamo-redis
Docker Container with Preinstalled Python/SQL/Dynamo/Redis Stack
Based on Ubuntu 16.04

## Packages installed

 - [Python](https://www.python.org/) 2.7
 - [MySQL](https://www.mysql.com/) 
 - [Redis](http://www.redis.io/) 
 - [DynamoDb](https://aws.amazon.com/dynamodb/) 

## Bitbucket Pipeline Configuration `bitbucket-pipelines.yml`

```YAML
image: mths/docker-python-mysql-dynamo-redis
pipelines:
  default:
    - step:
        script:
          - service mysql start
          - mysql -h localhost -u root -proot -e "CREATE DATABASE mydb;"
          - python setup.py install
          - py.test
```
