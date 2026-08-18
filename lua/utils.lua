local M = {}

-- Loads a plugin and runs `setup()` on it with the given config table.
-- If the plugin doesn't exist, nothing will happen and no error is raised.
-- Returns true if the plugin exists, otherwise false.
function M.setup_plugin(name, config)
    local has_plugin, plugin = pcall(require, name)

    if has_plugin then
        plugin.setup(config or {})
        return true
    end

    return false
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


function M.reflow_markdown(lines)
    local reflowed = {}
    local in_code_block = false
    local in_indent_block = false
    local lines_to_merge = {}

    local function flush_lines_to_merge()
        if #lines_to_merge > 0 then
            table.insert(reflowed, table.concat(lines_to_merge, " "))
            lines_to_merge = {}
        end
    end

    for _, line in ipairs(lines) do
        line = line:gsub('%s+$', '')

        if line:match('^%s*```') then
            flush_lines_to_merge()

            if in_code_block then
                table.insert(reflowed, line)
                table.insert(reflowed, '')  -- Padding around codeblock
            else
                table.insert(reflowed, '')  -- Padding around codeblock
                table.insert(reflowed, line)
            end

            in_code_block = not in_code_block

        elseif in_code_block then
            table.insert(reflowed, line)

        elseif line:match('^%s+') then
            flush_lines_to_merge()

            if not in_indent_block then
                table.insert(reflowed, '')  -- Padding around codeblock
            end

            table.insert(reflowed, line)
            in_indent_block = true

        else
            if in_indent_block then
                in_indent_block = false
                table.insert(reflowed, '')  -- Padding around codeblock
            end

            if line == '' then
                -- Blank line -> Insert line break and collapse consecutive blank lines into one
                flush_lines_to_merge()
            else
                local ends_sentence = line:match('[%.%!%?%:]%s*$')
                local starts_special = line:match('^[%-%*%+] ')
                    or line:match('^%d+%. ')
                    or line:match('^#+%s')
                    or line:match('^>')
                    or line:match('^|')
                    or line:match('^%s*[%-%*_][%-%*_][%-%*_]')

                if starts_special then
                    flush_lines_to_merge()
                end

                table.insert(lines_to_merge, line)

                if ends_sentence then
                    flush_lines_to_merge()
                end
            end
        end
    end

    flush_lines_to_merge()

    return reflowed
end


return M
