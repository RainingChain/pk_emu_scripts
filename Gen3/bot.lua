
local AUTO_LOAD_SAVE = true


local GBA_KEY_A = 1
local GBA_KEY_B = 2
local GBA_KEY_SELECT = 4
local GBA_KEY_START = 8
local GBA_KEY_RIGHT = 16
local GBA_KEY_LEFT = 32
local GBA_KEY_UP = 64
local GBA_KEY_DOWN = 128
local GBA_KEY_R = 256
local GBA_KEY_L = 512

local KEYS_BY_FRAME = {}

local atFrame = 0

function press(fr, keys)
  for i = 1, 3 do
    KEYS_BY_FRAME[fr + i - 1] = keys
  end
end

function press_a(fr)
  press(fr,GBA_KEY_A)
end

function press_s(fr)
  press(fr,GBA_KEY_START)
end

function press_d(fr)
  press(fr,GBA_KEY_DOWN)
end

function press_u(fr)
  press(fr,GBA_KEY_UP)
end

function press_l(fr)
  press(fr,GBA_KEY_LEFT)
end

function press_r(fr)
  press(fr,GBA_KEY_RIGHT)
end

local repeatCount = 0
function initKeyByFrame()
  KEYS_BY_FRAME = {}
  atFrame = 0

  atFrame = 150
  press_s(atFrame)
  atFrame = atFrame + 100
  press_s(atFrame)
  atFrame = atFrame + 150
  press_a(atFrame)
  atFrame = atFrame + 150
  press_a(atFrame)
  atFrame = atFrame + 150
  press_a(atFrame)
  atFrame = atFrame + 350 + (repeatCount * 10)
  press_s(atFrame)
  atFrame = atFrame + 50
  press_d(atFrame)
  atFrame = atFrame + 50
  press_a(atFrame)
  atFrame = atFrame + 100
  press_a(atFrame)
  atFrame = atFrame + 50
  press_d(atFrame)
  atFrame = atFrame + 50
  press_a(atFrame)
  atFrame = atFrame + 50

end


callbacks:add("frame", function()
  local frame = emu:currentFrame();
  if (frame == 1) then 
    initKeyByFrame()
    return
  end

  local keysToPress = KEYS_BY_FRAME[frame]
  if (keysToPress ~= nil) then
    emu:addKeys(keysToPress)
  elseif (frame < atFrame) then
    emu:clearKeys(0xffff)
  end
end)


local lastVblankCycleStart = 0
local lastVblankCycleEnd = 0

function emu_currentCycleInFrame()
  return emu:currentCycle() - lastVblankCycleStart
end


-- SweetScentWildEncounter
emu:setBreakpoint(function()
  local vblankDur = lastVblankCycleEnd - lastVblankCycleStart 
  console:log("SweetScentWildEncounter: " .. (emu_currentCycleInFrame() - vblankDur) ..  " (" .. emu_currentCycleInFrame() .. " - " .. vblankDur .. ")")
  if (AUTO_LOAD_SAVE) then
    repeatCount = repeatCount + 1
    emu:reset()
  end
end, 0x80b5578)

-- VblankIntr start
emu:setBreakpoint(function()
  lastVblankCycleStart = emu:currentCycle()
end, 0x08000738)

-- VblankIntr end
emu:setBreakpoint(function()
  lastVblankCycleEnd = emu:currentCycle()
  console:log("" .. (lastVblankCycleEnd - lastVblankCycleStart))
end, 0x80007dA)
