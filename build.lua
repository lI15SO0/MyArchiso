#!/bin/lua

local Builder = require("Lua.Builder")
Builder.setup {
	time = os.time(),

	image_name = "archiso",
	target_root_dir = "/Archiso",
	target = "Archlinux",
}

if Builder.FsChangeDector() then
	Builder.BuildDockerImage()
elseif not Builder.DetectImage() then
	Builder.BuildDockerImage()
end

Builder.BuildArchiso()
Builder.renameDir()
