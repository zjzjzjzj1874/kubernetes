
## 使用ECK部署[ES]和[kibana]

- 部署[ECK](https://www.elastic.co/guide/en/cloud-on-k8s/2.6/k8s-deploy-eck.html)
  - `kubectl apply -f crds.yaml`
  - `kubectl apply -f operator.yaml`
- 部署[ES](https://www.elastic.co/guide/en/cloud-on-k8s/2.6/k8s-deploy-elasticsearch.html)
  - `kubectl apply -f es-8.7.1.yaml`
- 部署[Kibana](https://www.elastic.co/guide/en/cloud-on-k8s/2.6/k8s-kibana-es.html#k8s-kibana-eck-managed-es)
  - `kubectl apply -f kibana-8.7.1.yaml`
- 获取es密码
  - `PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')`
  - `echo ${PASSWORD}`
  - Note:这里将quickstart换成你的es
- 配置Ingress,访问5601端口即可(我这里使用华为云,配置路由即可)
- 配置[Filebeat收集器](https://www.elastic.co/guide/en/beats/filebeat/current/running-on-kubernetes.html)
  - `kubectl apply -f filebeat-8.7.1.yml`
