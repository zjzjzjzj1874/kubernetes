# Pods

Pod是K8S中创建和管理的最小的可部署的计算单元,即K8S最小的调度单元;\
Pod(鲸鱼荚/豌豆荚)是一组(一个或多个)容器;他们是共享存储和网络的,同一个pod下的容器一般具有亲和性.

## 什么是pod

注:Docker是最有名的容器运行时,当然K8S还支持很多其他容器运行时,
如containerd,CRI-O,Docker-Engine和Mirantis Container Runtime,容器运行时是负责运行容器的软件.

- Pod的共享上下文包括一组Linux命名空间,控制组(cgroup)和可能其他方面的一些隔离,即用来隔离Docker容器的技术