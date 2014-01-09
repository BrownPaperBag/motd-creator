#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Paste your ASCII art header. Use http://patorjk.com/software/taag/#p=display&f=Doom&t= to create it (CTRL-D when done pasting): "

ASCII_ART=""

while read LINE
do
    ASCII_ART=$ASCII_ART$'\n'$LINE
done

echo "Installing tcl and fortune"

sudo apt-get install tcl fortune || exit 1

echo "Removing current motd/n"

sudo cat /dev/null > /etc/motd || exit 1
sudo cat /dev/null > /etc/motd.tail || exit 1

sudo cp -v "$DIR/motd-template.tcl" /etc/motd.tcl || exit 1
sudo chmod +x /etc/motd.tcl || exit 1

ASCII_ART=`echo ${ASCII_ART} | tr '\n' "\\n"`
sudo sed -i -e "s;ASCII_ART;${ASCII_ART};g" /etc/motd.tcl || exit 1

if [ -f "$HOME/.zshrc" ]; then
    echo '/etc/motd.tcl' >> "$HOME/.zshrc"
fi

/etc/motd.tcl

