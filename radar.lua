--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


--[====[ HOTKEYS ]====]
-- Press F6 to simulate this file
-- Press F7 to build the project, copy the output from /_build/out/ into the game to use
-- Remember to set your Author name etc. in the settings: CTRL+COMMA


--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "5x3")
    simulator:setProperty("ExampleNumberProperty", 123)

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

        simulator:setInputNumber(5, 150)
        simulator:setInputNumber(6, 0.1215)
        simulator:setInputNumber(7, -0.2)
        simulator:setInputNumber(8, 0.5)
        simulator:setInputNumber(9, 1400)
        simulator:setInputNumber(10, 0.015)
        simulator:setInputNumber(11, 0.8)
        simulator:setInputNumber(12, 1)
        -- NEW! button/slider options from the UI
        simulator:setInputBool(1, simulator:getIsToggled(1)) -- if button 1 is clicked, provide an ON pulse for input.getBool(31)

        -- simulator:setInputNumber(31, simulator:getSlider(1)) -- set input 31 to the value of slider 1

        -- simulator:setInputBool(32, simulator:getIsToggled(2)) -- make button 2 a toggle, for input.getBool(32)
        -- simulator:setInputNumber(32, simulator:getSlider(2) * 50) -- set input 32 to the value from slider 2 * 50
    end

    ;
end
---@endsection


--[====[ IN-GAME CODE ]====]
-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

ticks = 0
gB = input.getBool
gN = input.getNumber
maxTargets = 7
-- 0.5km, 1km, 2km, 5km, 10km, 15km, 30km, 60km
distanceDetector = { 0.002, 0.001, 0.0005, 0.0002, 0.0001, 0.000066, 0.0000333, 0.0000166 }
selectedDistance = distanceDetector[7]
function onTick()
    isTouched = gB(1)
    touchX = gN(2)
    touchY = gN(3)
    ticks = ticks + 1
    radar = {
        angle = (gN(4) % 1) * 360,
        found = {},
        target = {}
    }
    k = 5
    for i = 1, maxTargets, 1 do
        table.insert(radar.found, gB(i + 4))
        table.insert(radar.target, {
            distance = gN(k), azimuth = gN(k + 1), elevation = gN(k + 2), time = gN(k + 3)
        })
        k = k + 4
    end
end

detectedTargets = {}
function onDraw()
    w = screen.getWidth()
    h = screen.getHeight()
    r = (h / 2) * 0.95
    rX = r * math.sin(radar.angle * 0.0175) + h / 2
    rY = r * math.cos(radar.angle * 0.0175) + w / 2

    for k, t in pairs(detectedTargets) do
        if radar.angle < t.angle then
            screen.setColor(255, 0, 0)
            screen.drawRect(t.y, t.x, 1, 1)
        else
            table.remove(detectedTargets,k)
        end
    end

    screen.setColor(255, 255, 255)
    screen.drawRectF(w / 2 - 1, h / 2 - 1, 3, 3)
    screen.drawText(2, 0, string.format("%3.0f", r))
    screen.drawText(2, 8, string.format("%3.2f", radar.angle))
    screen.drawText(2, 16, string.format("%3.2f", rX))
    screen.drawText(2, 24, string.format("%3.2f", rY))
    screen.drawText(w - 38, 0, string.format("%.1f", (1 / selectedDistance) / 1000) .. "km")


    screen.setColor(40, 255, 40)
    screen.drawCircle(w / 2, h / 2, r)
    screen.drawLine(w / 2, h / 2, rY, rX)

    targetAngle = radar.angle
    for i = 1, maxTargets, 1 do
        if radar.found[i] then
            output.setBool(1,true)
            screen.setColor(255, 255, 255)
            tX = (radar.target[i].distance * selectedDistance) * r *
                math.sin((targetAngle - radar.target[i].azimuth / 100) * 0.0175) + h / 2
            tY = (radar.target[i].distance * selectedDistance) * r *
                math.cos((targetAngle - radar.target[i].azimuth / 100) * 0.0175) + w / 2
            screen.drawText(2, 32 + i * 8, string.format("%.0f", radar.target[i].distance))
            screen.drawTextBox(w - 38, 32 + i * 8, 36, 8, string.format("%.5f", radar.target[i].azimuth), -1, 0)
            screen.setColor(255, 0, 0)
            screen.drawRect(tY, tX, 1, 1)
            table.insert(detectedTargets, { y = tY, x = tX, angle = targetAngle })
        end
    end
end
