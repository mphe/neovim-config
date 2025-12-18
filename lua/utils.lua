local M = {}

-- Loads a plugin and runs `setup()` on it with the given config table.
-- If the plugin doesn't exist, nothing will happen and no error is raised.
function M.setup_plugin(name, config)
    local has_plugin, plugin = pcall(require, name)
    if has_plugin then
        plugin.setup(config)
    end
end


function M.find_plugin(name)
    local has_plugin, plugin = pcall(require, name)
    if has_plugin then
        return plugin
    end
    return nil
end


function M.has_plugin(name)
    return M.find_plugin(name) ~= nil
end

return M
