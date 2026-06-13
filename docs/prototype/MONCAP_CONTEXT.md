# MONCAP_CONTEXT.md
# Instructions complémentaires pour Claude Code
# NE PAS toucher à ce qui existe déjà sur Pastef France

---

## CE QUI NE CHANGE PAS

Tout ce que tu as déjà développé sur **Pastef France** reste tel quel.
Ne modifie aucune table existante, aucune feature existante.

---

## CE QUI S'AJOUTE — 2 choses uniquement

### 1. Le modèle multi-tenant
### 2. Moncap Diaspora Authentique

---

## 1. MODELE MULTI-TENANT

### Pourquoi
Un cadre de la diaspora vivant en France peut être :
- Membre de **Moncap** (cadre diaspora)
- ET militant de **Pastef France** (section France)

C'est la même personne physique. Un seul compte. Deux appartenances.

### Ce qu'il faut ajouter à la BDD existante

```sql
-- Table des organisations (si elle n'existe pas encore)
CREATE TABLE IF NOT EXISTS tenants (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug        TEXT UNIQUE NOT NULL,
  nom         TEXT NOT NULL,
  tagline     TEXT,
  actif       BOOLEAN DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- Insérer les deux tenants
INSERT INTO tenants (slug, nom, tagline) VALUES
  ('pastef-france', 'Pastef France', 'Piloter · Mobiliser · Agir'),
  ('moncap', 'Moncap Diaspora', 'Authentique')
ON CONFLICT (slug) DO NOTHING;

-- Table pivot : appartenance d'un profil à un ou deux tenants
CREATE TABLE IF NOT EXISTS profil_tenants (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profil_id     UUID NOT NULL,   -- Référence l'utilisateur Supabase Auth
  tenant_id     UUID NOT NULL REFERENCES tenants(id),
  role          TEXT NOT NULL,
  perimetre_id  UUID,            -- SS, commission, mouvement...
  actif         BOOLEAN DEFAULT true,
  created_at    TIMESTAMPTZ DEFAULT now(),
  UNIQUE(profil_id, tenant_id)
);
```

### Ce que ça change dans l'app

```
Connexion → email + mot de passe
              ↓
         1 seul compte
              ↓
    Vérifier profil_tenants
              ↓
    1 tenant → accès direct
    2 tenants → écran de choix :
         🇸🇳 Pastef France
         🎓 Moncap Diaspora Authentique
```

### Cas concret : Aminata
```
Aminata Sow — 1 compte email : aminata@gmail.com

profil_tenants :
  → tenant: pastef-france  · role: resp_sous_section · perimetre: SS-75
  → tenant: moncap         · role: resp_commission   · perimetre: Commission Santé
```

### RLS à ajouter
```sql
-- Chaque utilisateur ne voit que les données de son/ses tenant(s)
-- A appliquer sur les tables existantes Pastef France
-- ET sur les nouvelles tables Moncap

CREATE POLICY "tenant_isolation" ON [table]
  USING (
    tenant_id IN (
      SELECT tenant_id FROM profil_tenants
      WHERE profil_id = auth.uid()
      AND actif = true
    )
  );
```

---

## 2. MONCAP DIASPORA AUTHENTIQUE

### Structure organisationnelle

```
Bureau Moncap (14 postes)
    Coordinateur/trice + Adjoint/e
    Resp/Adj : Secrétariat · Communication · Finance
               Massification · Organisation · Scientifique

Pôle Scientifique
    Coordonne les 20 commissions thématiques

20 Commissions (Resp + Adj + membres listés)
```

### Les 20 commissions officielles

```
GOUVERNANCE & INSTITUTIONS
  1. Décentralisation & Réforme Territoriale
  2. Affaires Étrangères et Panafricanisme
  3. Défense et Sécurité
  4. Justice et Questions Juridiques
  5. Bonne Gouvernance, Patriotisme et Citoyenneté

ÉCONOMIE & FINANCES
  6.  Économie, Finances Publiques et Budget
  7.  Commerce, Entrepreneuriat et PME
  8.  Industrie, Mines et Carrières
  9.  Travail, Emploi et Fonction Publique

INFRASTRUCTURE & ENVIRONNEMENT
  10. Transport et Infrastructures
  11. Habitat et Aménagement du Territoire
  12. Énergie et Hydraulique
  13. Environnement et Cadre de Vie

SOCIAL & HUMAIN
  14. Santé et Protection Sociale
  15. Éducation Nationale
  16. Enseignement Supérieur et Formation Professionnelle
  17. Sport
  18. Culture, Tourisme et Artisanat

SCIENCE & INNOVATION
  19. Recherche Scientifique et Technologique
  20. Agriculture, Élevage et Pêche
```

### Rôles Moncap

```
bureau_moncap           Vue globale — tous droits
pole_scientifique       Toutes commissions — coordination
resp_commission         Sa commission — membres, travaux, docs
membre_commission       Sa commission — contribuer aux travaux
resp_finance_moncap     Finances Moncap
```

### Tables à créer (nouvelles — ne touchent pas à Pastef France)

