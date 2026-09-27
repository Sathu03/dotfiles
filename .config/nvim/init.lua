-- ~/.config/nvim/init.lua
--
-- Simple Nvim v0.13+ config
--
-- Depends (Alpine Linux):
--   curl fzf git ripgrep tree-sitter-cli
--   (as well as language servers, formatters and linters)
--
-- Recommended environment variables:
--   export ESCDELAY=0
--   export VISUAL=nvim
--   export EDITOR=nvim
--
-- Update plugins:
--   :packupdate
--
-- Quick references:
--   :h quickref

-- ===========================================================================
-- Misc

-- Byte-compile and cache Lua files (improves startup time (supposedly)).
vim.loader.enable()

-- Replace the builtin message + cmdline presentation layer. Also cap
-- the pager window to half the screen height. Comment this out if you
-- experience issues or prefer the older version.
-- See `:h ui2`.
require("vim._core.ui2").enable({
  msg = {
    pager = {
      height = 0.5,
    },
  },
})

-- ===========================================================================
-- Coloring
-- See `:h syntax.txt`.

-- Uncomment to enable a custom colorscheme. You must first create one in
-- ~/.config/nvim/colors/, or use one of the included ones.
--vim.cmd.colorscheme("mycolorscheme")

-- Uncomment to remove background color.
--vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
--vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })

-- Create trailing whitespace highlight.
vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "DarkRed" })

-- Highligh the above highlight to all normal buffers (excludes terminal
-- buffers, quickfix list buffers, etc.)
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  callback = function()
    local id = vim.w.trailing_ws_match
    if vim.bo.buftype ~= "" then
      if id then
        vim.fn.matchdelete(id)
        vim.w.trailing_ws_match = nil
      end
    elseif not id then
      vim.w.trailing_ws_match = vim.fn.matchadd("TrailingWhitespace", [[\s\+$]])
    end
  end,
})

-- Override the default Todo highlight.
vim.api.nvim_set_hl(0, "Todo", { fg = "LightRed", bold = true })

-- Highlight TODOs, FIXMEs, etc. We could install the
-- tree-sitter-comment parser for more precise handling (not highlight
-- TODOs outside comments for one), but it is noticeably slow.
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  callback = function()
    local id = vim.w.todo_match
    if vim.bo.buftype ~= "" then
      if id then
        vim.fn.matchdelete(id)
        vim.w.todo_match = nil
      end
    elseif not id then
      vim.w.todo_match =
        vim.fn.matchadd("Todo", [[\<\(TODO\|FIXME\|HACK\|NOTE\|XXX\)\>:\=]])
    end
  end,
})

-- ===========================================================================
-- Options
-- See `:h lua-guide-options`.

-- Prevent loading some unneeded modules and plugins.
vim.g.loaded_netrw = 1
vim.g.loaded_fzf = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Mapleaders.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Uncomment to always use the system clipboard register.
--vim.o.clipboard = "unnamedplus"

-- Enable project-local configuration. Execute any .nvim.lua, .nvimrc,
-- or .exrc file found in the current-directory and all parent
-- directories if the files are in the trust list.
vim.o.exrc = true

-- Enable line numbers and signcolumn, and limit signcolumn to one sign.
vim.o.number = true
vim.o.signcolumn = "yes:1"

-- When splitting windows, put the new ones to the right and below.
vim.o.splitright = true
vim.o.splitbelow = true

-- Enable autocompletion and scan current buffer, buffer from other
-- windows, and loaded buffers for content (but limit latter to 20
-- matches). Also enable fuzzycompletion and the height of the limit
-- completion menu popup.
--vim.o.autocomplete = true
--vim.o.complete = ".,w,b^20"
--vim.o.completeopt = "fuzzy,menuone,noselect"
vim.o.pumheight = 10
vim.o.wildoptions = "fuzzy,tagfile"

-- Always open buffers with all folds opened.
vim.o.foldlevelstart = 99

-- Use undofiles, disable swapfiles, and autosave files when changing
-- buffers etc.
vim.o.undofile = true
vim.o.swapfile = false
vim.o.autowrite = true

-- Use smarter indentation logic, round indent to multiple of
-- shiftwidth, and set shiftwidth to size of tabs. See `:h indent.txt`
-- for more info and indent method priority.
vim.o.smartindent = true
vim.o.shiftround = true
vim.o.shiftwidth = 0

-- Always have 5 extra lines at the top and bottom and sides.
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5

-- Disable key code sequence completion timeout.
vim.o.timeout = false
vim.o.ttimeoutlen = 0

-- Better searching.
vim.o.ignorecase = true
vim.o.smartcase = true

-- Uncomment to always use the terminals default cursor shape.
vim.o.guicursor = ""

-- Let nvim set the terminal window title.
vim.o.title = true

-- Abbreviate some messages.
vim.o.shortmess = "FIOTlot"

