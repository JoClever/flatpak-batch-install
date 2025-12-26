#!/bin/bash

# Install Flatpak applications from Flathub and Flathub Beta

workstation=false
gaming=false

# Get command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --help)
            echo "Usage: install.sh [options]"
            echo "Options:"
            echo "  --help          Show this help message"
            echo "  --workstation   Install extended set of applications"
            echo "  --laptop        Install essential set of applications"
            exit 0
            ;;
        --workstation)
            echo "Installing workstation applications..."
            workstation=true
            ;;
        --laptop)
            echo "Installing laptop applications..."
            workstation=false
            ;;
        --gaming)
            echo "Installing gaming applications..."
            gaming=true
            ;;
        *)
            echo "Unknown parameter passed: $1"
            exit 1
            ;;
    esac
    shift
done

# Check if Flatpak is installed
if ! command -v flatpak &> /dev/null; then
    echo "Error: Flatpak is not installed. Please install Flatpak and try again."
    exit 1
fi

# Check if FlatHub is added as a remote
if ! flatpak remotes | grep -c '^flathub\s' &> /dev/null; then
    echo "Adding Flathub as a remote..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Check if Flathub Beta is added as a remote
if ! flatpak remotes | grep -c '^flathub-beta\s' &> /dev/null; then
    echo "Adding Flathub Beta as a remote..."
    flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
fi

# Essential Flatpak stable apps to install
flatpaks=(
    # org.gnu.pspp
    # io.gitlab.gregorni.Calligraphy
    # one.ablaze.floorp
    # com.getpostman.Postman
    # com.anydesk.Anydesk
    # org.kde.krita
    # org.flameshot.Flameshot
    # com.sublimetext.three
    # cc.arduino.arduinoide
    # org.onlyoffice.desktopeditors
    # io.appflowy.AppFlowy
    app.drey.KeyRack
    best.ellie.StartupConfiguration
    com.bitwarden.desktop
    com.github.IsmaelMartinez.teams_for_linux
    com.jgraph.drawio.desktop
    com.mattjakeman.ExtensionManager
    com.spotify.Client
    com.visualstudio.code
    dev.qwery.AddWater
    io.github.alainm23.planify
    io.github.tobagin.karere
    net.nokyan.Resources
    org.gnome.gitlab.somas.Apostrophe
    org.libreoffice.LibreOffice
    org.remmina.Remmina
    re.sonny.Tangram
)

# Additional Flatpak stable apps for workstation
if [ "$workstation" = true ]; then
    flatpaks+=(
        com.github.qarmin.czkawka
        com.rawtherapee.RawTherapee
        com.ultimaker.cura
        com.valvesoftware.SteamLink
        com.vivaldi.Vivaldi
        io.github.shiftey.Desktop
        org.apache.directory.studio
        org.darktable.Darktable
        org.freecad.FreeCAD
        # org.fritzing.Fritzing
        # org.gnome.Boxes
        org.gnome.seahorse.Application
        org.inkscape.Inkscape
        org.kde.filelight
        org.octave.Octave
    )
fi

# Additional Flatpak stable apps for gaming
if [ "$gaming" = true ]; then
    flatpaks+=(
        com.valvesoftware.Steam
        com.heroicgameslauncher.hgl
        com.discordapp.Discord
        net.lutris.Lutris
    )
fi

# Flatpak beta apps to install
flatpaks_beta=(
    org.mozilla.Thunderbird//beta
    org.mozilla.firefox//beta
    org.signal.Signal//beta
    org.telegram.desktop//beta
)

# Additional Flatpak beta apps for workstation
if [ "$workstation" = true ]; then
    flatpaks_beta+=(
        org.gimp.GIMP//beta
    )
fi

# Install all stable Flatpaks
flatpak install -y flathub ${flatpaks[@]}

# Install all beta Flatpaks
flatpak install -y flathub-beta ${flatpaks_beta[@]}

echo "Flatpak installation completed!"
