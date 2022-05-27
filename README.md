# kubernetes

kunernetes in zjzjzjzj1874's repo

## 命名空间-namespace

- 创建命名空间：`kubectl create namespace kms-v2`
- 查看命名空间 `kubectl get nemaspace`
- 设置名字空间偏好
- `kubectl config set-context --current --namespace=<名字空间名称>`
- 验证 `kubectl config view | grep namespace:`
- 查看位于名字空间中的资源 `kubectl api-resources --namespaced=true`
- 查看不在名字空间中的资源 `kubectl api-resources --namespaced=false`
- 


## 部署清单 deployment
- 查看部署清单`kubectl get deploy (-o wide)`
- 查看部署清单描述信息`kubectl describe deployment  nginx-deployment`
- 部署清单：`kubectl apply -f quota-pod.yaml --namespace=kms-v2`


## 容器 container
- 查看所有命名空间下容器 `kubectl get pod -A`
- 查看对于命名空间下容器 `kubectl get pod (-n kms-v2)`
- 查看容器描述 `kubectl describe pod {pod-name}`
- 查看日志 `kubectl logs -f {pod-name}`
- 进入容器 `kubectl exec -it {pod-name} bash`