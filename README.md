# Update-PWSH-macOS-CLI

Script Bash pour mettre à jour automatiquement PowerShell vers la dernière version stable sur macOS Apple Silicon via la ligne de commande.

---

## Description

Ce projet fournit un script shell qui :

- Récupère la dernière version stable de PowerShell depuis l’API GitHub officielle.
- Télécharge le package `.pkg` adapté pour macOS Apple Silicon.
- Supprime les attributs de quarantaine macOS pour éviter les blocages Gatekeeper.
- Installe ou met à jour PowerShell proprement.
- Affiche une notification macOS en cas de succès ou d’erreur.
- Gère la variable d’environnement de version pour une utilisation avancée.

Il est idéal pour automatiser la maintenance de PowerShell sur Mac via un terminal.

---

## Prérequis

- macOS 13 (Sequoia) ou supérieur.
- Bash (version 4 ou 5 recommandée).
- Accès `sudo`.
- Connexion Internet active.
- `curl` et `osascript` installés (par défaut sur macOS).
- Git et GitHub CLI (`gh`) installés pour gestion du dépôt.

---

## Installation et utilisation

### Cloner le dépôt (après création sur GitHub)

```
git clone https://github.com/votre-username/Update-PWSH-macOS-CLI.git
cd Update-PWSH-macOS-CLI
```

### Rendre le script exécutable et lancer la mise à jour

```
chmod +x update_powershell_latest.sh
bash ./update_powershell_latest.sh
```

### Utilisation optionnelle: sourcing pour récupérer la variable

```
bash
source ./update_powershell_latest.sh
echo $LATEST_TAG
```

---

## Création du dépôt Git et GitHub

Voici les commandes complètes pour initialiser localement, créer et pousser un nouveau repo GitHub avec une description :

```
# Initialiser un dépôt git local
mkdir Update-PWSH-macOS-CLI
cd Update-PWSH-macOS-CLI
git init

# Créer le README.md et ajouter le script
nano README.md
# (coller le contenu README ici)

# Ajouter les fichiers et valider
git add README.md update_powershell_latest.sh
git commit -m "Initial commit - ajout du script de mise à jour PowerShell pour macOS"

# Créer le repo GitHub avec description, le lier et pousser
gh repo create Update-PWSH-macOS-CLI --public --description "Script Bash pour mise à jour automatique PowerShell sur macOS Apple Silicon" --source=. --remote=origin --push
```

---

## Fonctionnalités futures envisagées

- Automatisation via GitHub Actions pour vérifications régulières.
- Support multi-plateformes (Linux, Windows).
- Interface interactive pour choisir la version.
- Intégration avec des outils de gestion de configuration (Ansible, Chef, etc.).

---

## Licence

Ce projet est sous licence MIT.

---

N’hésitez pas à contribuer ou demander des améliorations !
```
