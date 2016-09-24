#!/bin/bash

this="$PWD"

cd ~
echo Copying pisstv script, replacing HOMEDIR with "$PWD"
sed s/HOMEDIR/"$PWD"/g "$this"/scripts/pisstv.sh > pisstv.sh

echo Setting pisstv script as executable
chmod +x pisstv.sh

echo Extracting PiFM
tar -xf "$this"/src/pifm.tar.gz

echo Patching pifm
patch -Np1 -i "$this"/src/pifm.patch

echo Compiling pifm
gcc -o pifm pifm.c

echo Extracting PySSTV
tar -xvf "$this"/src/scripts/PySSTV-*.tar.gz

echo Installing Python Imaging
sudo apt-get install python-imaging

read -r -p \
  'Do you want me to overwrite your /etc/rc.local with ours? If you have modified it, probably best not to... (y/N) ' overwrite
if [ "$overwrite" = "y" ]; then
  echo Replacing rc.local, replacing HOMEDIR with "$PWD"
  sed s/HOMEDIR/"$PWD"/g "$this"/config/rc.local | sudo tee /etc/rc.local
else
  echo Please add \""$PWD"/pisstv.sh \&\" to your rc.local or equivalent
fi
echo All done. Reboot your Pi and it should start beeping!
