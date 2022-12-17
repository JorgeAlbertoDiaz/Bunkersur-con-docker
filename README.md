# Bunkersur Dockerizado

## Descripción general
El docker compose esta configurado para que se ejecute un servidor `apache2`, `php 5.5`,`phpmyadmin` y `mysql 5.5` logrando emular el entorno de pruebas de [BUNKERSUR](http://bunkersur.dyndns.biz).

## Introducción

## Prerequisitos
Necesitas tener instalada las siguientes dependencias:

- [Docker Engine](https://docs.docker.com/engine/install/): *El motor de Docker*.
- [Docker Compose](https://docs.docker.com/compose/install/): *Para definir y ejecutar aplicaciones Docker con multi-contenedores*.

<details>
<summary>Haz click para mostrar instrucciones de instalación</summary>

Para verificar si tienes instalado todo lo necesario puedes ejecutar los siguientes comandos y ver la salida.

```bash
# Verificar versión instalada de Docker
$ docker --version

# Verificar versión instalada de Docker-Compose
$ docker-compos-composee --version
```

Ignora los siguientes comandos si ya tienes instalado **Docker** y **Docker Compose**.

```bash
# Agregar repositorio de Docker
$ sudo mkdir -p /etc/apt/keyrings
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
$ echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$ sudo apt update

# instalación del Docker, Docker-Compose y sus dependencias
$ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose -y

# permite ejecutar comandos docker si el comando `sudo`
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
$ newgrp docker

# Probar funcionamiento
$ docker run hello-world
```

> Para un detalle más completo puedes ir al siguiente enlace de la [**guía oficial para instalar Docker**](https://docs.docker.com/engine/install/ubuntu/).

</details>

### Primera ejecución
La primera vez que ejecutas el proyecto debes:

1. Copiar el código fuente de tu aplicación en la carpeta `./public_html`.
2. (Opcional) Crear un archivo en la siguiente ruta `./docker/mysqldump/dump.sql` el cual levantará tu base de datos.
El archivo `dump.sql` debe tener las siguientes sentencias al comienzo:

```sql
-- Recuerda modificarlo y cambiar el DB_NAME por el nombre de la base de datos
DROP DATABASE IF EXISTS `DB_NAME`;
CREATE DATABASE IF NOT EXISTS `DB_NAME`;
USE `DB_NAME`;

```

 
3. Ejecutar el comando `docker-compose up --build`, este creará los contenedores iniciales y éstos a su vez ejecutarán su script inicial.
4. Correr el archivo `./allow_mysql_remote_connection.sh` el cual ejecutará las modificaciones al usuario mysql para que pueda autenticarse remotamente.

El scrip habilita al usuario mysql para autenticarse remotamente, la forma manual de hacer ello es la siguiente:

```bash
# Mientras el contenedor este corriendo
$ docker exec -it bunkersur_mysql /bin/bash

# Dentro del contenedor
mysql -u root -p
```
y una vez dentro de mysql ejecutar lo siguiente:

```sql
UPDATE mysql.user SET host='%' WHERE user='root';
FLUSH PRIVILEGES;
```

> Con este paso realizado podrás autenticarte con el contenedor mysql "remotamente" desde el **mysql-workbench**, **phpmyadmin** o tu **aplicación php**.


#### Posibles errores
Si el punto **2.** fallará podrás importar el archivo manualmente desde el mysql workbench o bien desde la terminal con el comando:
```bash
# Reemplaza DB_NAME por el nombre de la base de datos.
msyql -u user -p -h 127.0.0.1 -P 33991 DB_NAME < ./docker/mysqldump/dump.sql.
```

### Ejecución

Si ya configuraste y lograste correrlo por primera vez ahora solo debes ejecutar el siguiente comando para volver a levantar el entorno:

```bash
docker-compose up -d
```
