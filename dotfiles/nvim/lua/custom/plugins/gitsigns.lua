return {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
        -- See `:help gitsigns.txt`
        signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
        },
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
            virt_text_priority = 100,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
        vim.keymap.set('n', '<leader>hr', require('gitsigns').reset_hunk,  { buffer = bufnr, desc = 'reset git hunk' })
        vim.keymap.set('n', '<leader>hd', require('gitsigns').diffthis,  { buffer = bufnr, desc = 'git diff this' })
        vim.keymap.set('n', '<leader>hb', function() require('gitsigns').blame_line{full=true} end,  { buffer = bufnr, desc = 'git blame line' })
        vim.keymap.set('n', '<leader>htb', require('gitsigns').toggle_current_line_blame,  { buffer = bufnr, desc = 'git blame line' })
        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
            if vim.wo.diff then
            return ']c'
            end
            vim.schedule(function()
            gs.next_hunk()
            end)
            return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
            if vim.wo.diff then
            return '[c'
            end
            vim.schedule(function()
            gs.prev_hunk()
            end)
            return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
        end,
    },
}