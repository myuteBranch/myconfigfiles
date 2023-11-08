local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	colored = true,
	update_in_insert = false,
	always_visible = true,
}

local filename = {
    "filename",
    path = 1,
}

return {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
        options = {
            icons_enabled = false,
            theme = 'onedark',
            component_separators = '|',
            section_separators = '',
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', diagnostics},
            lualine_c = {filename, 'filesize'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location', 'searchcount', "time"}
        },
    },  
}