return function ()
  local pause = {}

  pause.draw = function ()
    love.graphics.print('paused - press ESC to unpause')
  end

  pause.update = function ()
  end

  pause.keypressed = function (self, key, game)
    if key == 'escape' then game.scenes:pop() end
  end

  return pause
end
