-- ~/.config/nvim/init.lua
--
-- Simple Nvim v0.12+ config
--
-- Depends (Alpine Linux):
--   curl fzf git inotify-tools node ripgrep tar tree-sitter-cli
--
-- Set some environment variables:
--   export ESCDELAY=0
--   export VISUAL=nvim
--   export EDITOR=nvim
--
-- Update plugins:
--   :lua vim.pack.update()
--
-- Install and update tools:
--   :MasonToolsUpdate

-- Byte-compile and cache Lua files (improves startup time).
vim.loader.enable()

-- ==========================================
-- == Coloring
-- ==========================================

-- Highlight trailing whitespace.
vim.fn.matchadd("TrailingWhitespace", "\\s\\+$")
vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "DarkRed" })

-- To use dark gray instead:
--vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "NvimDarkGray3" })

-- To disable background color:
--vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })

-- ==========================================
-- == Options
-- ==========================================

-- Mapleaders.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Don't show banner in netrw file explorer, and preview files right side
-- vertically.
vim.g.netrw_banner = 0
vim.g.netrw_preview = 1
vim.g.netrw_alto = 0

-- Use C instead of C++ syntax for *.h files.
vim.g.c_syntax_for_h = true

-- Enable line numbers and signcolumn, and limit signcolumn to one sign.
vim.o.number = true
vim.o.signcolumn = "yes:1"

-- When splitting windows, put the new ones to the right and below.
vim.o.splitright = true
vim.o.splitbelow = true

-- Enable autocompletion and scan current buffer, buffer from other windows, and
-- loaded buffers for content (but limit latter to 20 matches). Also enable
-- fuzzycompletion and the height of the limit completion menu popup.
vim.o.autocomplete = true
vim.o.complete = ".,w,b^20"
vim.o.completeopt = "fuzzy,menuone,noselect"
vim.o.pumheight = 10
vim.o.wildoptions = "fuzzy,tagfile"

-- Have 'foldexpr' set the fold level, and have all folds be open at start by
-- setting folding level to a high number. 'foldexpr' will be set to use
-- treesitter when available, see further down.
vim.o.foldmethod = "expr"
vim.o.foldlevel = 99

-- Use undofiles, disable swapfiles, and autosave files when changing buffers
-- etc.
vim.o.undofile = true
vim.o.swapfile = false
vim.o.autowrite = true

-- Use smarter indentation logic (overridden by treesitter indentation if
-- available), round indent to multiple of shiftwidth, and set shiftwidth to
-- size of tabs. See `:h indent.txt` for more info and indent method priority.
vim.o.smartindent = true
vim.o.shiftround = true
vim.o.shiftwidth = 0

-- Disable key code sequence completion timeout.
vim.o.timeout = false
vim.o.ttimeoutlen = 0

-- Better searching.
vim.o.ignorecase = true
vim.o.smartcase = true

-- Use smartcase for a number of searching operations.
vim.o.guicursor = ""
vim.o.mousemodel = "extend"

-- Abbreviate some messages.
vim.o.shortmess = "FIOTlot"

-- Enable virtual text diagnostics, disable underlines, sort diagnostics based
-- on severity, and highlight linenumbers to match severity.
vim.diagnostic.config({
  virtual_text = true,
  underline = false,
  severity_sort = true,
  float = { source = true },
})

-- ==========================================
-- == Custom commands
-- ==========================================

-- Fuzzyfinder.
-- Open a file fuzzy finder in a terminal split window, using fzf.
vim.api.nvim_create_user_command("FzfFind", function()
  vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
    split = "below",
  })
  vim.fn.jobstart({ "fzf", "--reverse" }, {
    on_exit = function()
      local fname = vim.api.nvim_buf_get_lines(0, 0, 1, true)[1]
      vim.api.nvim_buf_delete(0, { force = true })
      if fname ~= "" then
        vim.cmd.edit(vim.fn.fnameescape(fname))
      end
    end,
    term = true,
  })
  vim.cmd.startinsert()
end, {})

-- Livegrepper.
-- Open a live grepper in a terminal split window, using fzf and ripgrep.
vim.api.nvim_create_user_command("FzfGrep", function()
  vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
    split = "below",
  })
  local rg = "rg -Suug !.git --column --color=always --"
  vim.fn.jobstart({
    "fzf",
    "--ansi",
    "--disabled",
    "--reverse",
    "--bind=change:reload:" .. rg .. " {q} || true",
  }, {
    env = { FZF_DEFAULT_COMMAND = rg .. " ''" },
    on_exit = function()
      local fname, lnum, col = vim.api
        .nvim_buf_get_lines(0, 0, 1, true)[1]
        :match("^(.+):(%d+):(%d+):.*$")
      vim.api.nvim_buf_delete(0, { force = true })
      if fname then
        vim.cmd.edit(vim.fn.fnameescape(fname))
        vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) - 1 })
      end
    end,
    term = true,
  })
  vim.cmd.startinsert()
