local player = require('src.player')
local vertEdge = require('src.ents.vertEdge')
local levelLoader = require('src.levelLoader')
local pause = require('src.scenes.pause')
local bullets = require('src.ents.bullets')
local between = require('src.scenes.between')
local levels = require('src.levels')
local turretManager = require('src.ents.turretManager')
local textBox = require('src.ents.textBox')
local tractorBeam = require('src.ents.tractorBeam')

local START_X = (16*32) / 2 - 16
local START_Y = 650

local nextLevel = function (self, game)
  -- HACK - move the player from off of the warp point
  -- should really be preventing any events from firing
  -- during level transitions
  self.player.x = START_X
  self.player.y = START_Y
  
  local next = levels[self.level.next]
  local nextLevelIndex = self.level.next
  game.scenes:push(between(next.name))
  self:reload(next, self.player, nextLevelIndex)
end

local _saveProgress = function (levelIndex)
  local saveTemplate = 'return ' .. levelIndex
  love.filesystem.write('trispace.sav', saveTemplate)
end

local reload = function (self, level, prevPlayer, levelIndex)
  self.phaser = 0

  if level == nil then level = levels[1] end

  self.level = level

  local levelData = levelLoader(level.path)
  self.map = levelData.map
  
  self.color = level.color
  self.player = player(START_X, START_Y)
  -- FIXME add a set ship method
  if prevPlayer then self.player.ship = prevPlayer.ship end
  if prevPlayer then self.player.shipIndex = prevPlayer.shipIndex end
  self.leftEdge = vertEdge(1, -32, level.difficulty * 10)
  self.rightEdge = vertEdge(-1, 32*17, level.difficulty * 10)
  self.bulletManager = bullets()
  self.turretManager = turretManager()
  self.tractorBeam = tractorBeam()
  self.entities = {
    self.player,
    self.leftEdge,
    self.rightEdge,
    self.bulletManager,
    self.turretManager,
    self.tractorBeam
  }

  for _, ent in ipairs(levelData.ents) do
    table.insert(self.entities, ent)
  end

  if level.commMessage then
    self.commAvailable:play()
  end

  if level.openComm then
    self.textBox = textBox(level.commMessage)
  end

  for _, ent in ipairs(self.entities) do
    if ent.reset then ent:reset() end
  end

  if levelIndex then _saveProgress(levelIndex) end
end

local restart = function (self, game)
  game.scenes:push(between(self.level.name))
  reload(self, self.level, self.player)
end

local update = function (self, dt, game)
  self.phaser = self.phaser + dt
  if self.phaser > 1 then self.phaser = 0 end

  if self.textBox then return end

  local playerX = self.player.x
  local edgeCollisionGrace = 15
  if playerX < self.leftEdge.x + 32 + edgeCollisionGrace
    or playerX > self.rightEdge.x - 32 - edgeCollisionGrace then
    self.player:explode()
  end

  for _, ent in ipairs(self.entities) do
    ent:update(dt, game, self)
  end

  local player = self.player
  for _, tile in ipairs(self.map) do
    for _, ent in ipairs(self.entities) do
      if tile.onTouch and ent.is and tile:collides(ent.x, ent.y, 32) then
        -- HACK assuming ents must have an is field
        -- to collide with a tile
        tile:onTouch(ent, self, game)
      end
    end
    if tile.onTick then
      tile:onTick(dt, self)
    end
  end

  self.bulletManager:collisions(self.map)
  self.turretManager:collisions(self.player)
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
  -- FIXME coupling of player and level
  if key == 'z' then
    if self.player.ship == 'raven' then
      local player = self.player
      self.bulletManager:spawnBullet(
        player.x,
        player.y - 32 * player.direction,
        player.direction
      )
    end
    if self.player.ship == 'gull' then
      self.player:dash(self)
    end
  end
  if key == 'c' then
    if self.textBox then
      self.commSound:play()
      self.textBox = nil
    else
      if self.level.commMessage then
        self.commSound:play()
        self.textBox = textBox(self.level.commMessage)
      end
    end
  end
  if key == 'x' then
    self.player:switchShip()
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
    if tile.sprite and tile.x*32 > lEdge and (tile.x + 1)*32 < rEdge then
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
    ent:draw(screen, color, lEdge + 32, rEdge - 32, self.phaser)
  end
  
  if self.textBox then self.textBox:draw(screen, color) end
  if self.level.commMessage and not self.textBox then
    love.graphics.printf('Incoming message\npress [c]', -200, 650, 200, 'right')
  end
  love.graphics.printf(
    'Power:\n' .. self.player:getPowerName(),
    16*32, 650, 200, 'left')

  love.graphics.pop()
end

return function (levelIndex)
  local level = {}

  level.textBox = nil
  level.commSound = love.audio.newSource('assets/sfx/open_comm.wav')
  level.commAvailable = love.audio.newSource('assets/sfx/message.wav')

  if not levelIndex then
    reload(level)
  else
    reload(level, levels[levelIndex])
  end

  level.update = update
  level.draw = draw
  level.moveable = moveable
  level.keypressed = keypressed
  level.nextLevel = nextLevel
  level.reload = reload
  level.restart = restart

  return level
end
