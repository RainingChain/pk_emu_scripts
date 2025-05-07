
-- Print every call to Random() in Ruby/Sapphire v1.2, excluding VBlankIntr and battle loop sub_800FCFC

local lastVblankCycle = 0
local vblankStart = nil

function emu_currentCycleInFrame()
  return emu:currentCycle() - lastVblankCycle
end

-- VblankIntr start
emu:setBreakpoint(function()
    lastVblankCycle = emu:currentCycle()
end, 0x08000570)

local JUMP_DATA = {
    {0x41C64E6D, 0x6073}, {0xC2A29A69, 0xE97E7B6A}, {0xEE067F11, 0x31B0DDE4}, {0xCFDDDF21, 0x67DBB608},
    {0x5F748241, 0xCBA72510}, {0x8B2E1481, 0x1D29AE20}, {0x76006901, 0xBA84EC40}, {0x1711D201, 0x79F01880},
    {0xBE67A401, 0x8793100}, {0xDDDF4801, 0x6B566200}, {0x3FFE9001, 0x803CC400}, {0x90FD2001, 0xA6B98800},
    {0x65FA4001, 0xE6731000}, {0xDBF48001, 0x30E62000}, {0xF7E90001, 0xF1CC4000}, {0xEFD20001, 0x23988000},
    {0xDFA40001, 0x47310000}, {0xBF480001, 0x8E620000}, {0x7E900001, 0x1CC40000}, {0xFD200001, 0x39880000},
    {0xFA400001, 0x73100000}, {0xF4800001, 0xE6200000}, {0xE9000001, 0xCC400000}, {0xD2000001, 0x98800000},
    {0xA4000001, 0x31000000}, {0x48000001, 0x62000000}, {0x90000001, 0xC4000000}, {0x20000001, 0x88000000},
    {0x40000001, 0x10000000}, {0x80000001, 0x20000000}, {0x1, 0x40000000}, {0x1, 0x80000000}}

local timerAddr = 0x3001790
local currentSeedAddr = 0x3004818
    
function LCRNG(s, mul, sum)
    local a = (mul >> 16) * (s % 0x10000) + (s >> 16) * (mul % 0x10000)
    local b = (mul % 0x10000) * (s % 0x10000) + (a % 0x10000) * 0x10000 + sum

    return b % 0x100000000
end

local tempCurrentSeed = 0

function LCRNGDistance(state0, state1)
    local mask = 1
    local dist = 0

    if state0 ~= state1 then
        for _, data in ipairs(JUMP_DATA) do
            local mult, add = table.unpack(data)
        
            if state0 == state1 then
                break
            end
        
            if ((state0 ~ state1) & mask) ~= 0 then
                state0 = LCRNG(state0, mult, add)
                dist = dist + mask
            end
        
            mask = mask << 1
        end
    
        tempCurrentSeed = state1
    end

    return dist > 999 and dist - 0x100000000 or dist
end

local initialSeed, advances = 0, 0

function getRngInfo()
    local timer = emu:read16(timerAddr)
    local current = emu:read32(currentSeedAddr)

    if (timer == 0 and current <= 0xFFFF) or current == timer then
        initialSeed = current
        tempCurrentSeed = current
    end
    
    if initialSeed == current then
        advances = 0
    else
        advances = advances + LCRNGDistance(tempCurrentSeed, current)
    end

    return advances
end


