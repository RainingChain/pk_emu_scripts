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
