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
  local font = love.graphics.newFont('assets/PressStart2P-Regular.ttf', 16)
  font:setFilter('nearest', 'nearest')
  love.graphics.setFont(font)

  local music = love.audio.newSource('assets/musak/running_out_of_space.compat.it')
  music:setLooping(true)
  music:setVolume(0.8)
  music:play()
  GAME.music = music
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
