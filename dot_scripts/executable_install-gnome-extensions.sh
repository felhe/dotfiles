#!/bin/bash

# Check if gnome-extensions-cli is installed
if ! command -v gnome-extensions-cli &>/dev/null; then
    echo "gnome-extensions-cli is not installed. Installing via pip..."
    # Install gnome-extensions-cli via pip
    pip install gnome-extensions-cli
    if [ $? -ne 0 ]; then
        echo "Failed to install gnome-extensions-cli. Exiting."
        exit 1
    fi
fi

# List of extensions to install
extensions=(
    "Vitals@CoreCoding.com"   # https://extensions.gnome.org/extension/1460/vitals/
    "3193"   # https://extensions.gnome.org/extension/3193/blur-my-shell/
    "307"	# https://extensions.gnome.org/extension/307/dash-to-dock/
    "2236"    # https://extensions.gnome.org/extension/2236/night-theme-switcher/
    # Add more extension IDs here as needed
)

# Loop through each extension ID and install it
for extension_id in "${extensions[@]}"; do
    echo "Installing extension with ID $extension_id"
    gnome-extensions-cli install "$extension_id"
done

# workaround for tray icons necessary
sudo dnf install gnome-shell-extension-appindicator
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
