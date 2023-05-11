## 部署[ECK](https://www.elastic.co/guide/en/cloud-on-k8s/2.6/k8s-deploy-eck.html)

- Install custom resource definitions: 
  - `kubectl create -f https://download.elastic.co/downloads/eck/2.6.1/crds.yaml`
  - 或者`wget https://download.elastic.co/downloads/eck/2.6.1/crds.yaml` && `kubectl create -f crds.yaml`
- Install the operator with its RBAC rules: 
  - `kubectl apply -f https://download.elastic.co/downloads/eck/2.6.1/operator.yaml`
  - 或者`wget https://download.elastic.co/downloads/eck/2.6.1/operator.yaml` && `kubectl create -f operator.yaml`
- 查看日志 `kubectl -n elastic-system logs -f statefulset.apps/elastic-operator`

## 部署[ES cluster](https://www.elastic.co/guide/en/cloud-on-k8s/2.6/k8s-deploy-elasticsearch.html)
- 启动ES
  - `kubectl apply -f es.yaml`
- 查看就行了
- 如果存储不够,或者引擎不是csi-nas,就替换成自己的.
