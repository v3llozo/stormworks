-- Author: V3llozo
-- GitHub: https://github.com/v3llozo
-- Workshop: <WorkshopLink>
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
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
