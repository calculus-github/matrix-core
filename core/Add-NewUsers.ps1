w# Importer le module Active Directory pour exécuter les applets de commande AD
Import-Module ActiveDirectory
  
# Stocker les données de NewUsersFinal.csv dans la variable $ADUsers
$ADUsers = Import-Csv $pwd\ListUsers.csv -Delimiter ";"

# Define UPN
$UPN = "CHANGEME"

# Boucle sur chaque ligne contenant les détails de l'utilisateur dans le fichier CSV
foreach ($User in $ADUsers) {

    #Lire les données utilisateur de chaque champ de chaque ligne et affecter les données Ã  une variable comme ci-dessous
    $username = $User.username
    $password = $User.password
    $firstname = $User.firstname
    $lastname = $User.lastname
    $initials = $User.initials
    $OU = $User.ou #This field refers to the OU the user account is to be created in
    $email = $User.email
    $streetaddress = $User.streetaddress
    $city = $User.city
    $zipcode = $User.zipcode
    $state = $User.state
    $country = $User.country
    $telephone = $User.telephone
    $jobtitle = $User.jobtitle
    $company = $User.company
    $department = $User.department

    # Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        
        # If user does exist, give a warning
        Write-Warning "A user account with username $username already exists in Active Directory."
    }
    else {

        # User does not exist then proceed to create the new user account
        # Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@$UPN" `
            -Name "$firstname $lastname" `
            -Surname $lastname `
            -Initials $initials `
            -Enabled $True `
            -DisplayName "$lastname, $firstname" `
            -Path $OU `
            -Company $company `
            -EmailAddress $email `
            -AccountPassword (ConvertTo-secureString $password -AsPlainText -Force) -ChangePasswordAtLogon $false

        # If user is created, show message.
        Write-Host "The user account $username is created." -ForegroundColor Cyan
    }
}

Read-Host -Prompt "Press Enter to exit"