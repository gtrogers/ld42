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
      scale, scale
    )
  end
end

local update = function (self, dt, game)
  self.x = self.x + dt*5
end

return function () 
  local leftEdge = {}
  leftEdge.x = -32
  leftEdge.sprite = love.graphics.newImage('assets/tiles/edge.png')
  leftEdge.sprite:setFilter('nearest', 'nearest')

  leftEdge.update = update
  leftEdge.draw = draw

  return leftEdge
end
