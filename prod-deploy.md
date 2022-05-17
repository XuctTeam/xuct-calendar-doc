### 一、部署mysql

#### 1. 下载安装包

```
wget https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb
```

#### 2. 安装原文件

```
sudo dpkg -i mysql-apt-config_0.8.22-1_all.deb
```

安装过程中出现选择项，通过上下键选择OK继续安装即可。

#### 3.安装server

```
1. 更新APT软件源 ：
   sudo apt-get update
   
2. 安装server
   sudo apt-get install mysql-server
```

- 输入 `y` 继续执行，弹出MySQL 8安装对话框，按回车键确定，进入设置root密码的对话框
- 下载速度可能有点慢请耐心等待，可以尝试更换APT数据源，国内的镜像网站有很多，比如[阿里云](https://developer.aliyun.com/mirror/)、[清华大学镜像](https://mirrors.tuna.tsinghua.edu.cn/)等等，至于如何更换，请自行[百度](https://www.baidu.com/)。

#### 4.配置密码

```
alter user 'root'@'localhost' identified with mysql_native_password by '***';

flush privileges;

CREATE USER 'root'@'172.21.0.12' IDENTIFIED WITH mysql_native_password BY '***';

grant all privileges on *.* to 'root'@'172.21.0.12';

flush privileges;
```

#### 5.新建nacos数据库

```
CREATE DATABASE nacos_config DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

USE nacos_config;

CREATE USER 'nacos'@'localhost' IDENTIFIED WITH mysql_native_password BY 'NacosCalendarDb842';

grant all privileges on nacos_config.* to 'nacos'@'localhost';

flush privileges;

```

导入nacos数据库表

```
USE nacos_config;

source /usr/local/nacos/conf/nacos-mysql.sql;
```

#### 6.新建oauth数据库

```
CREATE DATABASE oauth DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;
```

导入表。

#### 7. 新建leaf数据库

```
CREATE DATABASE leaf DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;
```

#### 8. 新建calendar数据库

```
CREATE DATABASE calendar DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;
```

### 二、部署Nacos

```
下载软件包

./startup.sh -m standalone
```

### 三、 部署redis

#### 1. 安装

```
sudo add-apt-repository ppa:chris-lea/redis-server

sudo apt-get update

sudo apt-get install redis-server -y

sudo systemctl enable redis-server.service
```

#### 2.配置密码

```
sudo vim /etc/redis/redis.conf

# 取消requirepass 注释
```

#### 3. 重启服务

```
service redis restart
```

### 四、部署rabbitmq

#### 1. 安装Erlang环境

- 更新并安装

  ```
  wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo apt-key add -
  
  echo "deb https://packages.erlang-solutions.com/ubuntu focal contrib" | sudo tee /etc/apt/sources.list.d/erlang-solution.list
  
  sudo apt update
  
  sudo apt install erlang
  ```

#### 2. 安装服务

```
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | sudo bash

sudo apt-get install rabbitmq-server

```

#### 3.修改内网地址

```
vim /etc/rabbitmq/rabbitmq-env.conf

#Below is an example of a minimalistic rabbitmq-env.conf file that overrides the default node name prefix from "rabbit" to "hare".

# I am a complete rabbitmq-env.conf file.
# Comment lines start with a hash character.
# This is a /bin/sh script file - use ordinary envt var syntax
NODENAME=rabbitmq
#In the below rabbitmq-env.conf file RabbitMQ configuration file location is changed to "/data/services/rabbitmq/rabbitmq.conf".

# I am a complete rabbitmq-env.conf file.
# Comment lines start with a hash character.
# This is a /bin/sh script file - use ordinary envt var syntax
RABBITMQ_NODE_IP_ADDRESS=
```

#### 4. 配置用户名密码

##### 1. 设置用户并配置密码

```
sudo rabbitmqctl add_user  admin  ****  
```

##### 2.配置用户组权限

```
sudo rabbitmqctl set_user_tags admin administrator
```

##### 3. 用户所有权，便于管理

```
sudo rabbitmqctl  set_permissions -p / admin '.*' '.*' '.*'
```

#### 4. 配置GUI启动

```
sudo  rabbitmq-plugins enable rabbitmq_management
```

#### 5.启用延迟队列

##### 1. 下载插件

```

cd /usr/lib/rabbitmq/
mkdir plugins && cd plugins
wget https://download.連接.台灣/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/3.10.0/rabbitmq_delayed_message_exchange-3.10.0.ez
sudo rabbitmq-plugins enable rabbitmq_delayed_message_exchange
```

##### 6. 基础命令

```
service rabbitmq-server start    # 启动
service rabbitmq-server stop     # 停止
service rabbitmq-server restart  # 重启 
```



### 五、部署fdfs

#### 1. 下载依赖包

```
https://github.com/happyfish100

mkdir -vp /home/fdfs/{tracker,storage} 
```

#### 2. 安装libfastcommon

```
cd libfastcommon/ && ./make.sh && ./make.sh install
```

##### 3. 安装fdfs

```
mv /tmp/fastdfs-6.08.tar.gz .

tar -xvf fastdfs-6.08.tar.gz

cd fastdfs-6.08

./make.sh && ./make.sh install

```

##### 4. 修改配置文件

```
cp /usr/local/src/fastdfs-6.08/conf/http.conf /etc/fdfs/

cp /usr/local/src/fastdfs-6.08/conf/mime.types /etc/fdfs/
```

##### 5. nginx-modulle

```
tar -xvf fastdfs-nginx-module-1.22.tar.gz

cp /usr/local/src/fastdfs-nginx-module-1.22/src/mod_fastdfs.conf /etc/fdfs

mv fastdfs-nginx-module-1.22 ../fastdfs-nginx
```

##### 6. oenSsl

```
sudo apt-get install libpcre3 libpcre3-dev
sudo apt-get install openssl libssl-dev zlib1g-dev

```

##### 7.编辑nginx

```
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module  --add-module=/usr/local/fastdfs-nginx/src

make && make install
```

##### 8.编辑配置

```
#vim /etc/fdfs/tracker.conf

bind_addr =10.0.16.12

base_path = /home/fdfs/tracker

# vim /etc/fdfs/storage.conf

bind_addr = 10.0.16.12

base_path = /home/fdfs/storage

store_path0 = /home/fdfs/storage

```

##### 9. 启动

```
/usr/bin/fdfs_tracker /etc/fdfs/tracker.conf
/usr/bin/fdfs_storaged /etc/fdfs/storage.conf
```

##### 10.测试上传

```
vim /etc/fdfs/client.conf

base_path = /home/fdfs/log

tracker_server = 10.0.16.12:22122

##
http://10.0.16.12/group1/M00/00/00/CgAQDGKDVWeASm9XAACEf3Qy6sE436.png
```

##### 11.配置nginx

```
vim /etc/fdfs/mod_fastdfs.conf

tracker_server=10.0.16.12:22122  #tracker服务器IP和端口
url_have_group_name=true
store_path0=/home/fdfs/storage

/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
```

```

```

