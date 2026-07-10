# Notes de reprise — 4DPop Macros

> Contexte de modernisation. À reprendre demain sur une autre machine.
> Faire `git pull` avant de commencer.

## À faire (prochaine session)
- ✅ **FAIT (2026-07-10)** — `_loadIcons()` sorti de `declaration` vers le
  `shared singleton` `cs.fieldIcons` (chargement 1×/session, **caché par color
  scheme** light/dark pour supporter un switch en cours de session).
  `declaration._loadIcons()` délègue désormais (`This.types:=cs.fieldIcons.me.types`
  + `This.classIcon:=cs.fieldIcons.me.classIcon`).
- Poursuivre la migration interprocess → `Form` / objets locaux sur les autres
  formulaires.
- **Compat 21.1 à retirer** quand le support 21.1 sera abandonné : `field_class_dark.svg`
  (couleurs dark en dur) + la sélection explicite light/dark du chemin d'icône (le
  rendu SVG light/dark natif n'existe qu'à partir de 21R3) → revenir à un seul SVG
  géré via `@media (prefers-color-scheme: dark)`.

## État actuel (branche `main`, synchronisée avec `origin/main`)

Chantier : modernisation du composant, suppression des actions obsolètes en
mode projet, remplacement des variables interprocess (`<>x` / `◊`) par des
propriétés `Form` ou des objets locaux.

