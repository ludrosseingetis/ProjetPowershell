Projet PowerShell - Gestionnaire de mots de passe
==================================================

Comment lancer le script
-------------------------

Ouvrir PowerShell et faire :

    .\PasswordManager.ps1

Le menu interactif
-------------------

1 - Generer un mot de passe
2 - Tester la force d'un mot de passe
3 - Generer une liste de mots de passe
4 - Exporter les mots de passe
5 - Sauvegarder au coffre-fort
6 - Quitter

Les fonctions disponibles
--------------------------

New-Password (1)
  Genere un mot de passe.
  Parametres : Nombre de caractères (Minimum 12)

Test-PasswordStrength (2)
  Teste la robustesse d'un mot de passe,
  3 état de robustesse:
  
  Weak
  Medium
  Strong
  Very Strong
  
New-PasswordList (3)
  Genere des mots de passe pour plusieurs utilisateurs depuis un fichier .txt,
  Créer un Fichier .txt et y rentrer des utilisateurs (se fier a l'exemple a la fin du readme)
  Puis lancer le script et indiquer le chemin d'accès

Export-Passwords (4)
  Exporte la derniere liste generee en CSV.

Save-SecurePassword (5)
  Sauvegarde un mot de passe chiffre dans vault.txt

Format du fichier users.txt pour la fonction 3
-----------------------------

Mettre un utilisateur par ligne :

user1
user2
user3

---

