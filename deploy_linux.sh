#!/bin/bash
# a simple deployment file脚本替换deployment的命名空间 需要传入参数,第一个参数:命名空间,第二个参数:镜像Tag

. ./deploy.sh # 导入deploy.sh,可以调用其中的变量和方法,类似与golang的import

ns_image_replace "$1" "$2" # 调用命名空间替换方法
#regen_configmap "$1"       # 替换configmap TODO 配置文件不在这个项目中,所以这个方法不调用
deployment_business_svc # 重新部署业务服务
