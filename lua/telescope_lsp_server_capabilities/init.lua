local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")

function Inspect(o, indent)
  indent = indent or 1
  if type(o) == "table" then
    local s = "{\n"
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. string.rep(" ", indent * 2) .. k .. ": " .. Inspect(v, indent + 1) .. ",\n"
    end
    return s .. string.rep(" ", (indent - 1) * 2) .. "}"
  elseif o == "\n" then
    return '"\\n"'
  else
    return '"' .. tostring(o) .. '"'
  end
end

function Split(str)
  local t = {}
  local i = 1
  for s in string.gmatch(str, "([^\n]+)") do
    t[i] = s
    i = i + 1
  end

  return t
end

local get_capabilities = function()
  local clients = vim.lsp.get_clients()
  local capabilities = {}
  for _, client in pairs(clients) do
    for capability_name, capability_info in pairs(client.server_capabilities) do
      table.insert(capabilities, {
        client_name = client.name,
        capability_name = capability_name,
        capability_info = capability_info,
      })
    end
  end
  return capabilities
end

local entry_maker = function(entry)
  local displayer = entry_display.create({
    separator = "|",
    items = {
      { width = 10 },
      { remaining = true },
    },
  })
  local make_display = function(item)
    return displayer({
      { item.value.client_name, "TelescopeResultsIdentifier" },
      item.value.capability_name,
    })
  end
  return {
    value = entry,
    display = make_display,
    ordinal = entry.client_name .. ": " .. entry.capability_name,
  }
end

local capabilities_picker = function(opts)
  opts = opts or {}
  local results = get_capabilities()
  local previewer = previewers.new_buffer_previewer({
    title = "LSP server capabilities",
    dyn_title = function(_, entry)
      return entry.value.client_name .. "'s capability: " .. entry.value.capability_name
    end,
    get_buffer_by_name = function(_, entry)
      return entry.value.client_name .. "_" .. entry.value.capability_name
    end,
    define_preview = function(self, entry)
      if self.state.bufname then
        return
      end
      local entries = Split(Inspect(entry.value.capability_info))
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, entries)
    end,
  })
  pickers
    .new(opts, {
      prompt_title = "Lsp server capabilities",
      finder = finders.new_table({
        results = results,
        entry_maker = entry_maker,
      }),
      previewer = previewer,
      sorter = conf.generic_sorter(opts),
      attach_mappings = function()
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          vim.cmd(
            [[:!open https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/\#:~:text=]]
              .. selection.value.capability_name
          )
        end)
        return true
      end,
    })
    :find()
end

return {
  lsp_server_capabilities = capabilities_picker,
}
