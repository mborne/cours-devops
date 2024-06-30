# Le stockage avec Docker


## Configuration du démon

Les points suivants peuvent être configurés dans `/etc/docker/daemon.json` :

| Paramètre        | Description                                                                                               | Exemple           |
|------------------|-----------------------------------------------------------------------------------------------------------|-------------------|
| `data-root`      | La racine du stockage                                                                                     | `/var/lib/docker` |
| `storage-driver` | Le [driver pour les volumes nommés](https://docs.docker.com/storage/storagedriver/select-storage-driver/) | `overlay2`        |


