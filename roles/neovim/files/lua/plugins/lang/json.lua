-- NOTE: Disabled
-- if true then
--   return {}
-- end

local mason = {
  'biome',
  'prettierd',
}

return {
  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc" })
      end
    end,
  },

  -- SchemaStore
  -- yaml schema support
  -- {
  --   "b0o/SchemaStore.nvim",
  --   lazy = true,
  --   version = false,
  -- },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        jsonls = {
          -- lazy-load schemastore when needed
          -- NOTE: Uncomment, if the schemaStore plugin is enabled
          -- on_new_config = function(new_config)
          --   new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          --   vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          -- end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },

  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, mason)
    end,
  },

  -- Formatter
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        ['json'] = { { 'biome', 'prettierd' } },
        ['jsonc'] = { { 'biome', 'prettierd' } },
        ['yaml'] = { { 'biome', 'prettierd' } },
      },
    },
  },
}