end, {})

-- ==========================================
-- == Mappings
-- ==========================================

-- Unmap space.
vim.keymap.set({ "n", "x" }, "<Space>", "<Nop>")

-- Toggle 'list' option.
vim.keymap.set("n", "<Leader>l", "<Cmd>set list!<CR>")

-- Change current tab's working directory to directory of current file.
vim.keymap.set("n", "~", "<Cmd>tcd %:h<CR>")

-- Open a netrw file explorer window.
vim.keymap.set("n", "-", "<Cmd>Explore<CR>")

-- Open a fuzzy file picker window and livegrep window.
vim.keymap.set("n", "<Leader>e", "<Cmd>FzfFind<CR>")
vim.keymap.set("n", "<Leader>/", "<Cmd>FzfGrep<CR>")
vim.keymap.set("n", "<Leader>f", ":find ")
vim.keymap.set("n", "<Leader>f", ":grep ")

-- Indent and de-indent visually selected text.
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- Center screen on n/N and C-o/C-i.
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")

-- Add current position to jumplist before gq and =.
vim.keymap.set({ "n", "x" }, "gq", "m'gq")
vim.keymap.set({ "n", "x" }, "=", "m'=")

-- Navigate quickfix-list with C-j and C-k.
-- Also see `:h make_makeprg`.
vim.keymap.set("n", "<C-j>", "<Cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<Cmd>cprev<CR>zz")

-- Navigate location-list with M-j and M-k.
vim.keymap.set("n", "<M-j>", "<Cmd>lnext<CR>zz")
vim.keymap.set("n", "<M-k>", "<Cmd>lprev<CR>zz")

-- Resize current window to max size with <C-w>z and <C-w><C-z>. To resize all
-- windows to equal size, do <C-w>=.
vim.keymap.set("n", "<C-w>z", "<Cmd>vertical resize | resize<CR>")
vim.keymap.set("n", "<C-w><C-z>", "<Cmd>vertical resize | resize<CR>")

-- Toggle the undotree window.
vim.keymap.set("n", "<Leader>u", "<Cmd>Undotree<CR>")

-- Toggle showing diagnostics in all buffers.
vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end)

-- Add all diagnostics to the quickfix-list.
vim.keymap.set("n", "grq", function()
  vim.diagnostic.setqflist({ open = false })
  pcall(vim.cmd.cc)
end)

-- Add all diagnostics to the location-list.
vim.keymap.set("n", "grl", function()
  vim.diagnostic.setloclist({ open = false })
  pcall(vim.cmd.ll)
end)

-- ==========================================
-- == Autocommands
-- ==========================================

-- Always display relative paths.
-- https://github.com/vim/vim/issues/549
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.cmd.lcd(".")
  end,
})

-- Clear jumplist on startup.
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.cmd.clearjumps()
  end,
})

-- Restore last cursor position.
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function(ev)
    local lastpos = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if pcall(vim.api.nvim_win_set_cursor, 0, lastpos) then
      vim.cmd.normal({ "zz", bang = true })
    end
  end,
})

-- Resize splits if window got resized.
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    local ctab = vim.fn.tabpagenr()
    vim.cmd.tabdo("wincmd =")
    vim.cmd.tabnext(ctab)
  end,
})

-- Create parent directories when saving a file.
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(ev)
    if not ev.file:find("^%w+://") then
      vim.fn.mkdir(vim.fs.dirname(ev.file), "p")
    end
  end,
})

-- Disable line numbers and highlight the textline of the cursor in
-- quickfix-list and location-list windows.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.wo.number = false
    vim.wo.cursorline = true
  end,
})

-- Disable diagnostics when entering insert mode.
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*:i",
  callback = function()
    vim.diagnostic.enable(false, { bufnr = 0 })
  end,
})

-- Enable diagnostics when leaving insert mode.
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "i:*",
  callback = function()
    vim.diagnostic.enable(true, { bufnr = 0 })
  end,
})

-- ==========================================
-- == LSP
-- ==========================================

-- See `:h lsp-defaults` for default LSP keymaps and behavior.

-- Enable some language servers.
vim.lsp.enable({
  "clangd",
  "gopls",
  "lua_ls",
  "ruff",
  "ty",
})

