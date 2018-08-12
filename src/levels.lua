local levels = {}

local level = function (path, difficulty, name, color, next, commMessage, openComm)
  return {
    path = path,
    difficulty = difficulty,
    name = name,
    color = color,
    next = next,
    commMessage = commMessage,
    openComm = openComm
  }
end

local CYAN   = {0, 255, 255}
local YELLOW = {255, 255, 0}
local RED    = {236, 51, 100}

-- Intro levels
levels[1] = level(
  'assets/levels/level_8.png', 1, 'Entrance', CYAN, 2,
  'Use the arrow keys to move.', true)
levels[2] = level('assets/levels/level_2.png', 1, 'Corridor', CYAN, 3)
levels[3] = level(
  'assets/levels/level_3.png', 1, 'Switches', CYAN, 4,
  'There must be a way to open those gates!'
  )
levels[4] = level('assets/levels/level_4.png', 1, 'Turrets', CYAN, 5)
levels[5] = level('assets/levels/level_5.png', 1, 'Keys', CYAN, 6)

-- Mid levels
levels[6] = level('assets/levels/level_6.png', 1, 'The drop', YELLOW, 7)
levels[7] = level('assets/levels/level_7.png', 1, 'The drop', YELLOW, 8)
levels[8] = level('assets/levels/level_8.png', 1, 'The drop', YELLOW, 1)

return levels
