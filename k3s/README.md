# k3s

- 重启k3s `systemctl restart k3s`
- 
* install
    * ubuntu: 一条命令安装：`curl -sfL https://get.k3s.io | sh -`
    * ubuntu:
      加速命令且不安装traefik：`curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_EXEC="--data-dir /data/rancher/k3s --disable traefik --cluster-cidr 10.58.0.0/16 --service-cidr 10.68.0.0/16 --cluster-dns 10.68.0.2 --cluster-domain cluster.local. --flannel-backend vxlan --kube-apiserver-arg=service-node-port-range=20000-40000 --kube-apiserver-arg=authorization-mode=Node,RBAC --kube-apiserver-arg=allow-privileged=true --kube-proxy-arg proxy-mode=ipvs masquerade-all=true --kube-proxy-arg metrics-bind-address=0.0.0.0 " sh --`