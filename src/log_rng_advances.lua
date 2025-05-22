--[[
Purpose: Print every call to Random(), excluding VBlankIntr and battle loop sub_800FCFC

Version: v1.0

Credits: RainingChain, Real96

License: GNU General Public License v3.0
--]] 

require"rse_header.lua"

local lastVblankCycle = 0
local vblankStart = nil

function emu_currentCycleInFrame()
  return emu:currentCycle() - lastVblankCycle
end

if gameVersionName == "Emerald" then    
    -- VblankIntr start
    emu:setBreakpoint(function()
        lastVblankCycle = emu:currentCycle()
    end, 0x08000738)

    emu:setBreakpoint(function()
        local caller = emu:readRegister("r14")
        if caller == 0x80007bf then -- VBlankIntr
            return
        end
        if caller == 0x8038a3b then -- VBlankCB_Battle
            return 
        end

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
            callerName = "PickWildMonNature_v1"
        elseif caller == 0x80b4e51 then
            callerName = "PickWildMonNature_v2"
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

        --[[
        elseif caller == 0x then
            callerName = ""
        elseif caller == 0x then
            callerName = ""
        elseif caller == 0x then
            callerName = ""

        --]]
        end
        
        local currentAdvances = getRngInfo()
        local cycleAsStr = "" .. emu_currentCycleInFrame()
        while string.len(cycleAsStr) < 7 do 
            cycleAsStr = " " .. cycleAsStr
        end

        local frame = emu:currentFrame()
        console:log("Adv=" .. currentAdvances .. ", Frame=" .. frame .. ", Cycle=" .. cycleAsStr .. " : " .. callerName .. " " .. callerAddr)
    end, 0x0806f5cc)
end

if gameVersionName == "Ruby" or gameVersionName == "Sapphire" then
    if gameRevision ~= "1.2" then
        console:log("Error: Only Ruby/Sapphire 1.2 is supported")
    end

    -- VblankIntr start
    emu:setBreakpoint(function()
        lastVblankCycle = emu:currentCycle()
    end, 0x08000570)

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
        
        local currentAdvances = getRngInfo()
        local frame = emu:currentFrame()
        local cycleAsStr = string.format("%-10s", emu_currentCycleInFrame())
        console:log("Adv=" .. currentAdvances .. ", Frame=" .. frame .. ", Cycle=" .. cycleAsStr .. " : " .. callerName .. " " .. callerAddr)
    end, 0x08040ea4)
end

local GameInfo = console:createBuffer("Advance")
GameInfo:setSize(100, 100)
callbacks:add("frame", function()
    local currentAdvances = getRngInfo()
    GameInfo:clear()
    if currentAdvances < 0 then
        GameInfo:print("Error: Unable to determine the current advance. Reset the game with Ctrl+R.")
    else 
        local frame = emu:currentFrame()
        GameInfo:print("Current advance: " .. currentAdvances .. "\nCurrent frame: " .. frame .. "\nNon-Vblank RNG update: " .. (currentAdvances - frame))
    end
end)
