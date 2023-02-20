-- Author: V3llozo
-- GitHub: https://github.com/v3llozo
-- Workshop: <WorkshopLink>
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
    throttle = input.getNumber(11)
    rps = input.getNumber(12)
    maxRps = 190 -- input.getNumber(13)
    wingL = 0
    wingR = 0
    tailL = 0
    tailR = 0
    rearL = 0
    rearR = 0

    roll = input.getNumber(1)
    pitch = input.getNumber(2)
    yaw = input.getNumber(3)

    wingL = clamp(roll,0,1) + clamp(pitch,0,1)
    wingR = clamp(roll,-1,0) + clamp(pitch,-1,0)

    tailL = clamp(yaw,0,1)
    tailR = clamp(yaw,-1,0)

    rearL = clamp(roll,0,1) + clamp(pitch,0,1)
    rearR = clamp(roll,-1,0) + clamp(pitch,-1,0)

    pidmax = clamp(throttlePid:run(rps, maxRps) * -1, throttle * -1, 0)
    if rps > maxRps then throttle = throttle + pidmax end
    output.setNumber(1, throttle)

    output.setNumber(3, wingL)
    output.setNumber(4, wingR)
    output.setNumber(5, tailL)
    output.setNumber(6, tailR)
    output.setNumber(7, rearL)
    output.setNumber(8, rearR)
end
