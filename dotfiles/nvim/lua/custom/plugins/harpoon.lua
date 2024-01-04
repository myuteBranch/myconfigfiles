return {
    'ThePrimeagen/harpoon',
    branch = "harpoon2",
    config = function()
        local harpoon = require("harpoon")
        --@diagnostic disable-next-line: missing-parameter
        harpoon:setup()
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end
        vim.keymap.set("n", "<leader>m", function() harpoon:list():append() end, { desc = "mark file for harpoon" })
        vim.keymap.set("n", "<leader>M", function() harpoon:list():removeAt(1) end,
            { desc = "pop oldest file from harpoon" })
        vim.keymap.set("n", "<C-M>", function() harpoon:list():prev() end, { desc = "previous file in harpoon" })
        vim.keymap.set("n", "<C-N>", function() harpoon:list():next() end, { desc = "next file in harpoon" })
        vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
    end
}
