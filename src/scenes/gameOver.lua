return function ()
  local scene = {}

  scene.draw = function (screen)
    love.graphics.print('Game Over!')
  end

  scene.update = function ()
  end

  return scene
end
