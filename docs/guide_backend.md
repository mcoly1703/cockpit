# Guide Backend — Cockpit Pastef France

> Pas à pas à exécuter soi-même. Claude explique, tu exécutes.
> Dernière mise à jour : Mai 2026

---

## Environnements et déploiement

### 3 environnements Supabase

| Environnement | Projet Supabase | Usage |
|---|---|---|
| DEV | `cockpit-dev` | Développement, données fictives, accès équipe dev |
| UAT | `cockpit-uat` | Validation par les responsables du parti avant mise en prod |
| PRD | `cockpit-prd` | Production réelle, données militantes réelles |

Chaque environnement = un projet Supabase séparé avec ses propres URL et clés API.

### Variables à externaliser (ne jamais hardcoder)

Dans Flutter, toutes ces valeurs passent par `AppConfig` selon l'environnement :

```
SUPABASE_URL         ← différent par environnement
SUPABASE_ANON_KEY    ← différent par environnement
APP_ENV              ← development | uat | production
APP_URL              ← différent par environnement
```

En Flutter, utiliser `--dart-define` au build pour injecter les variables :
```bash
flutter build apk --dart-define=SUPABASE_URL=xxx --dart-define=SUPABASE_ANON_KEY=xxx
```

### Migrations sur les 3 environnements

```bash
# Lier et pousser sur chaque environnement
supabase link --project-ref <REF_DEV>
supabase db push

supabase link --project-ref <REF_UAT>
supabase db push

supabase link --project-ref <REF_PRD>
supabase db push
```

### Admins techniques et équipe dev

Les admins techniques (équipe support, devs) sont gérés dans une table séparée `admins_techniques`, complètement distincte des rôles politiques militants.

**Table `admins_techniques` :**
- `id` UUID FK `auth.users` — compte Supabase Auth
- `nom`, `prenom` TEXT
- `is_active` BOOLEAN
- `created_at`, `updated_at` TIMESTAMPTZ

**Règles :**
- Un admin technique n'a JAMAIS de profil dans `profiles` — ce sont deux mondes séparés
- L'équipe dev accède uniquement à `cockpit-dev`, jamais à PRD
- En production, seuls les admins techniques désignés par le Secrétariat IT ont un compte

**Dans Flutter — logique de connexion :**
À la connexion, on vérifie dans cet ordre :
1. Le user est dans `admins_techniques` → interface admin/support
2. Le user est dans `profiles` → interface Cockpit militante
3. Ni l'un ni l'autre → accès refusé

**Créer un nouvel admin technique :**
1. Créer le user dans Supabase Studio → Authentication → Users
2. Insérer manuellement une ligne dans `admins_techniques` avec son UUID

---

## Convention — codes métier des unités organisationnelles

Le champ `code` de la table `unites_organisationnelles` suit cette convention :

| Type | Format | Exemples |
|---|---|---|
| Bureau Exécutif | `BEX` | `BEX` |
| Sous-section | `SS-{dept 3 chiffres ou trigramme}` | `SS-075`, `SS-092`, `SS-LYO` |
| Mouvement | `MVT-{sigle}` | `MVT-JPS`, `MVT-MJP` |
| Secrétariat | `SEC-{trigramme}` | `SEC-FIN`, `SEC-COM`, `SEC-ITE` |
| Cellule | `CEL-{dept}-{trigramme ville}` | `CEL-075-BLV`, `CEL-092-NEU` |

L'UUID reste la clé primaire technique. Le `code` est l'identifiant métier lisible.

---

## Stack
- Supabase Cloud (PostgreSQL + Auth + Storage + Realtime + Edge Functions)
- Supabase CLI (gestion migrations en local → push vers cloud)
- Deno / TypeScript (Edge Functions)

---

## Étape 1 — Créer le projet Supabase Cloud

1. Aller sur https://supabase.com et créer un compte
2. Cliquer **New project**
3. Remplir :
   - Name : `cockpit`
   - Database Password : générer un mot de passe fort, **le noter**
   - Region : `West EU (Ireland)` — données en Europe
4. Attendre la création (~2 min)
5. Dans **Project Settings → API**, noter :
   - `Project URL` → c'est ton `SUPABASE_URL`
   - `anon public` key → c'est ton `SUPABASE_ANON_KEY`
   - `service_role` key → c'est ton `SUPABASE_SERVICE_KEY`
6. Dans **Project Settings → General**, noter le **Reference ID** (ex: `abcdefghijkl`)

---

## Étape 2 — Installer le Supabase CLI

