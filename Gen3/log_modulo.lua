--[[
Purpose: Print modulo calls between TrySweetScentEncounter and CreateBoxMon (2nd IVS)

Ex: __umodsi3 (00000000,    24) CycleDur=    18 from GetSubstruct 806a283

Emerald only
--]]


local calc_modulo_cycle_u = function(dividend, divisor)
    if divisor <= 0 then
        return 0 -- error
    end

    -- Ensure unsigned 32-bit behavior
    dividend = dividend & 0xFFFFFFFF
    divisor = divisor & 0xFFFFFFFF

    if dividend < divisor then
        return 18
    end

    local cycles = 24
    local r0 = dividend
    local r1 = divisor
    local r3 = 1
    local r2
    local r12
    local r4 = 0x10000000

    -- First loop
    while true do
        if r1 >= r4 then
            cycles = cycles + 10
            break
        end
        if r1 >= r0 then
            cycles = cycles + 14
            break
        end
        r1 = (r1 << 4) & 0xFFFFFFFF
        r3 = (r3 << 4) & 0xFFFFFFFF
        cycles = cycles + 20
    end

    r4 = (r4 << 3) & 0xFFFFFFFF

    -- Second loop
    while true do
        if r1 >= r4 then
            cycles = cycles + 10
            break
        end
        if r1 >= r0 then
            cycles = cycles + 14
            break
        end
        r1 = (r1 << 1) & 0xFFFFFFFF
        r3 = (r3 << 1) & 0xFFFFFFFF
        cycles = cycles + 20
    end

    -- Main loop
    while true do
        r2 = 0
        cycles = cycles + 48
        if r0 >= r1 then
            r0 = r0 - r1
            cycles = cycles - 4
        end

        r4 = r1 >> 1
        if r0 >= r4 then
            r0 = r0 - r4
            r12 = r3
            r3 = ((r3 << (32 - 1)) | (r3 >> 1)) & 0xFFFFFFFF
            r2 = r2 | r3
            r3 = r12
            cycles = cycles + 7
        end

        r4 = r1 >> 2
        if r0 >= r4 then
            r0 = r0 - r4
            r12 = r3
            r3 = ((r3 << (32 - 2)) | (r3 >> 2)) & 0xFFFFFFFF
            r2 = r2 | r3
            r3 = r12
            cycles = cycles + 7
        end

        r4 = r1 >> 3
        if r0 >= r4 then
            r0 = r0 - r4
            r12 = r3
            r3 = ((r3 << (32 - 3)) | (r3 >> 3)) & 0xFFFFFFFF
            r2 = r2 | r3
            r3 = r12
            cycles = cycles + 7
        end

        r12 = r3
        if r0 == 0 then
            cycles = cycles + 12
            break
        end
        r3 = r3 >> 4
        if r3 == 0 then
            cycles = cycles + 16
            break
        end
        r1 = r1 >> 4
        cycles = cycles + 20
    end

    r2 = r2 & 0xE0000000
    if r2 == 0 then
        return cycles + 18
    end

    r3 = r12
    r3 = ((r3 << (32 - 3)) | (r3 >> 3)) & 0xFFFFFFFF
    if (r2 & r3) ~= 0 then
        r0 = r0 + (r1 >> 3)
        cycles = cycles - 2
    end

    r3 = r12
    r3 = ((r3 << (32 - 2)) | (r3 >> 2)) & 0xFFFFFFFF
    if (r2 & r3) ~= 0 then
        r0 = r0 + (r1 >> 2)
        cycles = cycles - 2
    end

    r3 = r12
    r3 = ((r3 << (32 - 1)) | (r3 >> 1)) & 0xFFFFFFFF
    if (r2 & r3) ~= 0 then
        -- r0 = r0 + (r1 >> 1)
        cycles = cycles - 2
    end

    return cycles + 75
end


