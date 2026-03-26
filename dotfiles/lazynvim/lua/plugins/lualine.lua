local function jj_info()
  local cwd = vim.fn.expand("%:p:h")
  if cwd == "" then
    cwd = vim.loop.cwd()
  end

  local is_jj_repo = vim.system({
    "jj",
    "root",
  }, { cwd = cwd, text = true }):wait()

  if is_jj_repo.code ~= 0 then
    return ""
  end

  local output = vim.system({
    "jj",
    "log",
    "--no-graph",
    "-r",
    "@",
    "-T",
    "change_id.shortest() ++ \"\\n\" ++ commit_id.shortest() ++ \"\\n\" ++ parents.map(|p| p.change_id().shortest()).join(\",\") ++ \"\\n\" ++ if(parents.len() > 0, parents.map(|p| p.bookmarks().join(\",\")).join(\",\"), \"\")",
  }, { cwd = cwd, text = true }):wait()

  if output.code ~= 0 or not output.stdout then
    return ""
  end

  local lines = vim.split(vim.trim(output.stdout), "\n", { plain = true })
  local change_id = lines[1] or ""
  local commit_id = lines[2] or ""
  local parent_ids = lines[3] or ""
  local bookmarks = lines[4] or ""

  if change_id == "" or commit_id == "" then
    return ""
  end

  local result = "󰘬 " .. change_id .. "/" .. commit_id

  if parent_ids ~= "" then
    result = result .. " p:" .. parent_ids
  end

  if bookmarks ~= "" then
    local bookmark_list = vim.split(bookmarks, ",", { plain = true, trimempty = true })
    if #bookmark_list == 1 then
      result = result .. " b:" .. bookmark_list[1]
    elseif #bookmark_list > 1 then
      result = result .. " b:" .. bookmark_list[1] .. ",+" .. (#bookmark_list - 1)
    end
  end

  return result
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}

      table.insert(opts.sections.lualine_x, 1, {
        jj_info,
        cond = function()
          return vim.fn.executable("jj") == 1
        end,
      })

      return opts
    end,
  },
}
