#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

git clone https://github.com/BrownPaperBag/motd-creator.git "$DIR/motd-creator"

echo "Paste your ASCII art header. Use http://patorjk.com/software/taag/#p=display&f=Doom&t= to create it: "

ASCII_ART=""

while read LINE
do
    ASCII_ART=$ASCII_ART$'\n'$LINE
done

echo "Installing tcl and fortune"

apt-get install tcl fortune

echo "Removing current motd/n"

cat /dev/null > /etc/motd
cat /dev/null > /etc/motd.tail

cp -v "$DIR/motd-creator/motd-template.tcl" /etc/motd.tcl
chmod +x /etc/motd.tcl

sed -i -e "s/ASCII_ART/$ASCII_ART/g" /etc/motd.tcl

/etc/motd.tcl

