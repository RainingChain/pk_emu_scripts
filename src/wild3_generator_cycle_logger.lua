
require"utils_calc_modulo.lua"
require"utils_vblank.lua"
require"utils_caller_to_name.lua"

function newState(cycleAtSweetScentWildEncounter)
    return {
        cycleAtSweetScentWildEncounter = cycleAtSweetScentWildEncounter,
        cycleAtMoments = {},
        reachedPidLow = false,
        reachedPidHigh = false,
    }
end

function printState(state)
    local str = "{\n"
    str = str .. " \"cycleAtMoments\":[\n"
    for i = 1, #state.cycleAtMoments do 
        local m = state.cycleAtMoments[i]
        str = str .. "  {\"moment\":\"" .. m.moment .. "\", \"cycle\":" .. m.cycle .. "}"

        if i ~= state.cycleAtMoments[i] then
            str = str .. ","
        end
        str = str .. "\n"
    end
    str = str .. " ]\n"
    str = str .. "}";

    console:log(str)
end

local state = newState(0)

function add_moment(moment)
    table.insert(state.cycleAtMoments, {
        cycle = emu_currentCycleInFrame() - state.cycleAtSweetScentWildEncounter,
        moment = moment,
    })
end

function overwrite_last_moment_cycle()
    state.cycleAtMoments[#state.cycleAtMoments].cycle = emu_currentCycleInFrame() - state.cycleAtSweetScentWildEncounter
end

-- SweetScentWildEncounter()
emu:setBreakpoint(function()
    state = newState(emu_currentCycleInFrame())
end, 0x80b5578)
 
-- Random()
emu:setBreakpoint(function()
    if state.cycleAtSweetScentWildEncounter == 0 then 
        return
    end

    local caller = emu:readRegister("r14")
    if caller == 0x80007bf then -- VBlankIntr
        return
    end
    if caller == 0x8038a3b then -- VBlankCB_Battle
        return 
    end

    
    local callerName = caller_to_name(caller, false)
    if callerName == "ChooseWildMonIndex_Land_Random" or 
            callerName == "ChooseWildMonLevel_RandomLvl"  or 
            callerName == "PickWildMonNature_RandomTestSynchro"  or 
            callerName == "CreateBoxMon_RandomIvs1"  then
        add_moment(callerName)
    end

    if callerName == "CreateBoxMon_RandomIvs2" then
        add_moment(callerName)
        printState(state)
        state = newState(0)      
    end

    if callerName == "CreateMonWithNature_RandomPidLow" and 
           state.reachedPidLow == false then
        add_moment("CreateMonWithNature_RandomPidLowFirst")
        state.reachedPidLow = true
    end
       
    if callerName == "CreateMonWithNature_RandomPidHigh" then
        if state.reachedPidHigh == false then 
            add_moment("CreateMonWithNature_RandomPidHighLast")
            state.reachedPidHigh = true
        else 
            overwrite_last_moment_cycle()
        end
    end

end, 0x0806f5cc)

-- VblankIntr end
emu:setBreakpoint(function()
    if state.cycleAtSweetScentWildEncounter ~= 0 then 
        printState(state)
        state = newState(0)
    end
end, 0x80007dA)
