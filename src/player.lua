local gameOver = require('src.scenes.gameOver')

local explode = function (self, screen)
  if self.exploding then return end
  local explode = love.audio.newSource('assets/sfx/explosion.wav')
  explode:play()
  self.exploding = true
end

local update = function (self, dt, game, scene)
  if self.exploding then
    self.explodeTime = self.explodeTime + dt
    if self.explodeTime > 2 then scene:restart(game) end
    return
  end

  local dx = 0
  local dy = 0
  
  if love.keyboard.isDown('left') then dx = -1 end
  if love.keyboard.isDown('right') then dx = 1 end
  if love.keyboard.isDown('up') then dy = -1 end
  if love.keyboard.isDown('down') then dy = 1 end

  local mag2 = dx * dx + dy * dy
  
  if dy > 0 and self.direction > 0 then
    self.direction = -1
  end

  if dy < 0 and self.direction < 0 then
    self.direction = 1
  end

  if mag2 > 0 then
    local mag = math.sqrt(mag2)
    local unitX = dx/mag
    local unitY = dy/mag
    local moved = 0
    local blocked = false

    while moved < self.speed and not blocked do
      local newX = self.x + unitX
      local newY = self.y + unitY

      if scene:moveable(newX, newY, 32) then
        self.x = newX
        self.y = newY
        moved = moved + mag
      else
        blocked = true
      end
    end
  end
end

local draw = function (self, screen)
  love.graphics.draw(
    self.sprites[self.ship],
    self.x,
    self.y,
    0,
    screen.scale,
    screen.scale * self.direction,
    4, 4)

    if self.exploding then
      local r = 1 + (self.explodeTime / 2)*32
      love.graphics.circle('fill', self.x + 16, self.y + 16, r)
    end
end

local switchShip = function (self)
  if self.ship == 'raven' then
    self.ship = 'eagle'
  else
    self.ship = 'raven'
  end
end

return function (x, y)
  local player = {}
  
  local spriteEagle = love.graphics.newImage('assets/ships/eagle.png')
  local spriteRaven = love.graphics.newImage('assets/ships/raven.png')
  spriteEagle:setFilter('nearest', 'nearest')
  spriteRaven:setFilter('nearest', 'nearest')
  
  player.sprites = {eagle=spriteEagle, raven=spriteRaven}
  player.ship = 'eagle'
  player.x = x
  player.y = y
  player.speed = 5
  player.exploding = false
  player.explodeTime = 0
  player.direction = 1

  player.update = update
  player.draw = draw
  player.keypressed = keypressed
  player.explode = explode
  player.switchShip = switchShip

  return player
end
