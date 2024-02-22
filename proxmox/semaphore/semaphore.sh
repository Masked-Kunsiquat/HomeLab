# semaphore.sh

#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    ___       __                           __
   /   | ____/ /___ ___  ______ __________/ /
  / /| |/ __  / __  / / / / __  / ___/ __  / 
 / ___ / /_/ / /_/ / /_/ / /_/ / /  / /_/ /  
/_/  |_\__,_/\__, /\__,_/\__,_/_/   \__,_/   
            /____/                           
 
EOF
}
header_info
echo -e "Loading..."
APP="Ansible Semaphore"
var_disk="2"
var_cpu="1"
var_ram="512"
var_os="ubuntu"
var_version="22.04"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /opt/Semaphore ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
if (( $(df /boot | awk 'NR==2{gsub("%","",$5); print $5}') > 80 )); then
  read -r -p "Warning: Storage is dangerously low, continue anyway? <y/N> " prompt
  [[ ${prompt,,} =~ ^(y|yes)$ ]] || exit
fi

SEM_VER="2.9.45"    # Update to latest version
wget "https://github.com/ansible-semaphore/semaphore/releases/download/v${SEM_VER}/semaphore_${SEM_VER}_linux_amd64.tar.gz"

msg_info "Stopping Semaphore"
systemctl stop semaphore
msg_ok "Stopped Semaphore"

msg_info "Updating Semaphore"
tar -xvf semaphore_${SEM_VER}_linux_amd64.tar.gz &>/dev/null
mkdir -p semaphore-backup
cp -r /opt/Semaphore/Semaphore.yaml /opt/Semaphore/data semaphore-backup/
cp Semaphore/Semaphore /opt/Semaphore/Semaphore
cp -r semaphore-backup/* /opt/Semaphore/
msg_ok "Updated Semaphore"

msg_info "Starting Semaphore"
systemctl start semaphore
msg_ok "Started Semaphore"

msg_info "Cleaning Up"
rm -rf semaphore_${SEM_VER}_linux_amd64.tar.gz Semaphore semaphore-backup
msg_ok "Cleaned"
msg_ok "Updated Successfully"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} Setup should be reachable by going to the following URL.
         ${BL}http://${IP}:3000${CL} \n"