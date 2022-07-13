#!/bin/bash
# a simple deployment file脚本替换deployment的命名空间 需要传入参数,第一个参数:命名空间,第二个参数:镜像Tag

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

  cd ./deployment/my-zero || exit

  files=$(ls | grep ".yaml")

  for file in ${files}; do
    echo "file name is ${file}"
    sed -i "s/{{namespace}}/${ns}/g" "${file}" # 替换ns
    sed -i "s/{{tag}}/${tag}/g" "${file}"      # 替换tag
  done

  echo "替换完成"
}

# 替换配置文件
regen_configmap() {
  echo "调用替换配置文件方法"
  # 命名空间使用传入变量
  ns=$1

  if [ -z "${ns}" ]; then
    echo "请传入命名空间"
    exit 1
  fi

  cd ./deployment/my-zero || exit
  pwd

  # 查找当前文件夹中所有k8s配置文件
  #  files=$(ls -R . | grep ".k8s.yaml")
  files=$(find "$PWD" | xargs ls -ld | grep ".k8s.yaml") # 查找所有k8s的配置文件,以后如果需要k8s部署,那么grep将会替换为{{dev}}.yaml,不同的分支用不同的配置

  oldIfs=$IFS
  IFS=$'\n'
  for file in ${files}; do
    echo "${file}"
    name=${file##*/}
    name="conf-${name%%.*}" # 截取configmap的名字
    echo "重新生成configmap文件名 ${name}"

    file="/${file#*/}" # 文件绝对路径获取

    kubectl delete configmap -n "${ns}" "${name}"                       # 删除原来configmap
    kubectl create configmap -n "${ns}" "${name}" --from-file="${file}" # 创建新的configmap
  done
  IFS=${oldIfs} # 恢复默认的分割
}

# 部署业务服务,todo 支持所有服务同时发或一个服务单独发
deployment_business_svc() {
  files=$(ls | grep ".yaml")

  for file in ${files}; do
    kubectl apply -f "${file}"
  done
}
