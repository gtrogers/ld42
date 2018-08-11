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
    if self.explodeTime > 2 then game.scenes:push(gameOver()) end
    return
  end

  local dx = 0
  local dy = 0
  
  if love.keyboard.isDown('left') then dx = -1 end
  if love.keyboard.isDown('right') then dx = 1 end
  if love.keyboard.isDown('up') then dy = -1 end
  if love.keyboard.isDown('down') then dy = 1 end

  local mag2 = dx * dx + dy * dy
  
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
    self.sprite,
    self.x,
    self.y,
    0,
    screen.scale,
    screen.scale)

    if self.exploding then
      local r = 1 + (self.explodeTime / 2)*32
      love.graphics.circle('fill', self.x + 16, self.y + 16, r)
    end
end

return function ()
  local player = {}
  player.sprite = love.graphics.newImage('assets/ships/raven.png')
  player.sprite:setFilter('nearest', 'nearest')
  player.x = 200
  player.y = 400
  player.speed = 5
  player.exploding = false
  player.explodeTime = 0

  player.update = update
  player.draw = draw
  player.keypressed = keypressed
  player.explode = explode

  return player
end
