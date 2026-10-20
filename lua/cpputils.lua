--- Convert C++ signature on current line to trailing return type notation.
local function to_trailing_return()
    local line = vim.api.nvim_get_current_line()
    local parser = vim.treesitter.get_string_parser(line, "cpp")
    local tree = parser:parse()[1]
    if not tree then return end

    local query = vim.treesitter.query.parse("cpp", [[
        [(declaration) (function_definition) (field_declaration)] @fn
    ]])

    for _, node in query:iter_captures(tree:root(), line) do
        local type_node = node:field("type")[1]
        if not type_node then return end

        -- descend through pointer/reference declarators to the function_declarator
        local decl = node:field("declarator")[1]
        while decl and decl:type() ~= "function_declarator" do
            local inner = decl:field("declarator")[1]
            if not inner then return end
            decl = inner
        end
        if not decl then return end

        local type_text = vim.treesitter.get_node_text(type_node, line)
        if type_text == "auto" then return end

        local _, type_start, _, type_end = type_node:range()
        local _, decl_start, _, decl_end = decl:range()

        -- pointers/refs between type and function name belong to the return type
        local ptr_part = vim.trim(line:sub(type_end + 1, decl_start))
        local ret_type = type_text .. (ptr_part ~= "" and ptr_part or "")

        local new_line = line:sub(1, type_start)
            .. "auto "
            .. line:sub(decl_start + 1, decl_end)
            .. " -> " .. ret_type
            .. line:sub(decl_end + 1)

        vim.api.nvim_set_current_line(new_line)
        return
    end
end

vim.api.nvim_create_user_command("ToTrailingReturn", to_trailing_return, {
    desc = "Convert C++ signature on current line to trailing return type",
})
