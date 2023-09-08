-- Author: v3llozo
-- GitHub: github.com/v3llozo
-- Workshop: N/A
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
		simulator:setInputBool(31, simulator:getIsClicked(1))     -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
		simulator:setInputNumber(31, simulator:getSlider(1))      -- set input 31 to the value of slider 1

		simulator:setInputBool(32, simulator:getIsToggled(2))     -- make button 2 a toggle, for input.getBool(32)
		simulator:setInputNumber(32, simulator:getSlider(2) * 50) -- set input 32 to the value from slider 2 * 50
	end;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!


--@section clamp
function clamp(n, min, max)
	if n > max then
		return max
	elseif n < min then
		return min
	end
	return n
end

--@endsection

--@section pid
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

--@endsection

ticks = 0
function onTick()
	ticks = ticks + 1
	if tickCounter > 60000 then tickCounter = 0 end

	air = input.getNumber(1)
	fuel = input.getNumber(2)
	temp = clamp(input.getNumber(3), 0, 100) * 0.01
	throttle = input.getNumber(4)
	stoichometric = input.getNumber(5)
	sensibility = input.getNumber(6)
	rps = input.getNumber(7)
	minRps = input.getNumber(8)
	maxRps = input.getNumber(9)
	gear = input.getNumber(10)
	-- inputP = input.getNumber(13)
	-- inputI = input.getNumber(14)
	-- inputD = input.getNumber(15)
	-- inputAFR = input.getNumber(16)
	-- inputSTR = input.getNumber(17)
	-- input = input.getNumber(18)
	-- input = input.getNumber(19)
	-- input = input.getNumber(20)
	startStop = input.getBool(1)
	onOff = input.getBool(2)
	overheat = input.getBool(3)

	-- Start/Stop system on Ignition button.
	if startStop == true then startStopToggle = not startStopToggle end

	-- Killswitch engine.
	if onOff == false or (onOff == true and startStopToggle == false) then
		throttle = 0
		airIntake = 0
		fuelIntake = 0
	else
		-- Throttle 
		if gear == 0 then throttle = clamp(throttle, 0, 0.25) end

		pidmin = clamp(rpsIdle:run(rps, minRps) * -1, 0, 1)
		pidmax = clamp(rpsLimit:run(rps, maxRps) * -1, throttle * -0.8, 0)
		throttle = throttle + pidmax
		if rps > 1 then
			if rps < minRps then throttle = throttle + pidmin end
		end

		if air == 0 then air = 0.0001 end
		if fuel == 0 then fuel = 0.0001 end
		if stoichometric == 0 then stoichometric = 0.5 end
		if sensibility == 0 then sensibility = 0.02 end

		x = ((14 - (stoichometric * 2)) * (1 - temp)) + ((15 - (stoichometric * 5)) * temp)
		y = clamp(y + ((1 - (x / ((air * 1000) / (fuel * 1000)))) * sensibility), -1, 1)
		airIntake = throttle * clamp(1 - y, 0.1, 1)
		fuelIntake = throttle * clamp(1 + y, 0.1, 1)
	end

	output.setNumber(1, airIntake)
	output.setNumber(2, fuelIntake)
	output.setNumber(3, pidmin)
	output.setNumber(4, pidmax)
	output.setNumber(5, temp * 100)
	output.setNumber(6, rps)

	output.setBool(1, startStopToggle)
	output.setBool(2, onOff)
end
