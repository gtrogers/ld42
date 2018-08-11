local draw = function (self, screen)
  local height = screen.tall.height
  local tileSize = screen.tileSize
  local scale = screen.scale
  for i=0, height do
    love.graphics.draw(
      self.sprite,
      self.x,
      i * tileSize,
      0,
      scale * self.direction, scale
    )
  end
end

local update = function (self, dt, game)
  self.x = self.x + dt*5 * self.direction
end

return function (direction, x) 
  local vertEdge = {}
  vertEdge.x = x
  vertEdge.direction = direction
  vertEdge.sprite = love.graphics.newImage('assets/tiles/edge.png')
  vertEdge.sprite:setFilter('nearest', 'nearest')

  vertEdge.update = update
  vertEdge.draw = draw

  return vertEdge
end
