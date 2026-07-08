vim.cmd.packadd("nvim.undotree")

-- Custom Filetypes
vim.filetype.add({
	filename = {
		["dot_bashrc"] = "bash",
	},
	pattern = {
		["compose.*%.ya?ml"] = "yaml.docker-compose",
		["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
	},
	extension = {
		tmpl = "gotmpl",
		age = "age",
	},
})
