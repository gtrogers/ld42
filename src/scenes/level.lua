local player = require('src.player')
local levelLoader = require('src.levelLoader')

local update = function (self, dt, game)
  self.phaser = self.phaser + dt
  if self.phaser > 1 then self.phaser = 0 end
  for _, ent in ipairs(self.entities) do
    ent:update(dt, game)
  end
end

local draw = function (self, screen)
  local scale = screen.scale
  local width = screen.tall.width
  local height = screen.tall.height
  local xOffset = screen.tall.xOffset
  local yOffset = screen.tall.yOffset
  local phase = math.sin(math.pi * self.phaser)/3 + 0.66
  love.graphics.push()
  love.graphics.translate(xOffset, yOffset)
  
  -- tiles
  love.graphics.setColor(0, phase*255, phase*255, 255)
  
  for i, tile in ipairs(self.map) do
    if tile.tile ~= 'empty' then
      local x = tile.x
      local y = tile.y
      love.graphics.draw(
        self.wall,
        x * scale * 8,
        y * scale * 8,
        0,
        scale, scale)
    end
  end

  -- player
  love.graphics.setColor(255, 255, 255, 255)
  for _, ent in ipairs(self.entities) do
    ent:draw(screen)
  end
  love.graphics.pop()
end

return function ()
  local level = {}
  level.phaser = 0
  level.map = levelLoader('assets/levels/test.png')
  level.wall = love.graphics.newImage('assets/tiles/wall.png')
  level.wall:setFilter('nearest', 'nearest')
  level.entities = { player() }

  level.update = update
  level.draw = draw

  return level
end
