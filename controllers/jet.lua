-- Author: V3llozo
-- GitHub: https://github.com/v3llozo
-- Workshop: <WorkshopLink>
--
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
    simulator:setScreen(1, "3x3")
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
        simulator:setInputBool(31, simulator:getIsClicked(1)) -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1)) -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2)) -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50) -- set input 32 to the value from slider 2 * 50
    end

    ;
end
---@endsection


--[====[ IN-GAME CODE ]====]
-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!
function pid(p, i, d)
    return {
        p = p,
        i = i,
        d = d,
        E = 0,
        D = 0,
        I = 0,
        run = function(s, sp, pv)
            local E, D, A
            E = sp - pv
            D = E - s.E
            A = math.abs(D - s.D)
            s.E = E
            s.D = D
            s.I = A < E and s.I + E * s.i or s.I * 0.5
            return E * s.p + (A < E and s.I or 0) + D * s.d
        end
    }
end

function clamp(n, min, max)
    if n > max then
        return max
    elseif n < min then
        return min
    end
    return n
end

throttlePid = pid(0.1, 0, 0)

ticks = 0
function onTick()
    ticks = ticks + 1
    throttle = input.getNumber(1)
    rps = input.getNumber(2)
    maxRps = 190 -- input.getNumber(2)

    pidmax = clamp(throttlePid:run(rps, maxRps) * -1, throttle * -1, 0)
	if rps > maxRps then throttle = throttle + pidmax end
    output.setNumber(1, throttle)
end
