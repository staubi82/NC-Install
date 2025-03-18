#!/bin/bash
#
# ███╗   ██╗███████╗██╗  ██╗████████╗ ██████╗██╗      ██████╗ ██╗   ██╗██████╗ 
# ████╗  ██║██╔════╝╚██╗██╔╝╚══██╔══╝██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗
# ██╔██╗ ██║█████╗   ╚███╔╝    ██║   ██║     ██║     ██║   ██║██║   ██║██║  ██║
# ██║╚██╗██║██╔══╝   ██╔██╗    ██║   ██║     ██║     ██║   ██║██║   ██║██║  ██║
# ██║ ╚████║███████╗██╔╝ ██╗   ██║   ╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝
# ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝ 
#
# All-in-One Nextcloud Installationsskript für Debian/Ubuntu
# Erstellt von Staubi - Mit Liebe und einer Prise Wahnsinn
#
# Verwendung: bash nextcloud-install.sh
#

# Farben für hübsche Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Funktion für Fortschrittsanzeige
show_progress() {
    echo -e "${YELLOW}[FORTSCHRITT]${NC} $1"
}

# Funktion für Erfolgsmeldungen
show_success() {
    echo -e "${GREEN}[ERFOLG]${NC} $1"
}

# Funktion für Fehlermeldungen
show_error() {
    echo -e "${RED}[FEHLER]${NC} $1"
    exit 1
}

# Funktion für Infomeldungen
show_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Funktion für witzige Kommentare
show_joke() {
    echo -e "${MAGENTA}[STAUBI SAGT]${NC} $1"
}

# Root-Rechte prüfen
if [ "$(id -u)" -ne 0 ]; then
    show_error "Dieses Skript muss mit Root-Rechten ausgeführt werden. Versuch's mit 'sudo'!"
    exit 1
fi

# Banner anzeigen
echo -e "${CYAN}"
echo "╔═════════════════════════════════════════════════════════════════╗"
echo "║                                                                 ║"
echo "║   Nextcloud All-in-One Installationsskript                      ║"
echo "║   Erstellt von Staubi                                           ║"
echo "║                                                                 ║"
echo "╚═════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

show_joke "Willkommen zum Nextcloud-Installer! Schnall dich an, wir bauen dir eine Cloud, die so fluffig ist wie eine Schäfchenwolke!"

# Systemupdate
show_progress "Aktualisiere das System... (Keine Sorge, das Internet wird nicht explodieren)"
apt update && apt upgrade -y || show_error "Konnte das System nicht aktualisieren. Ist dein Internet eingeschlafen?"

show_joke "System aktualisiert! Dein Server fühlt sich jetzt wie nach einem Wellnesstag."

# Benötigte Pakete installieren
show_progress "Installiere benötigte Pakete... (Das ist wie Einkaufen, nur ohne den Einkaufswagen)"
apt install -y \
    nginx \
    mariadb-server \
    php-fpm \
    php-mysql \
    php-common \
    php-gd \
    php-json \
    php-curl \
    php-mbstring \
    php-intl \
    php-imagick \
    php-xml \
    php-zip \
    php-apcu \
    php-redis \
    php-ldap \
    php-bcmath \
    php-gmp \
    unzip \
    curl \
    wget \
    bzip2 \
    sudo \
    cron \
    software-properties-common \
    ssl-cert || show_error "Konnte die benötigten Pakete nicht installieren. Vielleicht ist der Paketmanager im Urlaub?"

show_joke "Pakete installiert! Dein Server ist jetzt besser ausgestattet als meine Küche."

# PHP-Version ermitteln
PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
show_info "PHP Version $PHP_VERSION erkannt"

# PHP konfigurieren
show_progress "Konfiguriere PHP für optimale Leistung... (Gib PHP einen Energydrink)"

# PHP-FPM Konfiguration anpassen
PHP_FPM_POOL_CONF="/etc/php/$PHP_VERSION/fpm/pool.d/www.conf"
PHP_FPM_CONF="/etc/php/$PHP_VERSION/fpm/php-fpm.conf"
PHP_INI_CONF="/etc/php/$PHP_VERSION/fpm/php.ini"

# PHP-FPM Pool Konfiguration
sed -i 's/^pm.max_children =.*/pm.max_children = 120/' $PHP_FPM_POOL_CONF
sed -i 's/^pm.start_servers =.*/pm.start_servers = 12/' $PHP_FPM_POOL_CONF
sed -i 's/^pm.min_spare_servers =.*/pm.min_spare_servers = 6/' $PHP_FPM_POOL_CONF
sed -i 's/^pm.max_spare_servers =.*/pm.max_spare_servers = 18/' $PHP_FPM_POOL_CONF