```sql
-- Commissions thématiques
CREATE TABLE mc_commissions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID NOT NULL REFERENCES tenants(id),
  nom             TEXT NOT NULL,
  slug            TEXT NOT NULL,
  bloc_thematique TEXT NOT NULL,
  description     TEXT,
  actif           BOOLEAN DEFAULT true,
  ordre           INTEGER
);

-- Membres des commissions
CREATE TABLE mc_commission_membres (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  commission_id   UUID NOT NULL REFERENCES mc_commissions(id),
  profil_id       UUID NOT NULL,
  role            TEXT DEFAULT 'membre',
  date_entree     DATE DEFAULT CURRENT_DATE,
  actif           BOOLEAN DEFAULT true,
  UNIQUE(commission_id, profil_id)
);

-- Travaux intellectuels
CREATE TABLE mc_travaux (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id           UUID NOT NULL REFERENCES tenants(id),
  commission_id       UUID NOT NULL REFERENCES mc_commissions(id),
  titre               TEXT NOT NULL,
  type                TEXT NOT NULL,
  auteur_principal_id UUID,
  co_auteurs          UUID[],
  statut              TEXT DEFAULT 'brouillon',
  visibilite          TEXT DEFAULT 'interne',
  document_url        TEXT,
  created_at          TIMESTAMPTZ DEFAULT now()
);

-- Base documentaire Moncap
CREATE TABLE mc_documents (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID NOT NULL REFERENCES tenants(id),
  commission_id   UUID REFERENCES mc_commissions(id),
  titre           TEXT NOT NULL,
  type            TEXT,
  visibilite      TEXT DEFAULT 'interne',
  url             TEXT NOT NULL,
  format          TEXT,
  uploaded_by     UUID,
  created_at      TIMESTAMPTZ DEFAULT now()
);

-- Cotisations Moncap (structure différente de Pastef France)
CREATE TABLE mc_cotisations (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID NOT NULL REFERENCES tenants(id),
  profil_id       UUID NOT NULL,
  montant         DECIMAL(10,2) NOT NULL,
  periode         TEXT NOT NULL,
  mode_paiement   TEXT,
  created_at      TIMESTAMPTZ DEFAULT now()
);

-- Matrice des compétences
CREATE TABLE mc_competences (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profil_id       UUID NOT NULL,
  domaine         TEXT NOT NULL,
  niveau          TEXT NOT NULL,
  annees_exp      INTEGER,
  commission_liee UUID REFERENCES mc_commissions(id),
  created_at      TIMESTAMPTZ DEFAULT now()
);

-- Profil expert enrichi
CREATE TABLE mc_profil_expert (
  profil_id               UUID PRIMARY KEY,
  cv_url                  TEXT,
  disponible_senegal      TEXT DEFAULT 'non',
  type_contribution       TEXT[],
  duree_mission           TEXT[],
  preavis                 TEXT,
  pays_residence          TEXT,
  institution             TEXT,
  titre_professionnel     TEXT,
  langues                 TEXT[],
  updated_at              TIMESTAMPTZ DEFAULT now()
);

-- Diplômes et certifications
CREATE TABLE mc_diplomes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profil_id       UUID NOT NULL,
  titre           TEXT NOT NULL,
  etablissement   TEXT NOT NULL,
  pays            TEXT,
  annee           INTEGER,
  document_url    TEXT,
  verifie         BOOLEAN DEFAULT false
);

-- Références professionnelles
CREATE TABLE mc_references (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profil_id       UUID NOT NULL,
  nom_referent    TEXT NOT NULL,
  titre           TEXT,
  organisation    TEXT,
  email           TEXT,
  telephone       TEXT,
  relation        TEXT
);

-- Recommandations inter-membres
CREATE TABLE mc_recommandations (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profil_id           UUID NOT NULL,
  recommande_par_id   UUID NOT NULL,
  texte               TEXT NOT NULL,
  domaine             TEXT,
  created_at          TIMESTAMPTZ DEFAULT now()
);

-- Transmissions aux autorités sénégalaises
-- TRACABILITE COMPLETE — chaque action est enregistrée
CREATE TABLE mc_transmissions (
  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id               UUID NOT NULL REFERENCES tenants(id),
  ref_numero              TEXT UNIQUE NOT NULL,
  autorite                TEXT NOT NULL,
  motif                   TEXT NOT NULL,
  date_demande            DATE NOT NULL,
  recherche_par_id        UUID,
  criteres_recherche      JSONB,
  profils_consideres      UUID[],
  valide_par_id           UUID,
  valide_par_adjoint_id   UUID,
  date_transmission       TIMESTAMPTZ,
  resultat                TEXT,
  rapport_pdf_url         TEXT,
  created_at              TIMESTAMPTZ DEFAULT now()
);

-- Consentement de chaque membre pour une transmission
CREATE TABLE mc_transmission_membres (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  transmission_id UUID NOT NULL REFERENCES mc_transmissions(id),
  profil_id       UUID NOT NULL,
  consent_donne   BOOLEAN,
  consent_date    TIMESTAMPTZ,
  UNIQUE(transmission_id, profil_id)
);
```

### Seed des commissions

