-- Made by https://theduat.neocities.org


--[=[--[=[--[=[ THIS SCRIPT STORES THE CORE SOURCE CODE OF MIZOS. ONLY EDIT IF YOU KNOW WHAT YOU ARE DOING ]=]--]=]--]=]--



local system = {}

-- If you are writing software that interacts with the mizOS backend, please note that package installation can only be done from the CLI.

--Data types:
--error, output, info, command



--[=[--[=[ GENERAL PURPOSE FUNCTIONS. ]=]--]=]--





local home = os.getenv("HOME")



--[=[ Command shorteners. ]=]--
local function x(cmd)
	os.execute(cmd)
end

local function ipkg(pkg)
	x("sudo pacman -S " .. pkg)
end

local function ypkg(pkg)
	x("yay -S " .. pkg)
end



---[=[ String split function. ]=]--
local function splitstr(ins, sep)
	if sep == nil then
		sep = " "
	end
	local t = {}
	if ins and sep then
		for str in string.gmatch(ins, "([^"..sep.."]+)") do
			table.insert(t, str)
		end
	end
	return t
end



--[=[ Whitespace trimmer. ]=]--
function trim(s)
	local new = ""
	local i = 0
	local new = ""
	local len = string.len(s)
	while i <= len do
		local sub = string.sub(s, i, i)
		if sub ~= " " then
			new = new .. sub
		end
		i = i + 1
	end
	return new
end



--[=[ Get shell command output. ]=]--
local function capture(cmd, raw)
	local file = assert(io.popen(cmd, 'r'))
	local out = assert(file:read('*a'))
	file:close()
	if raw then return out end
	out = string.gsub(out, '^%s+', '')
	out = string.gsub(out, '%s+$', '')
	out = string.gsub(out, '[\n\r]+', ' ')
	return out
end



--[=[ Check if file exists. ]=]--
local function checkfile(name)
	local file = io.open(name, "r")
        if file ~= nil then
                io.close(file)
 		return {true, name}
	else
		return {false, name}
	end
end



--[=[ Read file contents. ]=]--
local function readfile(file)
	local contents = ""
	if checkfile(file) == true then
		contents = capture("cat " .. file)
	end
	return contents
end





--[=[--[=[ MIZOS SYSTEM ]=]--]=]--




