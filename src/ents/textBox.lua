local draw = function (self, screen, color)
  love.graphics.draw(
    self.sprite,
    self.x,
    self.y,
    0,
    screen.scale, screen.scale
  )

  local w = self.sprite:getWidth()
  local h = self.sprite:getHeight()
  
  love.graphics.printf(
    self.text,
    self.x + 32,
    self.y + 32,
    w * screen.scale - 64,
    'left')

  love.graphics.printf(
    '[c] to close',
    self.x, self.y + h*screen.scale - 32, w * screen.scale, 'center')
end

local update = function ()
end

return function (text)
  local textBox = {}
  textBox.text = text
  textBox.sprite = love.graphics.newImage('assets/textBox.png')
  textBox.sprite:setFilter('nearest', 'nearest')
  textBox.x = 0
  textBox.y = 2 * 32

  textBox.draw = draw
  textBox.update = update

  return textBox
end