```bash
# Windows (via Scoop)
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase

# Vérifier
supabase --version
```

---

## Étape 3 — Initialiser la structure backend locale

Depuis la racine du monorepo `cockpit/` :

```bash
mkdir backend
cd backend
supabase init
```

Cela crée `backend/supabase/config.toml` et `backend/supabase/migrations/`.

Modifier `config.toml` :
- `project_id = "cockpit"`
- `[auth] enable_signup = false` (inscriptions contrôlées par les admins)

---

## Étape 4 — Lier le projet Cloud

```bash
cd backend
supabase login
supabase link --project-ref <TON_REFERENCE_ID>
```

Saisir le mot de passe de la base quand demandé.

---

## Étape 5 — Migration 0001 : Types et fonctions utilitaires

Créer le fichier `backend/supabase/migrations/20260506000000_init_types.sql`.

Contenu à écrire : tous les `ENUM` PostgreSQL du projet + la fonction trigger `updated_at`.

Enums à créer :
- `user_role` — les 6 rôles (bureau_executif, coordinateur, responsable_sous_section, responsable_mouvement, responsable_secretariat, coordinateur_cellule)
- `unite_type` — les types d'unités (bureau_executif, sous_section, mouvement, secretariat, cellule)
- `sexe_type` — (M, F)
- `statut_militant` — (actif, inactif, suspendu)
- `transaction_type` — (entree, depense)
- `categorie_finance` — cotisation, don, benefice_event, goodies_vente / logistique, communication, materiel, deplacements, goodies_achat, administration, formation
- `statut_cotisation` — (payee, en_attente, en_retard)

Fonction trigger :
```sql
CREATE OR REPLACE FUNCTION trigger_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

Appliquer :
```bash
supabase db push
```

---

## Étape 6 — Migration 0002 : Unités organisationnelles

Créer `20260506000001_unites_organisationnelles.sql`.

Table `unites_organisationnelles` :
- `id` UUID PK
- `type` unite_type NOT NULL
- `nom` TEXT NOT NULL
- `code` TEXT (ex: '75', 'JPS')
- `parent_id` UUID FK self (nullable — NULL = racine = Bureau Exécutif)
- `is_active` BOOLEAN DEFAULT TRUE
- `created_at`, `updated_at` TIMESTAMPTZ

Indexes : parent_id, type, is_active
Trigger updated_at.
RLS activé (policies dans étape 10).

---

## Étape 7 — Migration 0003 : Profils utilisateurs

Créer `20260506000002_profiles.sql`.

Table `profiles` (étend `auth.users`) :
- `id` UUID PK FK `auth.users(id)` ON DELETE CASCADE
- `nom`, `prenom` TEXT NOT NULL
- `telephone` TEXT
- `role` user_role NOT NULL
- `unite_id` UUID FK `unites_organisationnelles(id)`
- `is_active` BOOLEAN DEFAULT TRUE
- `created_at`, `updated_at` TIMESTAMPTZ

Trigger de création automatique (s'exécute quand Supabase Auth crée un user) :
```sql
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, nom, prenom)
  VALUES (NEW.id, '', '');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
