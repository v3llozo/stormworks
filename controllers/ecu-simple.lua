-- ECU
-- Composite Driver seat
-- 1: A/D
-- 2: W/S
-- 3: Left/Right
-- 4: Up/Down
-- 9: Look X
-- 10: Look Y
-- 1-6 Boolean: Hotkeys
-- Composite Cylinder info
-- 1: Air Volume
-- 2: Fuel Volume
-- 3: Temperature
x = 0.0001
y = 0.0001
function onTick()
    air = input.getNumber(1)
    fuel = input.getNumber(2)
    temp = clamp(input.getNumber(3), 0, 100) * 0.01
    throttle = input.getNumber(4)
    stoichometric = input.getNumber(5)
    sensibility = input.getNumber(6)

    if air == 0 then air = 0.0001 end
    if fuel == 0 then fuel = 0.0001 end

    x = ((14 - (stoichometric * 2)) * (1 - temp)) + ((15 - (stoichometric * 5)) * temp)
    y = clamp(y + ((1 - (x / ((air * 1000) / (fuel * 1000)))) * sensibility), -1, 1)
    airIntake = throttle * clamp(1 - y, 0.1, 1)
    fuelIntake = throttle * clamp(1 + y, 0.1, 1)
    output.setNumber(1, airIntake)
    output.setNumber(2, fuelIntake)
    output.setNumber(3, y)
end

function clamp(n, min, max)
    if n > max then
        return max
    elseif n < min then
        return min
    end
    return n
end
