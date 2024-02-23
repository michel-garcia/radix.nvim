local M = {}

local setup = false

M.opts = {
    fallback = true,
    on_success = nil,
    patterns = {
        ".git",
        "Makefile",
        "package.json"
    },
    silent = true
}

M.setup = function (opts)
    if setup then
        return
    end
    setup = true
    M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function (args)
            local path, ok = M.get_root_dir(args.file)
            if path then
                vim.cmd.chdir(path)
                if ok then
                    pcall(M.opts.on_success, path)
                end
                if not M.opts.silent then
                    local msg = string.format(
                        "Working directory set to '%s'", path
                    )
                    vim.notify(msg)
                end
            end
        end,
        group = vim.api.nvim_create_augroup("radix", {
            clear = true
        })
    })
end

M.get_root_dir = function (path)
    if vim.fn.empty(path) == 1 then
        return
    end
    local current = vim.fn.resolve(vim.fn.fnamemodify(path, ":p:h"))
    local parents = {}
    if vim.fn.isdirectory(current) ~= 0 then
        table.insert(parents, current)
    end
    for dir in vim.fs.parents(current) do
        table.insert(parents, dir)
    end
    for _, dir in ipairs(parents) do
        for _, pattern in ipairs(M.opts.patterns) do
            local filename = vim.fn.globpath(dir, pattern)
            if vim.fn.empty(filename) == 0 then
                return dir, true
            end
        end
    end
    if M.opts.fallback and vim.fn.isdirectory(current) ~= 0 then
        return current, false
    end
end

return M
