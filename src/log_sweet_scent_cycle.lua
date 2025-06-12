
require"log_modulo.lua"
require"log_rng_advances.lua"

local printStack = function(what)
    local str = what 
        .. " : AdvBef=" .. getCurrentAdv() 
        .. ", Frame=" .. emu:currentFrame() 
        .. ", Cycle=" .. emu_currentCycleInFrame()

    console:log(str)
end

-- SweetScentWildEncounter()
emu:setBreakpoint(function()
    printStack("SweetScentWildEncounter")
end, 0x80b5578)

-- DoMassOutbreakEncounterTest()
emu:setBreakpoint(function()
    printStack("DoMassOutbreakEncounterTest")
end, 0x080b50dc)

-- CreateMon()
emu:setBreakpoint(function()
    printStack("CreateMon")
end, 0x08067b4c)
