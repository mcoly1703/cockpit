# COCKPIT — Contexte Projet pour Claude Code

## Présentation
**Cockpit** est une plateforme numérique interne de pilotage et gestion militante
pour la **Section France du Pastef** (Patriotes Africains du Sénégal pour le Travail,
l'Éthique et la Fraternité).

- **Nom technique** : cockpit
- **Nom affiché** : PASTEF France — Plateforme Militante
- **Cibles** : Android + Web (iOS secondaire)
- **Langue** : Français uniquement

---

## Stack technique

### Frontend
- Flutter 3.x / Dart 3.x
- Riverpod 2.x (state management + injection de dépendances)
- go_router (navigation)
- freezed + dartz (Either<Failure, Success>)
- fl_chart (graphiques KPIs)
- mobile_scanner (scan QR cartes membres)
- pdf + printing (génération rapports PDF)
- supabase_flutter (client Supabase)

### Backend
- Supabase self-hosted (PostgreSQL + Auth + Storage + Realtime + Edge Functions)
- Row Level Security (RLS) pour le cloisonnement des données par rôle
- Edge Functions en Deno/TypeScript (OCR, PDF, emails, QR check-in)

### Services externes
- Google Vision API (OCR feuilles manuscrites)
- Resend (emails transactionnels)

### Infrastructure
- Hetzner Cloud VPS (~25€/mois)
- Docker + Nginx
- Monorepo Git

---

## Architecture — Monorepo

```
cockpit/
├── frontend/          ← Flutter (Clean Architecture)
├── backend/           ← Supabase (migrations SQL + Edge Functions)
├── infrastructure/    ← Docker, Nginx, scripts déploiement
├── docs/
└── CLAUDE.md          ← Ce fichier
```

---

## Clean Architecture Flutter

Chaque feature suit STRICTEMENT cette structure :

```
features/[nom_feature]/
├── data/
│   ├── datasources/     ← Appels Supabase uniquement
│   ├── models/          ← JSON ↔ Entity (fromJson/toJson)
│   └── repositories/    ← Implémentation des interfaces domain
├── domain/
│   ├── entities/        ← Objets Dart purs, AUCUNE dépendance externe
│   ├── repositories/    ← Interfaces abstraites
│   └── usecases/        ← 1 fichier = 1 action métier
└── presentation/
    ├── providers/       ← Riverpod (Notifier + Provider)
    ├── pages/           ← Écrans Flutter
    └── widgets/         ← Widgets spécifiques à la feature
```

### Règles ABSOLUES
- `domain/` ne connaît NI Flutter NI Supabase — Dart pur uniquement
- `data/` connaît Supabase, implémente les interfaces de `domain/`
- `presentation/` connaît Flutter + Riverpod, appelle UNIQUEMENT les UseCases
- JAMAIS la présentation n'appelle directement Supabase
- Toujours utiliser `Either<Failure, T>` pour les retours de UseCases
- Toujours utiliser `freezed` pour les entités et états

### Flux des dépendances
```
Présentation → Domain ← Data
     ↓              ↑       ↑
Riverpod/UI     UseCase  Supabase
               Entity
```

---

## Structure frontend/lib/

```
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart        ← Branding + URLs (NE PAS hardcoder)
│   ├── constants/
│   │   ├── app_colors.dart        ← Couleurs Pastef
│   │   ├── app_routes.dart        ← Toutes les routes go_router
│   │   └── app_strings.dart       ← Textes de l'app
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── usecases/
│   │   └── usecase.dart           ← Classe abstraite UseCase<T, Params>
│   ├── utils/
│   │   ├── date_helper.dart
│   │   └── format_helper.dart
│   └── widgets/
│       ├── cockpit_button.dart    ← Bouton primaire Pastef
│       ├── cockpit_card.dart      ← Card standard
│       ├── kpi_card.dart          ← Card KPI dashboard
│       └── loading_widget.dart
│
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── militants/
│   ├── finances/
│   ├── prospects/
│   ├── evenements/
│   ├── reunions/
│   ├── bureau/
│   ├── elections/
│   ├── rapports/
│   └── scan/
│
└── main.dart
```

---

## Charte graphique Pastef France

```dart
// Couleurs officielles
static const Color colorPrimary   = Color(0xFF1B4D1B); // Vert foncé
static const Color colorSecondary = Color(0xFF8B0000); // Rouge foncé
static const Color colorAccent    = Color(0xFFC8950A); // Or
static const Color colorBg        = Color(0xFFF5F2F0); // Fond
static const Color colorCard      = Color(0xFFFFFFFF); // Cards
static const Color colorBorder    = Color(0xFFDDD8D0); // Bordures
static const Color colorText      = Color(0xFF1A1A1A); // Texte principal
static const Color colorText2     = Color(0xFF5A5248); // Texte secondaire

// Topbar : dégradé bicolore vert (gauche) → rouge (droite)
// Gradients KPI : linear gradient vert→vert2 ou rouge→rouge2
```

---

## Structure organisationnelle Pastef France

### Hiérarchie
```
Bureau Exécutif (16 postes)
    └── Assemblée Générale
        ├── Sous-sections (8 IDF + régions hors IDF)
        │   └── Cellules (1..n villes proches)
        ├── Mouvements (5) — budget AUTONOME
        └── Secrétariats (6)
```

### Bureau Exécutif — 16 postes
Coordinateur/trice + Adjoint/e · Resp/Vice : Finances · Massification · IT ·
Communication · Veille Électorale · Formation

### Bureau Sous-sections, Mouvements, Cellules — 18 postes
Coordinateur/trice + Vice · Resp/Vice : Communication · Finances · Massification ·
Veille Électorale · Organisation · Formation
+ Resp. locaux : MOJIP · JPS · Maggi Pastef · Foyer

### Sous-sections IDF (8)
Paris (75) · Seine-et-Marne (77) · Yvelines (78) · Essonne (91) ·
Hauts-de-Seine (92) · Seine-Saint-Denis (93) · Val-de-Marne (94) · Val-d'Oise (95)

### Sous-sections Hors IDF
1 sous-section par région administrative française

### Mouvements (5) — budget autonome
JPS (Jeunes) · MOJIP (Femmes) · Cadres · Foyers · Maggi Pastef

### Secrétariats (6)
Finance · Veille Électorale · Communication · Massification · Formation · IT

---

## Profils utilisateurs — 6 rôles

| Rôle (enum) | Périmètre | Peut créer cellule |
|---|---|---|
| `bureau_executif` | Global France | ✅ |
| `coordinateur` | Global France | ✅ |
| `responsable_sous_section` | Sa sous-section | ✅ |
| `responsable_mouvement` | Son mouvement | ❌ |
| `responsable_secretariat` | Son secrétariat | ❌ |
| `coordinateur_cellule` | Sa cellule | ❌ |

### Droits par action
| Action | BE | Resp.SS | Resp.Mvt | Resp.Sec | Coord.Cell |
|---|---|---|---|---|---|
| Ajouter militant | ✅ | ✅ | ✅ | ❌ | ✅ |
| Créer cellule | ✅ | ✅ | ❌ | ❌ | ❌ |
| Créer événement | ✅ | ✅ | ✅ | ✅ | ✅ |
| Créer réunion | ✅ | ✅ | ✅ | ✅ | ✅ |
| Enregistrer cotisation | ✅ | ✅ | ✅ | ❌ | ✅ |
| Saisir CR activité | ✅ | ✅ | ✅ | ✅ | ✅ |
| Générer rapport PDF | ✅ | ✅ | ✅ | ✅ | ✅ |

---

## 12 Modules — 3 phases

### Phase 1 — MVP (Semaines 1-6)
1. **auth** — Login + gestion des rôles
2. **dashboard** — KPIs + alertes + graphiques 6 mois
3. **militants** — CRUD + import CSV + import OCR
4. **finances** — Entrées/dépenses + taux recouvrement

### Phase 2 — (Semaines 7-10)
5. **prospects** — Entonnoir 4 étapes + QR Code meeting
6. **evenements** — Planification + QR Code présences
7. **reunions** — Réunions + décisions + documents
8. **bureau** — Composition des 16/18 postes
9. **rapports** — 5 types PDF (simple + consolidé)
10. **scan** — Scan carte membre QR

### Phase 2 suite — (Semaines 11-12)
11. **elections** — Mini-module (pas de vote électronique)
12. **cra** — Comptes rendus d'activité (remontée terrain)

---

## KPIs Dashboard

### Militants
- Total militants + évolution mensuelle
- Objectif 10 000 (global + par sous-section)
- Nouveaux ce mois · Répartition H/F
- Par sous-section / mouvement / secrétariat / cellule
- Graphique tendance **6 mois glissants**

### Finances
- Solde global (entrées - dépenses)
- **Taux de recouvrement cotisations** (objectif 80%)
- Entrées par catégorie : Cotisations · Dons · Bénéfices events · Goodies
- Dépenses par catégorie : Logistique · Comm · Matériel · Déplacements · Goodies · Admin · Formation
- Graphique entrées vs dépenses **6 mois glissants**

### Activité
- Prospects actifs + taux de conversion
- Événements ce mois + taux participation
- Décisions en attente + actions en retard
- CR activité reçus vs attendus

---

## Fonctionnalités spéciales

### QR Code Meeting
- Chaque événement génère un QR code unique
- URL : `cockpit.pastef-france.fr/event/{id}/register`
- Formulaire prospect : Nom/Prénom · Téléphone · Email · Ville · Sexe · Mouvement d'intérêt
- Création automatique en Prospect dans l'entonnoir

### Scan Carte Membre
- Lit les QR codes des cartes membres EXISTANTES (ne les génère pas)
- 3 résultats : ✅ OK · ⚠️ Cotisation en retard (avertissement) · ❌ Inconnu
- Compatible smartphone + scanner USB/Bluetooth
- Mode événement : compteur présences temps réel
- Fonctionne hors ligne (sync à la reconnexion)

### Import Massif Militants
- Option 1 : Import CSV/Excel (colonnes : Nom, Prénom, Téléphone, Email, Ville, Sexe)
- Option 2 : OCR feuille manuscrite via Google Vision API (Edge Function Supabase)
- Validation avant import avec signalement des erreurs/doublons

### Rapports PDF
- 5 types : CRA · Financier · Réunion · Événement · Cotisations
- 2 modes : Simple (ce niveau) · Consolidé (inclut niveaux inférieurs)
- Flux remontée CRA : Cellule → Sous-section → Bureau Exécutif

---

## Conventions de code

### Nommage
```dart
// Fichiers : snake_case
militant_model.dart
get_militants.dart

// Classes : PascalCase
class MilitantModel {}
class GetMilitants {}

// Variables/méthodes : camelCase
final List<Militant> militants = [];
Future<void> addMilitant() {}

// Constantes : camelCase avec 'k' prefix
const kPrimaryColor = Color(0xFF1B4D1B);
```

### Patterns obligatoires
```dart
// Toujours Either pour les UseCases
Future<Either<Failure, List<Militant>>> call(NoParams params);

// Toujours freezed pour les entités
@freezed
class Militant with _$Militant {
  const factory Militant({
    required String id,
    required String nom,
    required String prenom,
    // ...
  }) = _Militant;
}

// Toujours AsyncNotifier pour les providers avec données async
@riverpod
class MilitantsNotifier extends _$MilitantsNotifier {
  @override
  Future<List<Militant>> build() async { ... }
}
```

### Structure d'un UseCase
```dart
class GetMilitants implements UseCase<List<Militant>, NoParams> {
  final MilitantsRepository repository;
  GetMilitants(this.repository);

  @override
  Future<Either<Failure, List<Militant>>> call(NoParams params) =>
      repository.getMilitants();
}
```

---

## Variables d'environnement (.env)

```env
# Supabase
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=xxx
SUPABASE_SERVICE_KEY=xxx

# Google Vision (OCR)
GOOGLE_VISION_API_KEY=xxx

# Resend (emails)
RESEND_API_KEY=xxx

# App
APP_ENV=development
APP_URL=http://localhost:3000
```

---

## État d'avancement

### ✅ Fait
- Environnement Flutter configuré (Windows, Flutter 3.x)
- Projet créé : `flutter create --org fr.pastef --project-name cockpit frontend`
- Structure monorepo créée (frontend/ backend/ infrastructure/ docs/)
- main.dart nettoyé, app de base qui tourne

### 🔄 En cours
- Mise en place de la structure Clean Architecture dans lib/
- Installation des dépendances (pubspec.yaml)

### ⏳ À faire
- Tout le reste (voir les 12 modules)

---

## Instructions pour Claude Code

1. **Toujours respecter la Clean Architecture** — ne jamais appeler Supabase depuis la présentation
2. **Toujours utiliser Riverpod** pour la gestion d'état — pas setState sauf pour des widgets très simples
3. **Toujours utiliser Either<Failure, T>** pour les retours de UseCases
4. **Toujours utiliser freezed** pour les entités et les états
5. **Générer le code build_runner** après chaque fichier freezed (`flutter pub run build_runner build`)
6. **Respecter la charte graphique** — vert #1B4D1B, rouge #8B0000, or #C8950A
7. **Commenter en français** — c'est le projet d'une militante francophone
8. **Ne jamais hardcoder** les URLs ou clés API — toujours passer par AppConfig
9. **Un fichier = une responsabilité** — pas de classes God object
10. **Toujours demander confirmation** avant de modifier un fichier existant

---

*Dernière mise à jour : Mai 2025*
*Développeuse : Militante Pastef France — Data Engineer*