#!/bin/bash

# Variables
ZABBIX_VERSION="6.4"
ZABBIX_SERVER_IP="192.168.200.105"
ZABBIX_CONF_FILE="/etc/zabbix/zabbix_agentd.conf"

# Mensaje de bienvenida
echo "Muchas gracias por confiar en MonitorIT"
read -p "¿Seguro que quieres ejecutar este programa? (s/n): " confirm

if [[ "$confirm" != [sS] ]]; then
    echo "Operación cancelada."
    exit 1
fi

# Función para instalar Zabbix Agent en distribuciones basadas en Debian
install_zabbix_debian() {
    wget https://repo.zabbix.com/zabbix/$ZABBIX_VERSION/debian/pool/main/z/zabbix-release/zabbix-release_${ZABBIX_VERSION}-1%2Bdebian${VERSION}_all.deb
    dpkg -i zabbix-release_${ZABBIX_VERSION}-1+debian${VERSION}_all.deb
    apt update
    apt install -y zabbix-agent
}

# Función para instalar Zabbix Agent en distribuciones basadas en RHEL/CentOS
install_zabbix_rhel() {
    rpm -Uvh https://repo.zabbix.com/zabbix/$ZABBIX_VERSION/rhel/$VERSION/x86_64/zabbix-release-$ZABBIX_VERSION-1.el$VERSION.noarch.rpm
    yum clean all
    yum install -y zabbix-agent
}

# Función para configurar zabbix_agentd.conf
configure_zabbix_agent() {
    # Crear una copia de respaldo del archivo de configuración original
    cp $ZABBIX_CONF_FILE ${ZABBIX_CONF_FILE}.bak

    # Modificar las líneas de Server y ServerActive
    sudo tee $ZABBIX_CONF_FILE > /dev/null << EOL
$(awk -v server_ip="$ZABBIX_SERVER_IP" '
BEGIN {FS=OFS="="}
/^Server=/ { $2 = server_ip }
/^ServerActive=/ { $2 = server_ip }
{ print }
' ${ZABBIX_CONF_FILE}.bak)
EOL

    systemctl enable zabbix-agent
    systemctl restart zabbix-agent
}

# Función para verificar la instalación de Zabbix Agent
verify_installation() {
    if systemctl status zabbix-agent | grep -q "active (running)"; then
        echo "Zabbix Agent está instalado y ejecutándose correctamente."
    else
        echo "Error: Zabbix Agent no se está ejecutando. Verifica los registros para más detalles."
        exit 1
    fi

    if grep -q "^Server=$ZABBIX_SERVER_IP" $ZABBIX_CONF_FILE && grep -q "^ServerActive=$ZABBIX_SERVER_IP" $ZABBIX_CONF_FILE; then
        echo "El archivo de configuración $ZABBIX_CONF_FILE ha sido actualizado correctamente."
    else
        echo "Error: El archivo de configuración $ZABBIX_CONF_FILE no se ha actualizado correctamente."
        exit 1
    fi
}

# Verificar que se está ejecutando como root
if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ser ejecutado como root" 
   exit 1
fi

# Detectar la distribución y versión del sistema operativo
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
else
    echo "No se puede detectar el sistema operativo. Abortando."
    exit 1
fi

# Instalar Zabbix Agent según la distribución detectada
case "$OS" in
    debian|ubuntu)
        install_zabbix_debian
        ;;
    rhel|centos|fedora|rocky|alma)
        install_zabbix_rhel
        ;;
    *)
        echo "Distribución no soportada: $OS"
        exit 1
        ;;
esac

# Configurar Zabbix Agent
configure_zabbix_agent

# Verificar la instalación y configuración de Zabbix Agent
verify_installation

echo "Instalación y configuración de Zabbix Agent completada."
