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
  dans une nouvelle méthode) et `attributes($target)` (ex-`"attributes"` : pop up
  menu des attributs). Appels dans `_4DPop_MACROS.4dm` :
  `cs.method.new().create()` / `cs.method.new().attributes($text)`. Le garde-fou
  « Not yet available in project mode » de `method-attributes` est SUPPRIMÉ
  (activé en mode projet). Décl. interprocess `METHODS` retirée de
  `COMPILER_component.4dm` ; `METHODS` retiré de `folders.json` (+ `method`
  ajouté aux classes du namespace).
  ⚠️ RÈGLE 4D : une classe qui `extends` DOIT avoir un `Class constructor()`
  dont la 1ʳᵉ ligne est `Super()`, sinon les initialiseurs de propriété du
  parent ne s'exécutent pas (`This.title` Null → crash `Match regex` « argument
  alphanumérique attendu »). `method` a donc son constructeur `Super()`.
- **Macro `method-attributes` exposée** : le point d'entrée existait dans le
  dispatcher mais aucune macro ne l'appelait. Ajout de l'entrée
  `_4DPop_MACROS("method-attributes")` dans les 3 XML sources
  (`Macros v2/4DPop_Macros.xml`, `Resources/4DPop_Macros.xml`,
  `Resources/fr.lproj/4DPop_Macros.xml`), après « New method » / « Nouvelle
  méthode ». Noms : « Method attributes… » / « Attributs de la méthode… »,
  `type_ahead_text="_attributes"`. La macro passe le chemin de la méthode
  courante comme 2ᵉ param via le tag `<method_path/>` (même motif que la macro
  « Declarations ») → devient la `$target` de `attributes()` (fallback
  `Current method path` si vide).
- **`attributes()` réservé aux méthodes projet** : `METHOD Get attribute` /
  `METHOD SET ATTRIBUTE` ne fonctionnent QUE sur les méthodes projet (sur une
  classe/méthode objet/database method → erreur -9768 « Invalid object path:
  [class]/method »). Garde en tête de `attributes()` : `If (Not(This.projectMethod))`
  → `ALERT(Localized string("attributesProjectMethodOnly"))` + `return`. Nouvelle
  clé XLIFF `attributesProjectMethodOnly` (en + fr).
- **Menu contextuel via `cs.ui.menu`** (dépendance UI) au lieu des commandes
  natives (`Create menu`/`APPEND MENU ITEM`/`Dynamic pop up menu`). Chaînage
  `.append(label; param; mark).enable(bool)` puis `.popup()` (auto-release,
  `Dynamic pop up menu` à la souris) → `.selected` / `.choice`. ⚠️ `append`
  localise dans le contexte du COMPOSANT UI (pas Macros) : on crée donc le menu
  en `cs.ui.menu.new("no-localization")` et on passe des libellés DÉJÀ localisés
  via `Localized string(...)` (contexte Macros).
- **`Pop up menu` du bouton COMMENTS migré** : `Forms/COMMENTS/ObjectMethods/
  Bouton 3D2.4dm` (insertion de tags `<date/>`, `<time/>`…) utilise désormais
  `cs.ui.menu` (`.append($t;$t)` en boucle, `.popup().selected`, `.choice`) au
  lieu de `Pop up menu` + index `$c[$l-1]`. Seul usage natif restant : le
  brouillon `00_TESTS.4dm` (non commité).
- **Suppression de 8 méthodes `_o_` mortes + `Compiler_`** (0 appelant réel ;
  seules mentions = les blocs `If (False)` de déclaration des `COMPILER_*`) :
  `_o_array_Attributes`, `_o_CENTERED`, `_o_Preferences_Set`, `_o_xml_attributes`,
  `_o_xml_cleanup`, `_o_xml_encode`, `_o_xml_findByName`, `_o_xml_findElement`.
  Le cluster `_o_xml_*` est redondant avec la classe `xml` dispo en dépendance UI.
  `Compiler_.4dm` (ne contenait que ces décl. mortes) supprimé. Déclarations
  retirées de `Compiler_`/`COMPILER_xml`/`COMPILER_component`, entrées retirées de
  `folders.json`. Les 7 `_o_` VIVANTES gardées : `_o_isNumeric`,
  `_o_localizedControlFlow`, `_o_Preferences`, `_o_win_title`,
  `_o_xml_elementToObject`, `_o_xml_fileToObject`, `_o_xml_refToObject`.
