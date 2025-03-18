# Nextcloud All-in-One Installationsskript

Ein vollautomatisches Installationsskript für Nextcloud auf Debian/Ubuntu-Systemen. Erstellt von Staubi.

![Nextcloud Logo](https://nextcloud.com/media/nextcloud-logo-white.svg)

## Funktionen

- ✅ Automatische Installation der neuesten Nextcloud-Version
- ✅ Vollständige Konfiguration von PHP mit optimalen Einstellungen
- ✅ MySQL-Datenbank-Setup mit zufälligem Passwort
- ✅ Nginx-Webserver-Konfiguration
- ✅ Deutsche Spracheinstellung
- ✅ Automatische Erkennung der Server-IP
- ✅ Farbige und unterhaltsame Ausgabe

## Voraussetzungen

- Debian oder Ubuntu Server
- Root-Zugriff
- Internetverbindung

## Installation

Du kannst das Skript direkt von GitHub herunterladen und ausführen:

```bash
wget -O nextcloud-install.sh https://raw.githubusercontent.com/Staubi82/NC-Install/main/nextcloud-install.sh
chmod +x nextcloud-install.sh
sudo ./nextcloud-install.sh
```

Oder mit curl:

```bash
curl -o nextcloud-install.sh https://raw.githubusercontent.com/Staubi82/NC-Install/main/nextcloud-install.sh
chmod +x nextcloud-install.sh
sudo ./nextcloud-install.sh
```

## Was macht das Skript?

1. Aktualisiert das System (apt update && upgrade)
2. Installiert alle benötigten Pakete (nginx, MySQL, PHP und Module)
3. Konfiguriert PHP für optimale Leistung
4. Richtet eine MySQL-Datenbank mit zufälligem Passwort ein
5. Konfiguriert Nginx als Webserver
6. Lädt die neueste Nextcloud-Version herunter und installiert sie
7. Setzt Deutsch als Standardsprache
8. Konfiguriert die Berechtigungen und Sicherheitseinstellungen
9. Zeigt am Ende alle wichtigen Zugangsdaten an

## Nach der Installation

Nach erfolgreicher Installation kannst du auf deine Nextcloud über die angezeigte IP-Adresse zugreifen:

```
http://DEINE-SERVER-IP/
```

**Wichtig:** Ändere das Admin-Passwort nach dem ersten Login!

Die Standard-Anmeldedaten sind:
- Benutzername: admin
- Passwort: admin

## Fehlerbehebung

Falls Probleme auftreten:

1. Stelle sicher, dass du das Skript mit Root-Rechten ausführst
2. Überprüfe, ob alle benötigten Ports (80, 443) verfügbar sind
3. Stelle sicher, dass dein Server über ausreichend Speicherplatz verfügt
4. Prüfe die Logs in `/var/log/nginx/` und `/var/log/mysql/`

## Lizenz

Dieses Skript ist unter der MIT-Lizenz veröffentlicht. Fühle dich frei, es zu verwenden, zu modifizieren und zu teilen!

---

Mit ♥ erstellt von Staubi - Möge deine Cloud niemals regnen!
