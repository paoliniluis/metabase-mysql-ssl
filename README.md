# Metabase MySQL SSL repro

1) make sure you're in us-east-1 (N. Virginia)
2) set up a MySQL in RDS with the following parameters:
version: latest
type: single DB instance
DB instance identifier: metabase-app-db-mysql
Master username: metabase
Master password: Metabot1
DB instance class: db.m6g.large (you need this because you need to enable performance insights)
Storage type: general purpose SSD, 100gb
VPC: choose the default
subnet group: choose the default
public access: yes
vpc security group: default
database authentication: password only
Additional options:
- initial database name: metabase
- disable automated backups
- disable encryption
- ENABLE performance insights
- disable enhanced monitoring
- disable auto minor version upgrade
- disable deletion protection
3) click on create database and wait for the DB to be created
4) Once the DB finishes creating, click on the DB identifier and get the endpoint (it will finish in ".us-east-1.rds.amazonaws.com")
5) modify the docker-compose.yml and replace the endpoint on the connection string on the section that says "your_MySQL_RDS_hostname"
6) run docker-compose up
7) connect with another client that you know that will connect with SSL (e.g. DBeaver) and run the following command to get the connections and ciphers:
```
SELECT sbt.variable_value AS tls_version,  t2.variable_value AS cipher,
         processlist_user AS user, processlist_host AS host
FROM performance_schema.status_by_thread  AS sbt
   JOIN performance_schema.threads AS t ON t.thread_id = sbt.thread_id
   JOIN performance_schema.status_by_thread AS t2 ON t2.thread_id = t.thread_id
WHERE sbt.variable_name = 'Ssl_version' AND t2.variable_name = 'Ssl_cipher'
ORDER BY tls_version;
```
You'll see a table like:
|tls_version|cipher|user|
|---|---|---|
|""|""|rdsadmin|
|""|""|rdsadmin|
|""|""|metabase|
|""|""|metabase|
|""|""|metabase|
|""|""|metabase|
|TLSv1.3|TLS_AES_256_GCM_SHA384|metabase|

last value should be you with the client, all others which are empty are Metabase app