emu:setBreakpoint(function()
    local caller = emu:readRegister("r14")
    if caller == 0x80005b9 then -- VBlankIntr
        return
    end
    if caller == 0x800fd03 then -- battle loop sub_800FCFC
        return 
    end

    local callerAddr = string.format("%04x", caller)
    local callerName = "???"
    if caller == 0x813d875 then
        callerName = "sub_813D788_update_intro_anim"
    elseif caller == 0x80bd859 then
        callerName = "special_0x44_TV_show"    
    elseif caller == 0x8084bab then
        callerName = "ChooseWildMonIndex_Land"   
    elseif caller == 0x8084c67 then
        callerName = "ChooseWildMonIndex_Water"               
    elseif caller == 0x8085055 then
        callerName = "DoWildEncounterRateDiceRoll"    
    elseif caller == 0x8084d71 then
        callerName = "ChooseWildMonLevel"    
    elseif caller == 0x803ab01 then
        callerName = "CreateMonWithNature_v1" 
    elseif caller == 0x803ab07 then
        callerName = "CreateMonWithNature_v2"     
    elseif caller == 0x805413d then
        callerName = "UpdateAmbientCry"     
    elseif caller == 0x80540ad then
        callerName = "PlayAmbientCry_v1"     
    elseif caller == 0x80540c3 then
        callerName = "PlayAmbientCry_v2"     
    elseif caller == 0x8054159 then
        callerName = "PlayAmbientCry_v3"   
    elseif caller == 0x803aa19 then
        callerName = "CreateBoxMon_v1"      
    elseif caller == 0x803aa63 then
        callerName = "CreateBoxMon_v2"      
    elseif caller == 0x81071c9 then
        callerName = "BattleAI_SetupAIData"      
    elseif caller == 0x8040c6b then
        callerName = "SetWildMonHeldItem"  
    elseif caller == 0x8011d6b then
        callerName = "BattleBeginFirstTurn"     
    elseif caller == 0x80354ff then
        callerName = "OpponentHandlecmd20"         
    elseif caller >= 0x0805c8a8 and caller < 0x0805fd3c then
        callerName = "MovementType_*_Step*"    
    elseif caller == 0x8082973 then
        callerName = "UpdateRandomTrainerEyeRematches"  
    elseif caller == 0x81343bd then
        callerName = "RoamerMove"          
    elseif caller == 0x8085501 then
        callerName = "GetLocalWildMon"       
    elseif caller == 0x803fd9d then
        callerName = "AdjustFriendship"      
    elseif caller == 0x813bad1 then
        callerName = "Task_IntroLoadPart1Graphics" 
    elseif caller == 0x80bf7a9 then
        callerName = "sub_80BF77C_TV_Show"         
    elseif caller == 0x8040073 then
        callerName = "RandomlyGivePartyPokerus"         
    elseif caller == 0x804027b then
        callerName = "PartySpreadPokerus"           
    elseif caller == 0x8084e83 then
        callerName = "PickWildMonNature"   
    elseif caller == 0x808c3a1 then
        callerName = "CB2_InitPokedex"      
        
    elseif caller == 0x801c5c5 then
        callerName = "atk01_accuracycheck"      
    elseif caller == 0x801f695 then
        callerName = "atk15_seteffectwithchance"      
    elseif caller == 0x802afe5 then
        callerName = "atkE5_pickup_v1_if"      
    elseif caller == 0x802aff9 then
        callerName = "atkE5_pickup_v2_select_item"           
    end
    
    --[[
    callers of sub_80BF77C:
        
        sub_80BE074: always
            called when not catching pokemon

        sub_80BE778: ~always
            if (FlagGet(FLAG_SYS_GAME_CLEAR))
                and none of the 24 tv show is TVSHOW_MASS_OUTBREAK
            also calls another Random() if Random() <= 0x147

        sub_80BEB20: ~always
            if (FlagGet(FLAG_SYS_GAME_CLEAR))
                and if has at least 1 pokenews slot empty

        sub_80BF77C: never
            if caughtPoke > 0

        sub_80BE3BC:  never
            seems related with shop

        sub_80BEA88: never
            called on clock change (UpdateTVShowsPerDay)

    --]]
    
    local currentAdvances = getRngInfo()
    console:log("RNG Adv=" .. currentAdvances .. ": " .. callerName .. " " .. callerAddr .. " cycle " .. emu_currentCycleInFrame())
end, 0x08040ea4)

local GameInfo = console:createBuffer("Advance")
GameInfo:setSize(100, 100)
callbacks:add("frame", function()
    local currentAdvances = getRngInfo()
    GameInfo:clear()
    if currentAdvances < 0 then
        GameInfo:print("Error: Unable to determine the current advance. Reset the game with Ctrl+R.")
    else 
        GameInfo:print("Current advance: " .. currentAdvances)
    end
end)
