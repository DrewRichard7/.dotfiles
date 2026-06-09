local M = {}

M.floating_state = { buf = -1, win = -1 }
M.bottom_state = { buf = -1, win = -1 }
M.right_state = { buf = -1, win = -1 }

local hostname = vim.fn.hostname()

local function get_shell()
	if hostname == "andrews-MacBook-Pro.local" then
		return vim.env.SHELL or "zsh"
	end
	return vim.env.shell or "bash"
end

local SHELL = get_shell()

local function is_valid_buf(buf)
	return type(buf) == "number" and buf > 0 and vim.api.nvim_buf_is_valid(buf)
end

local function is_valid_win(win)
	return type(win) == "number" and win > 0 and vim.api.nvim_win_is_valid(win)
end

local function create_scratch_buf()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "hide"
	vim.bo[buf].swapfile = false
	return buf
end

local function ensure_terminal_buf(state)
	if not is_valid_buf(state.buf) then
		state.buf = create_scratch_buf()
	end

	if vim.bo[state.buf].buftype ~= "terminal" then
		vim.api.nvim_buf_call(state.buf, function()
			vim.fn.jobstart({ SHELL, "--login", "-i" }, {
				term = true,
			})
		end)
	end

	return state.buf
end

function M.create_floating_window(buf, width, height)
	width = width or math.floor(vim.o.columns * 0.9)
	height = height or math.floor(vim.o.lines * 0.6)

	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	})

	return win
end

local function create_bottom_window(buf)
	local height = math.floor(vim.o.lines * 0.3)

	return vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = vim.o.columns,
		height = height,
		row = vim.o.lines - height - 2,
		col = 0,
		style = "minimal",
		border = { "", "═", "", "", "", "", "", "" },
	})
end

local function ensure_opencode_buf(state)
	if not is_valid_buf(state.buf) then
		state.buf = create_scratch_buf()
	end

	if vim.bo[state.buf].buftype ~= "terminal" then
		vim.api.nvim_buf_call(state.buf, function()
			local cwd = vim.fn.getcwd()

			vim.fn.jobstart({
				SHELL,
				"--login",
				"-i",
				"-c",
				"opencode " .. vim.fn.shellescape(cwd),
			}, {
				term = true,
			})
		end)
	end

	return state.buf
end

local function create_right_window(buf)
	local width = math.floor(vim.o.columns * 0.4)

	vim.cmd("botright vertical " .. width .. "split")

	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)

	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	vim.wo[win].signcolumn = "no"
	vim.wo[win].wrap = false

	return win
end

function M.toggle_floating_terminal()
	if is_valid_win(M.floating_state.win) then
		vim.api.nvim_win_hide(M.floating_state.win)
		M.floating_state.win = -1
		return
	end

	local buf = ensure_terminal_buf(M.floating_state)
	M.floating_state.win = M.create_floating_window(buf)
	vim.cmd("startinsert")
end

function M.toggle_bottom_terminal()
	if is_valid_win(M.bottom_state.win) then
		vim.api.nvim_win_hide(M.bottom_state.win)
		M.bottom_state.win = -1
		return
	end

	local buf = ensure_terminal_buf(M.bottom_state)
	M.bottom_state.win = create_bottom_window(buf)
	vim.cmd("startinsert")
end

function M.toggle_right_terminal()
	if is_valid_win(M.right_state.win) then
		vim.api.nvim_win_close(M.right_state.win, false)
		M.right_state.win = -1
		return
	end

	local buf = ensure_opencode_buf(M.right_state)
	M.right_state.win = create_right_window(buf)
	vim.cmd("startinsert")
end

function M.show_messages()
	local output = vim.fn.execute("messages")
	local lines = vim.split(output, "\n", { plain = true })
	lines = #lines > 0 and lines or { "" }

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_call(buf, function()
		vim.opt_local.bufhidden = "wipe"
		vim.opt_local.buftype = "nofile"
		vim.opt_local.swapfile = false
	end)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	local ui = vim.api.nvim_list_uis()[1]
	local max_len = 0
	for _, line in ipairs(lines) do
		max_len = math.max(max_len, #line)
	end

	local width = math.max(1, math.min(max_len, ui.width - 4))
	local height = math.max(1, math.min(#lines, math.floor(ui.height / 2)))
	local row = math.floor((ui.height - height) / 2)
	local col = math.floor((ui.width - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
	})

	vim.api.nvim_win_call(win, function()
		vim.wo.wrap = false
	end)

	vim.keymap.set("n", "q", "<cmd>close<CR>", {
		buffer = buf,
		silent = true,
	})
end

return M
