local player = require('src.player')

local update = function (self, dt, game)
  for _, ent in ipairs(self.entities) do
    ent:update(dt, game)
  end
end

local draw = function (self, dt, game)
  for _, ent in ipairs(self.entities) do
    ent:draw(dt, game)
  end
end

return function ()
  local level = {}
  level.entities = { player() }

  level.update = update
  level.draw = draw

  return level
end
