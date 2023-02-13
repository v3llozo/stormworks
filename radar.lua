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
        simulator:setInputNumber(4, ticks / 10)

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

function onDraw()
    w = screen.getWidth()
    h = screen.getHeight()
    r = (h / 2) * 0.9
    rX = r * math.sin(radar.angle * 0.0175) + h / 2
    rY = r * math.cos(radar.angle * 0.0175) + w / 2

    screen.setColor(255, 255, 255)
    screen.drawCircleF(w / 2, h / 2, 6)
    screen.drawText(0, 0, string.format("%3.0f", r))
    screen.drawText(0, 8, string.format("%3.2f", radar.angle))
    screen.drawText(0, 16, string.format("%3.2f", rX))
    screen.drawText(0, 24, string.format("%3.2f", rY))

    screen.setColor(40, 255, 40)
    screen.drawCircle(w / 2, h / 2, r)
    screen.drawLine(w / 2, h / 2, rY, rX)
    for i = 1, maxTargets, 1 do
        if radar.found[i] then
            screen.setColor(255, 255, 255)
            tX = (radar.target[i].distance * 0.00001666) * r * math.sin(radar.angle * 0.0175) + h / 2
            tY = (radar.target[i].distance * 0.00001666) * r * math.cos(radar.angle * 0.0175) + w / 2
            screen.drawText(0, 32 + i * 8, string.format("%1.2f", radar.target[i].azimuth))
            screen.setColor(255, 0, 0)
            screen.drawRect(tY,tX, 3, 3)
        end
    end
end
