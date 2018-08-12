local level = require('src.scenes.level')

local draw = function (self, screen)
  local c1 = math.sin(math.pi * self.phaser) * 0.3 + 0.66
  local c2 = math.sin(math.pi * self.phaser * 2) * 0.3 + 0.66
  local c3 = math.sin(math.pi * self.phaser * 4) * 0.3 + 0.66
  love.graphics.setColor(255 * c1, 255 * c2, 255 * c3, 255)

  love.graphics.push()
  love.graphics.translate(screen.tall.xOffset, screen.tall.yOffset)
  love.graphics.printf(
    'TriSpace\n\n  [z] start\n[esc] exit', 0, 300, 16 * 32)
  
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.pop()
end

local update = function (self, dt)
  self.phaser = self.phaser + dt
  if self.phaser > 1 then self.phaser = 0 end
end

local keypressed = function (self, key, game)
  if key == 'z' then
    game.scenes:push(level())
  end
end

return function ()
  local scene = {}

  scene.phaser = 0
  scene.update = update
  scene.draw = draw
  scene.keypressed = keypressed

  return scene
end
