#!/bin/bash

# Récupérer la dernière version stable depuis GitHub API
LATEST_TAG=$(curl -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

if [[ -z "$LATEST_TAG" ]]; then
  echo "Erreur : impossible de récupérer la dernière version PowerShell."
  exit 1
fi

VERSION_CIBLE="$LATEST_TAG"
URL="https://github.com/PowerShell/PowerShell/releases/download/v$VERSION_CIBLE/powershell-$VERSION_CIBLE-osx-arm64.pkg"
PKG_PATH="/tmp/powershell-$VERSION_CIBLE-osx-arm64.pkg"

echo "Dernière version détectée : $VERSION_CIBLE"

# Fonction notification macOS
notify() {
  osascript -e "display notification \"$2\" with title \"$1\""
}

echo "Vérification de la connexion Internet..."
if ! ping -c 1 github.com &>/dev/null; then
  echo "Erreur : pas de connexion Internet."
  notify "PowerShell Update" "Échec : pas de connexion Internet."
  exit 1
fi

# Vérifier si sudo est disponible
if ! command -v sudo &>/dev/null; then
  echo "Erreur : sudo non trouvé."
  notify "PowerShell Update" "Échec : sudo non disponible."
  exit 1
fi

# Vérifier version actuelle
if command -v pwsh &>/dev/null; then
  CURRENT_VERSION=$(pwsh --version | sed 's/PowerShell //')
  echo "Version actuelle de PowerShell : $CURRENT_VERSION"
  if [ "$CURRENT_VERSION" == "$VERSION_CIBLE" ]; then
    echo "La version cible $VERSION_CIBLE est déjà installée. Aucun besoin de mise à jour."
    notify "PowerShell Update" "La version $VERSION_CIBLE est déjà installée."
    exit 0
  fi
else
  echo "PowerShell n'est pas installé, l'installation va commencer."
fi

echo "Téléchargement de PowerShell $VERSION_CIBLE..."
if ! curl -L -o "$PKG_PATH" "$URL"; then
  echo "Erreur lors du téléchargement."
  notify "PowerShell Update" "Échec du téléchargement."
  exit 1
fi

echo "Suppression de l'attribut de quarantaine (si présent)..."
sudo xattr -rd com.apple.quarantine "$PKG_PATH" 2>/dev/null || echo "Pas d'attribut de quarantaine détecté."

echo "Installation du package..."
if ! sudo installer -pkg "$PKG_PATH" -target /; then
  echo "Erreur lors de l'installation."
  notify "PowerShell Update" "Échec de l'installation."
  exit 1
fi

echo "Vérification de la version installée..."
NEW_VERSION=$(pwsh --version | sed 's/PowerShell //')
echo "PowerShell installé : $NEW_VERSION"

if [ "$NEW_VERSION" == "$VERSION_CIBLE" ]; then
  notify "PowerShell Update" "Mise à jour réussie vers la version $VERSION_CIBLE."
  echo "Mise à jour réussie."
else
  notify "PowerShell Update" "Mise à jour échouée."
  echo "Échec de mise à jour."
  exit 1
fi

# Nettoyage du fichier d'installation
rm -f "$PKG_PATH"
echo "Fichier d'installation supprimé."

export LATEST_TAG="$LATEST_TAG"
