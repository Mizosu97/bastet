local mizOS = {}



mizOS.initializeIO = function(frontend_IO)
	read  = frontend_IO.inp
	write = frontend_IO.outp
	say   = frontend_IO.foutp
	say2  = frontend_IO.afoutp
	fault = frontend_IO.err
end


local GlobalData = dofile("/var/mizOS/core/libraries/mOS_Global_Data.lua")
homeDir               = GlobalData.homeDir
initSystem            = GlobalData.initSystem
UITable               = GlobalData.UITable
integerCharacterSheet = GlobalData.integerCharacterSheet
hexCharacterSheet     = GlobalData.hexCharacterSheet

local UtilityFunctions = dofile("/var/mizOS/core/libraries/mOS_Utility_Functions.lua")
x            = UtilityFunctions.x
xs           = UtilityFunctions.xs
runAsRoot    = UtilityFunctions.runAsRoot
readCommand  = UtilityFunctions.readCommand
iPkg         = UtilityFunctions.iPkg
rPkg         = UtilityFunctions.rPkg
checkFile    = UtilityFunctions.checkFile
readFile     = UtilityFunctions.readFile
writeFile    = UtilityFunctions.writeFile
splitString  = UtilityFunctions.splitString
trimWhite    = UtilityFunctions.trimWhite
isInt        = UtilityFunctions.isInt
isHex        = UtilityFunctions.isHex
writeSetting = UtilityFunctions.writeSetting
exit         = UtilityFunctions.exit



return mizOS
