# semaphore-install.sh

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os
# -----------
msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y python3 python3-pip git     # Install Semaphore Dependencies (python3, python3-pip, git)
msg_ok "Installed Dependencies"
# -----------
msg_info "Installing Ansible"
$STD sudo apt update            # Install Ansible
$STD sudo apt install software-properties-common
$STD sudo add-apt-repository --yes --update
$STD ppa:ansible/ansible
$STD sudo apt install ansible
msg_ok "Installed Ansible"
# -----------
# Create service user "semaphore" & add to new semaphore group
msg_info "Creating user and group for Semaphore"
sudo addgroup semaphore
sudo adduser --shell /bin/bash --home /home/semaphore semaphore --ingroup semaphore semaphore
msg_ok "Create user and group for Semaphore"
# -----------
# Install Python modules
msg_info "Installing Python modules"
sudo -u semaphore python3 -m pip install --user --upgrade -r /home/semaphore/requirements.txt
msg_ok "Installed Python modules" 
# -----------
# Install Ansible collections & roles
msg_info "Installing Ansible collections and roles"
sudo -u semaphore ansible-galaxy collection install --upgrade -r /home/semaphore/requirements.yml
sudo -u semaphore ansible-galaxy role install --force -r /home/semaphore/requirements.yml
msg_ok "Installed Ansible collections and roles"
# -----------
# Install Semaphore software
msg_info "Installing Ansible Semaphore"

SEM_VER="2.9.45"
SEM_TARBELL="semaphore_{SEM_VER}_linux_amd64.tar.gz"
SEM_DIR="/opt/semaphore"

# Download latest Semaphore tarball
$STD tar zxvf <(curl -fsSL https://github.com/ansible-semaphore/semaphore/releases/download/v${SEM_VER}/semaphore_${SEM_VER}_linux_amd64.tar.gz) -C /opt
# Extract Semaphore tarball
tar xf semaphore_${SEM_VER}_linux_amd64.tar.gz
# Move semaphore files to /opt/semaphore
sudo mv semaphore 
# Set proper permissions
sudo chown -R semaphore:semaphore "${SEM_DIR}"
sudo chown -R 755 "${SEM_DIR}"

# Run Semaphore setup
${SEM_DIR}/setup
msg_ok "Installed Ansible Semaphore"

# Clean up downloaded tarball
rm "/opt/semaphore_${SEM_VER}_linux_amd64.tar.gz"

msg_ok "Installation completed successfully"
