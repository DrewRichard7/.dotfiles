-- require("vim._core.ui2").enable({})
require("config.init")
require("plugins.init")
require("todo-float").setup({
	global_file = "~/projects/todo.md",
})
