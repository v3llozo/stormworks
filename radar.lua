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
        simulator:setInputNumber(1, screenConnection.width)
        simulator:setInputNumber(2, screenConnection.height)
        simulator:setInputNumber(3, screenConnection.touchX)
        simulator:setInputNumber(4, screenConnection.touchY)

        -- NEW! button/slider options from the UI
        simulator:setInputBool(5, simulator:getIsToggled(1)) -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputBool(6, simulator:getIsToggled(2))
        simulator:setInputBool(7, simulator:getIsToggled(3))
        simulator:setInputBool(8, simulator:getIsToggled(4))
        simulator:setInputBool(9, simulator:getIsToggled(5))
        simulator:setInputBool(10, simulator:getIsToggled(6))
        simulator:setInputBool(11, simulator:getIsToggled(7))
        simulator:setInputBool(12, simulator:getIsToggled(8))

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
maxTargets = 8
function onTick()
    ticks = ticks + 1
    radar = {
        found = {},
        target = {}
    }
    k=1
    for i = 1 , maxTargets, 1 do
        radar.found.insert(i,gB(i+4))
        radar.target.insert(i,{
           {distance=gN(k), azimuth=gN(k+1), elevation=gN(k+2), time=gN(k+3)}
        })
        k=k+4
    end
end

function onDraw()
    w = screen.getWidth()
    h = screen.getHeight()

    screen.setColor(255,255,255)
    screen.drawLine(0,0,w,0)
    screen.drawLine(w/5,0,w/5,h)

    for i=1, maxTargets, 1 do
        screen.drawLine(2,i*8+1,w,i*8+1)
        screen.drawText(2, i*8, "["..i.."]:"..radar.found[i])
        screen.drawText(w/4, i*8, "aaa")
    end
end