### Correctifs clairvoyance récents (commit `374089c`, 2026-07-10, validés en 4D 21.1)
- **Code MULTI-LIGNES (continuation `\`)** : `parse()` replie les lignes physiques
  `\`-continuées en une **ligne logique** (helpers `_logicalLineAt` /
  `_stripContinuation`, champ `line.logical` routé vers `_clairvoyant` /
  `_getTypeFromDeclaration` / `_parseParameters`) pour voir tout l'énoncé d'un coup
  (l'indice de type sur une ligne ultérieure — `Length($v)`, `$v:="x"` — n'était
  plus raté) ; chaque ligne physique reste dans `_output` pour une sortie fidèle.
  ⚠️ précédence 4D : parenthéser `($i<(This.lines.length-1))`.
- **Commentaire de fin** cassait l'ancre de fin dans le bloc EXTRACT d'inférence de
  classe → nettoyage (`_cleanCode`+`_trimLine`) : `.membre(...)$` résout à nouveau la
  classe de retour (ex `.file` → 4D.File).
- **Commandes françaises → anglais** (clairvoyance en réglages régionaux FR) : seul
  le français localise les noms de commande. `cs.syntax` construit une map paresseuse
  `frToEn` depuis le fichier livré par 4D `fr.lproj/4D_CommandsFR.xlf` (`<source>`=EN,
  `<target>`=FR, 1430 commandes), bâtie au 1er échec de résolution EN (un projet
  anglais ne paie qu'au pire un parse/session). `commandReturnType`/`commandParamType`
  passent par `_toEnglishCommand` ; on ne traduit que les noms non résolus en EN
  (zéro collision avec les homographes). L'utilitaire dev `createFR2USMacro` (générateur
  de la macro FR→US, à lancer manuellement pour publier la macro) a été restauré.
- Antérieurs : `$o.count:=1`→Object, condition While/Until→Booléen, hoisting
  Repeat/Until, alerte base binaire non supportée.

### Commits récents
- `145074f` — refactor(macros): integrate COMMENTS into macro class and drop
  obsolete project-mode actions (15 fichiers, +225/−1610)
- `f32f499` — refactor(about): modernize ABOUT dialog, remove interprocess
  variables (11 fichiers, +196/−515)
- `f98a118` — chore(compiler): remove unused interprocess declarations, keep
  only what's still needed (−18 lignes)

### Changements réalisés
- **Clairvoyance `declaration` basée sur `syntaxEN.json` (nouveau `cs.syntax`)** :
  la détection du type des variables non déclarées ne s'appuie plus sur
  `gram.4dsyntax` mais sur le fichier `…/Resources/en.lproj/syntaxEN.json` livré
  avec 4D. Nouveau `shared singleton` `Classes/syntax.4dm` (`cs.syntax.me`) chargé
  et parsé UNE fois par session : construit les tables `commands`
  (nom→{ret, params[]}) et `members` (nom→type de retour). API `guessType($var;$line)`,
  `commandReturnType`, `commandParamType($name;$index)`, `memberReturnType`. La
  clairvoyance type désormais une variable à **n'importe quelle position d'argument**
  d'une commande (pas seulement le 1er param) : `params` est la liste ordonnée des
  types (ligne *result* exclue, opérateur `*` = slot 0), et `_argIndex` déduit la
  position en comptant les `;` avant la variable (littéraux `"…"` retirés). Dans
  `declaration` : `property gramSyntax` + `Function _loadGramSyntax()` SUPPRIMÉS,
  la branche `Else` de `_clairvoyant` délègue à `This._syntax.guessType(...)`
  (les heuristiques littérales — littéraux `{}`/`[]`, `.membre`, dates/heures,
  pointeurs, `For`, `If/Not` — restent inline). `$pos`/`$len` sont déclarés en
  `ARRAY LONGINT` et les regex à groupe capturant sont lues via `{1}`/`{2}`.
  - **Sortie enrichie** (`_apply` + `_groupDeclarations`) : les variables de même
    type inférées au même point d'insertion sont regroupées sur une seule ligne
    (`var $a; $b : Text`) ; et si la 1ʳᵉ utilisation d'une variable est sa propre
    affectation, la déclaration et l'affectation sont fusionnées
    (`$x:=…` → `var $x : Type := …`). Les tableaux restent individuels.
  - **Inférence de CLASSE depuis les membres** : `cs.syntax` construit aussi
    `memberClass` (classe du récepteur d'un membre) et `memberReturnClass` (classe
    de retour). Ex : `$file.getText()` → `$file : 4D.File`, `$col.length` →
    `$col : Collection`, `$folder.file("x")` → `$folder : 4D.Folder` et le résultat
    `$child : 4D.File`. Un membre présent sur >3 classes est jugé trop générique
    (pas de classe : `.size`, `.name`) ; sinon la classe est choisie par priorité
    (`Collection`, `4D.File`, `4D.Folder`, `4D.Entity`, `4D.EntitySelection`,
    `Object`, `4D.Blob`). ⚠️ Heuristique : peut se tromper pour un membre ambigu
    (`.extension` deviné `4D.File` même sur un `Folder`) — à revoir au dialogue.
    API `memberReceiverClass($name)`, `memberReturnClass($name)`. Côté
    `declaration` : `_memberReceiver`/`_receiverClassOf` (récepteur) et
    `_returnClassOf` (classe de retour dans le bloc EXTRACT).
  - **Sélecteur de classe dans le dialogue** : dans le formulaire `DECLARATION`,
    l'ancien `Input1` (affichage figé de `Form.current.class`) est remplacé par une
    dropdown `classPopup` (`cs.ui.dropDown`, datasource `Form.classDrop.data`),
    visible seulement pour les variables typées Object. Elle liste toutes les classes
    4D (via `cs.syntax.classNames()`, issu de `syntaxEN.json`) + `Object` (= objet nu)
    + les classes `cs.*`/`4D.*` référencées dans le code (`_classChoices()`). La classe
    trouvée est pré-sélectionnée ; si l'utilisateur en choisit une autre, elle est
    écrite dans `Form.current.class` et prise en compte par `_buildDeclaration`
    (`var $x : 4D.File`). Choisir `Object` remet une déclaration objet nue.
    ⚠️ Nécessite que la dépendance UI-with-Classes fournisse la classe `dropDown`.
  - ⚠️ Découverte : les fichiers `syntax<LANG>.json` de TOUTES les locales ont des
    clés de commande IDENTIQUES en anglais (seules les descriptions sont traduites)
    et des types neutres. On charge donc TOUJOURS `syntaxEN.json`. Conséquence : les
    noms de commandes anglais + tous les attributs/functions (toujours anglais) se
    résolvent ; les noms de commandes FRANÇAIS (option héritée « réglages
    régionaux ») ne se résolvent pas et retombent sur le dialogue, comme avant.
- **`declaration` par fonction sur une classe entière** : quand la fenêtre est
  une classe ET qu'il n'y a **pas de sélection**, `declaration` traite désormais
  chaque `Function` / `Class constructor` séparément (le préambule — `property`,
  `Class extends` — reste intact). Le constructeur aiguille vers `_processClass()`
  (découpe en blocs via `isFunction`/`isConstructor`, `_reset()` + `parse()` +
  `_dialog()` par bloc, réassemblage, un seul `kCaret` conservé) ou `_processScope()`
  (comportement historique : méthode entière ou sélection). Avec sélection dans une
  classe → `_processScope()` (scope sélectionné). Nouvelles fonctions : `_processScope`,
  `_processClass`, `_reset`, `_dialog`. Réutilise `paste`/`split`/`isFunction`/
  `isConstructor`/`class`/`withSelection` hérités de `macro`.
  - **UX** : le titre de la fenêtre du dialogue affiche la fonction courante
    (`SET WINDOW TITLE` via `_dialog($title)` + `_scopeName()`) pour savoir sur
    quelle fonction on définit les types.
  - **Déclarations au plus près de l'usage** : les variables locales SANS
    affectation ne sont plus remontées en bloc en tête ; `_apply` construit une
    déclaration par variable (`_buildDeclaration`) et l'insère juste avant sa
    première utilisation (`_firstUseIndex`, avec remontée au début d'une
    instruction multi-lignes `\` pour ne pas la casser). Les paramètres restent
    dans la signature ; les rares variables sans usage localisé (`$orphans`)
    restent en tête. Suppression du groupage `numberOfVariablePerLine`.
  - **Fix parse** : un paramètre nommé référencé uniquement dans une ligne de
    déclaration (`var $x:=…($param…)`) était compté 0 fois (rapporté « non
    utilisé »). La branche DECLARATION LINE de `parse()` teste désormais
    `This.parameters` avant de créer un local (comme le fait déjà la branche
    EXTRACT LOCAL VARIABLES).
  - **Dialogue seulement si nécessaire** (`_needsDialog()`) : on n'ouvre le
    dialogue que si une déclaration MANQUE (local utilisé jamais déclaré) ou si
    une variable est INUTILISÉE (count 0, hors valeur de retour). Sinon on
    applique les règles en silence (`_apply` direct). Fonction sans variable →
    laissée intacte. Si AUCUNE fonction n'a eu besoin du dialogue → une seule
    alerte « Toutes les déclarations ont été vérifiées » (clé XLIFF
    `allDeclarationsVerified`, en+fr). Correctif au passage : les fonctions sans
    variable n'étaient plus réinsérées dans la classe (Else manquant) — corrigé
    via un `Case of`.
  - ⚠️ Limite connue : la branche DECLARATION LINE de `parse()` ne distingue pas
    le LHS du RHS. Un token utilisé uniquement dans l'initialiseur d'un autre
    `var` (`var $token:=Substring($result;…)`) ne doit PAS être considéré comme
    déclaré — d'où le fait qu'on n'y force PAS `inDeclaration` sur les locals
    déjà connus (sinon `_needsDialog` afficherait « vérifié » alors que `_apply`
    ajoute quand même la déclaration).
  - **Message « vérifié » informatif** : 3 lignes (`allDeclarationsVerified` +
    `allVariablesDeclared` + `noUnusedVariable`, clés XLIFF en+fr) via
    `_verifiedMessage()`.
  - **Lignes vides parasites (méthode projet)** : deux corrections dans `_apply`.
    (1) Si rien à remonter en tête (aucun paramètre, locals au fil de l'eau) on
    n'exécute plus la logique de placement (qui insérait `\r` + caret → lignes
    vides) ; `$method:=""`. (2) La boucle restore supprime les lignes vides
    situées **dans la zone de déclarations en tête** — c.-à-d. entre la première
    déclaration retirée (déplacée au fil de l'eau) et la première ligne de code
    (`$removedDeclSeen && Not($codeSeen)`). Les blancs AVANT cette zone (après
    l'en-tête de fonction) ou APRÈS du vrai code sont préservés. (Une 1re version
    qui supprimait tout blanc jouxtant une déclaration retirée effaçait à tort les
    blancs structurels d'une fonction déjà propre — remplacée par la règle de zone.)
- **Regex externalisées — `declaration` (registre uniquement)** : le registre
  `_patterns` du constructeur (détection de type des `var`, gabarit `{type}`) migré
  vers `Resources/regex/declaration.txt` (`_dx` : `varType`/`classType`/
  `varWithAssignment`). **Décision : les ~48 regex inline des méthodes restent
  inline** (dupliquées, concaténées multi-lignes, échappements piégeux à préserver ;
  trop risqué sans compilateur). Ne pas chercher à « finir ».
- **Regex externalisées — `beautifier` (complet)** : registre du constructeur
  ET regex inline des méthodes (`before()` `{C_}`/`{op}`, `splitTests`,
  `_controls.caseOfItem`, `maybeFormatComment`, `_splitLiterals`…) migrés vers
  `Resources/regex/beautifier.txt` (29 clés). Constructeur via `$rx:=This._bx` ;
  méthodes via `This._bx.<clé>` (propriété distincte de `_rx` hérité de `macro`).
  Le singleton `patterns._resolve` résout au chargement `{commentMark}` et
  `{cmdNNN}` ; les jetons par-item (`{control}`, `{closure}`, `{closures}`,
  `{if}/{else}/{endIf}`, `{command}`, `{C_}`, `{op}`, `{1}/{2}`) restent
  substitués dans le code. **Compilé + testé OK dans 4D (2026-07-08).** Reste :
  `declaration` (54).
- **Regex externalisées (pilote sur `macro`)** : nouvelle classe `patterns`
  (shared singleton, `cs.patterns.me`) qui charge les regex depuis
  `/RESOURCES/regex/*.txt` (un fichier = un groupe ; lignes `clé<TAB>regex brute`,
  **sans échappement 4D**). `macro` référence désormais `This._rx.<clé>`
  (17 patterns migrés vers `Resources/regex/macro.txt`). Format texte choisi car
  JSON exigerait encore `\\`. À étendre à `beautifier` (29) et `declaration` (54)
  si le pilote convient — attention : ces classes ont des **gabarits**
  (`{control}`, `{type}`…) → stocker le gabarit, garder la substitution en code.
- **Localisation des messages** : tous les messages utilisateur littéraux
  (`ALERT`/`Request`) passés en `Localized string` avec 9 nouvelles clés XLIFF
  (en+fr, groupe `messages`) : `macroNeedsMethod`, `macroNeedsSelection`,
  `unknownMacroAction`, `obsoleteMacroAction`, `warningReference`,
  `noVariableToDeclare`, `notAConstant`, `noTextInPasteboard`, `textMustBeQuoted`.
  Concerne `_runMacro`, `macro`, `declaration`. Laissés en anglais : les `ASSERT`
  (diagnostics développeur) et les 2 ALERT d'inspection de valeur `[nom] (Text/
  Numeric) = valeur` (relevé, pas une phrase).
- **`_runMacro` : alerte explicative en cas d'échec** : lorsqu'une action échoue
  (`$success=False`), une `ALERT` indique désormais la raison (variable `$reason`) :
  « requires a method », « requires selected text », ou « Unknown or unavailable
  macro action: <action> ». Le `BEEP` est conservé.
- **Notation littérale objet/collection** : remplacement de `New object(...)` /
  `New collection(...)` par `{clé: valeur; …}` / `[…]` dans tout le code
  production (classes `settings`, `specialPaste`, `macro` ; formulaires `SETTINGS`,
  `COMMENTS`, `DECLARATIONS_SETTINGS`). `New shared object/collection` inchangés
  (pas de littéral partagé).
- **Option « Method syntax » (déclaration) supprimée** : avec le direct typing,
  l'option `methodDeclaration` (bloc `If(False)` de directives de compilation
  `4d:C…(nom;$0)` inséré en tête des méthodes projet) est obsolète. Retirée
  partout : classe `declaration` (bloc consommateur + toute la construction morte
  de `$compilerDirectives`), `Resources/default.settings`, migration XML→JSON de
  `settings.convertXmlPrefToJson`, checkbox `projectMethodDirective` du formulaire
  `DECLARATIONS_SETTINGS`, et chaînes XLIFF `MethodSyntax_Option`/`_Comment`
  (en+fr). Le `#DECLARE(...)` moderne reste inchangé.
- **Documentation 4D (markdown)** : ajout de `Documentation/Classes/<Classe>.md`
  (11) et `Documentation/Methods/<Méthode>.md` (19 méthodes production), selon la
  norme 4D (commentaire HTML de résumé = tooltip éditeur, `## Description`,
  `## Parameters`/`## Functions`, `## Example` en ```4d```). En anglais. Les
  `.DS_Store` sont ignorés par git.
- **Renommage dispatcher** : `_4DPop_MACROS` → `_runMacro`
  (`Project/Sources/Methods/_runMacro.4dm`). Nom plus parlant, sans « 4DPop ».
  Références mises à jour : `folders.json` (groupe ⚙️ MACROS), les 3 XML de
  macros (`Macros v2/`, `Resources/`, `Resources/fr.lproj/` — 26 appels chacun),
  en-tête de la méthode. Appelé en interne via `Current method name` (dynamique),
  donc pas d'autre appelant `.4dm` à modifier.
- **Dispatcher** `_runMacro.4dm` / `METHODS.4dm` : suppression des actions
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
  menu des attributs). Appels dans `_runMacro.4dm` :
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
  `_runMacro("method-attributes")` dans les 3 XML sources
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
- **Nommage `CODE_TO_EXECUTE_FORMULA`** : variables à préfixe hongrois renommées en
  camelCase parlant (`$Lon_Lignes`→`$lineNumber`, `$Txt_Code`→`$line`,
  `$Txt_Command`→`$command`, `$Lon_Position`→`$position`,
  `$Lon_CommandParameters`→`$parameterCount`, `$Lon_x`→`$commandIndex`,
  `$Lon_i`→`$i`, `$tTxt_Commands`→`$commandNames`). `$Lon_Error` (inutilisé)
  supprimé. `$_buffer` conservé (pas de préfixe de type). À faire ailleurs :
  `Method6`, `Forms/CREATE_BUTTON/.../source` (hors fichiers d'exemple/test).
- **Commentaires via la constante `kCommentMark`** : `CODE_TO_EXECUTE_FORMULA`
  utilisait l'ancien marqueur backtick `` ` `` puis `//` en dur → utilise
  désormais `kCommentMark` (détection `$command=kCommentMark+"@"`, préfixe
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
- **Compat 21.1** : retirer `field_class_dark.svg` + la sélection light/dark du
  chemin d'icône quand le support 21.1 sera abandonné (SVG light/dark natif ≥ 21R3).
- Heuristique de classe par priorité (`memberReceiverClass` / `_returnClassOf`) peut
  se tromper sur un membre ambigu (`.extension` → 4D.File même sur un Folder) :
  corrigé par l'utilisateur au dialogue (dropdown de classes) — compromis assumé.
- ✅ **FAIT (2026-07-10)** — commandes **françaises** (réglages régionaux) mappées vers
  l'anglais via `fr.lproj/4D_CommandsFR.xlf` (map paresseuse `cs.syntax.frToEn`), donc
  la clairvoyance type aussi le code en commandes françaises.

## Rappels techniques
- Compiler dans 4D pour valider (pas de compilateur 4D dans l'environnement).
- `.4dm` : indentation par TABULATIONS.
- 4D : pas de `Else if` ; `&`/`|` ne court-circuitent pas → `&&`/`||` ;
  `Length($t)>0` plus rapide que `$t#""`.