-- When a buffer attaches a language server, do this.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      -- Disable some annoying LSP features.
      vim.lsp.semantic_tokens.enable(false)
      vim.lsp.inlay_hint.enable(false)
      vim.lsp.document_color.enable(false)

      if client:supports_method("textDocument/completion") then
        -- Enable omnicompletion if language server has completion providing
        -- capabilities. Omnicompletion will by default be set to use it if it
        -- has.
        vim.bo.complete = "o"

        -- TODO: When https://github.com/neovim/neovim/pull/35346, you can do
        -- the following instead:
        --if not vim.bo.complete:find("o", 1, true) then
        --  vim.bo.complete = "o," .. vim.bo.complete
        --end

        -- Likewise enable some better LSP completion capabilities.
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
          -- Optional formating of LSP completion items.
          convert = function(item)
            -- Cap field labels to 15 characters, and don't show content in ()
            -- and {}.
            local label = item.label:gsub("%b()", ""):gsub("%b{}", "")
            local detail = item.detail or ""
            return {
              abbr = #label > 15 and label:sub(1, 14) .. "…" or label,
              menu = #detail > 15 and detail:sub(1, 14) .. "…" or detail,
            }
          end,
        })
      end
    end
  end,
})

-- ==========================================
-- == Plugins
-- ==========================================

-- Install some plugins. See `:h vim.pack`.
vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",
}, { confirm = false })

-- Builtin plugins
-- Some builtin plugins that are shipped with nvim.
-- ==========================================
vim.cmd.packadd({ "cfilter", bang = true })
vim.cmd.packadd({ "nvim.undotree", bang = true })

-- Plugin: nvim-treesitter
-- Install up-to-date tree sitter parsers. See its documentation for available
-- parsers.
-- ==========================================
require("nvim-treesitter").install({
  -- Bundled parsers.
  "c",
  "lua",
  "markdown",
  "markdown_inline",
  "query",
  "vim",
  "vimdoc",
  -- Extra parsers.
  "bash",
  "comment",
  "diff",
  "git_rebase",
  "gitcommit",
  "go",
  "python",
  "sql",
  "vhdl",
})

-- Run `:TSUpdate` when the nvim-treesitter plugin is updated.
vim.api.nvim_create_autocmd({ "PackChanged" }, {
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
      vim.schedule(function()
        vim.cmd.TSUpdate()
      end)
    end
  end,
})

-- Enable treesitter on supported filetypes.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    if pcall(vim.treesitter.start) then
      -- If treesitter is enabled and folding queries are installed, use the
      -- queries for folding.
      if vim.treesitter.query.get(ev.match, "folds") then
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end
      -- If treesitter is enabled and indent queries are installed, use the
      -- queries for indenting, overriding the smartindent option set earlier.
      if vim.treesitter.query.get(ev.match, "indents") then
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end
  end,
})

-- Plugin: mason.nvim
-- A package manager for editor related applications like LSPs, formatters and
-- linters.
-- ==========================================

require("mason").setup()

-- Plugin: mason-tool-installer
-- A wrapper around mason to autoinstall packages by listing them in a table.
-- ==========================================

require("mason-tool-installer").setup({
  run_on_start = false,
  ensure_installed = {
    "gofumpt",
    "gopls",
    "lua-language-server",
    "ruff",
    "shellcheck",
    "shfmt",
    "sqruff",
    "stylua",
    "ty",
    "vsg",
  },
})

-- Plugin: conform.nvim
-- Enable specific formatters per filetype. See its documentation for available
-- formatters.
-- ==========================================

require("conform").setup({
  -- Map formatters to filetypes.
  formatters_by_ft = {
    go = { "gofumpt" },
    lua = { "stylua" },
    markdown = { "injected" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    sh = { "shfmt" },
    sql = { "sqruff" },
    vhdl = { "vsg" },
    -- https://github.com/stevearc/conform.nvim/issues/752
    --["*"] = { "injected" },
  },
})

-- Set formatexpr to call conforms formatexpr function. formatexpr is used by gq
-- for formatting. To format something, do gq<motion>.
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Plugin: nvim-lint
-- A plugin to enable specific linters per filetype. See its documentation for
-- available linters.
-- ==========================================

local lint = require("lint")

-- Map linters to filetypes.
lint.linters_by_ft = {
  sh = { "shellcheck" },
  sql = { "sqruff" },
  vhdl = { "ghdl", "vsg" },
}

-- Redefine args given to the shellcheck linter. This is to make it read stdin,
-- making it faster.
lint.linters.shellcheck.args = { "-f", "json1", "-" }

-- Append `-Wall` to the ghdl.
table.insert(lint.linters.ghdl.args, "-Wall")

-- Enable the linting on these events.
vim.api.nvim_create_autocmd({ "FileType", "BufWritePost", "TextChanged" }, {
  callback = function()
    lint.try_lint(nil, { ignore_errors = true })
  end,
})
