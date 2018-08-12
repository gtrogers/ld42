local draw = function (self, screen)
  local c1 = math.sin(math.pi * self.phaser) * 0.3 + 0.66
  local c2 = math.sin(math.pi * self.phaser * 2) * 0.3 + 0.66
  local c3 = math.sin(math.pi * self.phaser * 4) * 0.3 + 0.66
  love.graphics.setColor(255 * c1, 255 * c2, 255 * c3, 255)

  love.graphics.push()
  love.graphics.translate(screen.tall.xOffset, screen.tall.yOffset)
  love.graphics.printf(self.text, 0, 100, 32 * 16, 'center')
  
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.pop()
end

local update = function (self, dt)
  self.phaser = self.phaser + dt
  if self.phaser > 1 then self.phaser = 0 end
end

return function ()
  local scene = {}

  local text = {
    'You Win',
    'Thanks for playing!',
    '',
    '',
    'Credits',
    'Code, art and music - G T Rogers',
    '',
    'Special Thanks',
    'sagamusix.de - for awesome tracker samples',
    'CodeMan38 - for the font (GoogleFonts)',
    'Tulara <3',
    '',
    'Press [esc] to exit.'
  }

  scene.text = table.concat(text, '\n')
  scene.draw = draw
  scene.update = update
  scene.phaser = 0

  scene.keypressed = function (self, key, game)
    if key == 'escape' then love.event.push('quit') end
  end

  return scene
end
