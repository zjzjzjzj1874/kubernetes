#!/bin/bash
# a simple deployment file脚本替换deployment的命名空间 需要传入参数,第一个参数:命名空间,第二个参数:镜像Tag

. ./deploy.sh # 导入deploy.sh,可以调用其中的变量和方法,类似与golang的import

# 替换部署文件的命名空间
# shellcheck disable=SC2120
ns_image_replace() {

  # 命名空间使用传入变量
  ns=$1

  if [ -z "${ns}" ]; then
    echo "请传入命名空间"
    exit 1
  fi

  tag=$2
  if [ -z "${tag}" ]; then
    echo "请传入镜像标签"
    exit 1
  fi

  echo " ================= 命名空间:${ns},镜像Tag:${tag} ================"

  cd ./deployment/my-zero || exit # TODO 服务器脚本中替换目录

  files=$(ls | grep ".yaml")

  for file in ${files}; do
    echo "file name is ${file}"
    sed -i "" "s/{{namespace}}/${ns}/g" "${file}" # 替换ns
    sed -i "" "s/{{tag}}/${tag}/g" "${file}"      # 替换tag
  done

  echo "替换完成"
}

ns_image_replace "$1" "$2" # 调用命名空间替换方法
regen_configmap "$1"       # 替换configmap TODO 配置文件不在这个项目中,所以这个方法不调用
deployment_business_svc    # 重新部署业务服务
