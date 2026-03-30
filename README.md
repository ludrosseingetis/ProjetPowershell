Projet PowerShell - Gestionnaire de mots de passe
==================================================

Comment lancer le script
-------------------------

Ouvrir PowerShell et faire :

    .\PasswordManager.ps1

Les fonctions disponibles
--------------------------

New-Password
  Genere un mot de passe.
  Parametres : -Length (longueur), -Uppercase, -Lowercase, -Numbers, -SpecialChars
  Exemple : New-Password -Length 16

Test-PasswordStrength
  Teste la robustesse d'un mot de passe.
  Exemple : Test-PasswordStrength -Password "MonMotDePasse1!"

New-PasswordList
  Genere des mots de passe pour plusieurs utilisateurs depuis un fichier .txt
  Exemple : New-PasswordList -UserFile users.txt -Length 14

Export-Passwords
  Exporte la derniere liste generee en CSV.
  Exemple : Export-Passwords -Path mots_de_passe.csv

Save-SecurePassword
  Sauvegarde un mot de passe chiffre dans vault.txt
  Exemple : Save-SecurePassword -User user1 -Password "Test123!"


Format du fichier users.txt
-----------------------------

Mettre un utilisateur par ligne :

user1
user2
user3

---

Le menu interactif
-------------------

1 - Generer un mot de passe
2 - Tester la force d'un mot de passe
3 - Generer une liste de mots de passe
4 - Exporter les mots de passe
5 - Sauvegarder au coffre-fort
6 - Quitter
