### 1- Qu'est-ce que Bicep ?

Microsoft le décrit comme un DSL (Domain Specific Language) permettant de décrire de manière déclarative les ressources Azure. Lors du déploiement, le code Bicep est automatiquement compilé en modèle ARM JSON, puis envoyé à Azure Resource Manager.

Le cycle est donc :

Bicep -> ARM Template (JSON) -> Azure Resource Manager -> Création des ressources

### 2- Pourquoi Microsoft a créé Bicep ?

Avant Bicep, il fallait écrire des fichiers ARM en JSON.
Les fichiers dépassaient rapidement plusieurs milliers de lignes.

```bash
{
   "type": "Microsoft.Storage/storageAccounts",
   "apiVersion":"2023-05-01",
   ...
}
```

Bicep simplifie énormément cela !

### 3- Terraform vs Bicep

| Terraform       | Bicep                   |
| --------------- | ----------------------- |
| Multi-cloud     | Azure uniquement        |
| HCL             | DSL Bicep               |
| Terraform State | Pas de state file local |
| Providers       | Azure Resource Manager  |
| Plan            | What-if                 |
| Apply           | Deploy                  |
| Modules         | Modules                 |
| Variables       | Parameters              |

### 4- Gestion du State

Terraform possède : terraform.tfstate qui contient l'état.
Bicep n'a pas de fichier d'état local.C'est Azure Resource Manager qui connaît déjà l'état de ton infrastructure. Lors d'un déploiement, ARM compare l'état actuel avec l'état désiré décrit dans le fichier Bicep et applique uniquement les changements nécessaires.

### 5- Pourquoi utiliser Bicep ?

Les principaux avantages sont :

syntaxe beaucoup plus lisible que les templates ARM JSON ;
prise en charge immédiate des nouveaux services et versions d'API Azure ;
autocomplétion et vérification de types dans VS Code ;
calcul automatique de nombreuses dépendances entre ressources ;
modularité (réutilisation de fichiers Bicep) ;
déploiements idempotents (relancer le même fichier produit le même état cible).

### 6- Les concepts principaux

Parameters :

```bash

param location string

```

Variables :

```bash

var appName = 'myApp'

```

Resource :

```bash

resource webApp 'Microsoft.Web/sites@2024-04-01' = {}

```

Output :

```bash

output endpoint string = webApp.properties.defaultHostName

```

Modules :

```bash

main.bicep

network.bicep

database.bicep

app.bicep

```

### 7- Travailler avec Bicep en local !

Même si tu ne déploies pas sur Azure, tu pourras compiler, valider la syntaxe et explorer les fonctionnalités.

1- Extension Bicep pour VS Code :

- Autocomplétion IntelliSense
- Coloration syntaxique
- Validation en temps réel
- Documentation intégrée
- Navigation entre modules
- Suggestions de propriétés

2- Azure CLI (installation dépend de votre OS) :
Télécharge-le depuis le site officiel : https://learn.microsoft.com/cli/azure/install-azure-cli

La plupart des commandes Bicep passent par az.De plus Azure télécharge automatiquement la dernière version de Bicep

```bash

az --version

```

```bash

az bicep version

```

### 8- Commandes utiles que tu utiliseras souvent

Compiler : résulatat ARM JSON template

```bash

az bicep build --file main.bicep

```

Formatter :

```bash

az bicep format --file main.bicep

```

Décompiler un ARM JSON :

```bash

az bicep decompile --file azuredeploy.json

```

### Chapitre 1 — Hello Bicep

Un fichier Bicep est simplement une description déclarative de l'état souhaité de ton infrastructure.

Il contient généralement :

paramètres (param)
variables (var)
ressources (resource)
sorties (output)

Tous ne sont pas obligatoires.

Le plus petit fichier Bicep valide peut ne contenir qu'un output.

Crée :

```
01-Hello-Bicep/
    main.bicep
```

Puis :

```bash

output message string = 'Hello Bicep!'

```

Compile :

```bash

az bicep build --file .\01-Hello-Bicep\main.bicep

```

Tu obtiendras :

```
main.json

```

Conclusion : Bicep n'est jamais exécuté directement. Il est toujours compilé en ARM JSON.

Ce qu'il faut retenir : - .bicep est le fichier source. - .json est le fichier généré. - Azure ne comprend que l'ARM JSON. - Bicep sert uniquement à écrire ce JSON plus facilement.