```sql
DO $$
DECLARE v_tenant UUID;
BEGIN
  SELECT id INTO v_tenant FROM tenants WHERE slug = 'moncap';

  INSERT INTO mc_commissions (tenant_id, nom, slug, bloc_thematique, ordre) VALUES
  (v_tenant, 'Décentralisation & Réforme Territoriale', 'decentralisation', 'gouvernance', 1),
  (v_tenant, 'Affaires Étrangères et Panafricanisme', 'affaires-etrangeres', 'gouvernance', 2),
  (v_tenant, 'Défense et Sécurité', 'defense', 'gouvernance', 3),
  (v_tenant, 'Justice et Questions Juridiques', 'justice', 'gouvernance', 4),
  (v_tenant, 'Bonne Gouvernance, Patriotisme et Citoyenneté', 'gouvernance', 'gouvernance', 5),
  (v_tenant, 'Économie, Finances Publiques et Budget', 'economie', 'economie', 6),
  (v_tenant, 'Commerce, Entrepreneuriat et PME', 'commerce', 'economie', 7),
  (v_tenant, 'Industrie, Mines et Carrières', 'industrie', 'economie', 8),
  (v_tenant, 'Travail, Emploi et Fonction Publique', 'travail', 'economie', 9),
  (v_tenant, 'Transport et Infrastructures', 'transport', 'infrastructure', 10),
  (v_tenant, 'Habitat et Aménagement du Territoire', 'habitat', 'infrastructure', 11),
  (v_tenant, 'Énergie et Hydraulique', 'energie', 'infrastructure', 12),
  (v_tenant, 'Environnement et Cadre de Vie', 'environnement', 'infrastructure', 13),
  (v_tenant, 'Santé et Protection Sociale', 'sante', 'social', 14),
  (v_tenant, 'Éducation Nationale', 'education', 'social', 15),
  (v_tenant, 'Enseignement Supérieur et Formation Professionnelle', 'enseignement-superieur', 'social', 16),
  (v_tenant, 'Sport', 'sport', 'social', 17),
  (v_tenant, 'Culture, Tourisme et Artisanat', 'culture', 'social', 18),
  (v_tenant, 'Recherche Scientifique et Technologique', 'recherche', 'science', 19),
  (v_tenant, 'Agriculture, Élevage et Pêche', 'agriculture', 'science', 20);
END $$;
```

### Visibilité des travaux

```
interne      → Commission uniquement
moncap       → Tous les membres Moncap
partageable  → Peut être diffusé à l'extérieur (autorités, presse...)
```

### Workflow transmission aux autorités
```
1. Demande autorité enregistrée (qui demande, pourquoi)
2. Recherche par Pôle Scientifique (critères loggés)
3. Sélection profils + justification → soumis au Bureau
4. Consentement explicite de chaque membre concerné
5. Double signature : Coordinateur + Adjoint obligatoire
6. Génération rapport PDF officiel horodaté
7. Transmission + archivage
8. Suivi du résultat (recruté / en discussion / sans suite)
```

### Charte graphique Moncap

```dart
static const Color mcPrimary   = Color(0xFF0A2463); // Bleu nuit
static const Color mcSecondary = Color(0xFF1E3A8A); // Bleu profond
static const Color mcAccent    = Color(0xFFC8950A); // Or
// Topbar : dégradé bleu nuit → bleu profond
// Tagline dorée : "Diaspora Authentique"
```

---

## 3. APPARTENANCE CROISEE — Ce qu'il faut coder

### Dans l'auth feature (à modifier légèrement)
```dart
// Après connexion, vérifier les tenants de l'utilisateur
final tenants = await profil_tenants
  .select('tenant_id, role, tenants(slug, nom)')
  .eq('profil_id', user.id)
  .eq('actif', true);

if (tenants.length == 1) {
  // Accès direct au bon tenant
  goTo(tenants[0].tenant.slug);
} else if (tenants.length > 1) {
  // Afficher l'écran de choix
  goTo('/choix-organisation');
}
```

### Écran de choix (à créer)
```
┌─────────────────────────────┐
│        COCKPIT              │
│                             │
│  Choisir votre espace :     │
│                             │
│  🇸🇳  Pastef France         │
│      Piloter·Mobiliser·Agir │
│                             │
│  🎓  Moncap Diaspora        │
│      Authentique            │
└─────────────────────────────┘
```

---

## RESUME DES ACTIONS A FAIRE

```
1. CREER   → table tenants (si absente)
2. CREER   → table profil_tenants
3. INSERER → les 2 tenants (pastef-france, moncap)
4. CREER   → toutes les tables mc_*
5. INSERER → les 20 commissions (seed)
6. AJOUTER → RLS tenant_isolation sur les tables existantes
7. MODIFIER → feature auth : ajouter logique sélecteur tenant
8. CREER   → écran de choix d'organisation
9. CREER   → toutes les features moncap/ dans lib/features/moncap/

NE PAS TOUCHER → tout ce qui existe déjà sur Pastef France
```

---
Version : 1.0 — Mai 2025
Complément au contexte existant — Moncap + Multi-tenant
