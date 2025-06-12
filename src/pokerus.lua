--[[
Purpose: Help obtaining Pokérus in Pokémon Ruby, Sapphire and Emerald.

Version: v1.0

Credits: RainingChain, Real96

License: GNU General Public License v3.0
--]] 

require"utils_rse_header.lua"

function printMessage(currentAdv, targetAdv, rngVal)
    console:log("-------------------------------------------------")
    console:log("Pokérus-related code was triggered!:")
    console:log("  RNG advance when Pokérus code was triggered: " .. (currentAdv - 1))
    console:log("  RNG advance needed to obtain Pokérus: " .. targetAdv)

    local diff = targetAdv - currentAdv

    if diff == 0 then
        console:log("Congratulations! One of your Pokémon now has Pokérus!")
        return
    end

    if diff > 0 then
        console:log("  Advance difference: +" .. diff)
    else
        console:log("  Advance difference: " .. diff)
    end

    if diff % 2 ~= 0 then
        console:log("")
        console:log("Warning: The current battle can't be used to obtain Pokérus. Start another battle.")
    elseif diff > 0 then
        console:log("")
        console:log("Reload a savestate during the battle and press A " .. diff .. " advances later.")
        console:log(
            "  Ex: If the Current advance you wrote down is XXXXX: reload your savestate, press Ctrl+N until Current advance displays (XXXXX + " ..
                diff .. "), then press A + Ctrl+P.")
    else
        console:log("")
        console:log("Reload a savestate during the battle and press A " .. (-diff) .. " advances earlier.")
    end
end

local GameInfo = console:createBuffer("Pokérus")
GameInfo:setSize(100, 100)

if gameVersionName == "Emerald" then
    console:log("Pokémon Emerald detected")
    emu:setBreakpoint(function()
        printMessage(emu:read32(0x020249c0), 66611)
    end, 0x806dcbe)

    callbacks:add("frame", function()
        GameInfo:clear()
        GameInfo:print("Current advance: " .. emu:read32(0x020249c0) .. "\n" .. "Target advance for Pokérus: 66611")
    end)
end

if gameVersionName == "Ruby" or gameVersionName == "Sapphire" then
    -- https://raw.githubusercontent.com/pret/pokeruby/refs/heads/symbols/pokesapphire_rev2.sym
    -- RandomlyGivePartyPokerus
    local POKERUS_FUNC_ADDRS = {
        0x08040068, -- Ruby Rev1, Ruby Rev2, Sapphire Rev1, Sapphire Rev2,
        0x08040048 -- Ruby, Sapphire
    }
    local pokerusFuncAddr = POKERUS_FUNC_ADDRS[1]
    if gameRevision == "1.2" then
        console:log("Pokémon Ruby/Sapphire v1.1 or v1.2 detected")
    elseif gameRevision == "1.0" == 512 then
        console:log("Pokémon Ruby/Sapphire v1.0 detected")
        pokerusFuncAddr = POKERUS_FUNC_ADDRS[2]
    else
        console:log("Error: Unable to determine the Pokémon Ruby/Sapphire version.")
    end

    emu:setBreakpoint(function()
        local currentAdvances = getCurrentAdv()
        printMessage(currentAdvances, 26923)

        -- console:log("    r0=" .. string.format("%04x", emu:readRegister("r0")))
        -- console:log("    r5=" .. string.format("%04x", emu:readRegister("r5")))
    end, pokerusFuncAddr + 0x10)

    emu:setBreakpoint(function()
        local currentAdvances = getCurrentAdv()
        console:log("atkE5_pickup triggered. RNG Adv = " .. currentAdvances .. ". RNG Val = " ..
                        emu:read32(currentSeedAddr))

        -- console:log("    r0=" .. string.format("%04x", emu:readRegister("r0")))
        -- console:log("    r5=" .. string.format("%04x", emu:readRegister("r5")))
    end, 0x0802af68)

    callbacks:add("frame", function()
        local currentAdvances = getCurrentAdv()
        GameInfo:clear()
        if currentAdvances < 0 then
            GameInfo:print("Error: Unable to determine the current advance. Reset the game with Ctrl+R.")
        else
            GameInfo:print("Current advance: " .. currentAdvances .. "\n" .. "Target advance for Pokérus: 26924")
        end
    end)
end

console:log("Pokérus helper script was activated.")
console:log("")
console:log("Guide:")
console:log("  - Restart the game with Ctrl+R.")
console:log("  - Start a Pokémon battle and attack the wild Pokémon until it faints")
console:log("  - Make a savestate on the message \"XXX gained YY EXP.Points.\"")
console:log("  - Pause the game with Ctrl+P.")
console:log("  - Write down the Current advance, which is displayed on the panel above.")
console:log("  - Press A with the game paused, and while holding A, unpause the game with Ctrl+P.")
console:log("  - A message from the script will be displayed with additional steps.")
console:log(
    "  - If no message is displayed after the battle, it's possibly an issue with mGBA. Try closing and opening mGBA again.")
