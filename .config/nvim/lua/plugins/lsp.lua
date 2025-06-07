return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		-- Mason must be loaded before its dependents so we need to set it up here.
		-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "saghen/blink.cmp" },
		{ "mfussenegger/nvim-jdtls" },
		{
			-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "norcalli/nvim-colorizer.lua" },

		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		--  This function gets run when an LSP attaches to a particular buffer.
		--    That is to say, every time a new file is opened that is associated with
		--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
		--    function will be executed to configure the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end
				-- Jump to the definition of the word under your cursor.
				--  This is where a variable was first declared, or where a function is defined, etc.
				--  To jump back, press <C-t>.
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

				-- Find references for the word under your cursor.
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

				-- Jump to the implementation of the word under your cursor.
				--  Useful when your language has ways of declaring types without an actual implementation.
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

				-- Fuzzy find all the symbols in your current workspace.
				--  Similar to document symbols, except searches over your entire project.
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header.
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
				---@param client vim.lsp.Client
				---@param method vim.lsp.protocol.Method
				---@param bufnr? integer some lsp support methods only in specific files
				---@return boolean
				local function client_supports_method(client, method, bufnr)
					if vim.fn.has("nvim-0.11") == 1 then
						return client:supports_method(method, bufnr)
					else
						return client.supports_method(method, { bufnr = bufnr })
					end
				end

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if
					client
					and client_supports_method(
						client,
						vim.lsp.protocol.Methods.textDocument_documentHighlight,
						event.buf
					)
				then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if
					client
					and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
				then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Diagnostic Config
		-- See :help vim.diagnostic.Opts
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			} or {},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		require("lspconfig").gdscript.setup(capabilities)
		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. Available keys are:
		--  - cmd (table): Override the default command used to start the server
		--  - filetypes (table): Override the default list of associated filetypes for the server
		--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--  - settings (table): Override the default settings passed when initializing the server.
		--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
		local servers = {
			clangd = {},
			pyright = {},
			html = {
				filetype = {
					"ejs",
				},
			},
			-- This starts a new client & server,
			-- or attaches to an existing client & server depending on the `root_dir`.
			lua_ls = {
				-- cmd = { ... },
				-- filetypes = { ... },
				-- capabilities = {},
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						-- diagnostics = { disable = { 'missing-fields' } },
					},
				},
			},
			-- JDTLS configuration for Eclipse projects
			jdtls = {
				-- The `cmd` parameter specifies the command to start JDTLS.
				-- Mason typically installs JDTLS in ~/.local/share/nvim/mason/bin/
				cmd = {
					vim.fn.expand("$HOME/.local/share/nvim/mason/bin/jdtls"),
				},
				-- This is CRUCIAL for Eclipse projects.
				-- JDTLS will look for any of these files to identify the project root.
				-- '.project' is the key for Eclipse projects.
				root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", ".project" }),
				-- JDTLS requires a dedicated workspace directory for each project.
				-- It stores project metadata, build output, and other internal data here.
				-- This dynamically creates a unique workspace for each project based on its name.
				-- Make sure to adjust the `workspace_root` path to a suitable location on your system.
				workspace_folder = function(root_dir)
					local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
					local workspace_root = vim.fn.expand("$HOME/.cache/nvim/jdtls-workspaces") -- Example path for Linux/macOS
					if not vim.loop.fs_stat(workspace_root) then
						vim.fn.mkdir(workspace_root, "p")
					end
					return workspace_root .. "/" .. project_name
				end,
				settings = {
					java = {
						configuration = {
							runtimes = {
								-- Define your JDK paths here if your projects use specific Java versions.
								-- JDTLS will pick the 'default' runtime for new projects.
								{
									name = "JavaSE-17",
									path = "/usr/lib/jvm/java-17-openjdk", -- Adjust to your JDK 17 path
									default = true,
								},
								{
									name = "JavaSE-11",
									path = "/usr/lib/jvm/java-11-openjdk", -- Adjust to your JDK 11 path
								},
								-- Add more runtimes as needed for different projects
							},
						},
					},
				},
				init_options = {
					-- If you use Lombok in your Eclipse projects, you need to point JDTLS to the lombok.jar.
					-- Mason usually installs lombok.jar in the same directory as jdtls.
					-- Verify the exact path for your Mason installation.
					["-javaagent"] = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar"),
					-- You can add more init_options here if needed for specific JDTLS features.
					-- For example, for advanced debugging or other extensions.
				},
				-- Pass capabilities to JDTLS (inherited from the main capabilities variable)
				capabilities = capabilities,
				-- The `on_attach` function is already handled by the global `LspAttach` autocommand.
				-- You can add JDTLS-specific `on_attach` logic here if it's not generic LSP behavior.
				-- For example, specific keymaps for JDTLS commands like organize imports.
				on_attach = function(client, bufnr)
					-- Call the existing global LspAttach handler
					vim.api.nvim_exec_autocmds("LspAttach", {
						buffer = bufnr,
						data = { client_id = client.id },
					})
					-- Add JDTLS specific keymaps that are not in the generic LspAttach
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "JDTLS: " .. desc })
					end
					map("<leader>oi", require("jdtls").organize_imports, "[O]rganize [I]mports")
					map("<leader>ev", require("jdtls").extract_variable, "[E]xtract [V]ariable")
					map(
						"v",
						"<leader>em",
						[[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
						"[E]xtract [M]ethod"
					)
				end,
			},
		}

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
			"jdtls",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
			automatic_installation = false,
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for ts_ls)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
					require("colorizer").setup()
				end,
			},
		})
	end,
}
