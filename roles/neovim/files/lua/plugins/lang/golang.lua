vim.filetype.add({ extension = { templ = "templ" } })

return {
  -- {
  --   "ray-x/go.nvim",
  --   dependencies = { -- optional packages
  --     "neovim/nvim-lspconfig",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   config = function()
  --     require("go").setup()
  --   end,
  --   event = { "CmdlineEnter" },
  --   ft = { "go", 'gomod' },
  --   build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  -- },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      'vrischmann/tree-sitter-templ',
    },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
        "gosum",
        "templ"
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        templ = {},
        gopls = {
          keys = {
            -- Workaround for the lack of a DAP strategy: https://github.com/nvim-neotest/neotest-go/issues/12
            { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
          },
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
      setup = {
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          LazyVim.lsp.on_attach(function(client, _)
            if client.name == "gopls" then
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end)
          -- end workaround
        end,
        templ = function (_, opts)
        end
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "goimports", "gofumpt", "delve" })
    end,
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "williamboman/mason.nvim",
      -- "leoluz/nvim-dap-go"
    },
    opts = function()
      local dap = require("dap")
      dap.adapters['go'] = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. '/mason/bin/dlv',
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }

      dap.configurations["go"] = {
        {
          type = "go",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
        },
        {
          type = "go",
          name = "Debug",
          request = "launch",
          program = vim.fn.glob(vim.fn.getcwd() .. "**/main.go") or "${file}"
        },
      }
    end
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = {
      adapters = {
        ["neotest-go"] = {
          -- Here we can set options for neotest-go, e.g.
          -- args = { "-tags=integration" }
          recursive_run = true,
        },
      },
    },
  },
}