### Chapitre 2 — Parameters

Sans paramètres, ton infrastructure est "codée en dur" (hardcoded).

Le problème :

- si tu veux changer le nom ➜ modifier le code
- si tu veux changer la région ➜ modifier le code
- si tu veux créer un environnement DEV et PROD ➜ dupliquer le fichier

Solution : Rendre un template réutilisable.On remplace les valeurs fixes par des paramètres.

Exemple : storageName est obligatoire ou location est optionnel (car une valeur par défaut est fournie)

Les types disponibles :

- param appName string

- param replicas int

- param enableHttps bool

- param tags object

- param regions array

Les paramètres seront fournis au moment du déploiement.

Bicep permet un maximum de 256 paramètres.

Les paramètres utilisent des décorateurs pour les contraintes ou les métadonnées.

Vous pouvez marquer les paramètres de type chaîne ou objet comme sécurisés. Lorsqu'un paramètre est annoté avec @secure(), Azure Resource Manager considère sa valeur comme sensible, empêchant ainsi son enregistrement dans l'historique des déploiements, le portail Azure et les sorties de ligne de commande.

utiliser les paramètres pour :

-tags
-environment
-SKU
-config

### Chapitre 3 — Variables

Une variable est une valeur calculée à partir du template.

Contrairement à un paramètre :

elle n'est jamais fournie par l'utilisateur ;
elle est déterminée automatiquement.

On peut résumer ainsi :

- param → vient de l'extérieur.
- var → est calculée à l'intérieur.

Elle ne peut pas être modifiée.

Utiliser var pour :

- construire des noms
- concaténer des chaînes
- calculer des chemins
- éviter les répétitions
- simplifier la lecture

Resource Manager résout les variables avant de lancer les opérations de déploiement. Partout où la variable est utilisée dans le fichier Bicep, Resource Manager la remplace par sa valeur résolue. Un fichier Bicep est limité à 512 variables.

Utilisez @export() pour partager la variable avec d'autres fichiers Bicep. Pour plus d'informations.

| `param`                             | `var`                                        |
| ----------------------------------- | -------------------------------------------- |
| Vient de l'utilisateur              | Calculée dans le template                    |
| Peut changer entre les déploiements | Déterminée par la logique du template        |
| Rend le template configurable       | Rend le template plus lisible et maintenable |

Astcue pour différencier entre param et var :
Demande-toi plutôt :

Qui décide de cette valeur ?

Si la réponse est :

Le développeur qui écrit le template

→ var

Si la réponse est :

La personne qui déploie

→ param

C'est la distinction fondamentale.

Dans les projets professionnels, tu verras souvent des templates avec beaucoup de paramètres.

Pourquoi ?

Parce que les équipes DevOps cherchent à construire des modules réutilisables.

### Chapitre 4 — Resources

Toute infrastructure Azure est composée de ressources.

Par exemple :

- Resource Group
- App Service
- Azure SQL Server
- Azure SQL Database
- Storage Account
- Key Vault
- Virtual Network
- Log Analytics Workspace
- Application Insights

En Bicep, chaque ressource est déclarée avec le mot-clé `resource`

```bash

resource <nom_interne> '<type>@<api-version>' = {
    propriétés...
}

```

- nom_interne : n'est pas le nom de la ressource Azure.

C'est uniquement une variable interne au fichier Bicep.

- type : Il indique à Azure quel type de ressource créer.

| Ressource       | Type                                |
| --------------- | ----------------------------------- |
| Storage Account | `Microsoft.Storage/storageAccounts` |
| App Service     | `Microsoft.Web/sites`               |
| SQL Server      | `Microsoft.Sql/servers`             |
| SQL Database    | `Microsoft.Sql/servers/databases`   |
| Key Vault       | `Microsoft.KeyVault/vaults`         |

- api-version : Azure expose des API versionnées.
  Une nouvelle version peut ajouter de nouvelles propriétés ou en déprécier d'anciennes.
  En pratique, on utilise généralement une version récente et stable recommandée par l'extension Bicep ou la documentation Azure.

Vous êtes limité à 800 ressources dans un fichier Bicep.

