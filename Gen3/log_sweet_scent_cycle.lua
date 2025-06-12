
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

function caller_to_name(caller)
    local callerAddr = string.format("%04x", caller)
    local callerName = "???"
    if caller == 0x816fa85 then
        callerName = "SpriteCB_PlayerOnBicycle"
    elseif caller == 0x817758f then
        callerName = "SetRandomLotteryNumber"
    elseif caller == 0x80b57f9 then
        callerName = "GetLocalWildMon"
    elseif caller == 0x80b4acf then
        callerName = "ChooseWildMonIndex_Land"
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
        callerName = "ChooseWildMonLevel"
    elseif caller == 0x80b4e2f then
        callerName = "PickWildMonNature_forSynchronize"
    elseif caller == 0x80b4e51 then
        callerName = "PickWildMonNature_pickRandom"
    elseif caller == 0x8067eb5 then
        callerName = "CreateMonWithNature_pidlow"
    elseif caller == 0x8067ebb then
        callerName = "CreateMonWithNature_pidhigh"
    elseif caller == 0x8067dcd then
        callerName = "CreateBoxMon_ivs1"
    elseif caller == 0x8067e17 then
        callerName = "CreateBoxMon_ivs2"
    elseif caller == 0x81309d3 then
        callerName = "BattleAI_SetupAIData"
    elseif caller == 0x806ea81 then
        callerName = "SetWildMonHeldItem"
    elseif caller == 0x80b4ebd then
        callerName = "CreateWildMon_CuteCharmRandom"
    elseif caller == 0x80b4ec7 then
        callerName = "CreateWildMon_CuteCharm_modulo"

    elseif caller == 0x80b4ca1 then
        callerName = "ChooseWildMonLevel_levelRange"
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
    return callerName .. " " .. callerAddr
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

--[[
Purpose: Print every call to Random(), excluding VBlankIntr and battle loop sub_800FCFC

Version: v1.0

Credits: RainingChain, Real96

License: GNU General Public License v3.0
--]] 

--[[
Exported:
    emu_currentCycleInFrame
    lastVblankCycleStart
    lastVblankCycleEnd

--]]


--[[
 Exported :
    gameVersionName: Emerald | Ruby | Sapphire
    gameRevision: "" | 1.0 | 1.2
    getCurrentAdv() => currentAdvance
    getNextRandVal() => u16
    getCurrentRandValU32() => u32
    LCRNG(s, mul, sum) => new s
--]]

if not emu then
    console:log("Error: This script must be executed while a game is running.")
    return
end

local lang = emu:read8(0x80000AF)

if lang ~= 0x45 then -- not English
    console:log("Error: Only English games supported.")
    return
end

local gameVersionId = emu:read8(0x80000AE)

local gameVersionName = emu:read8(0x80000AE)
if gameVersionId == 0x56 then
    gameVersionName = "Ruby"
elseif gameVersionId == 0x50 then
    gameVersionName = "Sapphire"
elseif gameVersionId == 0x45 then
    gameVersionName = "Emerald"
else
    console:log("Error: Only Pokémon Ruby, Sapphire and Emerald are supported.")
    return
end

local gameRevision = ""

local getCurrentAdv
local getCurrentRandValU32

function LCRNG(s, mul, sum)
    local a = (mul >> 16) * (s % 0x10000) + (s >> 16) * (mul % 0x10000)
    local b = (mul % 0x10000) * (s % 0x10000) + (a % 0x10000) * 0x10000 + sum

    return b % 0x100000000
end

local getNextRandVal = function() 
    return LCRNG(getCurrentRandValU32() >> 16, 0x6073, 0x41c64e6d)
end

if gameVersionName == "Emerald" then
    gameRevision = "1.0"
    getCurrentAdv = function()
        return emu:read32(0x020249c0)
    end
    getCurrentRandValU32 = function()
        return emu:read32(0x03005d80)
    end
end


if gameVersionName == "Ruby" or gameVersionName == "Sapphire" then

    if emu:read16(0x08040068) == 46448 then
        gameRevision = "1.2"
    elseif emu:read16(0x08040068) == 512 then
        gameRevision = "1.0"
    else
        console:log("Error: Unable to determine the Pokémon Ruby/Sapphire version.")
    end

    local JUMP_DATA = {{0x41C64E6D, 0x6073}, {0xC2A29A69, 0xE97E7B6A}, {0xEE067F11, 0x31B0DDE4},
                       {0xCFDDDF21, 0x67DBB608}, {0x5F748241, 0xCBA72510}, {0x8B2E1481, 0x1D29AE20},
                       {0x76006901, 0xBA84EC40}, {0x1711D201, 0x79F01880}, {0xBE67A401, 0x8793100},
                       {0xDDDF4801, 0x6B566200}, {0x3FFE9001, 0x803CC400}, {0x90FD2001, 0xA6B98800},
                       {0x65FA4001, 0xE6731000}, {0xDBF48001, 0x30E62000}, {0xF7E90001, 0xF1CC4000},
                       {0xEFD20001, 0x23988000}, {0xDFA40001, 0x47310000}, {0xBF480001, 0x8E620000},
                       {0x7E900001, 0x1CC40000}, {0xFD200001, 0x39880000}, {0xFA400001, 0x73100000},
                       {0xF4800001, 0xE6200000}, {0xE9000001, 0xCC400000}, {0xD2000001, 0x98800000},
                       {0xA4000001, 0x31000000}, {0x48000001, 0x62000000}, {0x90000001, 0xC4000000},
                       {0x20000001, 0x88000000}, {0x40000001, 0x10000000}, {0x80000001, 0x20000000}, {0x1, 0x40000000},
                       {0x1, 0x80000000}}

    local timerAddr = 0x3001790
    local currentSeedAddr = 0x3004818

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

    getCurrentAdv = function()
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
end

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
        console:log("vblank") -- NO_PROD
    end, 0x80007dA)
