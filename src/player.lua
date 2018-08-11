local update = function (self)
  local dx = 0
  local dy = 0
  
  if love.keyboard.isDown('left') then dx = -1 end
  if love.keyboard.isDown('right') then dx = 1 end
  if love.keyboard.isDown('up') then dy = -1 end
  if love.keyboard.isDown('down') then dy = 1 end

  local mag2 = dx * dx + dy * dy
  
  if mag2 > 0 then
    local mag = math.sqrt(mag2)
    self.x = self.x + (dx/mag) * self.speed
    self.y = self.y + (dy/mag) * self.speed
  end
end

local draw = function (self, screen)
  love.graphics.rectangle('fill', self.x, self.y, screen.scale * 8, screen.scale * 8)
end

return function ()
  local player = {}
  player.x = 10
  player.y = 10
  player.speed = 10

  player.update = update
  player.draw = draw
  player.keypressed = keypressed

  return player
end
