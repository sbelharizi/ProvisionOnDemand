Ce service permet de déployer une image docker personnalisé sur une VM possédant docker puis de créer des job à partir de jenkinsfile.

Image docker de jenkins personnalisé :
L'image est basé sur celle officiel de jenkins et apporte les éléments suivants :
- installation une liste de plugins
- suppression des écrans d'initialisation lors du premier lancement


Varriable nécessaire :
- TF_VAR_POD_COMMON_EXTERNAL_IP : ip de la VM cible
- TF_VAR_POD_COMMON_PRIV_KEY : clé privé pour ce connecter sur la VM cible
- TF_VAR_POD_COMMON_USER : utilisateur utilisé pour la connection SSH