end

if gameVersionName == "Ruby" or gameVersionName == "Sapphire" then
    -- VblankIntr start
    emu:setBreakpoint(function()
        lastVblankCycleStart = emu:currentCycle()
    end, 0x08000570)
end

-- Emerald

function caller_to_name(caller)
    local callerAddr = string.format("%04x", caller)
    local callerName = "???"
    if caller == 0x816fa85 then
        callerName = "SpriteCB_PlayerOnBicycle"
    elseif caller == 0x817758f then
        callerName = "SetRandomLotteryNumber"
    elseif caller == 0x80b57f9 then
        callerName = "GetLocalWildMon"
    elseif caller == 0x80b4acf then
        callerName = "ChooseWildMonIndex_Land"
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
        callerName = "ChooseWildMonLevel"
    elseif caller == 0x80b4e2f then
        callerName = "PickWildMonNature_forSynchronize"
    elseif caller == 0x80b4e51 then
        callerName = "PickWildMonNature_pickRandom"
    elseif caller == 0x8067eb5 then
        callerName = "CreateMonWithNature_pidlow"
    elseif caller == 0x8067ebb then
        callerName = "CreateMonWithNature_pidhigh"
    elseif caller == 0x8067dcd then
        callerName = "CreateBoxMon_ivs1"
    elseif caller == 0x8067e17 then
        callerName = "CreateBoxMon_ivs2"
    elseif caller == 0x81309d3 then
        callerName = "BattleAI_SetupAIData"
    elseif caller == 0x806ea81 then
        callerName = "SetWildMonHeldItem"
    elseif caller == 0x80b4ebd then
        callerName = "CreateWildMon_CuteCharmRandom"
    elseif caller == 0x80b4ec7 then
        callerName = "CreateWildMon_CuteCharm_modulo"

    elseif caller == 0x80b4ca1 then
        callerName = "ChooseWildMonLevel_levelRange"
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
    return callerName .. " " .. callerAddr
end


local cycleLastRandomCall = 0
local lastTotalModuloCycle = 0


if gameVersionName == "Emerald" then  
    -- Random()
    emu:setBreakpoint(function()
        local caller = emu:readRegister("r14")
        if caller == 0x80007bf then -- VBlankIntr
            return
        end
        if caller == 0x8038a3b then -- VBlankCB_Battle
            return 
        end

        local callerName = caller_to_name(caller)
        
        local currentAdvances = getCurrentAdv()

        local diffModulo = totalModuloCycle - lastTotalModuloCycle

        lastTotalModuloCycle = totalModuloCycle

        local diffCycle = emu:currentCycle() - cycleLastRandomCall - diffModulo
        cycleLastRandomCall = emu:currentCycle()

        local cycleAsStr = "" .. emu_currentCycleInFrame()
        while string.len(cycleAsStr) < 7 do 
            cycleAsStr = " " .. cycleAsStr
        end

        local frame = emu:currentFrame()
        
        local str = "AdvBef=" .. currentAdvances 
            .. ", Frame=" .. frame 
            .. ", Cycle=" .. cycleAsStr
            .. " (+" .. diffCycle .. " + " .. diffModulo .. " from modulo)"
            .. "RandomRetVal= " .. string.format("%04x", getNextRandVal())
            .. " : " .. callerName

        console:log(str)
    end, 0x0806f5cc)
end

if gameVersionName == "Ruby" or gameVersionName == "Sapphire" then
    if gameRevision ~= "1.2" then
        console:log("Error: Only Ruby/Sapphire 1.2 is supported")
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
            callerName = "CreateMonWithNature_pidlow" 
        elseif caller == 0x803ab07 then
            callerName = "CreateMonWithNature_pidhigh"     
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
            
            #1 sub_80BEB20: ~always
                if (FlagGet(FLAG_SYS_GAME_CLEAR))
                    and if has at least 1 pokenews slot empty

            #2 sub_80BE778: ~always
                if (FlagGet(FLAG_SYS_GAME_CLEAR))
                    and none of the 24 tv show is TVSHOW_MASS_OUTBREAK
                also calls another Random() if Random() <= 0x147

            #3 sub_80BE074: always
                called when not catching pokemon

            sub_80BF77C: never
                if caughtPoke > 0

            sub_80BE3BC:  never
                seems related with shop

            sub_80BEA88: never
                called on clock change (UpdateTVShowsPerDay)

        --]]
        
        local currentAdvances = getCurrentAdv()
        local frame = emu:currentFrame()
        local cycleAsStr = string.format("%-10s", emu_currentCycleInFrame())
        console:log("Adv=" .. currentAdvances .. ", Frame=" .. frame .. ", Cycle=" .. cycleAsStr .. " : " .. callerName .. " " .. callerAddr)
    end, 0x08040ea4)
end

local GameInfo = console:createBuffer("Advance")
GameInfo:setSize(100, 100)
callbacks:add("frame", function()
    local currentAdvances = getCurrentAdv()
    GameInfo:clear()
    if currentAdvances < 0 then
        GameInfo:print("Error: Unable to determine the current advance. Reset the game with Ctrl+R.")
    else 
        local frame = emu:currentFrame()
        GameInfo:print("Current advance: " .. currentAdvances .. "\nCurrent frame: " .. frame .. "\nNon-Vblank RNG update: " .. (currentAdvances - frame))
    end
end)


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
