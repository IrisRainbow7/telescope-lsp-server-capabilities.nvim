return require("telescope").register_extension({
	exports = {
		lsp_server_capabilities = require("lsp_server_capabilities").lsp_server_capabilities,
	},
})
