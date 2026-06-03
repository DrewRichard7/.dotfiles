vim.api.nvim_create_user_command("PackClean", function()
	local non_active = vim.iter(vim.pack.get())
		:filter(function(x)
			return not x.active
		end)
		:map(function(x)
			return x.spec.name
		end)
		:totable()

	if #non_active == 0 then
		vim.notify("No non-active plugins found", vim.log.levels.INFO)
		return
	end
end, {})
