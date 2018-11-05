# ProvisionOnDemand
Industrialiser la production de plateforme de services

==================== Get started ====================
Pour déployer les services voulu il faut :
- mettre sa configuration dans le fichier master.configuration
- exécuter le fichier master.sh


==================== creation d'un nouveau service ====================
Pour ajouter un nouveau module, il est nécessaire :
- de respecter la hierarchisation des dossiers :
      Provider      : fournisseur d'infrastrucure
        L Type      : type d'infrastructure
          L Service : module à déployer

- d'avoir les fichiers suivants dans le repertoire :
  * create.sh : script de création du module
  * delete.sh : script de destruction

  Ces scipts ne prennent aucun paramètres mais peuvent utiliser les varaibles globales.

- l'ensemble des varaibles de configuration d'un service doit être réuni dans le fichier master.conf.
