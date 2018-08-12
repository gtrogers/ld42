return function ()
  local pause = {}

  pause.draw = function (self, screen)
    love.graphics.push()
    love.graphics.translate(screen.tall.xOffset, screen.tall.yOffset)
    love.graphics.printf(
      'Paused\n\n[esc] unpause\n  [q] exit',
      0, 200, 32*16)
    love.graphics.pop()
  end

  pause.update = function ()
  end

  pause.keypressed = function (self, key, game)
    if key == 'escape' then game.scenes:pop() end
    if key == 'q' then love.event.push('quit') end
  end

  return pause
end
