local pause = require('src.scenes.pause')

return function ()
  local testScene = {}
  local count = 0

  testScene.draw = function ()
    love.graphics.print('hello world! ' .. count)
  end

  testScene.update = function ()
    count = count + 1
  end

  testScene.keypressed = function (k, game)
    if k == 'escape' then game.scenes:push(pause()) end
  end

  return testScene
end
