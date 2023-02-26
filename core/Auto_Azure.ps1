# Se connecter à Azure
#Connect-AzAccount

# Mes variables
$nbrvms=4
$rg="rg-david"
$location="northeurope"
$namesnetfe="snet-fe-david"
$namesnetbe="snet-be-david"
$ipsnetfe="10.0.0.0/24"
$ipsnetbe="10.0.1.0/24"
# Créer un groupe de ressources
New-AzResourceGroup -Name $rg -Location $location

# Création des sous réseaux de FE et de BE
$objsnetfe=New-AzVirtualNetworkSubnetConfig -AddressPrefix $ipsnetfe -Name $namesnetfe
$objsnetbe=New-AzVirtualNetworkSubnetConfig -AddressPrefix $ipsnetbe -Name $namesnetbe
# Création d'un vnet en associant les sous réseaux de FE et BE
$objvnet=New-AzVirtualNetwork -AddressPrefix 10.0.0.0/23 -Location $location -Name vnet-david -ResourceGroupName $rg -Subnet $objsnetfe,$objsnetbe

# Création de la règle SSH depuis n'importe ou
$objrulensg=New-AzNetworkSecurityRuleConfig -Name Rule-SSH -Access Allow -DestinationAddressPrefix 10.0.1.0/24 -DestinationPortRange 22 -Direction Inbound -Priority 100 -Protocol Tcp -SourceAddressPrefix * -SourcePortRange *
# Création d'un nsg de be en associant la règle
$objnsg=New-AzNetworkSecurityGroup -Location $location -Name nsg-david-be -ResourceGroupName $rg -SecurityRules $objrulensg
# Associé le NSG au sous réseau de BE
Set-AzVirtualNetworkSubnetConfig -AddressPrefix $ipsnetbe -Name $namesnetbe -VirtualNetwork $objvnet -NetworkSecurityGroup $objnsg
$objvnet | Set-AzVirtualNetwork


$username = "walter"
$password = "Maloute01"
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd

for ($i=1;$i -le $nbrvms;$i++) {

$namevm="deb0$i"

# Créer une adresse ip Public
$objpip=New-AzPublicIpAddress -AllocationMethod Dynamic -ResourceGroupName $rg -Location $location -Name "pip-$namevm" -Sku Basic
# Créer une carte réseau et associé l'adresse ip public
$objnic=New-AzNetworkInterface -Location $location -Name "nic-$namevm" -ResourceGroupName $rg -Subnet $objvnet.Subnets[1] -NetworkSecurityGroup $objnsg -PublicIpAddress $objpip
# Création d'une VM en spécifiant OS, Taille, et associé les éléments PIP & NIC
$vmConfig = New-AzVMConfig -VMName "vm-$namevm" -VMSize 'Standard_DS1_v2' | `
  Set-AzVMOperatingSystem -Linux -ComputerName "vm-$namevm" -Credential $cred | `
  Set-AzVMSourceImage -PublisherName 'Debian' -Offer 'debian-10' `
  -Skus '10' -Version latest | Add-AzVMNetworkInterface -Id $objnic.Id

New-AzVM -ResourceGroupName $rg -Location $location -VM $vmConfig
}
