function clamp(n, min, max)
	if n > max then return max
	elseif n < min then return min end
	return n
end

function pid(p, i, d)
	return { p = p, i = i, d = d, E = 0, D = 0, I = 0,
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

function onDraw()
end

rpsIdle = pid(.4, .0005, .07)
rpsLimit = pid(.01, .001, .8)
tickCounter = 0

x = 0.0001
y = 0.0001

function onTick()
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
	startStop = input.getBool(1)
	onOff = input.getBool(2)

	pidmin = clamp(rpsIdle:run(rps, minRps) * -1, 0, 0.9)
	pidmax = clamp(rpsLimit:run(rps, maxRps) * -1, -0.9, 0)
	if rps > 1 then
		if rps > maxRps then throttle = throttle + pidmax end
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

	output.setNumber(1, airIntake)
	output.setNumber(2, fuelIntake)
	output.setNumber(3, pidmin)
	output.setNumber(4, pidmax)
	output.setNumber(5, temp)
	output.setNumber(6, rps)

	output.setBool(1, startStop)
	output.setBool(2, onOff)

end
