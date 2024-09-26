#!/bin/bash
compras=$1
servidor_ssh=$2

# Codificar el archivo en Base64
echo "$(date) Codificando en Base64 el archivo $compras..."
base64 $compras > archivo_codificado.txt
echo "$(date) Codificación completada: archivo_codificado.txt"

# Cifrar el archivo usando AES-256 con pbkdf2
Password="Password123."
echo "$(date) Cifrando el archivo con AES-256..."
openssl aes-256-cbc -pbkdf2 -e -in archivo_codificado.txt -out archivoCifradoantespassword.txt.aes -k "$Password"
echo "$(date) Archivo cifrado: archivoCifradoantespassword.txt.aes"

# Calcular el hash SHA-256
echo "$(date) Calculando el hash SHA-256..."
sha256sum archivoCifradoantespassword.txt.aes | awk '{print $1}' > hash_sha256.txt
echo "$(date) Hash SHA-256: $(cat hash_sha256.txt)"

# Crear archivo ZIP con el archivo cifrado y el hash
echo "$(date) Creando archivo ZIP..."
zip resultado_comprimido.zip archivoCifradoantespassword.txt.aes hash_sha256.txt
echo "$(date) Archivo comprimido: resultado_comprimido.zip"

# Enviar el archivo al servidor SSH
echo "$(date) Enviando archivo a $servidor_ssh..."
sshpass -p 'centos' scp -o StrictHostKeyChecking=no resultado_comprimido.zip cloud-user@$servidor_ssh:/home/cloud-user/ejercicio

if [ $? -ne 0 ]; then
  echo "$(date) Error al enviar el archivo a $servidor_ssh"
else
  echo "$(date) Archivo enviado exitosamente a $servidor_ssh"
fi
