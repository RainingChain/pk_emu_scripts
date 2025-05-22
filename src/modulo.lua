-- Emerald only

local mustPrintModulo = false

function createFormattedJsonStruct()
  local s = {}
  s.currentSection_modulo = {}
  return s
end

local jsonStruct = createFormattedJsonStruct()

-- ChooseWildMonIndex_Land
emu:setBreakpoint(function()
  mustPrintModulo = true
end, 0x080b4ac8)

-- CreateMonWithNature
emu:setBreakpoint(function()
  mustPrintModulo = false

  local str = ""

  for k, v in pairs(jsonStruct.currentSection_modulo) do
    str = str .. k .. "," .. v .. "\n"
  end
  console:log("" .. str)
  jsonStruct.currentSection_modulo = {}

end, 0x08067e90)

 
--0x08067bbc CreateBoxMon

function resetAll()
  mustPrintModulo = false

  jsonStruct = createFormattedJsonStruct()
end

-- __umodsi3
emu:setBreakpoint(function()
  if (mustPrintModulo == false) then
    return
  end

  local dividend = emu:readRegister("r0")
  local divisor = emu:readRegister("r1")
  local caller = emu:readRegister("r14")
  local str = "" .. dividend .. " %u " .. divisor .. " caller=" .. caller;
  --printLog(str)

  if (jsonStruct.currentSection_modulo[str]) then
    jsonStruct.currentSection_modulo[str] = jsonStruct.currentSection_modulo[str] + 1
  else
    jsonStruct.currentSection_modulo[str] = 1
  end

end, 0x082e7be0)