#!/bin/bash

echo "Scriptul de curățare automată a sistemului pentru Arch Linux"
echo "---------------------------------------------------------"

# Verificăm dacă rulează scriptul ca root
if [[ $EUID -ne 0 ]]; then
   echo "Acest script trebuie să ruleze ca root."
   exit 1
fi

echo "Curățare cache-uri pachete..."
sudo pacman -Sc --noconfirm

echo "Curățare completă cache-uri pachete..."
sudo pacman -Scc --noconfirm

echo "Ștergere pachete nedorite..."
sudo pacman -Rns $(sudo pacman -Qdtq) --noconfirm

echo "Ștergere pachete orfane..."
sudo pacman -Qtdq | sudo pacman -Rns --noconfirm

if command -v paru >/dev/null; then
    echo "Curățare cache-uri AUR..."
    paru -Sc --noconfirm
fi

echo "Ștergere cache-uri fișiere locale neutilizate..."
sudo paccache -r

echo "Ștergere cache-uri personale..."
rm -rf ~/.cache/*

echo "Curățare jurnal sistem..."
sudo journalctl --vacuum-time=2weeks

echo "Ștergere istoric comenzi..."
history -c

echo "Curățare finalizată."
