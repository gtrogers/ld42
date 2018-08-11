return function (title)
  local scene = {}

  scene.draw = function ()
    love.graphics.printf(
      title .. '\n\n[press z]', 0, 200, 1024, 'center')
  end

  scene.update = function ()
  end

  scene.keypressed = function (self, key, game)
    if key == 'z' then game.scenes:pop() end
  end

  return scene
end
