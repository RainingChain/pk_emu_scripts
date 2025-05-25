-- Emerald only

require"utils_calc_modulo.lua"
require"utils_caller_to_name.lua"

local mustPrintModulo = true

mustPrintModulo = false

local totalModuloCycle = 0

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
    .. "\"]"
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
    .. "\"]"
  )
end, 0x082e7650)