-- Keep the default statusline, but show the file format for non-Unix
-- files, e.g. "[dos]" or "[mac]", after the filename, as well as the
-- arglist status.
vim.o.statusline = vim.o.statusline:gsub("%%<%%f", function(s)
  return s
    .. [[%{&fileformat !=# 'unix' ? ' [' . &fileformat . ']' : ''}]]
    .. [[%a]]
end, 1)

-- Enable virtual text diagnostics, disable underlines, sort diagnostics
-- based on severity, and highlight linenumbers to match severity.
vim.diagnostic.config({
  virtual_text = true,
  underline = false,
  severity_sort = true,
  float = { source = true },
})

-- ===========================================================================
-- Custom commands
-- See `:h lua-guide-commands`.

-- Fuzzyfinder.
-- Open a file fuzzy finder in a terminal split window, using fzf.
vim.api.nvim_create_user_command("FzfFind", function()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, { split = "below" })
  vim.fn.jobstart({ "fzf", "--reverse" }, {
    on_exit = function()
      local fname = vim.api.nvim_buf_get_lines(buf, 0, 1, true)[1]
      vim.api.nvim_buf_delete(buf, { force = true })
      if fname ~= "" then
        vim.cmd.edit(vim.fn.fnameescape(fname))
      end
    end,
    term = true,
  })
  vim.cmd.startinsert()
end, {})

-- Livegrepper.
-- Open a live grepper in a terminal split window, using fzf and
-- ripgrep.
vim.api.nvim_create_user_command("FzfGrep", function()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, { split = "below" })
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
        .nvim_buf_get_lines(buf, 0, 1, true)[1]
        :match("^(.+):(%d+):(%d+):.*$")
      vim.api.nvim_buf_delete(buf, { force = true })
      if fname then
        vim.cmd.edit(vim.fn.fnameescape(fname))
        vim.api.nvim_win_set_cursor(0, {
          tonumber(lnum),
          tonumber(col) - 1,
        })
      end
    end,
    term = true,
  })
  vim.cmd.startinsert()
end, {})

-- ===========================================================================
-- Mappings
-- See `:h lua-guide-mappings`.

-- Unmap space.
vim.keymap.set({ "n", "x" }, "<Space>", "<Nop>")

-- Toggle 'list' option.
vim.keymap.set("n", "<Leader>l", "<Cmd>set list!<CR>")

-- Change current tab's working directory to directory of current file.
vim.keymap.set("n", "g~", "<Cmd>tcd %:h<CR>")

-- When a language server is active, the default K keymap will we
-- reassigned call vim.lsp.buf.hover(). Instead, get the default
-- behavior with gK.
vim.keymap.set("n", "gK", "<Cmd>norm! K<CR>")

-- Open a fuzzy file picker window and livegrep window.
vim.keymap.set("n", "<Leader>e", "<Cmd>FzfFind<CR>")
vim.keymap.set("n", "<Leader>/", "<Cmd>FzfGrep<CR>")

-- Shortcuts for :find and :grep.
vim.keymap.set("n", "<Leader>f", ":find ")
vim.keymap.set("n", "<Leader>g", ":grep ")

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

-- Resize current window to max size with <C-w>z and <C-w><C-z>. To
-- resize all windows to equal size, do <C-w>=.
vim.keymap.set("n", "<C-w>z", "<Cmd>vertical resize | resize<CR>")
vim.keymap.set("n", "<C-w><C-z>", "<Cmd>vertical resize | resize<CR>")

-- Open a terminal split window with <Leader>t. When in a terminal,
-- enter normal-mode with <C-w><Esc> or <C-w><C-[>.
vim.keymap.set("n", "<Leader>t", "<Cmd>horizontal terminal<CR>")
vim.keymap.set("t", "<C-w><Esc>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-w>[", "<C-\\><C-n>")

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

-- ===========================================================================
-- Autocommands
-- See `:h lua-guide-autocommands`.

-- Disable line numbers and highlight the textline of the cursor in
-- quickfix-list, location-list, and directory view windows.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf", "directory" },
  callback = function()
    vim.wo[0][0].number = false
    vim.wo[0][0].cursorline = true
  end,
})

-- Clear jumplist on startup.
vim.api.nvim_create_autocmd("VimEnter", {
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
      vim.fs.mkdir(vim.fs.dirname(ev.file), { parents = true })
    end
  end,
})

-- Disable diagnostics when entering insert mode.
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*:i",
  callback = function(ev)
    vim.diagnostic.hide(nil, ev.buf)
  end,
})

-- Enable diagnostics when leaving insert mode.
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "i:*",
  callback = function(ev)
    vim.diagnostic.show(nil, ev.buf)
  end,
})

-- ===========================================================================
-- LSP
-- See `:h lsp`, and `:h lsp-defaults` for default LSP keymaps and
-- behavior.

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
    end
  end,
})

-- ===========================================================================
-- Plugins
-- See `:h plugins.txt`.

