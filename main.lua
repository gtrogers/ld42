local sceneHandler = require('src.sceneHandler')
local level = require('src.scenes.level')

local GAME = {}

local setUpScreen = function ()
  local tileSize = 8
  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()
  print('Setting up window: ' .. screenWidth .. ' x ' .. screenHeight) 
  return {
    tileSize = 32,
    scale = 4,
    tall = {
      width=16, 
      height=22,
      xOffset=(screenWidth - 16*32)/2,
      yOffset=0
    }
  }
end

love.load = function ()
  GAME.scenes = sceneHandler()
  GAME.scenes:push(level())

  GAME.screen = setUpScreen()
end

love.update = function (dt)
  GAME.scenes:update(dt, GAME)
end

love.draw = function ()
  GAME.scenes:draw(GAME.screen)
  love.graphics.print(love.timer.getFPS())
end

love.keypressed = function (key)
  GAME.scenes:dispatch('keypressed', {key, GAME})
end
