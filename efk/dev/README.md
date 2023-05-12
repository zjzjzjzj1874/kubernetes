
## 使用ECK部署ES和kibana

- 部署ECK
  - `kubectl apply -f crds.yaml`
  - `kubectl apply -f operator.yaml`
- 部署ES
  - `kubectl apply -f es-8.7.1.yaml`
- 部署Kibana
  - `kubectl apply -f kibana-8.7.1.yaml`
- 获取es密码
  - `PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')`
  - `echo ${PASSWORD}`
  - Note:这里将quickstart换成你的es
- 配置Ingress,访问5601端口即可(我这里使用华为云,配置路由即可)
