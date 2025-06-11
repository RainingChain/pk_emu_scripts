
local lastVblankCycleStart = 0
local lastVblankCycleEnd = 0

-- VblankIntr start
emu:setBreakpoint(function()
  lastVblankCycleStart = emu:currentCycle()
end, 0x08000738)

-- VblankIntr end
emu:setBreakpoint(function()
  lastVblankCycleEnd = emu:currentCycle()
  console:log("" .. (lastVblankCycleEnd - lastVblankCycleStart))
end, 0x80007dA)
