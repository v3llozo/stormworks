-- @section pid
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

-- @endsection
-- @section clamp
function clamp(n, min, max)
    if n > max then
        return max
    elseif n < min then
        return min
    end
    return n
end

-- @endsection

throttlePidL = pid(0.1, 0, 0)
throttlePidR = pid(0.1, 0, 0)

ticks = 0
function onTick()
    ticks = ticks + 1
    throttle = input.getNumber(11)
    rpsL = input.getNumber(12)
    rpsR = input.getNumber(13)
    roll = input.getNumber(1)
    pitch = input.getNumber(2)
    yaw = input.getNumber(3)

    afterburnerL = input.getBool(1)
    afterburnerR = input.getBool(2)

    maxRps = 180
    wingL = 0
    wingR = 0
    tailL = 0
    tailR = 0
    rearL = 0
    rearR = 0

    wingL = (roll + pitch)
    wingR = (roll * -1 + pitch)

    tailL = clamp(yaw, -1, 0.7)
    tailR = clamp(yaw, -0.7, 1)

    rearL = clamp((roll + pitch + yaw * -0.25), -0.5, 0.5)
    rearR = clamp((roll * -1 + pitch + yaw * 0.25), -0.5, 0.5)

    pidmaxL = clamp(throttlePidL:run(rpsL, maxRps) * -1, (yaw * -0.1 + throttle) * -1, 0)
    pidmaxR = clamp(throttlePidR:run(rpsR, maxRps) * -1, (yaw * 0.1 + throttle) * -1, 0)
    output.setNumber(1, (throttle + pidmaxL))
    output.setNumber(2, (throttle + pidmaxR))

    if afterburnerL == true then
        output.setNumber(3, throttle)
    end

    if afterburnerR == true then
        output.setNumber(4, throttle)
    end

    output.setNumber(5, wingL)
    output.setNumber(6, wingR)
    output.setNumber(7, tailL)
    output.setNumber(8, tailR)
    output.setNumber(9, rearL)
    output.setNumber(10, rearR)
end
