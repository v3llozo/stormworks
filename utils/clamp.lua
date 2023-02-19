-- Author: V3llozo
-- GitHub: https://github.com/v3llozo
-- Workshop: <WorkshopLink>
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
function clamp(n, min, max)
    if n > max then
        return max
    elseif n < min then
        return min
    end
    return n
end
