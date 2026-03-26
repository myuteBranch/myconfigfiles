return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}

      require("nvim-treesitter.install").compilers = { "gcc", "clang" }
      require("nvim-treesitter.install").prefer_git = true

      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "go",
        "gomod",
        "gosum",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "nix",
        "query",
        "regex",
        "rust",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      })

      return opts
    end,
  },
}
