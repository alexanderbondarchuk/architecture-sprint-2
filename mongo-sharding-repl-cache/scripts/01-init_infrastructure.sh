#!/bin/bash

###
# Инициализация сервера конфигурации
###
docker compose exec -T configSrv mongosh <<EOF
rs.initiate({
  _id: "config_server",
  configsvr: true,
  members: [{ _id: 0, host: "configSrv" }]
});
EOF




###
# Инициализация шардов
###
docker compose exec -T shard1_1 mongosh <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1_1" },
        { _id : 1, host : "shard1_2" },
        { _id : 2, host : "shard1_3" },
      ]
    }
);
EOF

docker compose exec -T shard2_1 mongosh <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2_1" },
        { _id : 1, host : "shard2_2" },
        { _id : 2, host : "shard2_3" },
      ]
    }
  );
EOF




###
# Добавление шардов в роутер
###
docker compose exec -T router mongosh <<EOF
sh.addShard("shard1/shard1_1,shard1_2,shard1_3");
sh.addShard("shard2/shard2_1,shard2_2,shard2_3");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
EOF