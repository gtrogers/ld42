local _tractor = function (player, ent, self)
  ent.tractored = false
  local dx = player.x - ent.x
  local dy = player.y - ent.y
  local mag2 = dx*dx + dy*dy
  local mag = math.sqrt(mag2)
  if mag > self.maxRange or mag < self.minRange then return end

  ent.tractored = true
  local ux = dx / mag
  local uy = dy / mag

  ent.x = ent.x + ux
  ent.y = ent.y + uy
end

local update = function (self, dt, game, scene)
  self.x = scene.player.x
  self.y = scene.player.y

  if love.keyboard.isDown('z') and scene.player.ship == 'eagle' then
    self.active = true
  else
    self.active = false
    for _, ent in ipairs(scene.entities) do
      ent.tractored = false
    end
  end

  if self.active then
    for _, ent in ipairs(scene.entities) do
      if ent.tractorable then _tractor(scene.player, ent, self) end
    end
  end
end

local draw = function (self, screen)
  if self.active then
    love.graphics.draw(
        self.sprite,
        self.x, self.y, 0,
        screen.scale, screen.scale,
        8, 8
    )
  end
end

return function ()
  local ent = {}

  ent.sprite = love.graphics.newImage('assets/ents/tractor_field.png')
  ent.sprite:setFilter('nearest', 'nearest')
  ent.maxRange = 128
  ent.minRange = 32
  ent.update = update
  ent.draw = draw
  ent.x = 0
  ent.y = 0

  return ent
end
