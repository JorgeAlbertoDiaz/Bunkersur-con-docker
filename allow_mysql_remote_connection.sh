#!/bin/bash
docker exec bunkersur_mysql mysql -uroot -pmandraque9191 -e 'UPDATE mysql.user SET host="%" WHERE user="root"; FLUSH PRIVILEGES;'
