#!/bin/bash

# Mensaje de bienvenida
echo "Buenas, gracias por confiar en MonitorIT"

# Pregunta al usuario si desea ejecutar el script
read -p "¿Estás seguro de que quieres ejecutar este programa? (S/N): " response

# Verifica la respuesta del usuario
if [ "$response" != "S" ] && [ "$response" != "s" ]; then
    echo "Operación cancelada."
    exit 0
fi

# Variables
LOGSTASH_IP="192.168.200.101"
LOGSTASH_PORT="5044"
ELK_VERSION="7.17.21"
HOSTNAME=$(hostname)

# Función para verificar el estado de la última operación y salir si falla
check_last_command() {
    if [ $? -ne 0 ]; then
        echo "Error en el paso: $1"
        exit 1
    else
        echo "Paso completado: $1"
    fi
}

echo "Iniciando configuración de Filebeat..."

# Agregar el repositorio de Elastic
echo "Agregando el repositorio de Elastic..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
check_last_command "Agregar el repositorio de Elastic"

echo "Añadiendo lista de fuentes de Elastic a sources.list.d..."
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
check_last_command "Añadir lista de fuentes de Elastic a sources.list.d"

# Actualizar la lista de paquetes
echo "Actualizando la lista de paquetes..."
sudo apt update
check_last_command "Actualizar la lista de paquetes"

# Verificar si Filebeat ya está instalado
if dpkg-query -W filebeat; then
    echo "Filebeat ya está instalado."
else
    # Instalar Filebeat
    echo "Instalando Filebeat..."
    sudo apt install -y filebeat=$ELK_VERSION
    check_last_command "Instalar Filebeat"
fi

# Configurar Filebeat para enviar logs a Logstash
echo "Configurando Filebeat para enviar logs a Logstash y Elasticsearch..."
sudo tee /etc/filebeat/filebeat.yml > /dev/null <<EOF
filebeat.inputs:
  - type: filestream
    id: my-filestream-id
    enabled: false
    paths:
      - /var/log/*.log
      - /var/log/syslog
      - /var/log/messages

filebeat.config.modules:
  path: \${path.config}/modules.d/*.yml
  reload.enabled: false

setup.template.settings:
  index.number_of_shards: 1

setup.kibana:

output.logstash:
  hosts: ["${LOGSTASH_IP}:${LOGSTASH_PORT}"]

processors:
  - add_host_metadata:
      when.not.contains.tags: forwarded
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~

path.data: /var/lib/filebeat/data-custom

setup.ilm.enabled: auto
setup.ilm.check_exists: false
setup.ilm.overwrite: true
setup.ilm.policy_name: "filebeat-policy"
setup.ilm.pattern: "{now/d}-000001"

EOF
check_last_command "Configurar Filebeat para enviar logs a Logstash y Elasticsearch"

# Habilitar los módulos de Logstash y system
echo "Habilitando el módulo de Logstash..."
sudo filebeat modules enable logstash
check_last_command "Habilitar el módulo de Logstash"

echo "Habilitando el módulo system..."
sudo filebeat modules enable system
check_last_command "Habilitar el módulo system"

# Configurar el manejo de índices en Elasticsearch
echo "Configurando el manejo de índices en Elasticsearch..."
sudo filebeat setup --index-management -E output.logstash.enabled=false -E "output.elasticsearch.hosts=[\"http://${LOGSTASH_IP}:9200\"]" -E "output.elasticsearch.username=elastic" -E "output.elasticsearch.password=elasticadmin11!"
check_last_command "Configurar el manejo de índices en Elasticsearch"

# Cargar el pipeline de ingestión de Filebeat para los módulos habilitados
echo "Cargando el pipeline de ingestión de Filebeat para los módulos habilitados..."
sudo filebeat setup --pipelines --modules logstash,system
check_last_command "Cargar el pipeline de ingestión de Filebeat"

# Iniciar y habilitar Filebeat
echo "Iniciando Filebeat..."
sudo systemctl start filebeat
check_last_command "Iniciar Filebeat"

echo "Habilitando Filebeat para que se inicie al arrancar el sistema..."
sudo systemctl enable filebeat
check_last_command "Habilitar Filebeat"

echo "Configuración de Filebeat completada exitosamente."
