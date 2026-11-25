# solutions-clouds : module Terraform nginx (Docker)

Module Terraform qui lance un ou plusieurs conteneurs **nginx** sur le Docker local, avec le provider [`kreuzwerker/docker`](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs).

- Les conteneurs sont nommés `<name_prefix>-1`, `<name_prefix>-2`, …
- Les ports hôte se suivent : le 1er conteneur écoute sur `start_port`, le 2e sur `start_port + 1`, etc.
- La page d'accueil de chaque conteneur affiche son **hostname**.

## Utilisation

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.7"
    }
  }
}

provider "docker" {}

module "nginx" {
  source = "github.com/ianb1204/solutions-clouds?ref=v1.0.0"

  image           = "nginx:latest"
  memory          = 256
  privileged      = false
  container_count = 3
  start_port      = 3000
}

output "urls" {
  value = module.nginx.urls
}
```

```bash
terraform init
terraform apply
curl http://localhost:3000   # 1er conteneur
curl http://localhost:3001   # 2e conteneur
```

> Déclare bien `kreuzwerker/docker` dans le `required_providers` de ta configuration racine. Sinon, Terraform cherche `hashicorp/docker`, qui n'existe pas.

## Variables

| Nom               | Type     | Défaut         | Description                                              |
|-------------------|----------|----------------|----------------------------------------------------------|
| `image`           | `string` | `nginx:latest` | Image Docker à utiliser (basée sur nginx)                |
| `memory`          | `number` | `256`          | Limite mémoire par conteneur, en Mo (minimum 6)          |
| `privileged`      | `bool`   | `false`        | Lance les conteneurs en mode privilégié                  |
| `container_count` | `number` | `1`            | Nombre de conteneurs à créer                             |
| `name_prefix`     | `string` | `nginx`        | Préfixe des noms générés (`nginx-1`, `nginx-2`, …)       |
| `start_port`      | `number` | `3000`         | Port hôte du 1er conteneur, puis +1 pour chaque suivant  |

## Outputs

| Nom               | Description                                   |
|-------------------|-----------------------------------------------|
| `container_names` | Liste des noms des conteneurs                 |
| `urls`            | Map `nom => http://localhost:<port>`          |
| `hostnames`       | Map `nom => hostname` (affiché sur la page)   |

## Affichage du hostname (Bonus 1)

L'image officielle nginx exécute au démarrage chaque script `*.sh` exécutable présent dans `/docker-entrypoint.d/`. Le module y dépose `files/hostname-page.sh` (bloc `upload` du `docker_container`). Ce script réécrit `index.html` avec le résultat de `hostname`.

C'est pour cela que `image` doit être une image nginx officielle ou dérivée (`nginx:latest`, `nginx:alpine`, `nginx:1.27`, …) qui écoute sur le port 80.

## Exemple local

`examples/basic` utilise le module via un chemin relatif (`source = "../.."`) :

```bash
cd examples/basic
terraform init && terraform apply
```
