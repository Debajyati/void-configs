local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
    -- use lazy to install lazy, just an experiment firstly which is going awesome
    {
	 "folke/lazy.nvim",
	 lazy = false,
    },

    {
	"ntk148v/habamax.nvim", 
	dependencies={ "rktjmp/lush.nvim" },
	name = "habamax",
    },

    {
	-- plugins/telescope.lua:
	'nvim-telescope/telescope.nvim', tag = '0.1.4',
	-- or                              , branch = '0.1.x',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		require('telescope').setup({
			defaults = {
				layout_config = {
					horizontal = {
						preview_cutoff = 0,
					},
				},
			},
		})
	end
    },

    {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },
	config = function()
		require("neodev").setup({
			library = {
				enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
				-- these settings will be used for your Neovim config directory
				runtime = true, -- runtime path
				types = true,   -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
				plugins = true, -- installed opt or start plugins in packpath
				-- you can also specify the list of plugins to make available as a workspace library
				-- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
			},
			setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
			-- With lspconfig, Neodev will automatically setup your lua-language-server
			-- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
			-- in your lsp start options
			lspconfig = false,
			-- much faster, but needs a recent built of lua-language-server
			-- needs lua-language-server >= 3.6.0
			pathStrict = true,
		})
	end,
	dependencies = {
		{ "folke/neodev.nvim" },
		    -- {
		    --   "j-hui/fidget.nvim", -- Useful status updates for LSP
		    --   config = function()
		    --     require("fidget").setup {
		    --       sources = { -- Sources to configure
		    --         jdtls = { -- Name of source
		    --           ignore = true, -- Ignore notifications from this source
		    --         },
		    --       },
		    --     }
		    --   end,
		    -- },
		{
			"williamboman/mason.nvim",
			cmd = {
				"Mason",
				"MasonInstall",
				"MasonUninstall",
				"MasonUninstallAll",
				"MasonLog",
			}, -- Package Manager
			dependencies = "williamboman/mason-lspconfig.nvim",
			config = function()
				local mason = require("mason")
				local mason_lspconfig = require("mason-lspconfig")
				local lspconfig = require("lspconfig")

				require("lspconfig.ui.windows").default_options.border = "rounded"

				local servers = {
					    -- "jsonls",
					    -- "clangd",
					    -- "intelephense",
					    -- "cssls",
					    -- "html",
					    -- "tsserver",
					    -- "emmet_ls",
					    -- "pyright",
					    -- "omnisharp",
					    -- "yamlls",
					    -- "gopls",
					    -- "lemminx",
					    -- "vimls",
					    -- "lua_ls",
					    -- "cmake",
					    -- "powershell_es",
				}

				mason.setup({
					ui = {
						    -- Whether to automatically check for new versions when opening the :Mason window.
						check_outdated_packages_on_open = false,
						border = "single",
						icons = {
							package_installed = "✓",
							package_pending = "",
							package_uninstalled = "➜",
						},
					},
				})

				mason_lspconfig.setup({
					ensure_installed = servers,
				})

				mason_lspconfig.setup_handlers({
					function(server_name)
						if server_name ~= "jdtls" then
							local opts = {
								on_attach = require("plugins.lsp.handlers").on_attach,
								capabilities = require("plugins.lsp.handlers").capabilities,
							}

							local require_ok, server = pcall(require, "plugins.lsp.settings." .. server_name)
							if require_ok then
								opts = vim.tbl_deep_extend("force", server, opts)
							end

							lspconfig[server_name].setup(opts)
						end
					end,
				})
			end,
		},
	},
    },

    {{
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        config = function ()
                local configs = require("nvim-treesitter.configs")

                configs.setup({
                        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
                        sync_install = false,
                        auto_install = true,
                        highlight = { enable = true, additional_vim_regex_highlighting = false, },
                        indent = { enable = true },
                })
        end
        },
        {"nvim-treesitter/playground"},
    },
    {
	"numToStr/Comment.nvim",
	-- enabled = false,
	config = function()
		require("Comment").setup({
			---Add a space b/w comment and the line
			padding = true,
			---Whether the cursor should stay at its position
			sticky = true,
			---Lines to be ignored while (un)comment
			ignore = nil,
			---LHS of toggle mappings in NORMAL mode
			toggler = {
				---Line-comment toggle keymap
				line = '<leader>/',
				---Block-comment toggle keymap
				block = 'gbc',
			},
			---LHS of operator-pending mappings in NORMAL and VISUAL mode
			opleader = {
				---Line-comment keymap
				line = '<leader>/',
				---Block-comment keymap
				block = 'gb',
			},
			---LHS of extra mappings
			extra = {
				---Add comment on the line above
				above = 'gcO',
				---Add comment on the line below
				below = 'gco',
				---Add comment at the end of line
				eol = 'gcA',
			},
			---Enable keybindings
			---NOTE: If given `false` then the plugin won't create any mappings
			mappings = {
				---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
				basic = true,
				---Extra mapping; `gco`, `gcO`, `gcA`
				extra = true,
			},
			---Function to call before (un)comment
			pre_hook = nil,
			---Function to call after (un)comment
			post_hook = nil, --
		})
	end

    },
    {
	"hrsh7th/nvim-cmp",
		event = {
			"InsertEnter",
			"CmdlineEnter"
		},
		dependencies = {
			"hrsh7th/cmp-buffer", -- Buffer Completions
				"hrsh7th/cmp-path", -- Path Completions
				"saadparwaiz1/cmp_luasnip", -- Snippet Completions
				"hrsh7th/cmp-nvim-lsp", -- LSP Completions
				"hrsh7th/cmp-nvim-lua", -- Lua Completions
				"hrsh7th/cmp-cmdline", -- CommandLine Completions
				"L3MON4D3/LuaSnip", -- Snippet Engine
				"rafamadriz/friendly-snippets", -- Bunch of Snippets
				"windwp/nvim-autopairs", -- autopairs
		},
		config = function()
			local cmp = require "cmp"
			local luasnip = require "luasnip"

			require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.fn.stdpath "config" .. "/snippets/snipmate" }
	require("luasnip.loaders.from_vscode").lazy_load()
		-- require("luasnip.loaders.from_vscode").lazy_load { paths = vim.fn.stdpath "config" .. "/snippets/vscode" }

	local kind_icons = {
		Text = "",
		Method = "",
		Function = "",
		Constructor = "",
		Field = "ﰠ",
		Variable = "",
		Class = "ﴯ",
		Interface = "",
		Module = "",
		Property = "ﰠ",
		Unit = "塞",
		Value = "",
		Enum = "",
		Keyword = "",
		Snippet = "",
		Color = "",
		File = "",
		Reference = "",
		Folder = "",
		EnumMember = "",
		Constant = "",
		Struct = "פּ",
		Event = "",
		Operator = "",
		TypeParameter = "",
		Namespace = " ",
		Package = " ",
		String = " ",
		Number = " ",
		Boolean = " ",
		Array = " ",
		Object = " ",
		Key = " ",
		Null = " ",
	}

	cmp.setup {
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body) -- For `luasnip` users.
				end,
		},

			mapping = cmp.mapping.preset.insert {
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs( -1)),
				["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1)),
				---@diagnostic disable-next-line: missing-parameter
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
				-- Abort auto completion
					["<C-c>"] = cmp.mapping {
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					},
				-- Accept currently selected item. If none selected, `select` first item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					["<CR>"] = cmp.mapping.confirm { select = false },
				["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
						cmp.select_next_item()
						elseif luasnip.expandable() then
						luasnip.expand()
						elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
						else
						fallback()
						end
						end, {
						"i",
						"s",
						}),
				["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
						cmp.select_prev_item()
						elseif luasnip.jumpable( -1) then
						luasnip.jump( -1)
						else
						fallback()
						end
						end, {
						"i",
						"s",
						}),
			},
			formatting = {
				format = function(_, vim_item)
					vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
					return vim_item
					end,
			},
			sources = {
				{ name = "nvim_lsp" },
				{ name = "nvim_lua" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			},
			confirm_opts = {
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			experimental = {
				ghost_text = true,
			},
	}

	cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
			{ name = "cmdline" },
			},
			window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
			},
			formatting = {
			-- fields = { 'abbr' },
			format = function(_, vim_item)
			vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
			return vim_item
			end,
			},
			})
	end,
    },

    {
	'windwp/nvim-autopairs',
	-- enabled = false,
	dependencies = { "hrsh7th/nvim-cmp" },
	config = function()
		require('nvim-autopairs').setup({
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false,
			},
			disable_filetype = { "TelescopePrompt", "spectre_panel", "vim" },
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0, -- Offset from pattern match
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
		})
		local cmp_autopairs = require('nvim-autopairs.completion.cmp')
		local cmp = require('cmp')
		cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
	end

    },

    {"mbbill/undotree"},

    {"ThePrimeagen/harpoon"},

    {"nvim-tree/nvim-web-devicons", lazy=true},
    {"tpope/vim-fugitive"},


})
