local art_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h") .. "/kanata.ans"

local function get_dimensions(path)
  local lines = vim.fn.readfile(path)
  local height = #lines
  local max_width = 0
  for _, line in ipairs(lines) do
    local visible = line:gsub("\27%[[%d;]*%a", ""):gsub("\r", ""):gsub("%s+$", "")
    local width = vim.api.nvim_strwidth(visible)
    if width > max_width then
      max_width = width
    end
  end
  return max_width, height
end

local art_width, art_height = get_dimensions(art_path)

return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      sections = {
        {
          section = "terminal",
          cmd = "cat " .. art_path,
          height = art_height,
          width = art_width,
          -- Offset of 64 compensates for terminal-specific padding or
          -- PTY width calculation discrepancies in snacks.nvim.
          indent = math.max(0, math.floor((vim.o.columns - art_width) / 2) - 54),
          padding = 3,
        },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
      preset = {
        pick = function(cmd, opts)
          return LazyVim.pick(cmd, opts)()
        end,
        -- stylua: ignore
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
}
