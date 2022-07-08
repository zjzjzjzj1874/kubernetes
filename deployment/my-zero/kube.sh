#!/bin/bash

# 生成k8s的部署文件 => 但生成之后需要做简单改动

goctl kube deploy -name deployment-my-zero -namespace default -image my-zero -o my-zero.yaml -port 80
