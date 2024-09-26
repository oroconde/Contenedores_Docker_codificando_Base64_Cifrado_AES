# Nombre del contenedor de envío y recepción
CONTAINER_ENVIO=contenedor_envio
CONTAINER_SSH=servidor_ssh

# Nombre de la red
NETWORK=red-archivos

# Nombre del archivo comprimido que se va a transferir
ARCHIVO=resultado_comprimido.zip

# Ruta donde se almacenarán los archivos en el contenedor de recepción
DIRECTORIO=/home/cloud-user/ejercicio

# Puerto SSH expuesto en el host
SSH_PORT=2222

# Construir las imágenes de Docker
build:
	docker-compose build
# docker-compose build --force-recreate

# Ejecutar los contenedores de envío y recepción en segundo plano
run:
	docker-compose up -d

# Detener los contenedores
stop:
	docker-compose down

# Verificar que el archivo ha sido transferido correctamente al contenedor de recepción
verify:
	docker exec -it $(CONTAINER_SSH) ls $(DIRECTORIO)

# Ingresar al contenedor de recepción para verificar el contenido manualmente
zsh-ssh:
	docker exec -it $(CONTAINER_SSH) bash

# Limpiar los contenedores y las redes
clean:
	docker-compose down --rmi all --volumes --remove-orphans

# Logs del contenedor de envío
logs-envio:
	docker logs $(CONTAINER_ENVIO)

# Logs del contenedor de recepción
logs-ssh:
	docker logs $(CONTAINER_SSH)
