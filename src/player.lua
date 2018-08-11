local update = function (self, dt, game, scene)
  local dx = 0
  local dy = 0
  
  if love.keyboard.isDown('left') then dx = -1 end
  if love.keyboard.isDown('right') then dx = 1 end
  if love.keyboard.isDown('up') then dy = -1 end
  if love.keyboard.isDown('down') then dy = 1 end

  local mag2 = dx * dx + dy * dy
  
  if mag2 > 0 then
    -- TODO - subpixel movement
    local mag = math.sqrt(mag2)
    local newX = self.x + (dx/mag) * self.speed
    local newY = self.y + (dy/mag) * self.speed

    if scene:moveable(newX, newY, 32) then
      self.x = newX
      self.y = newY
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
end

return function ()
  local player = {}
  player.sprite = love.graphics.newImage('assets/ships/raven.png')
  player.sprite:setFilter('nearest', 'nearest')
  player.x = 200
  player.y = 400
  player.speed = 5

  player.update = update
  player.draw = draw
  player.keypressed = keypressed

  return player
end
