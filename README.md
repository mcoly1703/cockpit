# 🎛️ Cockpit — Pastef France

> Plateforme numérique interne de pilotage et de gestion militante pour la Section France du Pastef.

---

## 🇸🇳 À propos

**Cockpit** est l'outil de pilotage interne du **Pastef Section France**.  
Il permet à chaque niveau de l'organisation (Bureau Exécutif, sous-sections, mouvements, cellules) de suivre en temps réel l'activité militante, les finances, les événements et bien plus.

---

## ✨ Fonctionnalités

- 📊 **Dashboard KPIs** — militants, finances, prospects, événements
- 🫂 **Gestion des militants** — import CSV, OCR feuilles manuscrites
- 💰 **Finances** — entrées/dépenses, taux de recouvrement
- 📋 **Prospects** — entonnoir de conversion + QR Code meeting
- 📅 **Événements** — planification + QR Code présences
- 🏛️ **Réunions & décisions** — PV, comptes rendus
- 🏅 **Bureau** — composition des instances (16/18 postes)
- 📷 **Scan carte membre** — vérification + présences
- 📑 **Rapports PDF** — 5 types, simple ou consolidé
- 🗳️ **Élections internes** — planification et archivage

---

## 🛠️ Stack technique

| Couche | Technologie |
|---|---|
| Mobile + Web | Flutter 3.x / Dart 3.x |
| State management | Riverpod 2.x |
| Navigation | go_router |
| Backend | Supabase (PostgreSQL + Auth + Storage + Realtime) |
| Edge Functions | Deno / TypeScript |
| OCR | Google Vision API |
| Emails | Resend |
| Hébergement | Hetzner Cloud (EU) |

---

## 🏗️ Architecture

Monorepo — Clean Architecture

```
cockpit/
├── frontend/          # App Flutter
│   └── lib/
│       ├── core/      # Constantes, widgets communs, utils
│       └── features/  # 1 dossier par module (clean architecture)
│           └── [feature]/
│               ├── data/         # Supabase, modèles
│               ├── domain/       # Entités, UseCases, interfaces
│               └── presentation/ # Pages, widgets, Riverpod
│
├── backend/           # Supabase
│   ├── migrations/    # SQL versionné
│   ├── functions/     # Edge Functions
│   └── seed/          # Données de test
│
├── infrastructure/    # Docker, Nginx, scripts
└── docs/              # Documentation
```

---

## 🚀 Démarrage

### Prérequis
- Flutter 3.x
- Dart 3.x
- Un projet Supabase (cloud ou self-hosted)

### Installation

```bash
# Cloner le repo
git clone https://github.com/[org]/cockpit.git
cd cockpit

# Configurer les variables d'environnement
cp .env.example .env
# Remplir SUPABASE_URL, SUPABASE_ANON_KEY...

# Installer les dépendances Flutter
cd frontend
flutter pub get

# Générer le code (freezed, riverpod)
flutter pub run build_runner build

# Lancer en mode développement
flutter run -d chrome
```

### Base de données

```bash
# Appliquer les migrations Supabase
cd backend
supabase db push
```

---

## 📁 Variables d'environnement

Copiez `.env.example` en `.env` et remplissez :

```env
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=xxx
SUPABASE_SERVICE_KEY=xxx
GOOGLE_VISION_API_KEY=xxx
RESEND_API_KEY=xxx
APP_ENV=development
```

---

## 🗺️ Roadmap

- [x] Initialisation du projet
- [x] Architecture définie
- [ ] Schéma base de données
- [ ] Auth + gestion des rôles
- [ ] Dashboard KPIs
- [ ] Module Militants
- [ ] Module Finances
- [ ] Module Prospects
- [ ] Module Événements
- [ ] Module Réunions
- [ ] Module Bureau
- [ ] Module Scan carte membre
- [ ] Module Rapports PDF
- [ ] Module Élections
- [ ] Module CR Activité
- [ ] Déploiement production

---

## 🔒 Sécurité & RGPD

- Données hébergées en Europe (Frankfurt)
- Row Level Security (RLS) Supabase — cloisonnement strict par rôle
- Données sensibles (CNI/NIN) accessibles uniquement au Bureau Exécutif
- Conformité RGPD — registre de traitement à tenir

---

## 📄 Licence

Usage interne — Pastef Section France.  
Tous droits réservés.

---

*Développé avec ❤️ pour le Pastef France*
