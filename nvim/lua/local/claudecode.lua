return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal = {
      snacks_win_opts = {
        position = "bottom",
        height = 0.4,
        width = 1.0,
        border = "single",
      }
    },
    diff_opts = {
      open_in_new_tab = false,
    },
  },
  keys = {
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    {
      "<leader>ac",
      function()
        require("lazy").load({ plugins = { "claudecode.nvim" } })
        local current_tab = vim.api.nvim_get_current_tabpage()
        local target_tab = nil

        -- Find or create the dedicated Claude tab
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          local success, name = pcall(vim.api.nvim_tabpage_get_var, tab, "tab_name")
          if success and name == "Claude" then
            target_tab = tab
            break
          end
        end

        -- WORKFLOW A: You are ALREADY on the Claude tab -> Switch back to your prior code tab
        if current_tab == target_tab then
          local success, prev_tab = pcall(vim.api.nvim_tabpage_get_var, current_tab, "prev_tab_id")
          --
          -- Fallback if the previous tab was closed or doesn't exist anymore
          if success and vim.api.nvim_tabpage_is_valid(prev_tab) then
            vim.api.nvim_set_current_tabpage(prev_tab)
          else
            -- Go to the very first tab if our memory tracking fails
            vim.api.nvim_set_current_tabpage(vim.api.nvim_list_tabpages()[1])
          end
          return
        end

        -- WORKFLOW B & C: Jump to or create the Claude tab
        if target_tab then
          -- Switch to it, storing your current tab ID first so you can get back later
          vim.api.nvim_tabpage_set_var(target_tab, "prev_tab_id", current_tab)
          vim.api.nvim_set_current_tabpage(target_tab)

          -- Clear out leftover windows/buffers in this tab to make room for new diffs
          local cur_win = vim.api.nvim_get_current_win()
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(target_tab)) do
            if win ~= cur_win and vim.api.nvim_win_is_valid(win) then
              pcall(vim.api.nvim_win_close, win, true)
            end
          end
        else
          -- Create a brand new tab layout and tag it
          vim.cmd("tabnew")
          target_tab = vim.api.nvim_get_current_tabpage()
          vim.api.nvim_tabpage_set_var(target_tab, "tab_name", "Claude")
          vim.api.nvim_tabpage_set_var(target_tab, "prev_tab_id", current_tab)

          -- Only spawn the Claude terminal process if the tab is being built fresh
          if vim.fn.exists(":ClaudeCodeToggle") == 2 then
            vim.cmd("ClaudeCodeToggle")
          else
            vim.cmd("ClaudeCode")
          end
        end

      end,
      desc = "Toggle Dedicated Claude Tab",
    }
  },
  config = function (_, opts)
    require("claudecode").setup(opts)

    -- 4. Auto-close Tab Autocommand
    vim.api.nvim_create_autocmd("BufWipeout", {
      group = vim.api.nvim_create_augroup("ClaudeTabAutoClose", { clear = true }),
      pattern = "*",
      callback = function(args)
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        if bufname:match("claudecode") or vim.bo[args.buf].filetype == "claudecode" then
          for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
            local success, name = pcall(vim.api.nvim_tabpage_get_var, tab, "tab_name")
            if success and name == "Claude" then
              vim.schedule(function()
                pcall(vim.api.nvim_command, "tabclose " .. vim.api.nvim_tabpage_get_number(tab))
              end)
              break
            end
          end
        end
      end,
    })
  end
}
