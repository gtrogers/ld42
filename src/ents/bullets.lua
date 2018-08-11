local spawnBullet = function (self, x, y, d)
  if self.cooldown ~= 0 then return end
  self.sound:play()
  table.insert(self.bullets, {x=x, y=y, d=d, t=0})
  self.cooldown = self.rechargeTime
end

local update = function (self, dt, game)
  if self.cooldown ~= 0 then
    self.cooldown = self.cooldown - dt
    if self.cooldown < 0 then self.cooldown = 0 end
  end
  for i, b in ipairs(self.bullets) do
    b.y = b.y - dt*self.speed*b.d
    b.t = b.t + dt
    if b.t > self.lifetime then
      table.remove(self.bullets, i)
    end
  end
end

local draw = function (self, screen)
  for i, b in ipairs(self.bullets) do
    love.graphics.draw(
      self.bullet,
      b.x,
      b.y,
      0,
      screen.scale, screen.scale,
      4, 4)
  end
end

local collisions = function (self, map)
  for i, bullet in ipairs(self.bullets) do
    for j, tile in ipairs(map) do
      if tile.onHit and tile:collides(bullet.x - 16, bullet.y - 16, 32) then
        tile:onHit(map)
        table.remove(self.bullets, i)
      end
    end
  end
end

return function ()
  local bullets = {}
  bullets.lifetime = 3
  bullets.speed = 350
  bullets.rechargeTime = 0.1
  bullets.cooldown = 0
  bullets.bullets = {}
  bullets.bullet = love.graphics.newImage('assets/ships/bullets.png')
  bullets.bullet:setFilter('nearest', 'nearest')
  bullets.sound = love.audio.newSource('assets/sfx/laser.wav')

  bullets.update = update
  bullets.draw = draw
  bullets.spawnBullet = spawnBullet
  bullets.collisions = collisions

  return bullets
end
