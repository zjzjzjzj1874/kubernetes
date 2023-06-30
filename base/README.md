
### Metric Server
* 验证Metrics Server是否有pod的访问权限:
可以使用kubectl命令验证Metrics Server的Service Account是否具有访问权限。执行以下命令：`kubectl auth can-i get pods --as=system:serviceaccount:<Namespace>:<ServiceAccount>`,
将<Namespace>替换为 Metrics Server 所在的命名空间kube-system，<ServiceAccount>替换为Metrics Server使用的metrics-server名称。确认返回结果为"yes" 表示 Service Account 具有访问权限。
执行`kubectl auth can-i get pods --as=system:serviceaccount:kube-system:metrics-server`


* Metric[指标](./mertrics-server.yaml)
    * 作用:检测node/pod的CPU和Memory使用情况,HPA的伸缩也依靠其采集的数据.不过除了Metric Server采集的指标,HPA也可以使用Prometheus Adapter和Custom Metrics API自定义的指标.
    * 部署命令:`kubectl apply -f metric-server.yaml -n kube-system`

* Metric如果采集不到指标,可以上到节点安装sysstat(`yum -y install sysstat`):
  * Sysstat是一个用于系统性能监控和统计的工具集。它包含了一组实用程序，用于收集、报告和分析系统资源的使用情况，如CPU使用率、内存使用率、磁盘I/O、网络流量等。