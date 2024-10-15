return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        'VonHeikemen/lsp-zero.nvim',
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                ['<C-e>'] = cmp.mapping.abort(),
                ["<C-y>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        require('mason').setup({
            PATH = "append"
        })
        require('mason-lspconfig').setup({
            ensure_installed = { 'lua_ls', 'ruff', 'pylsp'},
            handlers = {
                function(server_name)
                    if server_name == 'ruff' then
                        local ruff_config_path = vim.loop.os_homedir() .. '/.config/ruff/ruff.toml'
                        local project_ruff_config = vim.loop.cwd() .. '/pyproject.toml'
                        local f = io.open(project_ruff_config, 'r')
                        if f ~= nil then
                            io.close(f)
                            ruff_config_path = project_ruff_config
                        end
                        require('lspconfig').ruff.setup({
                            init_options = {
                                settings = {
                                    format = {
                                        args = { "--config=" .. ruff_config_path }
                                    },
                                    lint = {
                                        args = { "--config=" .. ruff_config_path }
                                    }
                                }
                            }
                        })
                    elseif server_name == 'pylsp' then
                        require('lspconfig').pylsp.setup({
                            settings = {
                                pylsp = {
                                    plugins = {
                                        pylsp_mypy = {enabled = true},
                                        flake8 = { enabled = false },
                                        yapf = { enabled = false },
                                        flakes = { enabled = false },
                                        pylint = { enabled = false },
                                        pycodestyle = { enabled = false },
                                        pydocstyle = { enabled = false },
                                        mccabe = { enabled = false },
                                        autopep8 = { enabled = false },
                                    }
                                }
                            }
                        })
                    elseif server_name == 'lua_ls' then
                        require('lspconfig').lua_ls.setup({
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { 'vim', 'describe', 'it' },
                                    },
                                    workspace = { library = vim.api.nvim_get_runtime_file("", true), },
                                    telemetry = { enable = false, },
                                }
                            }
                        })
                    else
                        require('lspconfig')[server_name].setup({
                        })
                    end
                end,
            }
        })
        require('lspconfig').ocamllsp.setup({
            on_attach = on_attach,
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(event
            )
                local map = function(key, func, desc)
                    vim.keymap.set("n", key, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
                map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                map(
                    "<leader>ws",
                    require("telescope.builtin").lsp_dynamic_workspace_symbols,
                    "[W]orkspace [S]ymbols"
                )
                map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                map("<leader>hh", vim.lsp.buf.hover, "Hover Documentation")
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
            end,
        })
    end
}
