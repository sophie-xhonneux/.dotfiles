return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                pylsp,
            },
            handlers = {
                function(server_name) -- default handler (optional)

                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end
            }
        })

        local lspconfig = require("lspconfig")
        lspconfig.pylsp.setup({
            capabilities = capabilities,
            settings = {
                pylsp = {
                    plugins = {
                        -- type checker
                        pylsp_mypy = {enabled = true},
                        -- formater & linter
                        ruff = {
                          enabled = true,  -- Enable the plugin
                          formatEnabled = true,  -- Enable formatting using ruffs formatter
                          extendSelect = { "I" },  -- Rules that are additionally used by ruff
                          extendIgnore = { "C90" },  -- Rules that are additionally ignored by ruff
                          format = { "I" },  -- Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
                          severities = { ["D212"] = "I" },  -- Optional table of rules where a custom severity is desired
                          unsafeFixes = false,  -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action

                          -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
                          lineLength = 88,  -- Line length to pass to ruff checking and formatting
                          exclude = { "__about__.py" },  -- Files to be excluded by ruff checking
                          select = { "F" },  -- Rules to be enabled by ruff
                          ignore = { "D210" },  -- Rules to be ignored by ruff
                          perFileIgnores = { ["__init__.py"] = "CPY001" },  -- Rules that should be ignored for specific files
                          preview = true,  -- Whether to enable the preview style linting and formatting.
                          targetVersion = "py310",  -- The minimum python version to target (applies for both linting and formatting).
                        },
                    }
                }
            }
        })
        lspconfig.ocamllsp.setup({
            on_attach = on_attach,
        })
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<Tab>'] = cmp.mapping.confirm({ select = true }),
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

        vim.keymap.set('n', '<leader>hh', vim.lsp.buf.hover, {})

    end
}
