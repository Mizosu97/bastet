local packageInfo = {}

packageInfo.exists = true -- Do not edit.



packageInfo.pacman_depends = {"gcc"}

packageInfo.aur_depends = {}



packageInfo.install = [[
#!/bin/bash

# Replace "bash" with the shell you want to use for your installation script.

echo -n "Create an encryption password for bastet: "
read pass

echo "Compiling bastet."
sed "s/password123/${pass}/g" src/bastet.c > src/bastet_gen.c
gcc src/bastet_gen.c -o src/bastet

echo "Installing bastet."
chmod +x src/bastet
sudo mv src/bastet /usr/bin⏎
]]



packageInfo.remove = [[
#!/bin/bash

sudo rm /usr/bin/bastet
]]



packageInfo.update = [[
#!/bin/bash

echo "Because of the way bastet is written, it does not support updating."
]]



return packageInfo
