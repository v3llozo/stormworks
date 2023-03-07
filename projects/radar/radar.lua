--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
--[====[ HOTKEYS ]====]
-- Press F6 to simulate this file
-- Press F7 to build the project, copy the output from /_build/out/ into the game to use
-- Remember to set your Author name etc. in the settings: CTRL+COMMA
--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
--
--- @section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "3x3")
    simulator:setProperty("System", "Radar")

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)
        -- touchscreen defaults
        local screenConnection = simulator:getTouchScreen(1)
        simulator:setInputBool(1, screenConnection.isTouched)
        simulator:setInputNumber(2, screenConnection.touchX)
        simulator:setInputNumber(3, screenConnection.touchY)
        simulator:setInputNumber(4, ticks / 300)
        if (ticks / 300 % 1) then
            simulator:setInputNumber(5, 1000)
            simulator:setInputNumber(6, 0)
            simulator:setInputNumber(7, 0)
            simulator:setInputNumber(8, 0)
        end
        simulator:setInputNumber(9, 1400)
        simulator:setInputNumber(10, 0.015)
        simulator:setInputNumber(11, 0.8)
        simulator:setInputNumber(12, 1)
        -- NEW! button/slider options from the UI
        -- simulator:setInputBool(1, simulator:getIsClicked(1)) -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
    end
end
---@endsection

--[====[ IN-GAME CODE ]====]
-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

ticks = 0
maxTargets = 7
defaultDistance = 3
-- 0.5km, 1km, 2km, 5km, 10km, 15km, 30km, 60km
distanceDetector = { 0.002, 0.001, 0.0005, 0.0002, 0.0001, 0.0000666, 0.0000333, 0.0000166 }
selectedDistance = distanceDetector[defaultDistance]
function getRaiousPosition(r, angle, h, w)
    return {
        x = r * math.sin(angle * 0.0175) + h / 2,
        y = r * math.cos(angle * 0.0175) + w / 2
    }
end

function onTick()
    output.setBool(1, false)
    isTouched = input.getBool(1)
    touchX = input.getNumber(2)
    touchY = input.getNumber(3)
    radar = {
        angle = (input.getNumber(4) % 1) * 360,
        found = {},
        target = {}
    }
    k = 5
    for i = 1, maxTargets, 1 do
        if input.getBool(i + 4) == true then
            output.setBool(1, true)
        end
        table.insert(radar.found, input.getBool(i + 4))
        table.insert(radar.target, {
            distance = input.getNumber(k),
            azimuth = input.getNumber(k + 1),
            elevation = input.getNumber(k + 2),
            time = input.getNumber(k + 3)
        })
        k = k + 4
    end
    ticks = ticks + 1
end

detectedTargets = {}
function onDraw()
    w = screen.getWidth()
    h = screen.getHeight()
    screen.setColor(5, 4, 8)
    screen.drawRectF(0, 0, w, h)
    r = h
    rX, rY = getRaiousPosition(r, radar.angle, h, w)

    if isTouched then
        if defaultDistance >= 7 then
            defaultDistance = 1
        else
            defaultDistance = defaultDistance + 1
        end
        selectedDistance = distanceDetector[defaultDistance]
        detectedTargets = {}
    end

    for k, t in ipairs(detectedTargets) do
        if t.angle > radar.angle and t.angle < radar.angle + 20 then
            table.remove(detectedTargets, k)
        end
    end

    screen.setColor(130, 130, 130)
    screen.drawRectF(w / 2 - 1, h / 2 - 1, 3, 3)
    for i = 1, 10, 1 do
        screen.drawCircle(w / 2, h / 2, r / 10 * i)
    end
    screen.setColor(40, 200, 40, 80)
    r1 = getRaiousPosition(r, radar.angle - 20, h, w)
    r2 = getRaiousPosition(r, radar.angle, h, w)
    screen.drawTriangleF(w / 2, h / 2, r1.y, r1.x, r2.y, r2.x)

    targetAngle = radar.angle
    for i = 1, maxTargets, 1 do
        if radar.found[i] then
            screen.setColor(255, 255, 255)
            tX = (radar.target[i].distance * selectedDistance) * r *
                math.sin((targetAngle - radar.target[i].azimuth / 100) * 0.0175) + h / 2
            tY = (radar.target[i].distance * selectedDistance) * r *
                math.cos((targetAngle - radar.target[i].azimuth / 100) * 0.0175) + w / 2
            screen.setColor(255, 10, 20)
            screen.drawRect(tY, tX, 1, 1)
            table.insert(detectedTargets, {
                y = tY,
                x = tX,
                angle = targetAngle,
                time = radar.target[i].time
            })
        end
    end
    for k, t in pairs(detectedTargets) do
        screen.setColor(220, 10, 20)
        screen.drawRect(t.y, t.x, 1, 1)
    end
    screen.setColor(255, 255, 255, 255)
    screen.drawRectF(w / 2 - 1, h / 2 - 1, 3, 3)
    screen.setColor(3, 3, 5)
    screen.drawRectF(0, h - 9, 23, 9)
    screen.setColor(255, 255, 255, 255)
    screen.drawRect(0, h - 9, 22, 8)
    screen.drawTextBox(1, h - 8, 22, 8, string.format("%1.1f", 1 / distanceDetector[defaultDistance] / 1000), 0, 0)
end
