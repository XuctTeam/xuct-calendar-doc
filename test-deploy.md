## 部署 calendar

### mysql

#### 启动 mysql

```
docker pull mysql:8.0.26
```

```
mkdir -p /usr/mysql/conf /usr/mysql/data
```

```
vim /usr/mysql/conf/my.cnf

#添加以下内容到上述创建的配置文件中

[client]
#socket = /usr/mysql/mysqld.sock
default-character-set = utf8mb4
[mysqld]
#pid-file        = /var/run/mysqld/mysqld.pid
#socket          = /var/run/mysqld/mysqld.sock
#datadir         = /var/lib/mysql
#socket = /usr/mysql/mysqld.sock
#pid-file = /usr/mysql/mysqld.pid
datadir = /var/lib/mysql
character_set_server = utf8mb4
collation_server = utf8mb4_bin
secure-file-priv= NULL
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
# Custom config should go here
!includedir /etc/mysql/conf.d/
```

```
sudo docker run -p 3306:3306 --name mysql \
-v /usr/mysql/log:/var/log/mysql \
-v /usr/mysql/data:/var/lib/mysql \
-v /usr/mysql/conf/my.cnf:/etc/mysql/my.cnf:rw \
-v /etc/localtime:/etc/localtime:ro #本机时间与数据库时间同步
-e MYSQL_ROOT_PASSWORD=root \
-d mysql:8.0.26
```

##### 登陆mysql

```
docker exec -it mysql /bin/bash
mysql -uroot -p
```

```
alter user 'root'@'localhost' identified with mysql_native_password by 'root';
flush privileges;
```



#### 创建用户

```
CREATE USER 'nacos'@'%' IDENTIFIED BY 'nacos';
GRANT ALL ON nacos_config.* TO 'nacos'@'%';
flush privileges;
```

### nacos

```
sudo docker run -d \
-e TZ="Asia/Shanghai" \
-e PREFER_HOST_MODE=49.233.22.83 \
-e MODE=standalone \
-e SPRING_DATASOURCE_PLATFORM=mysql \
-e MYSQL_SERVICE_HOST=10.0.16.17 \
-e MYSQL_SERVICE_PORT=3306 \
-e MYSQL_SERVICE_USER=nacos \
-e MYSQL_SERVICE_PASSWORD=nacos \
-e MYSQL_SERVICE_DB_NAME=nacos_config \
-e NACOS_AUTH_ENABLE=true \
-p 7848:7848 \
-p 8848:8848 \
-p 9848-9849:9848-9849 \
--name nacos \
--restart=always \
nacos/nacos-server:latest
```

### redis

```
docker run -d -p 6379:6379 --name redis -v /usr/local/redis/config/redis.conf:/etc/redis/redis.conf -v /usr/local/redis/data:/data -d redis redis-server /etc/redis/redis.conf --appendonly yes
```

### rabbitmq

#### 下载镜像

```
docker pull rabbitmq:management
docker run --name rabbitmq -d -p 15672:15672 -p 5672:5672 rabbitmq:management
```

#### 下载延迟队列

```
https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases

docker cp rabbitmq_delayed_message_exchange-3.9.0.ez rabbitmq:/plugins

docker exec -it rabbitmq bash

rabbitmq-plugins enable rabbitmq_delayed_message_exchange
```

