#!/bin/bash
set -e

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

