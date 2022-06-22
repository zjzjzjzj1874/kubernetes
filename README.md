# kubernetes

kunernetes in zjzjzjzj1874's repo

## 为什么使用K8S

- 容器化:目前我们CI/CD使用Jenkins+Docker;已经实现容器化部署,具备使用K8S的必要条件;
- 可靠性:docker-compose启动和停止服务会存在服务短暂暂停(类似STW),如果本次发布有异常,则服务暂停时间会更长;K8S的部署是先启动再停止,则能够规避这个问题;
- 高效利用资源:当前环境分开发,测试,预发布和生产,开发测试预发布负载很低,会存在资源浪费;基于k8s的namespace来区分环境,可以节约部分资源;
- 自动缩放功能:当服务负载升高时,K8S会自动创建一批新的pods以适应当前需求;若负载下降则会自动缩减pods数量;
- 总之:Kubernetes 使得应用的启动、迁移、部署变得即简单又安全,不必担心应用迁移后工作出现问题，也不用担心一台服务器无法应付突发的用户量。

## K8S参考资料

- [k8s基础教程-云原生](https://lib.jimmysong.io/kubernetes-handbook/)
- [k8s命令行手册](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-strong-getting-started-strong-)
- [k8s APIs和CLIs的设计文档](http://kubernetes.kansea.com/docs/user-guide/kubectl/kubectl/)
- [k8s资源类型](https://kubernetes.io/zh-cn/docs/reference/kubectl/#%E8%B5%84%E6%BA%90%E7%B1%BB%E5%9E%8B)
- [k8s工作负载资源](https://kubernetes.io/docs/concepts/workloads/controllers/)
- [k8s部署mysql](https://kubernetes.io/zh-cn/docs/tasks/run-application/run-replicated-stateful-application/#deploy-mysql)
- [helm Docs](https://helm.sh/docs/)
- [helm Tutorial](https://helm.sh/docs/intro/)

## config-context(主要用于对多集群的访问)

- 查看上下文配置
    - 查看所有=>(也可用于合并config) `kubectl config view`
    - 查看当前上下文配置 `kubectl config view --minify`
- 查看当前所处上下文 `kubectl config current-context`
- 查看上下文列表 `kubectl config get-contexts`
- 设置当前上下文(minikube为当前上下文) `kubectl config use-context minikube`
- 设置命名空间 `kubectl config set-context --current --namespace={namespace}`
    - 切换命名空间 `kubectl config set-context --current --namespace=kube-public`

## K8S常见资源类型

- `nodes`: 节点,即k8s的工作节点
- `namespaces`: 命名空间,主要用于隔离服务资源
- `deployment`: 无状态部署清单,修改部署清单,可能会对正在运行的pod有影响
- `replicaset`: 复制集,也是无状态的
- `services`: 服务,deployment启动服务之后,对外提供服务即是一个service
- [daemonset](https://kubernetes.io/zh-cn/docs/concepts/workloads/controllers/daemonset/): 守护程序集,包括集群/日志收集/监控守护进程,注意:
  删除daemonset会删除它创建的所有pod
- `statefulset`: 有状态集,包括mysql和redis等,需要持久化存储的,他们删除或创建都是有序的,区别于deployment创建的无状态集
- `pods`: k8s的最小调度单位,同一个pod中的容器将共享存储和网络,这些容器有亲和性,所以会被调度到同一个pod中
- [ingress](https://jimmysong.io/kubernetes-handbook/concepts/ingress.html): 外部访问k8s集群内部服务的入口,即进入集群的流量一般由ingress分发;
  K8S支持并维护GCE和Nginx两种,其他常见的Ingress Controller包括:Traefik,F5,Kong,Istio
- 其他的不常用的:`configmaps/endpoints/events/secrets/serviceaccounts/cronjobs/jobs/roles...`

## delete操作

- 常用删除
    - 删除部署清单 `kubectl delete deployment {deployment-name}`
    - 删除命名空间 `kubectl delete namespace {namespace-name}`
    - 删除pod `kubectl delete pod {pod-name}`
    - 删除pod `kubectl delete pods {pod-name}`
      部署如果是3个pod,那么delete一个之后,可能会很快起一个,因为deployment决定的
      可以使用`kubectl edit deployment {deployment-name}`来改变副本数量
    - 其他删除 `cronjob/configmap/ingress/job/node/pvc/svc/sa/secret/statefulset`

## describe操作

- 常用描述操作
    - 查看节点描述 `kubectl describe node`,包括节点系统信息,命名空间负载等各种资源信息
    - 查看ingress `kubectl describe ingress`
    - 查看命名空间 `kubectl describe namespace`
    - 查看pods描述 `kubectl describe pods (+ {pod-name})`
    - 查看副本集描述 `kubectl describe replicaset`
    - 查看服务描述 `kubectl describe svc`
    - 查看有状态集描述 `kubectl describe statefulset`
    - 查看其他资源 `daemonset/configmap/pvc/secret/sa(=serviceAccount)...`

## edit操作

- 常用编辑操作
    - 编辑节点 `kubectl edit node`
    - 编辑命名空间 `kubectl edit namespace {namespace-name}`
    - 编辑部署 `kubectl edit deployment {deployment-name}`,常用于临时修改镜像,副本数量等
    - 编辑pods `kubectl edit pods {pods-name}`
    - 编辑有状态集 `kubectl edit statefulset {name}`
    - 编辑复制集 `kubectl edit replicaset {name}`
    - 编辑其他资源 `cronjob/configmap/daemonset/ingress/job/pvc/svc...`
- 如果想生产yaml的部署文件,也可以使用对应的`edit`查看生产的yaml文件

## get操作

- 查看所有
    - 当前命名空间下:`kubectl get all` => 包括(pods/deployment/service/replicaset/statefulset等)
    - 本node所有命名空间:`kubectl get all --all-namespaces` => 包括(pods/deployment/service/replicaset/statefulset等)
    - 注:`--all-namespaces == -A`,所以上面命令 == `kubectl get all -A`,下同
- 查看所有configmap
    - 当前命名空间下:`kubectl get configmaps`
    - 本node所有命名空间:`kubectl get configmaps -A`
- 查看所有部署
    - 当前命名空间下:`kubectl get deployment`
    - 本node所有命名空间:`kubectl get deployment -A`
- 查看所有pods
    - 当前命名空间下:`kubectl get pods`
    - 本node所有命名空间:`kubectl get pods -A (-o wide)`
- 其他资源查看
    - `cronjob/daemonset/ingress/job/nodes/namespaces/pvc/svc/replicaset/statefulset/secret`
- `-o`:查看更多信息
    - `wide`: 输出更多信息
    - `json`: 以json格式输出
    - `yaml`: 以yaml格式输出

## exec操作

- 进入pod `kubectl exec -it {pod-name} bash`
- 不进入pods打印环境变量 `kubectl exec {pod-name} env`
- 不进入pod查看根目录文件结构 `kubectl exec {pod-name} ls /`
- 查看进程 `kubectl exec {pod-name} ps aux`
- 查看进程内容 `kubectl exec {pod-name} cat /proc/1/mounts`

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

## 其他常用操作

### 端口转发port-forward

- 容器端口转发 `kubectl port-forward pods/{pod-name} 8080:80`
- 服务端口转发 `kubectl port-forward service/{service-name} 8080:80`

### 日志查看

- 查看单个容器日志:`kubectl logs (-f) {pods-name}`
- 查看所有标签`app=nginx-demo`的容器日志:`kubectl logs -l app=nginx-demo --all-containers=true`
- 查看所有标签`app=nginx-demo`的容器日志:`kubectl logs -l app=nginx-demo --all-containers=true`
- 查看容器一个小时前:`kubectl logs --since=1h {pod-name}`

### scale主要(针对deployment和statefulset)

- 将部署集deployment-nginx副本设置为3:`kubectl scale --replicas=3 deployment/deployment-nginx`
- 如果部署集deployment-nginx副本为1,那么将其副本设置为2:`kubectl scale --current-replicas=1 --replicas=2 deployment/deployment-nginx`
- statefulset同理

## 推荐集群操作工具:

- [k9s](https://github.com/derailed/k9s):解放命令行操作神器
- [helm](https://helm.sh/docs/):K8S包管理工具,CNCF毕业项目
    - 安装: `brew install helm`
    - 初始化Helm Chart存储库:`helm repo add bitnami https://charts.bitnami.com/bitnami`
    - 查找bitnami库中的可用图表:`helm search repo bitnami`
    - 更新helm的repo: `helm repo update`
    - helm启动etcd:`helm install bitnami/etcd --generate-name`
    - 查看helm安装的服务: `helm list`
    - 卸载helm安装的服务: `helm uninstall etcd-1612624192`
    - 更多请查看官方文档