# Arma Update and run script WIP

# Server Configuration
$servername = "Spearhead Operation FurFags"
$serverpassword = "cold"
$mods = @('620260972','333310405')
$localmods = @('@aliveserver','@arametrics')
$missionname = "OpFrostbite.NapfWinter" # Name of mpmission folder & mission pbo name in quotes
$missiongit = "https://gitlab.com/Naltan/a3-operation-frostbite/-/archive/master/a3-operation-frostbite-master.zip"
# Server Paths
$serverpath = 'C:\Servers\arma3_server'
$steamCMD = 'C:\servers\steamcmd\steamcmd.exe'
$contentFolder = 'C:\servers\steamcmd\steamapps\workshop\content\107410'

# Login Information for mod downloads
$username = "ztrackbox"
$pwd = "Icanteven69"

# Arma IDs
$Arma_appID = 107410
$ArmaServer_AppID = 233780

#--------------------------------------------------------------------------------
# END CONFIGURATION
# Don't change shit below this line or a tree-72 will come attack you in your sleep
#--------------------------------------------------------------------------------

$updateDedi = $null
Write-Host "Downloading / Updating Arma Dedicated Server Files..." -ForegroundColor DarkGreen
Start-Process -FilePath $steamCMD -ArgumentList ('+login',$username,$pwd,'+force_install_dir',$serverpath,'+app_update',$ArmaServer_AppID,'validate','+quit') -Wait -RedirectStandardOutput out.txt -NoNewWindow
sleep -Seconds 1
$updateDedi = Get-Content out.txt
if ($showSteamOutput -eq $true){Write-Host $updateDedi}

#check download/verify was good
if ($updateDedi -like "*Success! App '233780' fully installed.") {
Write-Host "Downloading / Updating Arma Dedicated Server Files Complete." -ForegroundColor DarkGreen
del out.txt
$updateDedi = $null
}else{
Write-Host "Validation / Downloading of Arma Server Files Failed! Please try running again." -ForegroundColor DarkRed
del out.txt
$updateDedi = $null
break
}

#download arma mods from workshop

$modCount = $mods.Count
$ii = 0
$modDownloadsGood = $true
$updateMods = $null
foreach ($mod in $mods){
$ii+=1
Write-Host "Downloading / Updating mod $mod ($ii of $modCount)..." -ForegroundColor DarkGreen
#if (Test-Path out.txt){del out.txt}
#New-Item -ItemType file out.txt
Start-Process -FilePath $steamCMD -ArgumentList ('+login',$username,$pwd,'+workshop_download_item',$Arma_appID,$mod,'validate','+quit') -Wait -RedirectStandardOutput out.txt -NoNewWindow
sleep -Seconds 1
$updateMods = Get-Content out.txt
#check download/verify was good
if ($showSteamOutput -eq $true){Write-Host $updateMods}

if ($updateMods[7] -like "Success. Downloaded item $mod to *") {
Write-Host "Downloading / Updating mod $mod ($ii of $modCount) Complete." -ForegroundColor DarkGreen
del out.txt
$updateMods = $null
}else{
Write-Host "Downloading / Updating mod $mod ($ii of $modCount) Failed! Please try running again." -ForegroundColor DarkRed
Write-Host $updateMods
del out.txt
$updateMods = $null
$modDownloadsGood = $false
break
}
sleep -Seconds 1
}


# Create Symbolic links to main arma server folder
Write-Host "Creating Mod Links..." -ForegroundColor DarkGreen
if ($modDownloadsGood -eq $true){
$modFolders = Get-ChildItem $contentFolder
$ii = 0
foreach ($modFolder in $modFolders){
$ii+=1
[string]$newmodfolderName = "@" + $modFolder.Name
new-item -itemtype symboliclink -path $serverpath -name $newmodfolderName -value $modFolder.FullName
sleep -Seconds 1
}


sleep -Seconds 5 #pause for 5 sec to ensure file operations are done before continuing
}

# Updating Mission PBO
Write-Host "Updating mission pbo" -ForegroundColor DarkGreen

$mpmissions = $serverpath + "\mpmissions" # + "\" + $missionname
$missionfolder = $serverpath + "\mpmissions" + "\" + $missionname
rm $missionfolder # Delete old files
mkdir $missionfolder

if (Test-Path $missionfolder) # If folder exists, delete it. If it does not, create it
{
    rm $missionfolder
    mkdir $missionfolder
    }else{
    mkdir $missionfolder
    }

[string]$User = "" # Your GitHub username, for using the Authenticated Service. Providing 5000 requests per hour.
[string]$Token = "" # The parameter Token is the generated token for authenticated users. Create one here (after logging in on your account): https://github.com/settings/tokens
[string]$Owner = "Jigsor" # Owner of the repository you want to download from.
[string]$Repository = "BMR-Insurgency" # The repository name you want to download from.
[string]$Path = "" # Path of repo we want to download. If empty, its entire repo
[string]$DestinationPath = $missionfolder

	# Authentication
	$authPair = "$($User):$($Token)"; 
	$encAuth = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($authPair));
	$headers = @{ Authorization = "Basic $encAuth" };
	
	# REST Building
	$baseUri = "https://api.github.com";
	$argsUri = "repos/$Owner/$Repository/contents/$Path";
	$wr = Invoke-WebRequest -Uri ("$baseUri/$argsUri") -Headers $headers;

	# Data Handler
	$objects = $wr.Content | ConvertFrom-Json
	$files = $objects | where {$_.type -eq "file"} | Select -exp download_url
	$directories = $objects | where {$_.type -eq "dir"}
	
	# Iterate Directory
	$directories | ForEach-Object { 
		DownloadFilesFromRepo -User $User -Token $Token -Owner $Owner -Repository $Repository -Path $_.path -DestinationPath "$($DestinationPath)/$($_.name)"
	}

	# Destination Handler
	if (-not (Test-Path $DestinationPath)) {
		try {
			New-Item -Path $DestinationPath -ItemType Directory -ErrorAction Stop;
		} catch {
			throw "Could not create path '$DestinationPath'!";
		}
	}

	# Iterate Files
	foreach ($file in $files) {
		$fileDestination = Join-Path $DestinationPath (Split-Path $file -Leaf)
		$outputFilename = $fileDestination.Replace("%20", " ");
		try {
			Invoke-WebRequest -Uri "$file" -OutFile "$outputFilename" -ErrorAction Stop -Verbose
			"Grabbed '$($file)' to '$outputFilename'";
		} catch {
			throw "Unable to download '$($file)'";
		}
	}






# copy over the new files
echo "Copying over git..."
cp .\a3-operation-frostbite\* .\OpFrostbite.NapfWinter\ -Recurse

# Delete git meta
# rm .\OpFrostbite.NapfWinter\.git -Recurse -Force
echo "Deleting git meta..."
rm .\OpFrostbite.NapfWinter\LICENSE -Force
rm .\OpFrostbite.NapfWinter\README.md -Force

# compile the pbo
echo "Compiling .pbo..."
& "C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack .\OpFrostbite.NapfWinter .\OpFrostbite.NapfWinter.pbo 

# delete the files (again)
echo "Cleaning up..."
rm .\OpFrostbite.NapfWinter\* -Recurse -Force

#End of husky shitcode

Write-Host "Server Configuration Complete." -ForegroundColor DarkGreen

# Start Arma 3 Server

for ($i=0; $i -lt $mods.Count; $i++) {
    $clientsidemods[$i] = "@" + $mods[$i]
}
