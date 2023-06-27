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

这段代码是用来创建或更新一个名为"filebeat-dev"的索引生命周期策略（index lifecycle policy）。索引生命周期策略用于定义索引在不同阶段的行为，如热阶段（hot phase）、温暖阶段（warm
phase）和删除阶段（delete phase）。
在这个策略中，包含了以下阶段和动作：

* 热阶段（hot phase）：
    * min_age：索引的最小存活时间为0毫秒，表示索引立即进入热阶段。
    * actions：定义了两个动作：
        - **rollover**：当索引大小达到20GB或主分片大小达到10GB或索引年龄达到5天时，执行rollover操作（切换到新的索引）。
        - **set_priority**：设置索引的优先级为50。
* 温暖阶段（warm phase）：
    * min_age：索引的最小存活时间为3天。
    * actions：定义了三个动作：
        * forcemerge：将索引的段数合并为1，以优化查询性能。
        * set_priority：设置索引的优先级为25。
        * shrink：将索引的分片数缩减为1。
* 删除阶段（delete phase）：
    * min_age：索引的最小存活时间为3天。
    * actions：定义了一个动作：
        * delete：删除索引，并在删除之前创建可搜索的快照（delete_searchable_snapshot为true,也可以不需要）。

该策略的作用是将索引在不同阶段进行合适的操作，如切换到新索引、优化查询性能、缩减分片数和删除索引。可以根据具体需求进行调整和定制。

### Pipeline
在Elasticsearch中，Pipeline是一系列处理步骤的有序序列，用于对文档进行转换、操作和预处理。Pipeline可以在文档索引之前或检索之后应用于文档数据。它们通常用于对原始数据进行清洗、提取关键信息、转换数据类型、计算新字段等操作。

通过定义自定义的Pipeline，你可以使用各种处理器来执行各种转换和操作。一些常用的处理器包括JSON处理器（用于解析和操作JSON数据）、Grok处理器（用于解析和提取结构化日志数据）、日期处理器（用于处理日期和时间字段）等。处理器按照定义的顺序逐个应用于文档，并可以修改文档的字段值、添加新字段、删除字段等。

通过使用Pipeline，你可以在数据被索引之前对其进行预处理，从而提高索引的效率和准确性。此外，Pipeline还可以用于在检索数据时对结果进行转换和处理，以满足特定的需求。

总而言之，Pipeline是用于对文档进行转换、操作和预处理的一组处理步骤，可以在索引之前或检索之后应用于文档数据。它们提供了灵活的方式来处理和转换数据，以满足特定的业务需求。

以下:设置一个名为my-es-pipeline的管道

```shell
PUT _ingest/pipeline/my-es-pipeline
{
  "description": "我es的pipeline",
  "processors": [
    {
      "json": {
        "field": "message",
        "target_field": "msg_json",
        "ignore_failure": true
      }
    },
    {
      "convert": {
        "field": "msg_json.time_used",
        "type": "auto",
        "target_field": "time_used_float",
        "ignore_missing": true,
        "ignore_failure": true
      }
    },
    {
      "convert": {
        "field": "msg_json.batch",
        "type": "integer",
        "target_field": "batch_int",
        "ignore_missing": true,
        "ignore_failure": true
      }
    }
  ]
}
```

该Pipeline的作用是对message字段进行处理。首先，使用json处理器将message字段解析为JSON格式，并将结果存储在msg_json字段中。设置ignore_failure为true表示在处理过程中忽略任何错误。
接下来，使用convert处理器将msg_json.time_used字段转换为浮点数类型。field参数指定要转换的字段名,并将结果存储在target_field字段中，type参数指定要转换的目标类型（这里是float）。ignore_missing参数设置为true，表示如果字段不存在，则忽略转换操作。同样，ignore_failure参数设置为true，表示在转换过程中忽略任何错误。
通过定义这个Pipeline，你可以将它应用于Elasticsearch中的索引，以在索引过程中自动执行这些处理步骤。