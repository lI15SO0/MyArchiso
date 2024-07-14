local Logger = {
	setupd = false,
	mode = {},
	tags = {}
}

function Logger.setup(modes)
	local tag = 1
	for i, j in pairs(modes) do
		Logger.tags[i] = tag
		Logger.mode[i] = {tag = tag, path = j}
		tag = tag * 2
	end
	Logger.setupd = true
	return Logger
end

function Logger.write(strs, mode)
	if Logger.setupd then
		for _, v in pairs(Logger.mode) do
			if ( mode & v.tag ) ~= 0 then
				local file = io.open(v.path, "a")
				file:write(strs .. "\n")
				file:flush()
				file:close()
			end
		end
	else
		print("[Warn] Logger may not setup.")
	end
	print(strs)
end

function Logger.info(mode,  ... )
	local arg = {...}
	local strs = "[Info] " .. table.concat(arg, " ")
	Logger.write(strs, mode)
end

function Logger.warn(mode,  ... )
	local arg = {...}
	local strs = "[Warn] " .. table.concat(arg, " ")
	Logger.write(strs, mode)
end

function Logger.err(mode,  ... )
	local arg = {...}
	local strs = "[Err] " .. table.concat(arg, " ")
	Logger.write(strs, mode)
end

function Logger.log(mode,  ... )
	local arg = {...}
	local strs = table.concat(arg, " ")
	Logger.write(strs, mode)
end

return Logger
