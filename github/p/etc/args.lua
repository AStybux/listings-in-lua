-- args.lua
-- Обрабатывает аргументы командной строки:
--   -o <owner>   – владелец репозитория
--   -r <repo>    – имя репозитория
--   -j           – вывод в JSON (по умолчанию)
--   -t           – вывод в текстовом виде

local function usage()
    io.stderr:write([[
Usage: lua github.lua -j|-t -o <owner> -r <repo>
  -j          output as JSON (default)
  -t          output as plain text
  -o <owner>  GitHub repository owner
  -r <repo>   GitHub repository name
]])
    os.exit(1)
end

local function parseArgs()
    local args = {
        output_format = "json",   -- значение по умолчанию
        owner = nil,
        repo  = nil,
    }

    local i = 1
    while i <= #arg do
        local a = arg[i]

        if a == "-j" then
            args.output_format = "json"
            i = i + 1

        elseif a == "-t" then
            args.output_format = "text"
            i = i + 1

        elseif a == "-o" then
            if i + 1 > #arg then usage() end
            args.owner = arg[i + 1]
            i = i + 2

        elseif a == "-r" then
            if i + 1 > #arg then usage() end
            args.repo = arg[i + 1]
            i = i + 2

        else
            -- неизвестный параметр
            io.stderr:write("Unknown option: " .. a .. "\n")
            usage()
        end
    end

    -- проверяем обязательные параметры
    if not args.owner or not args.repo then
        io.stderr:write("Error: both -o <owner> and -r <repo> are required.\n")
        usage()
    end

    return args
end

return {
    parseArgs = parseArgs,
}

