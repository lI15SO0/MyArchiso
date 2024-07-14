local tags = require("Lua.Logger").tags

local M = {
	options = {
		time = 0,

		image_name = "archiso",
		target_root_dir = "~",
		target = "Archisolinux_" .. os.date("%Y-%m-%d_%H-%M", 0),
		target_dir = "~/Archiso/" .. "Archlinux_" .. os.date("%Y-%m-%d_%H-%M", 0),
	},
	status = {
		fs_change = false,
	},
	Logger = require("Lua.Logger"),
}

local function executer(cmd)
	local cmd_str = table.concat(cmd, " ")
	local cmd_line = io.popen(cmd_str)
	if cmd_line == nil then
		return ''
	end
	local result = cmd_line:read('a')
	cmd_line:close()
	return string.sub(result, 1, -2)
end

local function executes(mode, cmds)
	local result = {}
	for i, v in pairs(cmds) do
		result[i] = executer(v)
		M.Logger.log(mode, result[i])
	end
	return result
end

function M.setup(opt)
	local time = os.date("%Y-%m-%d %H:%M:%S", opt.time)
	local time_string = os.date("%Y-%m-%d_%H-%M", opt.time)

	M.options = {
		time = opt.time,
		image_name = opt.image_name,
		target_root_dir = opt.target_root_dir,
		target = opt.target .. time_string,
		target_dir = opt.target_root_dir .. "/" .. opt.target .. time_string,
	}

	M.Logger.setup {
		buildLog = opt.target_root_dir .. "/Build_" .. time_string .. ".log",
		vbuildLog = opt.target_root_dir .. "/Build_verbose_" .. time_string .. ".log",
		checkLog = opt.target_root_dir .. "/CheckLog_" .. time_string .. ".log"
	}

	M.Logger.info(
		tags.buildLog | tags.vbuildLog | tags.checkLog,
		"Builder setup completed at: " .. time .. "."
	)
end

function M.DetectImage()
	M.Logger.info(
		tags.buildLog | tags.vbuildLog,
		'Detecting image "' .. M.options.image_name .. '".'
	)
	local result = executer({ "docker", "images", "-q", M.options.image_name })

	M.Logger.info(
		tags.vbuildLog,
		'Detected docker image, result: "' .. result .. '"'
	)
	if result == "" then
		return false
	else
		return true
	end
end

function M.BuildDockerImage()
	M.Logger.info(
		tags.buildLog | tags.vbuildLog,
		'Building image \"' .. M.options.image_name .. '"'
	)

	local result = executer({ "docker", "build", ".", "-t", M.options.image_name })
	M.Logger.log(
		tags.vbuildLog,
		result
	)
end

function M.FsChangeDector()
	M.Logger.info(
		tags.buildLog | tags.checkLog | tags.vbuildLog,
		"Checking fs change."
	)
	executer({ "python", "./get_file_sha1.py" })
	local diff = executer({ "diff", "new.sha", "old.sha" })
	local result = false
	if diff ~= "" then
		M.Logger.info(
			tags.buildLog | tags.checkLog | tags.vbuildLog,
			"fs changed! need update image"
		)
		result = true
	else
		M.Logger.info(
			tags.buildLog | tags.checkLog | tags.vbuildLog,
			"fs not changed."
		)
		result = false
	end
	executer({ "mv", "new.sha", "old.sha" })
	M.options.fs_change = result
	return result
end

function M.BuildArchiso()
	M.Logger.info(
		tags.buildLog | tags.vbuildLog,
		'Building archiso via docker image "' .. M.options.image_name .. '"'
	)
	local cmds = {}

	local container = executer({ "docker", "container", "ls", "-f", "name=builder", "-q" })
	if container ~= "" then
		M.Logger.info(tags.buildLog | tags.vbuildLog, "Find old build container, deleteing...")
		table.insert(cmds, { "docker", "container", "rm", "builder", "2>&1" })
	end

	table.insert(cmds,
		{ "docker", "run", "--privileged", "--name", "builder", "--hostname", "archisobuilder", M.options.image_name,
			"2>&1" })
	table.insert(cmds, { "docker", "container", "cp", "builder:out", M.options.target_dir, "2>&1" })
	table.insert(cmds, { "docker", "container", "rm", "builder", "2>&1" })

	executes(
		tags.vbuildLog,
		cmds
	)
	M.Logger.info(
		tags.buildLog | tags.vbuildLog | tags.checkLog,
		"Build completed. Checking file sha256."
	)
	local sha_result = executes(
		tags.checkLog,
		{ { "sh", '-c "', "cd", M.options.target_dir, ";", "sha256sum", "-c", "*.sha256", '"' } }
	)
	M.Logger.info(
		tags.buildLog | tags.vbuildLog | tags.checkLog,
		"Check complete, result: " .. sha_result[1]
	)
end

function M.renameDir()
	M.Logger.info(
		tags.buildLog | tags.vbuildLog,
		M.options.target_root_dir .. "/out -> " .. M.options.target_dir
	)
	os.rename(M.options.target_root_dir .. "/out", M.options.target_dir)
end

return M
