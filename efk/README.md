# ElasticSearch在集群中的部署

## 使用OpenSSL生成自签证书
- 生成私钥 `openssl genrsa -out es-dev.pem 2048` => `es-dev.pem`
- 创建证书请求 `openssl req -new -key es-dev.pem -out es-dev.csr` => `es-dev.csr`
- 创建自签名证书 `openssl x509 -req -days 730 -in es-dev.csr -signkey es-dev.pem -out es-dev-cert.pem` => `es-dev-cert.pem`
- 生成keystore.p12文件 `openssl pkcs12 -export -in es-dev-cert.pem -inkey es-dev.pem -out keystore.p12` 输入密码 => `keystore.p12`
- 生成truststore.p12 `keytool -importcert -file es-dev-cert.pem -keystore truststore.p12 -storetype PKCS12`
- 将CD证书(es-dev-cert)导入新的truststore `keytool -list -v -keystore truststore.p12 -storetype PKCS12`

## 将生成的SSL证书和私钥存储在Secret对象中，以便可以将其挂载到Elasticsearch容器中。可以使用以下命令创建Secret对象
    `kubectl create secret generic elasticsearch-certs --from-file=certs/`




## es单个节点创建ssl证书
- [参考资料](https://www.elastic.co/guide/en/elasticsearch/reference/8.6/security-basic-setup.html#generate-certificates)
- 创建CA证书 `./bin/elasticsearch-certutil ca` => elastic-stack-ca.p12
- 创建证书和私钥 `./bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12` => elastic-stack-ca.p12
- 将证书从pod中拷贝出来 
    `kubectl cp elasticsearch-0:/usr/share/elasticsearch/elastic-certificates.p12 elastic-certificates.p12`
    `kubectl cp elasticsearch-0:/usr/share/elasticsearch/elastic-stack-ca.p12 elastic-stack-ca.p12`
- 将证书从本地拷入其他pod中(上一步中,反转源和目标即可)
  `kubectl cp elastic-certificates.p12 elasticsearch-1:/usr/share/elasticsearch/elastic-certificates.p12`
  `kubectl cp elastic-stack-ca.p12 elasticsearch-1:/usr/share/elasticsearch/elastic-stack-ca.p12`

## 
- 向配置文件中添加
    xpack.security.transport.ssl.enabled: true
    xpack.security.transport.ssl.verification_mode: certificate
    xpack.security.transport.ssl.client_authentication: required
    xpack.security.transport.ssl.keystore.path: elastic-certificates.p12
    xpack.security.transport.ssl.truststore.path: elastic-certificates.p12
- 如果证书有密码,去所有pod中执行
  `./bin/elasticsearch-keystore add xpack.security.transport.ssl.keystore.secure_password` => +密码
  `./bin/elasticsearch-keystore add xpack.security.transport.ssl.truststore.secure_password` => +密码

### 尝试
- 生成私钥文件和证书文件 `openssl req -x509 -newkey rsa:4096 -nodes -keyout private-key.pem -out certificate.pem -days 365`
- 生成PKCS12格式的keystore文件 `openssl pkcs12 -export -in certificate.pem -inkey private-key.pem -out keystore.p12 -name my-keystore -passout pass:password`
- 生成truststore文件 `openssl pkcs12 -in keystore.p12 -out truststore.p12 -nokeys -clcerts -passin pass:password -passout pass:password`






### Ubuntu安装NFS
- 安装nfs-kernel-server，将会自动安装nfs-common和rpcbind等依赖
  `sudo apt-get install nfs-kernel-server`
- 配置/etc/exports文件
  `/mnt/{你的目录} *(rw,sync,no_root_squash,no_subtree_check)`
- 重启nfs服务
  `sudo /etc/init.d/nfs-kernel-server restart`
- [参考](https://www.wpgdadatong.com/cn/blog/detail/45305)

