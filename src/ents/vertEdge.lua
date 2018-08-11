local draw = function (self, screen, color)
  local height = screen.tall.height
  local tileSize = screen.tileSize
  local scale = screen.scale

  love.graphics.setColor(color)

  for i=0, height do
    love.graphics.draw(
      self.sprite,
      self.x,
      i * tileSize,
      0,
      scale * self.direction, scale
    )
  end

  love.graphics.setColor(255, 255, 255, 255)
end

local update = function (self, dt, game)
  self.x = self.x + dt*self.speed * self.direction
end

return function (direction, x, speed) 
  local vertEdge = {}
  vertEdge.speed = speed
  vertEdge.x = x
  vertEdge.direction = direction
  vertEdge.sprite = love.graphics.newImage('assets/tiles/edge.png')
  vertEdge.sprite:setFilter('nearest', 'nearest')

  vertEdge.update = update
  vertEdge.draw = draw

  return vertEdge
end