# PHP.ini Konfiguration
sed -i 's/^memory_limit =.*/memory_limit = 512M/' $PHP_INI_CONF
sed -i 's/^upload_max_filesize =.*/upload_max_filesize = 10G/' $PHP_INI_CONF
sed -i 's/^post_max_size =.*/post_max_size = 10G/' $PHP_INI_CONF
sed -i 's/^max_execution_time =.*/max_execution_time = 300/' $PHP_INI_CONF
sed -i 's/^max_input_time =.*/max_input_time = 300/' $PHP_INI_CONF
sed -i 's/^opcache.enable=.*/opcache.enable=1/' $PHP_INI_CONF
sed -i 's/^opcache.memory_consumption=.*/opcache.memory_consumption=128/' $PHP_INI_CONF
sed -i 's/^opcache.interned_strings_buffer=.*/opcache.interned_strings_buffer=8/' $PHP_INI_CONF
sed -i 's/^opcache.max_accelerated_files=.*/opcache.max_accelerated_files=10000/' $PHP_INI_CONF
sed -i 's/^opcache.revalidate_freq=.*/opcache.revalidate_freq=1/' $PHP_INI_CONF
sed -i 's/^opcache.save_comments=.*/opcache.save_comments=1/' $PHP_INI_CONF

show_success "PHP wurde konfiguriert und ist jetzt schneller als ein Gepard mit Raketenantrieb!"

# MariaDB konfigurieren
show_progress "Konfiguriere MariaDB... (Datenbanken sind wie Bibliotheken, nur ohne die Stille)"

# Zufälliges Passwort generieren
DB_PASS=$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9')
DB_USER="nextcloud"
DB_NAME="nextcloud"

# MySQL sichern und Datenbank erstellen
mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

show_success "MariaDB konfiguriert! Deine Datenbank ist jetzt so sicher wie ein Tresor... naja, fast."

# Nginx konfigurieren
show_progress "Konfiguriere Nginx... (Webserver sind wie Türsteher, nur höflicher)"

# Server-IP ermitteln
SERVER_IP=$(hostname -I | awk '{print $1}')

# Nginx Konfiguration erstellen
cat > /etc/nginx/sites-available/nextcloud << 'EOF'
server {
    listen 80;
    listen [::]:80;
    
    # Setze den Server-Namen auf die IP-Adresse oder Domain
    server_name _;
    
    # Setze den Root-Pfad auf das Nextcloud-Verzeichnis
    root /var/www/nextcloud;
    
    # Füge index.php zu den Index-Dateien hinzu
    index index.php index.html index.htm;
    
    # Setze den Zeichensatz
    charset utf-8;
    
    # Optimiere die Übertragung von statischen Dateien
    location ~ \.(?:css|js|mjs|svg|gif|png|jpg|ico|wasm|tflite|map|ogg|mp4|webm|avif|woff2?|eot|ttf|otf)$ {
        try_files $uri /index.php$request_uri;
        expires 6M;
        access_log off;
        add_header Cache-Control "public, immutable";
    }
    
    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }
    
    # Verweigere den Zugriff auf versteckte Dateien
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
    
    # Nextcloud .well-known URL-Umschreibungen
    location = /.well-known/carddav {
        return 301 $scheme://$host/remote.php/dav;
    }
    
    location = /.well-known/caldav {
        return 301 $scheme://$host/remote.php/dav;
    }
    
    location = /.well-known/webfinger {
        return 301 $scheme://$host/index.php/.well-known/webfinger;
    }
    
    location = /.well-known/nodeinfo {
        return 301 $scheme://$host/index.php/.well-known/nodeinfo;
    }
    
    # Setze maximale Upload-Größe
    client_max_body_size 10G;
    fastcgi_buffers 64 4K;
    
    # Aktiviere gzip, aber nicht für IE6
    gzip on;
    gzip_vary on;
    gzip_comp_level 4;
    gzip_min_length 256;
    gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
    gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
    
    # Nextcloud-Regeln
    location / {
        rewrite ^ /index.php;
    }
    
    location ~ ^\/(?:build|tests|config|lib|3rdparty|templates|data)\/ {
        deny all;
    }
    
    location ~ ^\/(?:\.|autotest|occ|issue|indie|db_|console) {
        deny all;
    }
    
    # PHP-Verarbeitung für Nextcloud
    location ~ ^\/(?:index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[ms]-provider\/.+)\.php(?:$|\/) {
        fastcgi_split_path_info ^(.+?\.php)(\/.*|)$;
        set $path_info $fastcgi_path_info;
        try_files $fastcgi_script_name =404;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $path_info;
        fastcgi_param HTTPS off;
        fastcgi_param modHeadersAvailable true;
        fastcgi_param front_controller_active true;
        fastcgi_pass unix:/run/php/php-fpm.sock;
        fastcgi_intercept_errors on;
        fastcgi_request_buffering off;
        fastcgi_read_timeout 300;
    }
    
    location ~ ^\/(?:updater|oc[ms]-provider)(?:$|\/) {
        try_files $uri/ =404;
        index index.php;
    }
    
    # Füge Trailing Slashes zu Verzeichnissen hinzu
    location ~ ^\/(?:core\/vendor|build|plugins|lib|3rdparty)\/.*\.(?:css|js)$ {
        try_files $uri /index.php$request_uri;
    }
    
    # .htaccess und .htpasswd verbieten
    location ~ /\.ht {
        deny all;
    }
}
EOF

