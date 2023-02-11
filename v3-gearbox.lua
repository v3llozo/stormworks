function onTick()
    gear = input.getNumber(1)
    gearCount = input.getNumber(2)
    gearMap = { false, false, false, false }
    if gearCount < 2 then
        output.setBool(1, false)
    else
        rem = 1
        i = 1
        k = 1
        x = gear - 1
        while x ~= 0 do
            rem = math.fmod(x, 2)
            if rem >= 1 then gearMap[k] = true end
            k = k + 1
            x = tonumber(x / 2)
            i = i * 10
        end
        output.setBool(1, gearMap[1])
        output.setBool(2, gearMap[2])
        output.setBool(3, gearMap[3])
        output.setBool(4, gearMap[4])
        output.setNumber(5, gear)
    end
end

function onDraw()
    w = screen.getWidth()
    h = screen.getHeight()
    screen.setColor(255, 255, 255)
    screen.drawText(0, 0, "[1]" .. tostring(gearMap[1]))
    screen.drawText(0, 8, "[2]" .. tostring(gearMap[2]))
    screen.drawText(0, 16, "[3]" .. tostring(gearMap[3]))
    screen.drawText(0, 24, "[4]" .. tostring(gearMap[4]))
end