- **`_o_xml_*` (les 3 vivantes) → classe `xml`** (`Classes/xml.4dm`, `shared
  singleton`) : `fileToObject($path; $references)` publique (retour inchangé
  `{success; value; errors}`) + helpers privés `_refToObject`, `_elementToObject`
  (récursif), `_collectChildren`. Appels migrés vers `cs.xml.me.fileToObject(...)`
  (settings/preferences/_o_Preferences). Pas de classe `xml` en dépendance (les
  deps sont `pop`, `rgx`, `ui`) → classe LOCALE. `COMPILER_xml` gardé pour la
  seule var `xml_ERROR` (utilisée par `xml_NO_ERROR`), bloc `If (False)` vidé.
  `xml` ajoutée aux classes du namespace dans `folders.json`.
- **`_o_Preferences` → classe `preferences`** (`shared singleton`, `cs.preferences.me`) :
  la classe `preferences` existait mais était MORTE (jamais instanciée) et sa
  `loadPreferences` était BUGGÉE (itérait `M_4DPop` au lieu de `M_4DPop.preferences`).
  Réécrite avec la logique legacy correcte : `_resolveFile`, `_populate() : Boolean`,
  `get($key) : Variant`, `set($key; $value)`, `_decode`/`_encode` (base64), propriété
  `loaded`. Appels migrés : `Init` → `cs.preferences.me.loaded` ; `specialPaste`
  (4×) → `.get()`/`.set()` (valeurs au lieu de pointeurs). SUPPRIMÉS : `_o_Preferences`,
  `Preferences_Get` (mort, 0 appelant réel), `_o_isNumeric` (orphelin ; coercition
  numérique désormais inline `Match regex("^\d+$")`). Clés spéciales `@_file/@_folder/
  @_path` de `Get_Value` abandonnées (jamais utilisées). Décl. retirées de
  `COMPILER_component`, entrées retirées de `folders.json`.
- **`preferences` : abandon total de `Storage`** — le singleton porte l'état en
  mémoire (`property data`, un `New shared object`). Constat : `Storage.macros.`
  `preferences` et `Storage.macros.declarations` étaient écrits mais **relus par
  personne** (la classe `declaration` lit son propre JSON ; `settings` relit le
  fichier). `get($key)` renvoie `This.data[$key]` (in-memory, plus de DOM par
  appel) ; `set` met à jour `This.data` (via `Use`) + le fichier. Le chargement
  des `declarations` (mort) est supprimé. `Storage.macros` (pour `lastUsed` du
  dispatcher) est désormais créé dans `Init`, pas par `preferences`.
- **`_o_win_title` → `macro._windowTitle`** : le helper « titre de fenêtre éditeur
  → nom cible » (split sur `:`, strip du `*` non-sauvé) devient une fonction privée
  de la classe `macro` (seul appelant = `macro` lui-même, pour `<method_name/>`).
  Méthode supprimée, décl. retirée de `COMPILER_component` + `folders.json`.
- **`str_hyphenation` → `specialPaste._hyphenate`** : l'utilitaire de wrapping de
  texte (coupe à N colonnes, respect des délimiteurs) n'était utilisé que par
  `specialPaste` (3×, couplé à `This.columns`). Devient une fonction privée de
  `specialPaste`. Décls `C_`→signature typée. Méthode supprimée, décl. retirée de
  `COMPILER_component` + `folders.json`.
- **Suppression de `Install_regex` (obsolète)** : elle écrivait `regex.xml`
  (patterns `Get_Macro`/`Method_Parsing`/`Get_Locals`…), vestige de la base
  binaire, que PLUS AUCUN code ne relit (le regex actif est inline `Match regex`
  + `cs.rgx.regex`). Son seul rôle dans `Init` était de « garder » l'appel à
  `Install_resources` (elle renvoyait toujours True) → `Init` appelle désormais
  `Install_resources` directement. Décl. retirée de `COMPILER_component`, entrée
  de `folders.json`. (Idem `Private_Boo_Paste_Regex_Pattern`, mort, supprimé.)
