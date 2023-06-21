#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import subprocess
from subprocess import getoutput
import json
import datetime

class Main:

    def __init__(self):
        alen = len(sys.argv)
        if len(sys.argv) > 1:
            cmd = sys.argv[1]

            if( alen>2 ):
                subCmd = sys.argv[2]
            else:
                subCmd = ""

            if(cmd=="help"):
                print("dockerctl list, 容器列表")
                print("dockerctl info 容器名称, 查看容器信息")
                print("dockerctl dir 容器名称, 进入容器目录")
                print("dockerctl bash 容器名称, 进入容器终端")

            elif(cmd=="list"):
                if( alen>2 ):
                    cmdline = "docker ps " + subCmd
                else:
                    cmdline = "docker ps"
                result = getoutput(cmdline)
                print(result)

            # 信息
            elif(cmd=="info"):
                if( alen>2 ):
                    self.dockerInfo(subCmd)
                else:
                    print("请输入容器名称！")

            # 目录
            elif(cmd=="dir"):
                if( alen>2 ):
                    self.dockerDir(subCmd)
                else:
                    print("请输入容器名称！")

            # 终端
            elif(cmd=="bash"):
                if( alen>2 ):
                    subprocess.call(["docker", "exec", "-u", "root", "-it", subCmd, "bash"])
                else:
                    print("请输入容器名称！")

        else:
            print("请输入 dockerctl help 查询用法")


    def dockerDir(self, conName):
        """进入docker目录
        """
        infoJson = self.dockerInfoJson(conName)
        if( infoJson=="" ):
            return
        dirPath = infoJson[0]["GraphDriver"]["Data"]["MergedDir"]
        os.chdir(dirPath)
        shell = os.environ.get('SHELL', '/bin/bash')
        os.execl(shell, shell)

    def dockerInfo(self, conName):
        """查看docker 容器信息
        """
        infoJson = self.dockerInfoJson(conName)
        if( infoJson=="" ):
            return

        print("容器名:", conName)

        # 2023-06-09T10:12:30.882541557Z
        dt = datetime.datetime.strptime(infoJson[0]["Created"].split('.')[0], '%Y-%m-%dT%H:%M:%S')
        local_dt = dt.astimezone(datetime.timezone.utc).astimezone(datetime.timezone(datetime.timedelta(hours=8)))
        formatted_dt = local_dt.strftime("%Y/%m/%d %H:%M:%S")
        print("创建时间:", formatted_dt)

        print("镜像:", infoJson[0]["Config"]["Image"])
        print("容器ID:", infoJson[0]["Id"])
        print("配置文件:", "/var/lib/docker/containers/"+infoJson[0]["Id"]+"/config.v2.json")
        # print("日志文件:", infoJson[0]["LogPath"])
        print("状态:", infoJson[0]["State"]["Status"])

        tmpJson = infoJson[0]["HostConfig"]["PortBindings"]
        for key in tmpJson.keys():
            for obj in tmpJson[key]:
                print("端口绑定:", key+" -> " + obj["HostIp"] + obj["HostPort"])

        tmpJson = infoJson[0]["NetworkSettings"]
        text = tmpJson["IPAddress"] + tmpJson["Gateway"] + tmpJson["MacAddress"]
        if( text!="" ):
            print("IP:", tmpJson["IPAddress"])
            print("网关:", tmpJson["Gateway"])
            print("MAC:", tmpJson["MacAddress"])

        tmpJson = infoJson[0]["NetworkSettings"]["Networks"]
        for key in tmpJson.keys():
            print("专用网络:", key)
            print("IP:", tmpJson[key]["IPAddress"])
            print("网关:", tmpJson[key]["Gateway"])
            print("MAC:", tmpJson[key]["MacAddress"])


    def dockerInfoJson(self, conName):
        """读取容器的信息（docker inspect xx）
        """
        cmdline = "docker inspect "+ conName
        result = getoutput(cmdline)
        infoJson=""
        try:
            infoJson = json.loads(result)
            return infoJson
        except json.JSONDecodeError as e:
            print("JSON 解析错误：", e)
            return ""


if __name__ == "__main__":
    g = Main()
