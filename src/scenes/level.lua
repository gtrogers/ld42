local player = require('src.player')

local update = function (self, dt, game)
  self.phaser = self.phaser + dt
  if self.phaser > 1 then self.phaser = 0 end
  for _, ent in ipairs(self.entities) do
    ent:update(dt, game)
  end
end

local draw = function (self, screen)
  local width = screen.tall.width
  local height = screen.tall.height
  local xOffset = screen.tall.xOffset
  local yOffset = screen.tall.yOffset
  local phase = math.sin(math.pi * self.phaser)/3 + 0.66
  love.graphics.push()
  love.graphics.translate(xOffset, yOffset)
  love.graphics.setColor(0, phase*255, phase*255, 255)
  for i=0, width do
    for j=0, height do
      if i == 0 or i == width then
        love.graphics.draw(
          self.wall,
          i * 8 * screen.scale,
          j * 8 * screen.scale,
          0,
          screen.scale,
          screen.scale
        )
      end
    end
  end
  love.graphics.setColor(255, 255, 255, 255)
  for _, ent in ipairs(self.entities) do
    ent:draw(screen)
  end
  love.graphics.pop()
end

return function ()
  local level = {}
  level.phaser = 0
  level.wall = love.graphics.newImage('assets/tiles/wall.png')
  level.wall:setFilter('nearest', 'nearest')
  level.entities = { player() }

  level.update = update
  level.draw = draw

  return level
end
