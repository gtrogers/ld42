return function ()
  local scene = {}

  scene.draw = function (self)
    love.graphics.print('Game Over!')
  end

  scene.update = function ()
  end

  return scene
end
