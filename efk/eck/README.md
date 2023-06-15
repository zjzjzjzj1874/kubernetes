
## 普通服务器部署filebeat收集日志
* [docker-compose](./filebeat-docker-compose.yaml)文件
* [filebeat.yaml](./filebeat-8.7.yaml)配置

### 配置ILM

* 使用DevTools修改ILM:

`PUT _ilm/policy/filebeat-dev`
```json
{
  "policy": {
    "phases": {
      "hot": {
        "min_age": "0ms",
        "actions": {
          "rollover": {
            "max_size": "10gb",
            "max_age": "5d"
          },
          "set_priority": {
            "priority": 50
          }
        }
      },
      "warm": {
        "min_age": "5d",
        "actions": {
          "forcemerge": {
            "max_num_segments": 1
          },
          "set_priority": {
            "priority": 25
          },
          "shrink": {
            "number_of_shards": 1
          }
        }
      },
      "delete": {
        "min_age": "5d",
        "actions": {
          "delete": {
            "delete_searchable_snapshot": true
          }
        }
      }
    }
  }
}
```