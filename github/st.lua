local function ex(text)
    os.execute(text)
end

fd = io.popen('hostname')
result = fd:read('*all')

--ex("cd && love l/lv/soo && clear")
-- ex("
local function r()
    return math.floor(os.clock()*20000)%2
end

function sleep(n)
    os.execute("sleep " .. tonumber(n))
end


-- if result == "terminal" then
--     print(1)
-- end

-- print(string.len(result))
-- print(string.len("terminal\n"))


if r()==1 then
    if result == "terminal\n" then
        ex("screenfetch -c 01,8")
    else
        -- ex("echo 'Выполнение команды...'")
        ex("sudo hostname terminal")
        -- ex("echo '\nУспешно!'" )
        ex("screenfetch -c 01,8")
    end
else
    sleep(1)
    if r()==1 then
        ex("cpufetch --color 208,70,72:210,170,153:1,1,1:68,36,52:210,170,153 --logo-intel-new")
    else
        ex("cpufetch --logo-long --color 208,70,72:210,170,153:1,1,1:68,36,52:210,170,153")
    end
end

-- вывести последние команды 
-- cpufetch --logo-long --color 208,70,72:210,170,153:1,1,1:68,36,52:210,170,153
--color intel
