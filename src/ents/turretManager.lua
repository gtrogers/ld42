local spawnBullet = function (self, x, y, direction)
  local k = '_' .. tostring(y)
  if self.cooldowns[k] == nil then self.cooldowns[k] = 0 end
  if self.cooldowns[k] ~= 0 then return end
  
  table.insert(self.bullets, {x=x, y=y, d=direction, t=0})
  self.cooldowns[k] = self.rechargeTime
end

local update = function (self, dt, game)
  for k, v in pairs(self.cooldowns) do
    self.cooldowns[k] = v - dt
    if self.cooldowns[k] < 0 then self.cooldowns[k] = 0 end
  end

  for i, b in ipairs(self.bullets) do
    b.x = b.x + dt * self.speed * b.d
    b.t = b.t + dt
    if b.t > self.lifetime then
      b.done = true
    end
  end

  for i, b in ipairs(self.bullets) do
    if b.done == true then table.remove(self.bullets, i) end
  end
end

local _collision = function (x1, y1, x2, y2)
  local dx = x2 - x1
  local dy = y2 - y1
  local mag2 = dx*dx + dy * dy
  return math.sqrt(mag2) < 16
end

local collisions = function (self, player)
  for _, b in ipairs(self.bullets) do
    if _collision(player.x, player.y, b.x, b.y) then
      player:explode()
    end
  end
end

local draw = function (self, screen, color, lEdge, rEdge)
  local scale = screen.scale
  love.graphics.setColor(color)
  for _, b in ipairs(self.bullets) do
    if b.x > lEdge and b.x < rEdge then
      love.graphics.draw(
        self.sprite,
        b.x,
        b.y,
        0,
        scale, scale,
        4, 4)
    end
  end
  love.graphics.setColor(255, 255, 255, 255)
end

return function ()
  local ent = {}

  ent.bullets = {}
  ent.sprite = love.graphics.newImage('assets/turretBullet.png')
  ent.sprite:setFilter('nearest', 'nearest')
  ent.lifetime = 6
  ent.speed = 70
  ent.cooldowns = {}
  ent.rechargeTime = 2

  ent.draw = draw
  ent.update = update
  ent.spawnBullet = spawnBullet
  ent.collisions = collisions

  return ent
end
