
### 验证Metrics Server是否有pod的访问权限:

可以使用kubectl命令验证Metrics Server的Service Account是否具有访问权限。执行以下命令：`kubectl auth can-i get pods --as=system:serviceaccount:<Namespace>:<ServiceAccount>`,
将<Namespace>替换为 Metrics Server 所在的命名空间kube-system，<ServiceAccount>替换为Metrics Server使用的metrics-server名称。确认返回结果为"yes" 表示 Service Account 具有访问权限。
执行`kubectl auth can-i get pods --as=system:serviceaccount:kube-system:metrics-server`