```

---

## Étape 8 — Migration 0004 : Militants

Créer `20260506000003_militants.sql`.

Séquence pour numéro de carte :
```sql
CREATE SEQUENCE militants_carte_seq START 1;
```

Table `militants` :
- `id` UUID PK
- `numero_carte` TEXT UNIQUE DEFAULT `'PST-' || LPAD(NEXTVAL('militants_carte_seq')::TEXT, 6, '0')`
- `nom`, `prenom` TEXT NOT NULL
- `date_naissance` DATE
- `sexe` sexe_type
- `telephone`, `email` TEXT
- `ville`, `code_postal` TEXT
- `unite_id` UUID FK unites_organisationnelles NOT NULL
- `statut` statut_militant DEFAULT 'actif'
- `date_adhesion` DATE DEFAULT CURRENT_DATE
- `photo_url` TEXT
- `created_by` UUID FK profiles
- `created_at`, `updated_at` TIMESTAMPTZ

Indexes : unite_id, statut, numero_carte, created_by

---

## Étape 9 — Migration 0005 : Finances

Créer `20260506000004_finances.sql`.

Table `transactions` :
- `id` UUID PK
- `type` transaction_type NOT NULL
- `categorie` categorie_finance NOT NULL
- `montant` NUMERIC(12,2) NOT NULL CHECK (montant > 0)
- `description` TEXT
- `date_transaction` DATE NOT NULL DEFAULT CURRENT_DATE
- `piece_justificative_url` TEXT
- `unite_id` UUID FK unites_organisationnelles NOT NULL
- `militant_id` UUID FK militants (nullable — pour les cotisations)
- `created_by` UUID FK profiles NOT NULL
- `created_at`, `updated_at` TIMESTAMPTZ

Table `cotisations` (suivi par militant et par année) :
- `id` UUID PK
- `militant_id` UUID FK militants NOT NULL
- `annee` SMALLINT NOT NULL
- `montant` NUMERIC(12,2) NOT NULL
- `statut` statut_cotisation DEFAULT 'en_attente'
- `date_paiement` DATE
- `transaction_id` UUID FK transactions (nullable)
- `created_by` UUID FK profiles NOT NULL
- `created_at`, `updated_at` TIMESTAMPTZ
- UNIQUE (militant_id, annee) — une cotisation par militant par an

Indexes : unite_id, militant_id, type, date_transaction, (militant_id + annee)

---

## Étape 10 — Migration 0006 : Politiques RLS

Créer `20260506000005_rls_policies.sql`.

Activer RLS sur toutes les tables + créer la fonction helper :

```sql
-- Retourne tous les unite_ids accessibles selon le rôle de l'utilisateur courant
CREATE OR REPLACE FUNCTION get_accessible_unite_ids()
RETURNS SETOF UUID AS $$
DECLARE
  v_role user_role;
  v_unite_id UUID;
BEGIN
  SELECT role, unite_id INTO v_role, v_unite_id
  FROM profiles WHERE id = auth.uid();

  -- Bureau exécutif et coordinateur : accès global
  IF v_role IN ('bureau_executif', 'coordinateur') THEN
    RETURN QUERY SELECT id FROM unites_organisationnelles WHERE is_active = TRUE;

  -- Responsable sous-section : sa SS + toutes ses cellules
  ELSIF v_role = 'responsable_sous_section' THEN
    RETURN QUERY
      SELECT id FROM unites_organisationnelles
      WHERE (id = v_unite_id OR parent_id = v_unite_id) AND is_active = TRUE;

  -- Tous les autres : leur unité uniquement
  ELSE
    RETURN QUERY SELECT v_unite_id;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;
```

Policies à créer pour chaque table (SELECT / INSERT / UPDATE / DELETE) selon le tableau des droits du CLAUDE.md.

---

## Étape 11 — Seed : Données initiales

Créer `backend/supabase/seed.sql`.

Insérer les unités organisationnelles de base :
- 1 Bureau Exécutif
- 8 Sous-sections IDF (75, 77, 78, 91, 92, 93, 94, 95)
- Sous-sections hors IDF (une par région administrative)
- 5 Mouvements (JPS · MOJIP · Cadres · Foyers · Maggi Pastef)
- 6 Secrétariats (Finance · Veille Électorale · Communication · Massification · Formation · IT)

Appliquer :
```bash
supabase db reset  # en local
# ou en production :
psql <connection_string> -f supabase/seed.sql
```

---

## Étape 12 — Créer le premier admin

> ⚠️ **À faire plus tard** : remplacer l'email perso par `cockpit@pasteffrance.fr` une fois l'adresse créée.
> Supabase Studio → Authentication → Users → cliquer sur le user → modifier l'email.

## Étape 12 — Créer le premier admin

Dans Supabase Studio → Authentication → Users :
1. Cliquer **Invite user** → saisir l'email de l'admin
2. Dans Table Editor → profiles → trouver le profil créé
3. Mettre à jour : `role = 'bureau_executif'`, `unite_id = <id_bureau_executif>`, `nom`, `prenom`

---

## Récap des fichiers à créer

```
backend/
├── supabase/
│   ├── config.toml
│   ├── migrations/
│   │   ├── 20260506000000_init_types.sql
│   │   ├── 20260506000001_unites_organisationnelles.sql
│   │   ├── 20260506000002_profiles.sql
│   │   ├── 20260506000003_militants.sql
│   │   ├── 20260506000004_finances.sql
│   │   └── 20260506000005_rls_policies.sql
│   └── seed.sql
└── README.md
```

---

## Commandes Supabase CLI utiles

```bash
supabase db push          # Appliquer les nouvelles migrations vers le cloud
supabase db pull          # Récupérer le schéma distant (si modifié via Studio)
supabase db diff          # Voir les différences entre local et cloud
supabase status           # Voir l'état de la connexion
supabase migration list   # Lister les migrations appliquées
```