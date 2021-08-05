#!/bin/bash
set -e

# Install all necessary packages
# Run the step-repo-mirrors.sh script to ensure all repo mirrors are correct


# Allow sudo to read custom paths
grep '#Defaults.*secure_path' /etc/sudoers &> /dev/null || {
    sed -i -e '/secure_path/s/^/#/' /etc/sudoers
}

grep 'Defaults env_keep += "PATH"' /etc/sudoers &> /dev/null || {
    echo 'Defaults env_keep += "PATH"' >> /etc/sudoers
}


# Other utilities
PKGS="$PKGS dos2unix unzip zip wget"

# python3 and pip3
PKGS="$PKGS software-properties-common python3 python3-pip"

# snapd for snap packages
PKGS="$PKGS snapd"

apt-get  update
# Install packages via yum
for pkg in $PKGS; do
  apt install -y $pkg
done

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
apt-get install -y openjdk-11-jdk
apt-get install -y maven 

# Install pip3 packages
python3 -m pip install --upgrade pip==21.0.1
python3 -m pip install virtualenv==20.4.3
python3 -m pip install oyaml==1.0

# Enable snapd for downloading snap packages
systemctl enable --now snapd.socket
ln -s /var/lib/snapd/snap /snap # enable classic support
snap wait system seed.loaded
snap set system refresh.hold="$(date --date="$(date --date=today +30days)" +%Y-%m-%dT%H:%M:%S%:z)"
snap set system refresh.timer=23:00-5:00


# Install snap packages using channel and dev mode to prevent automatic updates
# `snap download` will download a SNAP_REV.snap file and a SNAP_REV.assert file
install-snap-package() {
    PACKAGE=$1
    CHANNEL=$2
    pushd /tmp >> /dev/null
    snap download "$PACKAGE" --channel="$CHANNEL"
    snap ack "$(find . -name "$PACKAGE"_*.assert)"
    snap install "$(find . -name "$PACKAGE"_*.snap)" --dangerous --classic
    rm -f "$PACKAGE"_*.assert
    rm -f "$PACKAGE"_*.snap
    popd >> /dev/null
}

# Install snap packages
install-snap-package jq latest/stable
install-snap-package microk8s 1.19/stable
install-snap-package helm 3.4/stable
install-snap-package go 1.16/stable

echo "PATH=\$PATH:/vagrant" >> /etc/profile
echo "PATH=\$PATH:/home/vagrant/bin" >> /home/vagrant/.bashrc

echo "packages have been successfully installed"

apt-get update -y && sudo apt-get upgrade -y && sudo apt-get autoremove -y && sudo apt-get autoclean -y

apt-get update -y && sudo apt-get dist-upgrade -y

