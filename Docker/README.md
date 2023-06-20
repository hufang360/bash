# dockerctl

docker辅助工具

<br>

## 使用
```shell
# 下载脚本
wget https://raw.githubusercontent.com/hufang360/bash/master/Docker/dockerctl.py

# 设置脚本为可执行
chmod +x dockerctl.py

# 脚本帮助
./dockerctl.py help

# 查看容器信息
./dockerctl.py info 容器名称

# 进入容器目录
./dockerctl.py dir 容器名称

# 进入容器终端
./dockerctl.py bash 容器名称
```

<br>

## 小技巧
linux下修改终端配置文件，自定义终端指令

```shell
# 创建自定义指令
echo 'function dockerctl() { ~/dockerctl.py $*;}' >> ~/.bash_profile

# 让环境变量生效
source ~/.bash_profile

# 之后即可使用 dockerctl 指令来使用本脚本
dockerctl help
```