--[=[ User Interface Data ]=]--
uis = { 
	{"budgie", "budgie-desktop", false},
	{"cinnamon", "cinnamon", false},
	{"cutefish", "cutefish", false},
	{"deepin", "deepin", false},
	{"enlightenment", "enlightenment", false},
	{"gnome", "gnome", false},
	{"gnome-flashback", "gnome-flashback", false},
	{"kde", "plasma", false},
	{"lxde", "lxde", false},
	{"lxqt", "lxqt", false},
	{"mate", "mate", false},
	{"sugar", "sugar sugar-fructose", false},
	{"ukui", "ukui", false},
	{"xfce", "xfce4", false},
	{"cde", "cdesktopenv", true},
	{"ede", "ede", true},
	{"kde1", "kde1-kdebase-git", true},
	{"liri", "liri-shell-git", true},
	{"lumina", "lumina-desktop", true},
	{"moksha", "moksha-git", true},
	{"pantheon", "pantheon-session-git", true},
	{"paperde", "paperde", true},
	{"phosh", "phosh", true},
	{"plasma-mobile", "plasma-mobile", true},
	{"thedesk", "thedesk", true},
	{"trinity", "trinity", false},
	{"maui", "maui-shell-git", true},
	{"2bwm", "2bwm", true},
	{"9wm", "9wm", true},
	{"afterstep", "afterstep-git", true},
	{"berry", "berry-git", true},
	{"blackbox", "blackbox", false},
	{"compiz", "compiz", false},
	{"cwm", "cwm", true},
	{"eggwm", "eggwm", true},
	{"evilwm", "evilwm", true},
	{"fluxbox", "fluxbox", false},
	{"flwm", "flwm", true},
	{"fvmm", "fvmm", true},
	{"gala", "gala", false},
	{"goomwwm", "goomwwm", true},
	{"icewm", "icewm", false},
	{"jbwm", "jbwm", true},
	{"jwm", "jwm", false},
	{"karmen", "karmen", true},
	{"kwin", "kwin", false},
	{"lwm", "lwm", false},
	{"marco", "marco", false},
	{"metacity", "metacity", false},
	{"muffin", "muffin", false},
	{"mutter", "mutter", false},
	{"mwm", "openmotif", false},
	{"openbox", "openbox", false},
	{"pawm", "pawm", true},
	{"pekwm", "pekwm", false},
	{"sawfish", "sawfish", true},
	{"sowm", "sowm", true},
	{"tinywm", "tinywm", true},
	{"twm", "xorg-twm", false},
	{"ukwm", "ukwm", false},
	{"uwm", "ude", true},
	{"wind", "windwm", true},
	{"windowlab", "windowlab", true},
	{"windowmaker", "windowmaker", true},
	{"wm2", "wm2", true},
	{"worm", "worm-git", true},
	{"xfwm", "xfwm4", false},
	{"bspwm", "bspwm", false},
	{"exwm", "exwm-git", true},
	{"herbstluftwm", "herbstluftwm", false},
	{"i3", "i3-wm", false},
	{"larswm", "larswm", true},
	{"leftwm", "leftwm", true},
	{"notion", "notion", false},
	{"ratpoison", "ratpoison", false},
	{"stumpwm", "stumpwm", false},
	{"subtle", "subtle-hg", true},
	{"wmfs2", "wmfs2-git", true},
	{"awesome", "awesome", false},
	{"dwm", "dwm", true},
	{"echinus", "echinus", true},
	{"frankenwm", "frankenwm", true},
	{"i3-gaps", "i3-gaps", false},
	{"spectrwm", "spectrwm", false},
	{"sway", "sway", false},
	{"qtile", "qtile", false},
	{"xmonad", "xmonad", false},
	{"hyprland", "hyprland", true}
}



--[=[ Detect init system. ]=]--
local init = dofile("/var/mizOS/init/init.lua")



