<h1 align="center">🗂 bkup.sh (KDE Config Backup Manager)</h1>
<p align="center">A simple Bash CLI tool to back up and restore your KDE Plasma configuration files</p>

---

## 📦 Features

- Backup user-level KDE configs (Plasma, fonts, icons, widgets, etc.)
- Backup essential system-level settings (like SDDM, global themes)
- Restore from `.tar.gz` archive
- Simple CLI with colorful output

---

## 🚀 Usage

**Download the [bkup.sh](https://github.com/ujaRHR/bkup.sh/releases/download/v1.0/bkup.sh) file or clone the repository:**
```
git clone https://github.com/ujaRHR/bkup.sh
cd bkup.sh
chmod +x bkup.sh
```

##### Backup KDE Settings

```./bkup.sh --backup /path/to/backup-folder```

##### Restore KDE Settings
```./bkup.sh --restore /path/to/kde-backup-yyyy-mm-dd-hhmm.tar.gz ```

#### Examples
```
./bkup.sh --backup ~/Backups
./bkup.sh --restore ~/Backups/kde-backup-2025-06-24-1201.tar.gz
```

## ⚙️ What Does It Back Up?

##### Home-Level KDE Configs ($HOME/)
```
.config/plasma-org.kde.plasma.desktop-appletsrc
.config/plasmarc
.config/kdeglobals
.config/kwinrc
.config/kwinrulesrc
.config/systemsettingsrc
.config/khotkeysrc
.config/kglobalshortcutsrc
.config/krunnerrc
.config/kscreenlockerrc
.config/gtk*
.local/share/plasma*
.local/share/plasmoids
.local/share/plasma_layouts
.local/share/icons
.local/share/themes
.local/share/fonts
.local/share/wallpapers
.fonts
.config/dolphinrc
.config/konsole
.config/yakuakerc
```

##### Root-Level System Configs
```
/etc/sddm.conf
/etc/sddm.conf.d
/etc/xdg/k*rc
/etc/xdg/kdeglobals
/usr/share/sddm/themes
/usr/share/themes
/usr/share/icons
/usr/share/wallpapers
/usr/share/plasma
/usr/share/plasma/plasmoids
```

> You can modify the directories as you want according to your distro...

------

⭐ Star the repo if you found it useful!

🛠️ **Created by [Reajul Hasan Raju](https://github.com/ujaRHR)**
