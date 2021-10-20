#!/bin/bash

cd /opt

mkdir backups

cd backups

pw=root

mysqldump -u root -p$pw wordpress > wordpress_$(date +%F).sql.gz