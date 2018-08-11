local levels = {}

local level = function (path, difficulty, name, color, next)
  return {
    path = path,
    difficulty = difficulty,
    name = name,
    color = color,
    next = next
  }
end

local CYAN = {0, 255, 255}
local RED = {236, 51, 100}

levels[1] = level('assets/levels/level_4.png', 1, 'Entry Way', CYAN, 2)
levels[2] = level('assets/levels/level_2.png', 1, 'Corridor', CYAN, 3)
levels[3] = level('assets/levels/level_3.png', 1, 'Switch', CYAN, 4)
levels[4] = level('assets/levels/level_4.png', 1, 'Turret', RED, 1)

return levels
