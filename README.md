# Explicación de cada objetivo en el Makefile

1. **`build`**: Este objetivo construye las imágenes de Docker para ambos contenedores (envío y recepción) utilizando el `docker-compose.yml`. Ejecuta:
    
    `make build`

   Nota: en caso de no levantar los contenedores, ejecutar el siguiente comando para recrear toda la configuración.
   `docker-compose up --build --force-recreate`
    
3. **`run`**: Ejecuta los contenedores de envío y recepción en segundo plano. Usa `docker-compose up -d` para iniciarlos. Ejecuta:
    
    `make run`
    
4. **`stop`**: Detiene y elimina los contenedores en ejecución. Esto cierra ambos contenedores y la red de Docker. Ejecuta:
    
    `make stop`
    
5. **`verify`**: Verifica si el archivo ha sido transferido correctamente al contenedor de recepción (`servidor_ssh`). Usa `docker exec` para listar los archivos en el directorio de recepción. Ejecuta:
    
    `make verify`
    
6. **`shell-ssh`**: Ingresa al contenedor de recepción (`servidor_ssh`) para verificar manualmente los archivos o realizar otras acciones. Ejecuta:

    `make shell-ssh`
    
7. **`clean`**: Elimina todos los contenedores, imágenes, volúmenes y redes asociadas con los servicios definidos en `docker-compose.yml`. Ejecuta:
    
    `make clean`
    
8. **`logs-envio`**: Muestra los logs del contenedor de envío (`contenedor_envio`) para verificar la ejecución del script y cualquier problema durante el proceso de envío. Ejecuta:

    `make logs-envio`
    
9. **`logs-ssh`**: Muestra los logs del contenedor de recepción (`servidor_ssh`) para ver las conexiones SSH y la transferencia de archivos. Ejecuta:
    
    `make logs-ssh`
    
## Uso del Makefile:

1. **Construcción**: Para construir las imágenes de Docker:

    `make build`
    
2. **Ejecución**: Para iniciar los contenedores:
    
    `make run`
    
3. **Verificación**: Para verificar que el archivo fue recibido correctamente:
    
    `make verify`
    
4. **Detener contenedores**: Para detener y eliminar los contenedores:

    `make stop`
    
5. **Limpiar todo**: Para eliminar contenedores, imágenes, volúmenes, etc., y dejar limpio el entorno:
    
    `make clean`


### Verificar la integridad del archivo cifrado con el hash SHA-256

- Accede al contenedor del servidor SSH:
  
    `docker exec -it servidor_ssh bash`

- Dentro del contenedor_ssh, navegar hacia directorio donde se guardó el archivo recibido
  
    `cd home/cloud-user/ejercicio/`

- Descomprimir el archivo .zip recibido
  
    `unzip resultado_comprimido.zip`

- Verifica que el servidor SSH esté corriendo
  
    `ps aux | grep sshd`

Calcular el hash del archivo cifrado en el servidor de recepción y compararlo con el hash almacenado en **hash_sha256.txt** para verificar que el archivo no fue alterado durante la transferencia.

1. Calcular el hash del archivo cifrado: Ejecuta el siguiente comando en el servidor de recepción para calcular el hash del archivo **archivoCifradoantespassword.txt.aes**:
    
    `sha256sum archivoCifradoantespassword.txt.aes`
    
2. Comparar el hash calculado con el contenido de **hash_sha256.txt**: Si ambos hashes coinciden, significa que el archivo no fue alterado durante la transferencia. Puedes comparar visualmente el hash calculado con el que está en **hash_sha256.txt** o usar un comando como **diff**:
    
    `diff <(sha256sum archivoCifradoantespassword.txt.aes | awk '{print $1}') hash_sha256.txt`
    
    **Si el comando no muestra salida, significa que ambos hashes coinciden!**
    

### Descifrar el archivo

Una vez que hayas verificado la integridad del archivo, puedes proceder a descifrar el archivo con la contraseña que se usó para cifrarlo (en este caso, `Passworod123.`).

1. **Descifrar el archivo**:
    Ejecuta el siguiente comando en el servidor de recepción para descifrar el archivo
    `openssl aes-256-cbc -pbkdf2 -d -in archivoCifradoantespassword.txt.aes -out archivo_descifrado.txt -k "Password123."`
    
`-d`: Indica que estamos descifrando. `-pbkdf2`: Utiliza la derivación de clave segura. `-in`: Especifica el archivo cifrado de entrada. `-out`: Especifica el archivo de salida descifrado. `-k`: Especifica la contraseña utilizada para el cifrado.
    
2. **Verificar el contenido del archivo descifrado**: Una vez que hayas descifrado el archivo, puedes verificar el contenido del archivo archivo_descifrado.txt:
    
    `cat archivo_descifrado.txt`

	Ejemplo de respuesta recibida:
	
		RXN0byBlcyB1bmEgcHJ1ZWJhIHBhcmEgbGEgZmFzZSAyIGRlbCBjdXJzbyBkZSBjcmlwdG9ncmFm
		w61hLCBlc3BlY2lhbGl6YWNpw7NuIGVuIHNlZ3VyaWRhZCBpbmZvcm3DoXRpY2EgVU5BRA==

3. **Descodificar**, se puede decodificar de Base64 para obtener el mensaje en texto legible.

        echo "RXN0byBlcyB1bmEgcHJ1ZWJhIHBhcmEgbGEgZmFzZSAyIGRlbCBjdXJzbyBkZSBjcmlwdG9ncmFm w61hLCBlc3BlY2lhbGl6YWNpw7NuIGVuIHNlZ3VyaWRhZCBpbmZvcm3DoXRpY2EgVU5BRA==" | base64 -d

Esto completa el flujo de trabajo de codificación, cifrado, transferencia, verificación y descifrado del archivo.

## Comandos Docker

- Asegurar que todo el entorno sea recreado desde cero con la configuración más reciente

    `docker-compose up --build --force-recreate`
    
- Detener y eliminar los contenedores junto con la red y las imágenes.
  
    `docker-compose down --rmi all --volumes --remove-orphans`