# Ersetze den Socket-Pfad mit der richtigen PHP-Version
sed -i "s|fastcgi_pass unix:/run/php/php-fpm.sock;|fastcgi_pass unix:/run/php/php$PHP_VERSION-fpm.sock;|" /etc/nginx/sites-available/nextcloud

# Aktiviere die Nextcloud-Site
ln -sf /etc/nginx/sites-available/nextcloud /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Nginx-Konfiguration testen
nginx -t || show_error "Nginx-Konfiguration ist fehlerhaft. Das ist peinlicher als ein Hosenanziehen mit den Beinen in den Ärmeln."

show_success "Nginx konfiguriert! Dein Webserver ist jetzt bereit, die Welt zu erobern... oder zumindest deine Nextcloud zu hosten."

# Nextcloud herunterladen und installieren
show_progress "Lade Nextcloud herunter... (Bitte warten, das Internet ist manchmal wie eine Schnecke mit Jetlag)"

# Nextcloud-Verzeichnis erstellen
mkdir -p /var/www

# Neueste Version herunterladen
cd /tmp
wget https://download.nextcloud.com/server/releases/latest.zip || show_error "Konnte Nextcloud nicht herunterladen. Ist das Internet im Urlaub?"

show_joke "Download abgeschlossen! Das ging schneller als erwartet. Das Internet hatte wohl einen guten Tag."

# Nextcloud entpacken
show_progress "Entpacke Nextcloud... (Wie ein Geschenk auspacken, nur ohne das Papier)"
unzip -q latest.zip -d /var/www/ || show_error "Konnte Nextcloud nicht entpacken. Vielleicht ist die Datei schüchtern?"
rm latest.zip

# Berechtigungen setzen
show_progress "Setze Berechtigungen... (Damit alles schön ordentlich ist)"
chown -R www-data:www-data /var/www/nextcloud/
find /var/www/nextcloud/ -type d -exec chmod 750 {} \;
find /var/www/nextcloud/ -type f -exec chmod 640 {} \;

show_success "Nextcloud wurde entpackt und die Berechtigungen wurden gesetzt!"

# Nextcloud installieren
show_progress "Installiere Nextcloud... (Der spannendste Teil, wie der Höhepunkt eines Films)"

# Installationskommando ausführen
cd /var/www/nextcloud
sudo -u www-data php occ maintenance:install \
    --database "mysql" \
    --database-name "$DB_NAME" \
    --database-user "$DB_USER" \
    --database-pass "$DB_PASS" \
    --admin-user "admin" \
    --admin-pass "admin" \
    --data-dir "/var/www/nextcloud/data" || show_error "Konnte Nextcloud nicht installieren. Das ist so enttäuschend wie eine leere Chipstüte."

# Sprache auf Deutsch setzen
sudo -u www-data php occ config:system:set default_language --value="de"
sudo -u www-data php occ config:system:set default_locale --value="de_DE"

# Trusted Domains konfigurieren
sudo -u www-data php occ config:system:set trusted_domains 1 --value="$SERVER_IP"

# HTTP-Protokoll erzwingen (verhindert Weiterleitungsprobleme)
sudo -u www-data php occ config:system:set overwriteprotocol --value="http"

# Dienste neustarten
show_progress "Starte Dienste neu... (Wie ein kleiner Powernap für deinen Server)"
systemctl restart php$PHP_VERSION-fpm
systemctl restart nginx
systemctl restart mariadb

show_joke "Alles neu gestartet! Dein Server fühlt sich jetzt erfrischt wie nach einer kalten Dusche."

# Abschluss
show_success "Nextcloud wurde erfolgreich installiert! Juhuuuu! 🎉"

echo -e "${CYAN}"
echo "╔═════════════════════════════════════════════════════════════════╗"
echo "║                                                                 ║"
echo "║   Nextcloud Installation abgeschlossen!                         ║"
echo "║                                                                 ║"
echo "║   Zugriff auf deine Nextcloud:                                  ║"
echo "║   http://$SERVER_IP/                                          ║"
echo "║                                                                 ║"
echo "║   Admin-Benutzer: admin                                         ║"
echo "║   Admin-Passwort: admin                                         ║"
echo "║                                                                 ║"
echo "║   Datenbank-Benutzer: $DB_USER                                  ║"
echo "║   Datenbank-Passwort: $DB_PASS                                  ║"
echo "║                                                                 ║"
echo "║   WICHTIG: Ändere das Admin-Passwort nach dem ersten Login!     ║"
echo "║                                                                 ║"
echo "╚═════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

show_joke "Deine Cloud ist jetzt einsatzbereit! Zeit für einen Kaffee und ein High-Five! ☕👋"
show_joke "Vergiss nicht, mir auf GitHub zu folgen, wenn dir das Skript gefallen hat!"
show_joke "Mit ♥ erstellt von Staubi - Möge deine Cloud niemals regnen!"

exit 0
