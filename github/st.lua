local coolf = ("").format

local function terminal(command)
    if command ~= nil then
        os.execute(command)
    else
        os.execute("clear")
    end
end

local function popen(command)
    if command then
        local handle = io.popen(command)
        local result = handle:read("*a")

        handle:close()

        return result
    else

        return [[
Программа           Слова
bastet              тетрис, стратегические игры, логика, развлечение
baobab              очистка, управление, файловая система, сервисы для каталогизации
cmus                музыка, аудиоплеер, воспроизведение, плейлисты, поддержка форматов
catimg / chafa      вывод картинки на экран терминала, ASCII, графика, отображение изображений
cmatrix             матрица, визуализация, экранная заставка, анимация
di                  диск, файловая система, управление дисками, информация о хранилище
dosbox              архитектура, эмуляция, винтажные игры, старые программы, DOS
eog                 фото, просмотр изображений, поддержка форматов, редактор
exa                 содержимое, файловая система, альтернативная команда ls, интеграция с Git
        ]]
    end
end

local function generate_printf_commands()
    local text_block = popen(nil)
    local is_header_passed = false

    for line in text_block:gmatch("[^\r\n]+") do
        local _, words_part = line:match("^(.-)%s+(.*)$")
        if words_part then
            for word in words_part:gmatch("[^,]+") do
                terminal(coolf('printf "\\033[90m%s\\033[0m"', word:match("^%s*(.-)%s*$")))
            end
        end
    end
end

local function fortune(n)
    local n = n or 5
    local output = popen "fortune ru"

    if #output < 23*11 then

        return output
    elseif n > 0 then

        return fortune(n - 1)
    else

        return output
    end
end

local function XY(x, y, text)
    local i = 0

    for line in (("").format("%s\n",text)):gmatch("(.-)\n") do
        i = i + 1
        io.write(coolf("\27[%d;%dH%s\n", y + i, x, line))
    end
end

terminal()

XY(0,2, popen("figlet --font mono9 --metal lua"))

local function popen_with_gray_column()
    local base_table = popen(nil)
    local result_lines = {}
    local header_passed = false

    for line in base_table:gmatch("[^\r\n]+") do
        if not header_passed then
            local col1, col2 = line:match("^(.-)%s%s+(.+)$")

            if col1 and col2 then
                table.insert(result_lines, coolf("%-20s\t    \27[90m%s\27[0m", col1, col2))
            else
                table.insert(result_lines, line)
            end
            header_passed = true
        else
            local program, words = line:match("^(.-)%s%s+(.+)$")

            if program and words then
                local colored_line = coolf("%-20s\27[90m%s\27[0m", program, words)

                table.insert(result_lines, colored_line)
            else
                table.insert(result_lines, line)
            end
        end
    end
    
    return table.concat(result_lines, "\n")
end

XY(25, 1, popen_with_gray_column())
XY(0, 13, fortune())
