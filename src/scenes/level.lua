local player = require('src.player')
local vertEdge = require('src.ents.vertEdge')
local levelLoader = require('src.levelLoader')
local pause = require('src.scenes.pause')
local bullets = require('src.ents.bullets')

local update = function (self, dt, game)
  self.phaser = self.phaser + dt
  if self.phaser > 1 then self.phaser = 0 end

  for _, ent in ipairs(self.entities) do
    ent:update(dt, game, self)
  end

  local playerX = self.player.x
  if playerX - 32 < self.leftEdge.x or playerX + 64 > self.rightEdge.x then
    self.player:explode()
  end

  self.bulletManager:collisions(self.map)
end

local moveable = function (self, x, y, w)
  local allowed = true
  for _, tile in ipairs(self.map) do
    if tile.solid and tile:collides(x, y, w) then
      allowed = false
      break
    end
  end

  return allowed
end

local keypressed = function (self, key, game)
  if key == 'escape' then game.scenes:push(pause()) end
  if key == 'z' then
    local player = self.player
    self.bulletManager:spawnBullet(player.x, player.y - 32)
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
  local lEdge = self.leftEdge.x
  local rEdge = self.rightEdge.x

  for i, tile in ipairs(self.map) do
    if tile.tile ~= 'empty' and tile.x*32 > lEdge and (tile.x + 1)*32 < rEdge then
      local x = tile.x
      local y = tile.y
      love.graphics.draw(
        tile.sprite,
        x * scale * 8,
        y * scale * 8,
        0,
        scale, scale)
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
  level.map = levelLoader('assets/levels/test.png')
  level.wall = love.graphics.newImage('assets/tiles/wall.png')
  level.destructable = love.graphics.newImage('assets/tiles/destructable.png')
  level.wall:setFilter('nearest', 'nearest')
  level.destructable:setFilter('nearest', 'nearest')
  
  level.player = player()
  level.leftEdge = vertEdge(1, -32)
  level.rightEdge = vertEdge(-1, 32*17)
  level.bulletManager = bullets()
  level.entities = {
    level.player,
    level.leftEdge,
    level.rightEdge,
    level.bulletManager
  }

  level.update = update
  level.draw = draw
  level.moveable = moveable
  level.keypressed = keypressed

  return level
end