local calc_modulo_cycle_s = function(dividend, divisor)
    local abs = math.abs
    -- Simulate 32-bit signed/unsigned
    local function to_u32(x) return x & 0xFFFFFFFF end

    local r1 = abs(divisor)
    local r0 = abs(dividend)
    local r3 = 1
    local r2, r4, r12
    local cycles = 10

    if divisor > 0 then
        cycles = cycles + 4
    end

    cycles = cycles + 10
    if dividend > 0 then
        cycles = cycles + 4
    end

    if r0 < r1 then
        if dividend > 0 then
            return cycles + 32
        end
        return cycles + 28
    end

    r4 = 0x10000000
    cycles = cycles + 8

    -- First loop
    while true do
        if r1 >= r4 then
            cycles = cycles + 10
            break
        end
        if r1 >= r0 then
            cycles = cycles + 14
            break
        end
        r1 = to_u32(r1 << 4)
        r3 = to_u32(r3 << 4)
        cycles = cycles + 20
    end

    r4 = to_u32(r4 << 3)
    cycles = cycles + 2

    -- Second loop
    while true do
        if r1 >= r4 then
            cycles = cycles + 10
            break
        end
        if r1 >= r0 then
            cycles = cycles + 14
            break
        end
        r1 = to_u32(r1 << 1)
        r3 = to_u32(r3 << 1)
        cycles = cycles + 20
    end

    -- Main loop
    while true do
        r2 = 0
        cycles = cycles + 48
        if r0 >= r1 then
            r0 = r0 - r1
            cycles = cycles - 4
        end

        r4 = r1 >> 1
        if r0 >= r4 then
            r0 = r0 - r4
            r12 = r3
            r3 = to_u32((r3 << (32 - 1)) | (r3 >> 1))
            r2 = r2 | r3
            r3 = r12
            cycles = cycles + 7
        end

        r4 = r1 >> 2
        if r0 >= r4 then
            r0 = r0 - r4
            r12 = r3
            r3 = to_u32((r3 << (32 - 2)) | (r3 >> 2))
            r2 = r2 | r3
            r3 = r12
            cycles = cycles + 7
        end

        r4 = r1 >> 3
        if r0 >= r4 then
            r0 = r0 - r4
            r12 = r3
            r3 = to_u32((r3 << (32 - 3)) | (r3 >> 3))
            r2 = r2 | r3
            r3 = r12
            cycles = cycles + 7
        end

        r12 = r3
        if r0 == 0 then
            cycles = cycles + 12
            break
        end
        r3 = r3 >> 4
        if r3 == 0 then
            cycles = cycles + 16
            break
        end
        r1 = r1 >> 4
        cycles = cycles + 20
    end

    r2 = r2 & 0xE0000000
    if r2 == 0 then
        if dividend >= 0 then
            return cycles + 36
        end
        return cycles + 32
    end
    cycles = cycles + 8

    r3 = r12
    cycles = cycles + 17
    r3 = to_u32((r3 << (32 - 3)) | (r3 >> 3))
    if (r2 & r3) ~= 0 then
        r0 = r0 + (r1 >> 3)
        cycles = cycles - 2
    end
    r3 = r12

    cycles = cycles + 17
    r3 = to_u32((r3 << (32 - 2)) | (r3 >> 2))
    if (r2 & r3) ~= 0 then
        r0 = r0 + (r1 >> 2)
        cycles = cycles - 2
    end
    r3 = r12

    cycles = cycles + 17
    r3 = to_u32((r3 << (32 - 1)) | (r3 >> 1))
    if (r2 & r3) ~= 0 then
        -- r0 = r0 + (r1 >> 1)
        cycles = cycles - 2
    end

    cycles = cycles + 18
    if dividend >= 0 then
        cycles = cycles + 4
    end
    return cycles
end

-- Emerald

