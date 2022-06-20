# kubernetes

kunernetes in zjzjzjzj1874's repo

- [k8s命令行手册](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-strong-getting-started-strong-)

- 重启k3s `systemctl restart k3s`

## 命名空间-namespace

- 创建命名空间 `kubectl create namespace kms-v2`
- 查看命名空间 `kubectl get nemaspace`
- 设置名字空间偏好 `kubectl config set-context --current --namespace=<名字空间名称>`
- 验证 `kubectl config view | grep namespace:`
- 查看位于名字空间中的资源 `kubectl api-resources --namespaced=true`
- 查看不在名字空间中的资源 `kubectl api-resources --namespaced=false`

## 部署清单 deployment

- 查看部署清单 `kubectl get deploy (-o wide)`
- 查看部署清单描述信息 `kubectl describe deployment  nginx-deployment`
- 部署清单 `kubectl apply -f quota-pod.yaml --namespace=kms-v2`
- 删除部署 `kubectl delete deployment {deployment-name}`

## 容器 container

- 查看所有命名空间下容器 `kubectl get pod -A`
- 查看对于命名空间下容器 `kubectl get pod (-n kms-v2)`
- 查看容器描述 `kubectl describe pod {pod-name}`
- 查看日志 `kubectl logs -f {pod-name}`
- 进入容器 `kubectl exec -it {pod-name} bash` or `kubectl exec -it {pod-name} sh`
- 在容器中运行单个命令
    - 查看环境变量: `kubectl exec {pod-name} env` => 注:docker同理
    - 查看进程 `kubectl exec {pod-name} ps aux`
    - 查看目录 `kubectl exec {pod-name} ls /`
    - 查看进程内容 `kubectl exec {pod-name} cat /proc/1/mounts`

## 端口转发port-forward

- 容器端口转发 `kubectl port-forward pods/{pod-name} 8080:80`
- 服务端口转发 `kubectl port-forward service/{service-name} 8080:80`

## 推荐集群操作工具:

- k9s