Les noms symboliques sont sensibles à la casse. Ils peuvent contenir des lettres, des chiffres et des traits de soulignement (\_). Ils ne peuvent pas commencer par un chiffre. Une ressource ne peut pas porter le même nom qu'un paramètre, une variable ou un module.

Pour déployer plusieurs instances d'une ressource, utilisez la syntaxe `for`. Vous pouvez utiliser le décorateur `batchSize` pour spécifier si les instances sont déployées en série ou en parallèle.

### Chapitre 5 — Dependencies

Lors du déploiement de ressources, il peut être nécessaire de s'assurer que certaines ressources sont déployées avant d'autres. Par exemple, un serveur SQL logique est requis avant le déploiement d'une base de données. Cette relation est établie en déclarant une ressource comme dépendante de l'autre. L'ordre de déploiement des ressources est déterminé de deux manières : par dépendance implicite ou par dépendance explicite.

Azure Resource Manager évalue les dépendances entre les ressources et les déploie dans l'ordre de dépendance. Lorsque les ressources sont indépendantes, Resource Manager les déploie en parallèle. Il suffit de définir les dépendances pour les ressources déployées dans le même fichier Bicep.

Les dépendances explicites : Microsoft recommande de ne l'utiliser que lorsqu'il n'existe aucune référence entre les ressources.

### Chapitre 6 — Outputs

Pendant un déploiement, Azure crée des ressources.

À la fin, on veut souvent récupérer des informations comme :

- l'URL d'un site Web ;
- l'ID d'une ressource ;
- le nom d'un Storage Account ;
- le nom d'un Key Vault.

C'est exactement le rôle des output.

Très pratique pour :

- les pipelines CI/CD ;
- les scripts ;
- les modules Bicep.

Quand utilise-t-on les outputs ?
1- Pour afficher des informations utiles
2- Pour communiquer entre modules
3- Pour les pipelines CI/CD

Avec Bicep version 0.35.1 et ultérieures, vous pouvez marquer les sorties de type chaîne ou objet comme sécurisées. Lorsqu'une sortie est annotée avec `@secure()`, Azure Resource Manager traite sa valeur comme sensible, empêchant ainsi son enregistrement dans l'historique des déploiements, le portail Azure et les sorties de ligne de commande.

### Chapitre 7 — Les fonctions Azure

Il existe des fonctions qui interrogent Azure.

- `resourceGroup()` : Cette fonction retourne des informations sur le Resource Group courant.Tu peux écrire :
  `location: resourceGroup().location` au lieu de `location: 'France Central'`.Ainsi, toutes les ressources seront créées dans la même région que le Resource Group.

- `uniqueString()` : Certains noms Azure doivent être uniques au niveau mondial(comme un nom de storageAccount).

- `subscription()` : Retourne des informations sur l'abonnement Azure.

Les fonctions dépendant du contexte Azure (resourceGroup(), subscription()) seront résolues lors du déploiement.

| Fonction          | Usage                                  |
| ----------------- | -------------------------------------- |
| `toLower()`       | Minuscules                             |
| `toUpper()`       | Majuscules                             |
| `length()`        | Taille                                 |
| `resourceGroup()` | Infos du Resource Group                |
| `subscription()`  | Infos de l'abonnement                  |
| `uniqueString()`  | Générer un suffixe unique déterministe |

### Chapitre 8 — Les fichiers .bicepparam

Séparer la logique de l'infrastructure des valeurs propres à chaque environnement.

Le problème

- Supposons que ton template soit :

```bash
param environment string
param location string
param appName string
```

Modifier le fichier à chaque fois pour changer les valeurs en cas de besoin.

La bonne solution c'est que le template reste identique,puis on crée un fichier séparé(par environnement par exemple).

Puis dans déploiement :

```bash
az deployment group create \
    --parameters dev.bicepparam
```

Bonnes pratiques : Les paramètres qui changent

Dans les .bicepparam :

- environnement
- région
- SKU
- tags
- tailles
- nombres d'instances

### Chapitre 9 — Modules Bicep

Découper une infrastructure en blocs réutilisables et maintenables.
Chaque module gère une partie de l’infrastructure.

Un module est :

une boîte noire réutilisable

- Entrées → params
- Sorties → outputs

Vous pouvez passer les paramétres au module depuis main.bicep et récupérer les outputs d’un module.

1 module = 1 responsabilité
