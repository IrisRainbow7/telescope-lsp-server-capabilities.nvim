return require("telescope").register_extension({
	exports = {
		lsp_server_capabilities = require("telescope_lsp_server_capabilities").lsp_server_capabilities,
	},
})