-- Store plugin lockfile at ~/.local/share/nvim/nvim-pack-lock.json. By
-- default, it is put at ~/.config/nvim/nvim-pack-lock.json.
vim.o.packlockfile = vim.fn.stdpath("data") .. "/nvim-pack-lock.json"

-- Install some plugins. See `:h vim.pack`.
vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/monkoose/matchparen.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/lervag/vimtex",
  { src = "https://github.com/saghen/blink.cmp", version = "v1.10.2", },
}, { confirm = false })

-- ---------------------------------------------------------------------------
-- Builtin plugins
-- Some builtin plugins that are shipped with nvim.
-- See `:h standard-plugin-list`.

vim.cmd.packadd({ "cfilter", bang = true })
vim.cmd.packadd({ "nvim.undotree", bang = true })
vim.cmd.packadd({ "nvim.difftool", bang = true })

-- ---------------------------------------------------------------------------
-- Plugin: nvim-treesitter
-- Install up-to-date tree sitter parsers. See its documentation for
-- available parsers.
-- See `:h treesitter.txt` and `:h nvim-treesitter.txt`.

require("nvim-treesitter").install({
  -- Bundled parsers.
  "c",
  "diff",
  "lua",
  "markdown",
  "markdown_inline",
  "query",
  "vim",
  "vimdoc",
  -- Extra parsers.
  "bash",
  "git_rebase",
  "gitcommit",
  "go",
  "json",
  "python",
  "sql",
  "vhdl",
})

-- Run `:TSUpdate` when the nvim-treesitter plugin is install or
-- updated.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if
      ev.data.spec.name == "nvim-treesitter"
      and (ev.data.kind == "install" or ev.data.kind == "update")
    then
      vim.schedule(function()
        vim.cmd.TSUpdate()
      end)
    end
  end,
})

-- Enable treesitter in supported filetypes.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang or not vim.treesitter.language.add(lang) then
      return
    end

    vim.treesitter.start(ev.buf, lang)

    if vim.treesitter.query.get(lang, "folds") then
      vim.wo[0][0].foldexpr = vim.treesitter.foldexpr
      vim.wo[0][0].foldmethod = "expr"
    end
  end,
})

-- ---------------------------------------------------------------------------
-- Plugin: matchparen.nvim
-- Until https://github.com/neovim/neovim/issues/39683 is addressed.
-- See `:h matchparen.nvim`.

require("matchparen").setup()

-- ---------------------------------------------------------------------------
-- Plugin: conform.nvim
-- Enable specific formatters per filetype. See its documentation for
-- available formatters.
-- See `:h conform.txt`.

require("conform").setup({
  -- Map formatters to filetypes.
  formatters_by_ft = {
    go = { "gofumpt" },
    json = { "jq" },
    lua = { "stylua" },
    markdown = { "injected" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    sh = { "shfmt" },
    sql = { "sqruff" },
    vhdl = { "vsg" },
    ["*"] = { "injected" },
    ["_"] = { lsp_format = "prefer" },
  },
})

-- Set formatexpr to call conforms formatexpr function. formatexpr is
-- used by gq for formatting. To format something, do gq<motion>.
vim.o.formatexpr = require("conform").formatexpr

-- ---------------------------------------------------------------------------
-- Plugin: nvim-lint
-- A plugin to enable specific linters per filetype. See its
-- documentation for available linters.
-- See `:h lint.txt`.

local lint = require("lint")

-- Map linters to filetypes.
lint.linters_by_ft = {
  json = { "jq" },
  sh = { "shellcheck" },
  sql = { "sqruff" },
  vhdl = { "ghdl", "vsg" },
}

-- Redefine args given to shellcheck. This is to make it read stdin,
-- making it faster.
lint.linters.shellcheck.args = { "-f", "json1", "-" }

-- Append `-Wall` to ghdl.
table.insert(lint.linters.ghdl.args, "-Wall")

-- Enable linting on these events.
vim.api.nvim_create_autocmd({ "FileType", "BufWritePost", "TextChanged" }, {
  callback = function()
    lint.try_lint(nil, { ignore_errors = true })
  end,
})

-- ---------------------------------------------------------------------------
-- Plugin: VimTeX

vim.g.vimtex_view_method = "skim"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_quickfix_mode = 2
vim.g.vimtex_mappings_enabled = 1

vim.g.vimtex_compiler_latexmk = {
  build_dir = "build",
  callback = 1,
  continuous = 1,
  executable = "latexmk",
  options = {
    "-pdf",
    "-interaction=nonstopmode",
    "-synctex=1",
  },
}

-- ---------------------------------------------------------------------------
-- Plugin: blink.cmp

require("blink.cmp").setup({
  keymap = {
    preset = "default",
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    documentation = {
      auto_show = true,
    },
  },
  sources = {
    default = { "lsp", "path", "buffer" },
  },
  fuzzy = {
    implementation = "prefer_rust_with_warning",
  },
})
