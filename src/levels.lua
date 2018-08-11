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

local CYAN = {0, 255, 255}
local RED = {236, 51, 100}

levels[1] = level(
  'assets/levels/level_1.png', 1, 'Entry Way', CYAN, 2,
  'Use the arrow keys to move.', true)
levels[2] = level('assets/levels/level_2.png', 1, 'Corridor', CYAN, 3)
levels[3] = level(
  'assets/levels/level_3.png', 1, 'Switch', CYAN, 4,
  'There must be a way to open those gates!'
  )
levels[4] = level('assets/levels/level_4.png', 1, 'Turret', CYAN, 1)

return levels
