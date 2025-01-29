#!/bin/bash

###
# Проверка данных. Количество документов в базе, первый шард
###

docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF



###
# Проверка данных. Количество документов в базе, второй шард
###

docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF



###
# Проверка данных. Количество документов в базе, все шарды (через роутер)
###

docker compose exec -T router mongosh --port 27017 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF