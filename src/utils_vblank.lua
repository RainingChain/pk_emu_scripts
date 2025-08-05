--[[
Exported:
    emu_currentCycleInFrame
    lastVblankCycleStart
    lastVblankCycleEnd

--]]

require"utils_rse_header.lua"

local lastVblankCycleStart = 0
local lastVblankCycleEnd = 0

function emu_currentCycleInFrame()
  return emu:currentCycle() - lastVblankCycleStart
end  

if gameVersionName == "Emerald" then  
    -- VblankIntr start
    emu:setBreakpoint(function()
        lastVblankCycleStart = emu:currentCycle()
    end, 0x08000738)

    -- VblankIntr end
    emu:setBreakpoint(function()
        lastVblankCycleEnd = emu:currentCycle()
    end, 0x80007dA)
end

if gameVersionName == "Ruby" or gameVersionName == "Sapphire" then
    -- VblankIntr start
    emu:setBreakpoint(function()
        lastVblankCycleStart = emu:currentCycle()
    end, 0x08000570)
end
