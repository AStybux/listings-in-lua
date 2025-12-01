-- pretty.lua
-- Утилита для красивого табличного вывода пар «ключ – значение».
-- Поддерживает любые типы значений (строка, число, таблица, JSON‑строка и т.д.).
-- Позволяет задать:
--   * ширину столбца с названиями (по умолчанию – самая длинная метка + 2 пробела)
--   * символ‑разделитель (по умолчанию – двоеточие)
--   * выравнивание значений (left / right / center)

local pretty = {}

--- Возвращает строку, отформатированную по заданным параметрам.
--- @param key   string   название поля
--- @param value any      значение (будет преобразовано в строку)
--- @param opts  table    опции: width (number), sep (string), align ("left","right","center")
--- @return string
function pretty.format(key, value, opts)
    opts = opts or {}
    local width = opts.width or #key + 2          -- минимум: название + 2 пробела
    local sep   = opts.sep   or ":"               -- разделитель
    local align = opts.align or "left"

    -- Приводим значение к строке
    local val_str
    if type(value) == "table" then
        -- Попытка сериализовать таблицу в JSON‑подобный вид
        local ok, json = pcall(require, "cjson")
        if ok then
            val_str = json.encode(value)
        else
            -- fallback: простая печать через tostring
            val_str = tostring(value)
        end
    else
        val_str = tostring(value)
    end

    -- Формируем отступ после ключа
    local padded_key = key .. string.rep(" ", width - #key)

    -- Выравнивание значения
    local formatted_val
    if align == "right" then
        formatted_val = string.format("%" .. #val_str .. "s", val_str)
    elseif align == "center" then
        local left  = math.floor((#val_str) / 2)
        local right = #val_str - left
        formatted_val = string.rep(" ", left) .. val_str .. string.rep(" ", right)
    else -- left
        formatted_val = val_str
    end

    return padded_key .. sep .. " " .. formatted_val
end

--- Выводит несколько пар «ключ – значение» в виде таблицы.
--- @param data table   массив таблиц {key=..., value=..., opts=...}
function pretty.print(data)
    -- Определяем максимальную ширину названий, если пользователь не задал width
    local max_key_len = 0
    for _, item in ipairs(data) do
        max_key_len = math.max(max_key_len, #item.key)
    end

    for _, item in ipairs(data) do
        local opts = item.opts or {}
        opts.width = opts.width or (max_key_len + 2)   -- +2 пробела для читаемости
        io.write(pretty.format(item.key, item.value, opts), "\n")
    end
end

return pretty

