
--[[
 Exported :
    gameVersionName: Emerald | Ruby | Sapphire
    gameRevision: "" | 1.0 | 1.2
    getRngInfo() => currentAdvance
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

local getRngInfo

if gameVersionName == "Emerald" then
    gameRevision = "1.0"
    getRngInfo = function()
        return emu:read32(0x020249c0)
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

    getRngInfo = function()
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