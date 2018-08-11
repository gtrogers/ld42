local spawnBullet = function (self, x, y)
  if self.cooldown ~= 0 then return end
  table.insert(self.bullets, {x=x, y=y, t=0})
  self.cooldown = self.rechargeTime
end

local update = function (self, dt, game)
  if self.cooldown ~= 0 then
    self.cooldown = self.cooldown - dt
    if self.cooldown < 0 then self.cooldown = 0 end
  end
  for i, b in ipairs(self.bullets) do
    b.y = b.y - dt*self.speed
    b.t = b.t + dt
    if b.t > self.lifetime then
      table.remove(self.bullets, i)
    end
  end
end

local draw = function (self, screen)
  for i, b in ipairs(self.bullets) do
    love.graphics.draw(self.bullet, b.x, b.y, 0, screen.scale, screen.scale)
  end
end

return function ()
  local bullets = {}
  bullets.lifetime = 3
  bullets.speed = 100
  bullets.rechargeTime = 0.5
  bullets.cooldown = 0
  bullets.bullets = {}
  bullets.bullet = love.graphics.newImage('assets/ships/bullets.png')
  bullets.bullet:setFilter('nearest', 'nearest')

  bullets.update = update
  bullets.draw = draw
  bullets.spawnBullet = spawnBullet

  return bullets
end
