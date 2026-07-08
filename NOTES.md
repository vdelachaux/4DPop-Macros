# Notes de reprise — 4DPop Macros

> Contexte de modernisation. À reprendre demain sur une autre machine.
> Faire `git pull` avant de commencer.

## État actuel (branche `main`, synchronisée avec `origin/main`)

Chantier : modernisation du composant, suppression des actions obsolètes en
mode projet, remplacement des variables interprocess (`<>x` / `◊`) par des
propriétés `Form` ou des objets locaux.

### Commits récents
- `145074f` — refactor(macros): integrate COMMENTS into macro class and drop
  obsolete project-mode actions (15 fichiers, +225/−1610)
- `f32f499` — refactor(about): modernize ABOUT dialog, remove interprocess
  variables (11 fichiers, +196/−515)
- `f98a118` — chore(compiler): remove unused interprocess declarations, keep
  only what's still needed (−18 lignes)

### Changements réalisés
- **Dispatcher** `_4DPop_MACROS.4dm` / `METHODS.4dm` : suppression des actions
  obsolètes (`method-export`, `method-list`, `export`, `list`, branches
  `_display_list@`). Conservé : `new`, `attributes`, `about`.
- **Formulaire LIST** : dossier `Forms/LIST/` supprimé + entrée retirée de
  `folders.json`.
- **Formulaire ABOUT** modernisé :
  - `method.4dm` : `FORM Event`, propriétés `Form.flip/image/macro/buffer/`
    `displayed/autoHide/picture`, `getResource("scomber";"PICT")`, correctif
    d'affichage initial du logo via `OBJECT SET VALUE("_Background"; Form.picture)`
    en On Load et à `flip=90`.
  - `ABOUT.4dm` : `DIALOG("ABOUT"; {…})` avec objet de paramètres.
  - `form.4DForm` : `_Background`→`Form.picture`, `Variable1`→`Form.displayed`,
    `Titles_12`→input lié `Form.version`.
  - Nouvelle méthode `getResource.4dm` : `#DECLARE($name:Text; $type:Text):Picture`
    (retourne une Picture directement, sans pointeur).
  - Supprimées : `Get_resource.4dm`, `Get_Version.4dm`, `_o_Files_And_Folders.4dm`,
    `ABOUT/ObjectMethods/Bouton invisible1.4dm`.
- **COMPILER_component.4dm** : suppression des déclarations interprocess
  inutilisées. **Conservés** : `<>tTxt_lines` et `M_4DPop_tTxt_Buffer` (utilisés
  par `CODE_TO_EXECUTE_FORMULA.4dm`) ; `var v1;v2;v3;v4 : Variant` (nécessaires à
  `macro.4dm` → `Formula from string("4D:C1810(v1;v2;v3;v4)")` tant que le direct
  typing n'est pas prêt).
- **Suppression `OPTIONS_GET` / `OPTIONS_SET`** (méthodes propres aux bases
  binaires, déplacées vers `Project/Trash/Methods/`) : les 2 déclarations
  associées retirées de `COMPILER_component.4dm` ; groupe `Binary database`
  passé en corbeille dans `folders.json` (`(Binary database)` sous `trash`,
  retiré de `📦 COMPONENT`). Aucun appelant vivant restant (seules occurrences
  hors trash = `DerivedData/`, régénéré au build).
- **`METHODS` → classe `method`** (`Classes/method.4dm`, `extends macro`) : le
  dispatcher project method `METHODS` est supprimé. Ses 2 entry points
  deviennent des fonctions : `create()` (ex-`"new"` : extraction de la sélection
  dans une nouvelle méthode) et `attributes()` (ex-`"attributes"` : pop up menu
  des attributs, cible = `This.highlighted`). Appels dans `_4DPop_MACROS.4dm` :
  `cs.method.new().create()` / `cs.method.new().attributes()`. Le garde-fou
  « Not yet available in project mode » de `method-attributes` est SUPPRIMÉ
  (activé en mode projet). Décl. interprocess `METHODS` retirée de
  `COMPILER_component.4dm` ; `METHODS` retiré de `folders.json` (+ `method`
  ajouté aux classes du namespace).

## À faire / pistes pour la suite
- Poursuivre la migration interprocess → `Form` / objets locaux sur les autres
  formulaires.
- Passer au direct typing pour pouvoir retirer `v1..v4` de COMPILER_component.

## Rappels techniques
- Compiler dans 4D pour valider (pas de compilateur 4D dans l'environnement).
- `.4dm` : indentation par TABULATIONS.
- 4D : pas de `Else if` ; `&`/`|` ne court-circuitent pas → `&&`/`||` ;
  `Length($t)>0` plus rapide que `$t#""`.
