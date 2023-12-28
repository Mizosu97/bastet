local packageInfo = {}

packageInfo.exists = true -- Do not edit.


packageInfo.dependencies = {
    ["Installation Dependencies"] = {
        ["pacman"] = {"gcc"}, 
        ["apt"]    = {"gcc"}, 
        ["xbps"]   = {"gcc"}, 
        ["dnf"]    = {"gcc"}, 
        ["zypper"] = {"gcc"}  
    },
    ["Program Dependencies"] = {
        ["pacman"] = {},
        ["apt"]    = {},
        ["xbps"]   = {},
        ["dnf"]    = {},
        ["zypper"] = {}
    }
}


packageInfo.install = [[
#!/bin/bash

echo -n "Create an encryption password for bastet: "
read pass

echo "Compiling bastet."
sed "s/password123/${pass}/g" src/bastet.c > src/bastet_gen.c
gcc src/bastet_gen.c -o src/bastet

echo "Installing bastet."
chmod +x src/bastet
sudo mv src/bastet /usr/bin/

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
