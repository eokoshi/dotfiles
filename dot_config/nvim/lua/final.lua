vim.cmd.packadd("nvim.undotree")

-- Custom Filetypes
vim.filetype.add({
	filename = {
		["dot_bashrc"] = "bash",
	},
	extension = {
		tmpl = "gotmpl",
		age = "age",
	},
})

vim.filetype.add({
	pattern = {
		["compose.*%.ya?ml"] = "yaml.docker-compose",
		["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
	},
})