- **`_o_localizedControlFlow` → singleton `cs.controlFlow`** : les mots-clés de
  structure (`controlFlow.json`) ne varient pas dans une session → classe
  `shared singleton` (`cs.controlFlow.me`), chargée UNE fois via
  `OB Copy(JSON Parse(...); ck shared)`. API : `get keywords : Collection`
  (intl ou fr selon la langue 4D) + `localized($ctrl) : Text`. Remplace le
  `property _controlFlow` + les 2 chargements JSON inline de `macro` (dont un
  `.fr(...)` corrigé en `.fr[...]`), et les 2 appels `_o_localizedControlFlow(
  ""; ->$array)` de `CODE_TO_EXECUTE`/`CODE_TO_EXECUTE_FORMULA` (→ `COLLECTION
  TO ARRAY(cs.controlFlow.me.keywords; $array)`). `_o_localizedControlFlow`
  supprimée. `win_NOT_UNDER_TOOLBAR` modernisée (`#DECLARE() : Integer` + `var`).
  Le bloc `If (False)` de `COMPILER_component` est désormais VIDE (supprimé) ;
  restent uniquement `<>tTxt_lines`, `M_4DPop_tTxt_Buffer`, `v1..v4`.
- **`<>tTxt_lines` / `M_4DPop_tTxt_Buffer` → locaux** : c'étaient des tableaux
  interprocess/process utilisés UNIQUEMENT comme buffers de travail dans
  `CODE_TO_EXECUTE_FORMULA`. Renommés en `$_lines` / `$_buffer` (locaux). Retirés
  de `COMPILER_component` (ne reste que `var v1;v2;v3;v4`).
- **`CODE_TO_EXECUTE_FORMULA` : passage aux collections** — `$_lines` (les lignes)
  et `$tTxt_controlFlow` (les mots-clés) deviennent des collections (`$lines`,
  `$controlFlow`) au lieu de `COLLECTION TO ARRAY` + travail sur tableau : boucle
  `For each ($Txt_Code; $lines)` (avec compteur `$Lon_Lignes`), test
  `$controlFlow.indexOf($Txt_Command)>=0`. `$_buffer` et `$tTxt_Commands` restent
  des tableaux (ce dernier a une logique index=numéro-de-commande à préserver).
- **`CODE_TO_EXECUTE_FORMULA` dual-mode + méthode de test** : `#DECLARE($code :
  Text) : Text`. Sans paramètre = mode macro (GET/SET MACRO PARAMETER, inchangé
  pour le dispatcher) ; avec un texte = transforme et RETOURNE le résultat.
  Méthode `CODE_TO_EXECUTE_FORMULA_test` (groupe TESTS) : passe des échantillons,
  renvoie les paires `{input; output}` et copie un rapport lisible dans le
  presse-papier.
- **Commentaires via la constante `kCommentMark`** : `CODE_TO_EXECUTE_FORMULA`
  utilisait l'ancien marqueur backtick `` ` `` puis `//` en dur → utilise
  désormais `kCommentMark` (détection `$Txt_Command=kCommentMark+"@"`, préfixe
  `kCommentMark+" "`). Si le marqueur change à l'avenir, seule la constante est à
  mettre à jour (déjà utilisée dans `macro`/`specialPaste`). Échantillons de test
  en `//` littéral (données d'exemple).
- **`macro._comment` modernisée + `v1..v4` supprimés + `COMPILER_component`
  supprimé** : `_comment()` utilisait un hack `Formula from string("4D:C1810(v1;
  v2; v3; v4)")` (appel de la commande n°1810 par numéro) pour retrouver la ligne
  de la sélection. Remplacé par un test simple : ligne entière si la sélection
  figure dans `Split(This.method)` (via `.indexOf`), sinon `/* */` ; multi-ligne
  = bloc `/* */` avec `\r` final (séparateur pour `duplicateAndComment`). Plus de
  `v1..v4` → le dernier contenu de `COMPILER_component` disparaît, donc la méthode
  est SUPPRIMÉE (+ son appel dans `Init`, + entrée `folders.json`). Le composant
  n'a plus aucune méthode de déclaration compilateur.

## À faire / pistes pour la suite
- Poursuivre la migration interprocess → `Form` / objets locaux sur les autres
  formulaires.
- Passer au direct typing pour pouvoir retirer `v1..v4` de COMPILER_component.

## Rappels techniques
- Compiler dans 4D pour valider (pas de compilateur 4D dans l'environnement).
- `.4dm` : indentation par TABULATIONS.
- 4D : pas de `Else if` ; `&`/`|` ne court-circuitent pas → `&&`/`||` ;
  `Length($t)>0` plus rapide que `$t#""`.