--[=[ https://github.com/Mizosu97/mgpu ]=]--
local function mgpu(gpu, arguments)
	local gcmd = ""
	for _,ag in pairs(arguments) do
		if ag ~= "miz" 
		and ag ~= "/bin/lua" 
		and ag ~= "/usr/bin/miz" 
		and ag ~= "./miz" 
		and ag ~= "xd" 
		and ag ~= "xi" 
		and ag ~= "gfx" then
			gcmd = gcmd .. ag .. " "
		end
	end
	if gpu == "xd" then
		return "export DRI_PRIME=1 && exec " .. gcmd
	elseif gpu == "xi" then
		return "export DRI_PRIME=0 && exec " .. gcmd
	end
end


--[=[ mizOS configuration. ]=]--
system.config = function(op, value)
	return {"error", "Still in development."}
	if op == "wallpaper" then
		local splitval = splitstr(value, "/")
		local wallid = 0
		for _,part in pairs(splitval) do
			wallid = wallid + 1
		end
		local dircount = 1
		local directory = "/"
		while dircount < wallid do
			directory = directory .. splitval[dircount] .. "/"
			dircount = dircount + 1
		end
		local wallpapername = splitval[wallid]
		local wallpapersplit = splitstr(wallpapername,".")
		local final = ""
		if wallpapersplit[2] == "png" then
			final = directory .. "wallpaper.png"
		elseif wallpapersplit[2] == "jpg" then
			final = directory .. "wallpaper.jpg"
		elseif wallpapersplit[2] == "webp" then
			final = directory .. "wallpaper.webp"
		else
			return {"error", "Inavlid filetype passed. (Must be .png, .jpg, or .webp)"}
		end
		x("mv " .. value .. " " final)
		x("rm /var/mizOS/wallpaper/* && mv " .. final .. " /var/mizOS/wallpaper/")
	end
end



--[=[ System safety. ]=]--
system.safety = function(op, program)
	return {"error", "Still in development."}
	if op == "backup" then
		if program == nil then
		end
	end
end



local officialpkgs = {
	"mizosu97/grapejuice"
}



--[=[ mizOS package management. ]=]--
local function package(op, thepkg)
	local pkgsplit
	local dev
	local name
	local insdir
	local pkgdir
	if thepkg then
		pkgsplit = splitstr(thepkg, "/")
		dev = trim(pkgsplit[1])
		name = trim(pkgsplit[2])
        	insdir = "/var/mizOS/work/" .. name
		pkgdir = "/var/mizOS/packages/" .. dev .. "_" .. name
	end
	if pkgsplit[1] and pkgsplit[2] then
		if op == "install" then
			x([[su -c "rm -rf /var/mizOS/work/*" root]])
			x("cd /var/mizOS/work && git clone https://github.com/" .. pkgsplit[1] .. "/" .. pkgsplit[2])
			x("ls /var/mizOS/work/" .. pkgsplit[2])
			if dofile(insdir .. "/MIZOSPKG.lua") == true then
				print("> Package is valid, continuing installation.")
				local info = dofile(insdir .. "/info.lua")
				local pacpkgs = ""
				local aurpkgs = ""
				for _,pacdep in pairs(info.pacman_depends) do
					pacpkgs = pacpkgs .. pacdep .. " "
				end
				for _,aurdep in pairs(info.aur_depends) do
					aurpkgs = aurpkgs .. aurdep .. " "
				end
				ipkg(pacpkgs)
				ypkg(aurpkgs)
				x("mkdir " .. pkgdir)
				x("cp " .. insdir .. "/info.lua " .. pkgdir .. "/")
				x("cd " .. insdir .. " && ./install")
			else
				return {"error", "That package either doesn't exist, or was not made correctly."}
			end
		elseif op == "remove" then
			if checkfile(pkgdir .. "/info.lua") == true then
				local info = dofile(pkgdir .. "/info.lua")
				print("Removing program files.")
				for _,file in pairs(info.files) do
					print("> Deleting " .. file)
					x("sudo rm " .. file)
				end
				print("Removing program directories.")
				for _,folder in pairs(info.directories) do
					print("> Removing " .. folder)
					x("sudo rm -rf " .. folder)
				end
				local pacpkgs = ""
				local aurpkgs = ""
				for _,pacdep in pairs(info.pacman_depends) do
					pacpkgs = pacpkgs .. pacdep .. " "
				end
				for _,aurdep in pairs(info.aur_depends) do
					aurpkgs = aurpkgs .. aurdep .. " "
				end
				print("Pacman dependencies:\n")
				print(pacpkgs)
				print("\n\nAUR dependencies:\n")
				print(aurpkgs)
				io.write("\n\nRemove dependencies for " .. thepkg .. " ? (y/n)\n\n> ")
				if io.read() == "y" then
					x("sudo pacman -Rn " .. pacpkgs)
					x("yay -Rn " .. aurpkgs)
				end
				x("sudo rm -rf " .. pkgdir)
				return {"output", thepkg .. " has been uninstalled."}
			else
				return {"error", "That package is not installed."}
			end
		elseif op == "update" then
			if checkfile(pkgdir .. "/info.lua") == true then
				x("rm -rf " .. pkgdir)
				x([[su -c "rm -rf /var/mizOS/work/*" root]])
				x("cd /var/mizOS/work && git clone https://github.com/" .. dev .. "/" .. name)
				if dofile(insdir .. "/MIZOSPKG.lua") == true then				
					local info = dofile(insdir .. "/info.lua")
					local pacpkgs = ""
					local aurpkgs = ""
					for _,pacdep in pairs(info.pacman_depends) do
						pacpkgs = pacpkgs .. pacdep .. " "
					end
					for _,aurdep in pairs(info.aur_depends) do
						aurpkgs = aurpkgs .. aurdep .. " "
					end
					ipkg(pacpkgs)
					ypkg(aurpkgs)
					x("mkdir " .. pkgdir)
					x("cp " .. insdir .. "/info.lua " .. pkgdir .. "/")
					x("cd " .. insdir .. " && ./update")
				else
					return {"error", "That package either doesn't exist, or was not made correctly."}
				end
			end
		elseif op == "list" then
			return capture("ls /var/mizOS/packages")
		end
	end
end



--[=[ Software management. ]=]--
system.software = function(op, channel, pkgs)
	local packages = ""
	for _,ag in pairs(pkgs) do
		if ag ~= "neofetch" then
			packages = packages .. ag .. " "
		end
	end
	if op == "fetch" then
		if channel == "aur" then
			ypkg(packages)
		elseif channel == "ui" then
			for _,desktop in pairs(uis) do
                        	if desktop[1] == packages then
					if desktop[3] == false then
                                        	ipkg(desktop[2])
                                	elseif desktop[3] == true then
                                        	ypkg(desktop[2])                                               
					end
                       		end
                	end
		elseif channel == "pacman" then
			x("sudo pacman -S " .. packages)
		elseif channel == "mizos" then
			return package("install", packages)
		end
	elseif op == "remove" then
		if channel == "aur" then
			x("yay -Rn " .. packages)
		elseif channel == "ui" then
			for _,desktop in pairs(uis) do
                                if desktop[1] == packages then  
					if desktop[3] == false then
						x("sudo pacman -Rn " .. desktop[2])
                                        elseif desktop[3] == true then
                                                x("yay -Rn " .. desktop[2])

                                        end
                                end
                        end
		elseif channel == "pacman" then
			x("sudo pacman -Rn " .. packages)
		elseif channel == "mizos" then
			return package("remove", packages)
		end
	elseif op == "clear cache" then
		x("yay -Scc")
		if init == "systemd" then
			x("sudo journalctl --vacuum-time=21days")
		else
			return {"error", "SystemD not found, unable to clear journal logs."}
		end
	elseif op == "list packages" then
		if channel == "mizos" then
			local packagestring = package("list", nil)
			local packagetable = splitstr(packagestring, " ")
			return {"info", packagetable}
		elseif channel == "pacman" then
			return {"rawput", capture("sudo pacman -Qe")}
		elseif channel == "aur" then
			return {"error", "AUR packages cannot be listed individually."}
		end
	else
		return {"error", "Command not found!"}
	end
end



--[=[ Runit command conversion ]=]--
local function runit(op, service)
	if op == "link" then
                        x("sudo ln -s /etc/runit/sv/" .. service .. " /run/runit/service/")
        elseif op == "unlink" then   
		x("sudo rm /run/runit/service/" .. service)
	elseif op == "disable" then
		x("sudo touch /run/runit/service/" .. service .. "/down")  
	elseif op == "enable" then
                x("sudo rm /run/runit/service/" .. service .. "/down")
        elseif op == "start" then
                x("sudo sv start " .. service)
        elseif op == "stop" then         
		x("sudo sv stop " .. service)
        elseif op == "restart" then
                x("sudo sv restart " .. service)
        elseif op == "list" then
                if service == "installed" then   
			return {"info", capture("ls /etc/runit/sv/")}
                elseif service == "linked" then  
			return {"info", capture("ls /run/runit/service/")}
                end
	else
		return {"error", "Command not found!"}
        end
end



--[=[ SystemD command conversion. ]=]--
local function systemd(op, service)
	if op == "link" then              
		return {"error", "This command is only available for the Runit init system."}
        elseif op == "unlink" then
                return {"error", "This command is only available for the Runit init system."}
        elseif op == "disable" then
                x("sudo systemctl disable " .. service)
        elseif op == "enable" then
                x("sudo systemctl enable " .. service)
        elseif op == "start" then
                x("sudo systemctl start " .. service)
        elseif op == "stop" then
                x("sudo systemctl stop " .. service)
        elseif op == "restart" then
                x("sudo systemctl restart " .. service)
        elseif op == "list" then
                if service == "installed" then      
			return {"output", capture("systemctl list-units --type=service --all")}
		elseif service == "linked" then                              
			return {"output", capture("systemctl list-units --state=enabled")}
                end
	else
		return {"error", "Command not found!"}
        end
end



--[=[ OpenRC command conversion ]=]--
local function openrc(op, service)
	if op == "link" then       
		return {"error", "This command is only available for the Runit init system."}
        elseif op == "unlink" then
                return {"error", "This command is only available for the Runit init system."}
	elseif op == "disable" then  
		x("sudo rc-update del " .. service .. " default")  
	elseif op == "enable" then  
		x("sudo rc-update add " .. service .. " default")  
	elseif op == "start" then
                x("sudo rc-service " .. service .. " start")
        elseif op == "stop" then
                x("sudo rc-service " .. service .. " stop")
        elseif op == "restart" then
                x("sudo rc-service " .. service .. " restart")
        elseif op == "list" then
                if service == "installed" then
                        return {"output", capture("rc-update show")}
                elseif service == "linked" then
                        return {"output", capture("rc-update -v show")}
                end
	else
		return {"error", "Command not found!"}
        end
end



--[=[ Service. ]=]--
system.service = function(op, service)
	if init == "runit" then
		return runit(op, service)
	elseif init == "systemd" then
		return systemd(op, service)
	elseif init == "openrc" then
		return openrc(op, service)
	else
		return {"error", "Your init system is not supported."}
	end
end



--[=[ Graphics stuff. ]=]--
system.gfx = function(op, mode, arguments)
	if op == "xi" or op == "xd" then
                x(mgpu(op, arguments))
        elseif op == "mode" then 
		if mode == "i" then
			return {"output", capture("supergfxctl --mode integrated")}
                elseif mode == "d" then
                        return {"output", capture("supergfxctl --mode dedicated")}
                elseif mode == "h" then
                        return {"output", capture("supergfxctl --mode hybrid")}
                elseif mode == "c" then  
			return {"output", capture("supergfxctl --mode compute")}
                elseif mode == "v" then
                        return {"output", capture("supergfxctl --mode vfio")}
                end
	elseif op == "setup" then
		x("sudo systemctl enable --now power-profiles-daemon.service && sudo systemctl enable --now supergfxd")
	else
		return {"error", "Command not found."}
        end
end



--[=[ Info ]=]--
system.info = function(op)
	if op == "help" then
                return {"output", "https://discord.gg/CzHw7cXKCx"}
        elseif op == "source" then
                return {"output", "https://github.com/Mizosu97/mizOS"}
        elseif op == "creator" then
                return {"output", "https://theduat.neocities.org"}
        elseif op == "uilist" then
                return {"info", {"desktops", uis}}
	else
		return {"error", "Command not found."}
	end
end



--[=[ System updater. ]=]--
system.update = function(op)
	if op == "packages" then
		local updatepkgst = capture("ls /var/mizOS/packages")
		local updatepkgs = splitstr(updatepkgst, " ")
		for _,pkg in pairs(updatepkgs) do
			local splitpkg = splitstr(pkg, "_")
			if splitpkg[1] and splitpkg[2] then
				local finalpkg = splitpkg[1] .. "/" .. splitpkg[2]
				package("update", finalpkg)
			end
		end
	elseif op == "system" then
		x("cd /var/mizOS/src && git clone https://github.com/Mizosu97/mizOS && cd /var/mizOS/src/mizOS && ./install && rm -rf /var/mizOS/src/mizOS")
        end
end



--[=[ Root ]=]--
system.root = function(command)
	local final = [[su -c "]] .. command .. [[" root]]
	x(final)
end





return system
