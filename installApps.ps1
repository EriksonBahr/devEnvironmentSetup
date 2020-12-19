function MoveDistroTo($distro, $path)
{
  Write-Host "Moving $distro to $path"
  mkdir -p $path -force
  wsl --export $distro "$pwd\$distro.tar"
  wsl --unregister $distro
  wsl --import $distro "$path\$distro" "$pwd\$distro.tar" --version 2
  del "$distro.tar"
}

#install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#disable uac
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0

choco install vscode, notepadplusplus, docker-desktop, visualstudio2019community, ditto, git.install -y
#not working
# choco install spotify -y

#enable wsl2
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
wget https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -o wsl_update_x64.msi
msiexec /q wsl_update_x64.msi
Remove-item wsl_update_x64.msi
wsl --set-default-version 2
MoveDistroTo "docker-desktop" "D:\\wsl"
MoveDistroTo "docker-desktop-data" "D:\\wsl"
#windows insider new installation mode (w10 build 20246 or above) - see https://devblogs.microsoft.com/commandline/distro-installation-added-to-wsl-install-in-windows-10-insiders-preview-build-20246
wsl --install -d Ubuntu-20.04
MoveDistroTo "Ubuntu-20.04" "D:\\wsl"
wsl --set-default -s Ubuntu-20.04