return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	build = ":Copilot auth",
	event = "InsertEnter",
	opts = {
		suggestion = {
			enabled = not vim.g.ai_cmp,
			auto_trigger = true,
			keymap = {
				accept = false, -- handled by nvim-cmp / blink.cmp
				next = "<M-]>",
				prev = "<M-[>",
			},
		},
		panel = { enabled = false },
		filetypes = {
			markdown = true,
			help = true,
		},
	},
	config = function(_, opts)
		require("copilot").setup(opts)
		-- HACK: work-around for https://github.com/neovim/neovim/issues/31262
		local Util = require("copilot.util")
		local language_for_file_type = Util.language_for_file_type
		Util.language_for_file_type = function(ft)
			return language_for_file_type(ft or "")
		end
	end,
}
