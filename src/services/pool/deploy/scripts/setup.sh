#!/usr/bin/env bash

SUDO=""

if command -v sudo; then
  SUDO="sudo"
fi

if command -v node; then
  echo "node installed"
else
  curl -fsSL https://deb.nodesource.com/setup_19.x | $SUDO -E bash - 
  $SUDO apt-get install -y nodejs
fi

if ! command -v pm2; then
  $SUDO bash -c "source ~/.nvm/nvm.sh; npm i -g pm2@latest"
fi

echo -n "Set up quota user to have 5G 5G and 2m 2m block and inode limit."
read -p " Enter to continue "
$SUDO cp ./scripts/commands/* /usr/local/bin/

# Edit the $SUDOers file to allow members of the "renice" group to run the "renice" command
if ! $SUDO grep -q "%renice ALL=(ALL) NOPASSWD:" /etc/sudoers;
then
  $SUDO groupadd renice >&2
  echo "%renice ALL=NOPASSWD: /usr/bin/renice, /usr/bin/loginctl, /usr/bin/id" | $SUDO tee -a /etc/$SUDOers >&2
fi

$SUDO ./scripts/commands/newuser.sh quotauser

