return {
  {
    "milanglacier/minuet-ai.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      -- Uses local Ollama via OpenAI-compatible chat endpoint for llama3.1:8b / gemma4:12b.
      -- Switch to 'ollama_qwen_fim' preset via <leader>aM if you pull qwen2.5-coder:7b.
      provider = "openai_compatible",
      n_completions = 1,
      context_window = 2048,
      request_timeout = 5,
      throttle = 800,
      debounce = 350,
      notify = "error",

      virtualtext = {
        auto_trigger_ft = { "*" },
        auto_trigger_ignore_ft = {
          "snacks_picker_input",
          "snacks_dashboard",
          "TelescopePrompt",
          "lazy",
          "mason",
          "neo-tree",
          "help",
        },
        show_on_completion_menu = true,
        keymap = {
          accept = "<A-y>",
          accept_line = "<A-a>",
          accept_n_lines = "<A-z>",
          next = "<A-]>",
          prev = "<A-[>",
          dismiss = "<A-e>",
        },
      },

      provider_options = {
        openai_compatible = {
          api_key = function()
            return "ollama"
          end,
          name = "Ollama",
          end_point = "http://localhost:11434/v1/chat/completions",
          model = "llama3.1:8b",
          stream = true,
          optional = {
            max_tokens = 128,
            top_p = 0.9,
          },
        },
        openai_fim_compatible = {
          api_key = function()
            return "ollama"
          end,
          name = "Ollama-FIM",
          end_point = "http://localhost:11434/v1/completions",
          model = "qwen2.5-coder:7b",
          stream = true,
          optional = {
            max_tokens = 128,
            top_p = 0.9,
            stop = { "\n\n" },
          },
        },
      },

      presets = {
        ollama_llama = {
          provider = "openai_compatible",
          provider_options = {
            openai_compatible = {
              model = "llama3.1:8b",
            },
          },
        },
        ollama_gemma = {
          provider = "openai_compatible",
          provider_options = {
            openai_compatible = {
              model = "gemma4:12b",
            },
          },
        },
        ollama_qwen_fim = {
          provider = "openai_fim_compatible",
          provider_options = {
            openai_fim_compatible = {
              model = "qwen2.5-coder:7b",
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>am",
        "<cmd>Minuet virtualtext toggle<cr>",
        desc = "Toggle Ollama Inline Suggestions",
      },
      {
        "<leader>aM",
        function()
          vim.ui.select(
            { "ollama_llama (llama3.1:8b)", "ollama_gemma (gemma4:12b)", "ollama_qwen_fim (qwen2.5-coder:7b)" },
            { prompt = "Select Local Ollama Model Preset:" },
            function(choice)
              if not choice then
                return
              end
              local preset = choice:match("^(%S+)")
              vim.cmd("Minuet change_preset " .. preset)
              vim.notify("Minuet preset switched to " .. preset)
            end
          )
        end,
        desc = "Switch Ollama Inline Model",
      },
    },
  },
}
