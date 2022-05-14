### 一、部署mysql

#### 1. 下载安装包

```
wget https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb
```

#### 2. 安装原文件

```
sudo dpkg -i mysql-apt-config_0.8.29-1_all.deb
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
alter user 'root'@'localhost' identified with mysql_native_password by 'root';
flush privileges;
```

#### 5.新建nacos数据库

```
CREATE DATABASE nacos_config DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

USE nacos_config;

CREATE USER 'nacos'@'10.0.16.12' IDENTIFIED WITH mysql_native_password BY 'NacosCalendarDb842';

grant all privileges on nacos_config.* to 'nacos'@'10.0.16.12';

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
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -

echo "deb http://www.rabbitmq.com/debian/ testing main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list

sudo apt-get install rabbitmq-server
```

#### 3.修改内网地址

```
vim /etc/rabbitmq/rabbitmq-env.conf
```

#### 4. 配置用户名密码

##### 1. 设置用户并配置密码

```
sudo rabbitmqctl add_user  admin  RabbitmqQueue468  
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

```

### 五、部署fdfs

#### 1. 下载依赖包

```
https://github.com/happyfish100
```

