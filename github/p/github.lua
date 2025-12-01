local http = require("socket.http") -- Подключаем библиотеку для HTTP-запросов
local ltn12 = require("ltn12") -- Подключаем библиотеку для обработки потоков
local json = require("dkjson") -- Подключаем библиотеку для работы с JSON

local BASE_URL = "https://api.github.com"

-- Функция для выполнения GET-запроса
local function get(url)
    local response_body = {}
    local res, code, response_headers = http.request {
        url = url,
        sink = ltn12.sink.table(response_body),
        headers = {
            ["User-Agent"] = "Lua-Script",
            ["Accept"] = "application/vnd.github.v3+json"
        }
    }

    if code ~= 200 then
        error("HTTP Error: " .. code)
    end

    return table.concat(response_body)
end

-- Функция для получения информации о репозитории
local function getRepositoryInfo(owner, repo)
    local url = string.format("%s/repos/%s/%s", BASE_URL, owner, repo)
    local repo_info = get(url)
    return repo_info
end

-- Функция для получения списка открытых issue
local function getOpenIssues(owner, repo)
    local url = string.format("%s/repos/%s/%s/issues", BASE_URL, owner, repo)
    local issues = get(url)
    return issues
end

-- Функция для создания нового issue
local function createIssue(owner, repo, title, body)
    local url = string.format("%s/repos/%s/%s/issues", BASE_URL, owner, repo)
    local response_body = {}
    local res, code = http.request {
        url = url,
        method = "POST",
        headers = {
            ["User-Agent"] = "Lua-Script",
            ["Content-Type"] = "application/json",
            ["Accept"] = "application/vnd.github.v3+json"
        },
        source = ltn12.source.string(json.encode({title = title, body = body})), -- Кодируем данные в JSON
        sink = ltn12.sink.table(response_body),
    }

    if code ~= 201 then
        error("Error creating issue: " .. code)
    end

    return table.concat(response_body)
end

-- Функция для обработки аргументов командной строки
local function parseArguments()
    local args = {}
    for i = 1, #arg do
        if arg[i] == "-j" or arg[i] == "-m" and arg[i+1] == "1" then
            args.output_format = "json"
        elseif arg[i] == "-t" or arg[i] == "-m" and arg[i+1] == "2" then
            args.output_format = "text"
        else
            args[i] = arg[i]
        end
    end
    return args
end

-- Пример использования функций
local pretty = require("etc.pretty") 

local arg_parser = require("etc.args")
local args = arg_parser.parseArgs()

local owner = args.owner
local repo  = args.repo

--local repo_info = getRepositoryInfo(owner, repo)
--local open_issues = getOpenIssues(owner, repo)

if args.output_format == "json" then
    print(json.encode({repository = repo_info, issues = open_issues}))
else
    pretty.print{
        {key = "Repository",   value = repo_info or "0"},
        {key = "Open issues",  value = open_issues or "0"},
        {key = "Owner",        value = args.owner},
        {key = "Repo",         value = args.repo},
    }
end