function caller_to_name(caller, withAddress)
    local callerAddr = string.format("%04x", caller)
    local callerName = "???"
    if caller == 0x816fa85 then
        callerName = "SpriteCB_PlayerOnBicycle"
    elseif caller == 0x817758f then
        callerName = "SetRandomLotteryNumber"
    elseif caller == 0x80b57f9 then
        callerName = "GetLocalWildMon"
    elseif caller == 0x80b4acf then
        callerName = "ChooseWildMonIndex_Land_Random"
    elseif caller == 0x80b4b8b then
        callerName = "ChooseWildMonIndex_WaterRock"            
    elseif caller == 0x80ebf75 then
        callerName = "GetRandomActiveShowIdx"
    elseif caller == 0x8076beb then
        callerName = "SetSaveBlocksPointers"
    elseif caller == 0x8076ccb then
        callerName = "MoveSaveBlocks_ResetHeap_v1"
    elseif caller == 0x8076cd1 then
        callerName = "MoveSaveBlocks_ResetHeap_v2"
    elseif caller == 0x8085a8d then
        callerName = "UpdateAmbientCry_v1"

    elseif caller == 0x80859f5 then
        callerName = "PlayAmbientCry_v1"
    elseif caller == 0x8085a0b then
        callerName = "PlayAmbientCry_v2"
    elseif caller == 0x8085ae9 then
        callerName = "UpdateAmbientCry_v2"
    elseif caller >= 0x0808f3e0 and caller <= 0x0809299c then
        callerName = "Movement*"
    elseif caller == 0x80b5151 then
        callerName = "EncounterOddsCheck"
    elseif caller == 0x8195eb3 then
        callerName = "CheckMatchCallChance"
    elseif caller == 0x8195f79 then
        callerName = "SelectMatchCallTrainer"
    elseif caller == 0x819680f then
        callerName = "SelectMatchCallMessage"
    elseif caller == 0x819691b then
        callerName = "GetGeneralMatchCallText"
    elseif caller == 0x8196abf then
        callerName = "GetLandEncounterSlot"
    elseif caller == 0x8196b57 then
        callerName = "GetWaterEncounterSlot"
    elseif caller == 0x8196c2f then
        callerName = "PopulateSpeciesFromTrainerLocation"
    elseif caller == 0x803a1db then
        callerName = "BattleStartClearSetData"
    elseif caller == 0x806dcbf then
        callerName = "RandomlyGivePartyPokerus"
    elseif caller == 0x806decf then
        callerName = "PartySpreadPokerus"
    elseif caller == 0x81968c5 then
        callerName = "GetBattleMatchCallText"
    elseif caller == 0x80b4c97 then
        callerName = "ChooseWildMonLevel_RandomLvl"
    elseif caller == 0x80b4e2f then
        callerName = "PickWildMonNature_RandomTestSynchro"
    elseif caller == 0x80b4e51 then
        callerName = "PickWildMonNature_RandomPickNature"
    elseif caller == 0x8067eb5 then
        callerName = "CreateMonWithNature_RandomPidLow"
    elseif caller == 0x8067ebb then
        callerName = "CreateMonWithNature_RandomPidHigh"
    elseif caller == 0x8067dcd then
        callerName = "CreateBoxMon_RandomIvs1"
    elseif caller == 0x8067e17 then
        callerName = "CreateBoxMon_RandomIvs2"
    elseif caller == 0x81309d3 then
        callerName = "BattleAI_SetupAIData"
    elseif caller == 0x806ea81 then
        callerName = "SetWildMonHeldItem"
    elseif caller == 0x80b4ebd then
        callerName = "CreateWildMon_RandomTestCuteCharm"
    elseif caller == 0x80b4ec7 then
        callerName = "CreateWildMon_CuteCharm_modulo"

    elseif caller == 0x80b4ca1 then
        callerName = "ChooseWildMonLevel_RandomLvl"
    elseif caller == 0x806a283 then
        callerName = "GetSubstruct"
        
    elseif caller == 0x80b4e5b then
        callerName = "PickWildMonNature_modulo"
        
    elseif caller == 0x806d091 then
        callerName = "GetNatureFromPersonality"
        
    elseif caller == 0x8067fa3 then
        callerName = "CreateMonWithGenderNatureLetter_pidlow"
        
    elseif caller == 0x8067fa9 then
        callerName = "CreateMonWithGenderNatureLetter_pidhigh"

    --[[
    elseif caller == 0x then
        callerName = ""
    elseif caller == 0x then
        callerName = ""
    elseif caller == 0x then
        callerName = ""

    --]]
    end

    if withAddress ~= false then
        return callerName .. " " .. callerAddr
    else
        return callerName
    end
end


local mustPrintModulo = true

--mustPrintModulo = false

local totalModuloCycle = 0

--[[ -- NO_PROD
-- TrySweetScentEncounter
emu:setBreakpoint(function()
  mustPrintModulo = true
end, 0x08159fec)

-- CreateBoxMon (2nd ivs)
emu:setBreakpoint(function()
  mustPrintModulo = false
end, 0x8067e17)
--]]

-- __umodsi3
emu:setBreakpoint(function()
  if (mustPrintModulo == false) then
    return
  end

  local dividend = emu:readRegister("r0")
  local divisor = emu:readRegister("r1")
  local cycle = calc_modulo_cycle_u(dividend, divisor)
  totalModuloCycle = totalModuloCycle + cycle
  local callerName = caller_to_name(emu:readRegister("r14"))
  
  local dividendStr = string.format("%08x", dividend)
  if string.sub(dividendStr, 1, string.len("ffffffff")) == "ffffffff" then
    dividendStr = string.sub(dividendStr, 9)
  end
  
  console:log("  __umodsi3 (" 
    .. dividendStr
    .. ", " 
    .. string.format("%5s", tostring(divisor))  
    .. ") CycleDur= " 
    .. string.format("%5s", tostring(cycle)) 
    .. " from "
    .. callerName
  )
end, 0x082e7be0)

-- __modsi3
emu:setBreakpoint(function()
  if (mustPrintModulo == false) then
    return
  end

  local dividend = emu:readRegister("r0")
  local divisor = emu:readRegister("r1")
  local cycle = calc_modulo_cycle_s(dividend, divisor)
  totalModuloCycle = totalModuloCycle + cycle
  local callerName = caller_to_name(emu:readRegister("r14"))

  console:log("  __modsi3  (" 
    .. string.format("0x%08x", dividend) 
    .. ", " 
    .. string.format("%5s", tostring(divisor))  
    .. ") CycleDur= " 
    .. string.format("%5s", tostring(cycle)) 
    .. " from "
    .. callerName
  )
end, 0x082e7650)
