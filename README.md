# Bunkersur

Este proyecto es para dockerizar el entorno de pruebas de [bunkersur](http://bunkersur.dyndns.biz).


## Requerimientos

- Docker
- Docker-Compose

## Instalación del entorno

Para verificar si tienes instalado todo lo necesario puedes ejecutar los siguientes comando y ver la salida.

```bash
# Verificar versión instalada de Docker
$ docker --version

# Verificar versión instalada de Docker-Compose
$ docker-compos-composee --version
```

**Ignora los siguientes comandos si ya tienes instalado docker y docker-compose**.

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

> Para un detalle más completo puedes ir al siguiente [enlace de la guía oficial para instalar Docker](https://docs.docker.com/engine/install/ubuntu/).

## Ejecución

Para ejecutar el proyecto debes poner el código php dentro de la carpeta `./public` y ejecutar el comando `docker-compose up -d` desde la carpeta raíz.

La primera vez que ejecutes el comando es necesario habilitar al usuario mysql la opción de autenticarse remotamente.

Para ello debes entrar al contenedor de mysql, autenticarte e ingresar la siguiente línea de código:

```sql
UPDATE mysql.user SET host='%' WHERE user='root';
FLUSH PRIVILEGES;
```

> Con el paso anterior realizado ahora podrás autenticarte con el contenedor mysql "remotamente" desde el **mysql-workbench**, **phpmyadmin** o tu **aplicación php**.
