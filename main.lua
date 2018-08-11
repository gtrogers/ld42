local sceneHandler = require('src.sceneHandler')
local level = require('src.scenes.level')

local GAME = {}

love.load = function ()
  GAME.scenes = sceneHandler()
  GAME.scenes:push(level())

  GAME.screen = {scale = 4}
end

love.update = function ()
  GAME.scenes:update()
end

love.draw = function ()
  GAME.scenes:draw(GAME.screen)
end

love.keypressed = function (key)
  GAME.scenes:dispatch('keypressed', {key, GAME})
end
