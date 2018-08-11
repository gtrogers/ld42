local player = require('src.player')
local vertEdge = require('src.ents.vertEdge')
local levelLoader = require('src.levelLoader')
local pause = require('src.scenes.pause')
local bullets = require('src.ents.bullets')
local between = require('src.scenes.between')
local levels = require('src.levels')

local START_X = (16*32) / 2 - 16
local START_Y = 650

local nextLevel = function (self, game)
  -- HACK - move the player from off of the warp point
  -- should really be preventing any events from firing
  -- during level transitions
  self.player.x = START_X
  self.player.y = START_Y
  
  local next = levels[self.level.next]
  game.scenes:push(between(next.name))
  self:reload(next)
end

local reload = function (self, level)
  self.phaser = 0

  if level == nil then level = levels[1] end

  self.level = level

  self.map = levelLoader(level.path)
  
  self.color = level.color
  self.player = player(START_X, START_Y)
  self.leftEdge = vertEdge(1, -32)
  self.rightEdge = vertEdge(-1, 32*17)
  self.bulletManager = bullets()
  self.entities = {
    self.player,
    self.leftEdge,
    self.rightEdge,
    self.bulletManager
  }

  self.done = false
end

local update = function (self, dt, game)
  self.phaser = self.phaser + dt
  if self.phaser > 1 then self.phaser = 0 end

  local playerX = self.player.x
  if playerX - 32 < self.leftEdge.x or playerX + 64 > self.rightEdge.x then
    self.player:explode()
  end

  for _, ent in ipairs(self.entities) do
    ent:update(dt, game, self)
  end

  local player = self.player
  for _, tile in ipairs(self.map) do
    if tile.onTouch and tile:collides(player.x, player.y, 32) then
      tile:onTouch(ent, self, game)
    end
  end

  self.bulletManager:collisions(self.map)
end

local moveable = function (self, x, y, w)
  local allowed = true
  for _, tile in ipairs(self.map) do
    if tile.solid and tile:collides(x - 16, y - 16, w) then
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
    self.bulletManager:spawnBullet(
      player.x,
      player.y - 32 * player.direction,
      player.direction
    )
  end
end

local _phaseify = function (n, color)
  local c = {}

  for _, v in ipairs(color) do
    local shift = math.sin(math.pi * n) * 0.2 + 0.66
    table.insert(c, v * shift)
  end
  table.insert(c, 255)

  return c
end

local draw = function (self, screen)
  local scale = screen.scale
  local width = screen.tall.width
  local height = screen.tall.height
  local xOffset = screen.tall.xOffset
  local yOffset = screen.tall.yOffset
  local color = _phaseify(self.phaser, self.color)

  love.graphics.push()
  love.graphics.translate(xOffset, yOffset)
  love.graphics.setColor(color)

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
    ent:draw(screen, color)
  end
  
  love.graphics.pop()

end

return function ()
  local level = {}

  reload(level)

  level.update = update
  level.draw = draw
  level.moveable = moveable
  level.keypressed = keypressed
  level.nextLevel = nextLevel
  level.reload = reload

  return level
end
