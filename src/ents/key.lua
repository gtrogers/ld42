local draw = function (self, screen, color)
  if self.done then return end
  love.graphics.setColor(color)
  love.graphics.draw(
    self.sprite, self.x, self.y, 0,
    screen.scale, screen.scale)
  love.graphics.setColor(255, 255, 255, 255)
end

local _home = function (self)
  return self.homeX == self.x and self.homeY == self.y
end

local update = function (self, dt, game, scene)
  if self.done then return end
  if not self.tractored and not _home(self) then
    self.y = self.y + dt * self.fallSpeed
  end
end

return function (x, y)
  local ent = {}
  ent.is = 'key'
  ent.sprite = love.graphics.newImage('assets/ents/friend.png')
  ent.sprite:setFilter('nearest', 'nearest')
  ent.x = x
  ent.y = y
  ent.homeX = x
  ent.homeY = y
  ent.tractorable = true
  ent.tractored = false
  ent.fallSpeed = 15
  ent.done = false

  ent.draw = draw
  ent.update = update

  return ent
end
