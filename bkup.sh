#!/bin/bash
set -e

green="\e[32m"
yellow="\e[33m"
red="\e[31m"
blue="\e[34m"
cyan="\e[36m"
reset="\e[0m"

# KDE Config Paths
# The list is more than enough for a KDE Plasma Desktop
# Don't add full path like /home/username/paths...
# Only add relative paths just like .config/your_folder
home_items=(
  ".config/plasma-org.kde.plasma.desktop-appletsrc"
  ".config/plasmarc"
  ".config/kdeglobals"
  ".config/kwinrc"
  ".config/kwinrulesrc"
  ".config/systemsettingsrc"
  ".config/khotkeysrc"
  ".config/kglobalshortcutsrc"
  ".config/krunnerrc"
  ".config/kscreenlockerrc"
  ".config/gtk*"
  ".local/share/plasma*"
  ".local/share/plasmoids"
  ".local/share/plasma_layouts"
  ".local/share/icons"
  ".local/share/themes"
  ".local/share/fonts"
  ".local/share/wallpapers"
  ".fonts"
  ".config/dolphinrc"
  ".config/konsole"
  ".config/yakuakerc"
)

# The list is more than enough for a KDE Plasma Desktop
# If you modify make sure to add the full root path starting with a '/'
root_items=(
  "/etc/sddm.conf"
  "/etc/sddm.conf.d"
  "/etc/xdg/k*rc"
  "/etc/xdg/kdeglobals"
  "/usr/share/sddm/themes"
  "/usr/share/themes"
  "/usr/share/icons"
  "/usr/share/wallpapers"
  "/usr/share/plasma"
  "/usr/share/plasma/plasmoids"
)


# Status Indicator
print_status() {
  echo -e "${blue}==>${reset} $1"
}

print_ok() {
  echo -e "${green}[✓]${reset} $1"
}

print_error() {
  echo -e "${red}[✗]${reset} $1"
}

show_loader() {
  local pid=$1
  local msg=$2
  echo -ne "${blue}==> $msg${reset}"
  while kill -0 "$pid" 2>/dev/null; do
    echo -ne "."
    sleep 0.5
  done
  echo -e " ${green}done!${reset}"
}

do_backup() {
  dest="$1"
  dest="${dest%/}"
  timestamp=$(date +%F-%H%M)
  backup_name="kde-backup-$timestamp.tar.gz"
  dest_path="$dest/$backup_name"
  
  tmp_dir=$(mktemp -d)

  print_status "Creating backup at: $dest_path"

  mkdir -p "$tmp_dir/home" "$tmp_dir/root"

  for item in "${home_items[@]}"; do
    [[ -e "$HOME/$item" ]] && cp -r --parents "$HOME/$item" "$tmp_dir/home"
  done

  for item in "${root_items[@]}"; do
    [[ -e "$item" ]] && sudo cp -r --parents "$item" "$tmp_dir/root"
  done

  (tar -czf "$dest_path" -C "$tmp_dir" .) &
  show_loader $! "Creating backup"


  sudo rm -rf "$tmp_dir"
  print_ok "Backup created: $dest_path"
}

do_restore() {
  file="$1"
  file="${file%/}"
  tmp_dir=$(mktemp -d)
  print_status "Restoring from: $file"

  (tar -xzf "$file" -C "$tmp_dir") &  
  show_loader $! "Extracting backup"

  if [[ -d "$tmp_dir/home" ]]; then
    (cp -rT "$tmp_dir/home/$HOME" "$HOME") &
    show_loader $! "Restoring user config"
    
    print_ok "User config restored."
  fi

  if [[ -d "$tmp_dir/root" ]]; then
    (sudo cp -rT "$tmp_dir/root" /) &
    show_loader $! "Restoring system config"

    print_ok "System config restored."
  fi

  sudo rm -rf "$tmp_dir"
  print_ok "Restore complete."
}

# Help Menu
show_help() {
  echo -e " ${yellow}\n 💾 Config Backup Manager v1.0${reset}"
  echo -e " A simple CLI tool to back up and restore KDE/Plasma config files."
  echo
  echo -e " ${red}Usage:${reset}"
  echo -e "  bkup.sh --backup  <destination_dir>   ${cyan}# Create a backup${reset}"
  echo -e "  bkup.sh --restore <backup_file>       ${cyan}# Restore from a backup${reset}"
  echo
  echo -e " ${red}Examples:${reset}"
  echo -e "  ./bkup.sh --backup ~/Backups"
  echo -e "  ./bkup.sh --restore ~/Backups/kde-backup-yyyy-mm-dd-hhmm.tar.gz"
  echo
  echo
  echo -e " ${green}Author:${reset}  Reajul Hasan Raju"
  echo -e " ${green}GitHub:${reset}  https://github.com/ujaRHR/bkup.sh"
  echo
  echo -e " ⭐ Star the repo if you find it useful!"
  exit 1
}


# Main Commands
if [[ "$1" == "--backup" && -n "$2" ]]; then
  if [[ ! -d "$2" ]]; then
    print_error "Destination folder does not exist: $2"
    exit 1
  fi
  do_backup "$2"
elif [[ "$1" == "--restore" && -n "$2" ]]; then
  if [[ ! -f "$1" ]]; then
    print_error "Backup file not found!"
    exit 1
  fi
  do_restore "$2"
else
  show_help
fi
