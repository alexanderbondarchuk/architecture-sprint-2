#!/bin/bash

###
# Инициализация сервера конфигурации
###
docker compose exec -T configSrv mongosh --port 27018 <<EOF
rs.initiate({
  _id: "config_server",
  configsvr: true,
  members: [{ _id: 0, host: "configSrv:27018" }]
});
EOF




###
# Инициализация шардов
###
docker compose exec -T shard1_1 mongosh --port 27011 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1_1:27011" },
        { _id : 1, host : "shard1_2:27021" },
        { _id : 2, host : "shard1_3:27031" },
      ]
    }
);
EOF

docker compose exec -T shard2_1 mongosh --port 27012 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2_1:27012" },
        { _id : 1, host : "shard2_2:27022" },
        { _id : 2, host : "shard2_3:27032" },
      ]
    }
  );
EOF




###
# Добавление шардов в роутер
###
docker compose exec -T router mongosh --port 27017 <<EOF
sh.addShard("shard1/shard1_1:27011,shard1_2:27021,shard1_3:27031");
sh.addShard("shard2/shard2_1:27012,shard2_2:27022,shard2_3:27032");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
EOF