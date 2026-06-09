local M = {}

local function center_in(outer, inner)
	return math.floor((outer - inner) / 2)
end

local function win_config()
	local width = math.min(math.floor(vim.o.columns * 0.8), 64)
	local height = math.floor(vim.o.lines * 0.8)

	return {
		relative = "editor",
		width = width,
		height = height,
		col = center_in(vim.o.columns, width),
		row = center_in(vim.o.lines, height),
		border = "rounded",
	}
end

local function open_floating_file(path, missing_message)
	local expanded_path = vim.fn.expand(path)

	if vim.fn.filereadable(expanded_path) == 0 then
		vim.notify(missing_message or ("file does not exist: " .. expanded_path), vim.log.levels.WARN)
		return
	end

	local buf = vim.fn.bufadd(expanded_path)
	vim.fn.bufload(buf)

	vim.bo[buf].swapfile = false

	vim.api.nvim_open_win(buf, true, win_config())

	vim.keymap.set("n", "q", function()
		if vim.api.nvim_get_option_value("modified", { buf = buf }) then
			vim.notify("save your changes first", vim.log.levels.WARN)
			return
		end

		vim.api.nvim_win_close(0, true)
	end, {
		buffer = buf,
		silent = true,
		desc = "Close todo float",
	})
end

function M.open_global()
	open_floating_file("~/projects/todo.md", "global todo.md does not exist")
end

function M.open_local()
	open_floating_file("./todo.md", "no project local todo.md")
end

function M.setup(opts)
	opts = opts or {}

	local global_file = opts.global_file or "~/projects/todo.md"

	vim.api.nvim_create_user_command("TodoGlobal", function()
		open_floating_file(global_file, "global todo.md does not exist")
	end, {})

	vim.api.nvim_create_user_command("TodoLocal", function()
		open_floating_file("./todo.md", "no project local todo.md")
	end, {})

	vim.api.nvim_create_user_command("Todo", function()
		open_floating_file(global_file, "global todo.md does not exist")
	end, {})
end

return M
