return {
    "olimorris/persisted.nvim",
    opts = {
        -- save_dir = "/code/sessions",
        autoload = true,
        on_autoload_no_session = function()
            vim.notify("No existing session to load.")
        end
    },
    config = true
}