-- Emerald only

local mustPrintModulo = true

mustPrintModulo = false

-- TrySweetScentEncounter
emu:setBreakpoint(function()
  mustPrintModulo = true
end, 0x08159fec)

-- CreateBoxMon (2nd ivs)
emu:setBreakpoint(function()
  mustPrintModulo = false
end, 0x8067e17)

-- __umodsi3
emu:setBreakpoint(function()
  if (mustPrintModulo == false) then
    return
  end

  local dividend = emu:readRegister("r0")
  local divisor = emu:readRegister("r1")
  local caller = emu:readRegister("r14")
  console:log("[" .. dividend .. ", \"%u\", " .. divisor .. "],      caller=" .. caller)
end, 0x082e7be0)

-- __modsi3
emu:setBreakpoint(function()
  if (mustPrintModulo == false) then
    return
  end

  local dividend = emu:readRegister("r0")
  local divisor = emu:readRegister("r1")
  local caller = emu:readRegister("r14")
  console:log("[" .. dividend .. ", \"%s\",  " .. divisor .. "],      caller=" .. caller)
end, 0x082e7650)
