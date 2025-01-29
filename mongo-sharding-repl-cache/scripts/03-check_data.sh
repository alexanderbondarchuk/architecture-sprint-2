#!/bin/bash

###
# Проверка данных. Количество документов в базе, первый шард первая реплика
###

docker compose exec -T shard1_1 mongosh --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF



###
# Проверка данных. Количество документов в базе, первый шард вторая реплика
###

docker compose exec -T shard1_2 mongosh --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF



###
# Проверка данных. Количество документов в базе, второй шард первая реплика
###

docker compose exec -T shard2_1 mongosh --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF



###
# Проверка данных. Количество документов в базе, второй шард третья реплика
###

docker compose exec -T shard2_3 mongosh --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF



###
# Проверка данных. Количество документов в базе, все шарды (через роутер)
###

docker compose exec -T router mongosh --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF



###
# Проверяем реплики
###

docker compose exec -T shard1_1 mongosh <<EOF
rs.status()

rs.secondaryOk()
use somedb
db.helloDoc.find().count()
EOF

docker compose exec -T shard2_1 mongosh <<EOF
rs.status()

rs.secondaryOk()
use somedb
db.helloDoc.find().count()
EOF