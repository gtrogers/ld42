local templates = {}
  if prevPlayer then self.player.ship = prevPlayer.ship end

local reify = function (self, x, y)
  local tile = {
    tile = self.tile.id,
    onHit = self.tile.onHit,
    collides = self.tile.collides,
    sprite = self.tile.sprite,
    onTouch = self.tile.onTouch,
    solid = self.tile.solid,
    onTick = self.tile.onTick,
    x = x,
    y = y
  }
  
  return tile
end

local template = function (
  img,
  id,
  onHit,
  collider,
  solid,
  onTouch,
  onTick)
  
  local template = {}

  if img then img:setFilter('nearest', 'nearest') end
  
  template.tile = {
    onHit=onHit,
    collides=collider,
    sprite=img,
    id=id,
    solid=solid,
    onTouch = onTouch,
    onTick = onTick
  }

  template.reify = reify
  return template
end

local consumeBullet = function (self)
  -- no op
  -- TODO play nice plink sound
end

local switch_on = love.graphics.newImage('assets/tiles/switch_on.png')
local ding = love.audio.newSource('assets/sfx/ding.wav')
switch_on:setFilter('nearest', 'nearest')

local switch = function (self, map)
  local sound = false
  for _, m in ipairs(map) do
    if m.tile == 'switch_off' then
      sound = true
      m.sprite = switch_on
      m.tile = 'switch_on'
    end
    if m.tile == 'switchable' then
      m.tile = 'empty'
      m.onHit = nil
      m.collides = nil
      m.sprite = nil
      m.solid = false
    end
  end

  if sound then ding:play() end
end

local destructable = function (self)
  local explosion = love.audio.newSource('assets/sfx/small_explosion.wav')
  explosion:play()
  self.tile = 'empty'
  self.onHit = nil
  self.collides = nil
  self.sprite = nil
  self.solid = false
end

local nextLevel = function (self, ent, scene, game)
  if ent.is == 'player' then scene:nextLevel(game) end
end

local collider = function (self, x, y, size)
  -- FIXME assuming the colliding ent is the same size as the tile
  local entLeft = x + 1
  local entRight = x + (size-2)
  local tileLeft = self.x * size
  local tileRight = tileLeft + size
  local entTop = y + 1
  local entBottom = y + size - 2
  local tileTop = self.y * size
  local tileBottom = tileTop + size

  return (entLeft < tileRight) and (entRight > tileLeft) and 
    (entTop < tileBottom) and (entBottom > tileTop)
end

local zapCollider = function (self, x, y, size)
  local tileTop = self.y * size + 4
  local tileBottom = (self.y + 1 ) * size - 4
  local tileLeft = self.x * size
  local tileRight = (self.x + 1) * size

  local entTop = y - 16
  local entBottom = y + size - 16
  local entLeft = x
  local entRight = x + size

  return (entLeft < tileRight) and (entRight > tileLeft)
    and (entTop < tileBottom) and (entBottom > tileTop)
end

local activated = love.graphics.newImage('assets/tiles/receptor_on.png')
activated:setFilter('nearest', 'nearest')
local receptor = function (self, ent, scene, game)
  if ent.is == 'key' then
    ent.done = true
    self.sprite = activated
    for _, m in ipairs(scene.map) do
      if m.tile == 'keyable' then
        m.tile = 'empty'
        m.onHit = nil
        m.collides = nil
        m.sprite = nil
        m.solid = false
      end
    end
  end
end

templates.EMPTY = template(nil, 'empty')
templates.DECOR = template(
  love.graphics.newImage('assets/tiles/decor.png'), 'empty')

templates.RECEPTOR = template(
  love.graphics.newImage('assets/tiles/receptor.png'),
  'receptor',
  consumeBullet,
  collider,
  false,
  receptor)

templates.KEY_HINT = template(nil, 'keyHint')

templates.WALL = template(
  love.graphics.newImage('assets/tiles/wall.png'),
  'wall', consumeBullet, collider, true)

templates.DESTRUCTABLE = template(
  love.graphics.newImage('assets/tiles/destructable.png'),  
  'destructable', destructable, collider, true)

templates.WARP_LEFT = template(
  love.graphics.newImage('assets/tiles/warp_left.png'),
  'warp',
  consumeBullet,
  collider,
  false,
  nextLevel
)

templates.WARP_RIGHT = template(
  love.graphics.newImage('assets/tiles/warp_right.png'),
  'warp',
  consumeBullet,
  collider,
  false,
  nextLevel
)

templates.SWITCH = template(
  love.graphics.newImage('assets/tiles/switch_off.png'),
  'switch_off',
  switch,
  collider,
  false,
  nil
)

templates.SWITCHABLE = template(
  love.graphics.newImage('assets/tiles/switchable.png'),
  'switchable',
  consumeBullet,
  collider,
  true,
  nil
)

templates.KEYABLE = template(
  love.graphics.newImage('assets/tiles/switchable.png'),
  'keyable',
  consumeBullet,
  collider,
  true,
  nil
)

local shoot = function (self, dt, scene)
  scene.turretManager:spawnBullet(self.x * 32 + 16, self.y * 32 + 16, 1)
end

templates.TURRET = template(
  love.graphics.newImage('assets/tiles/turret.png'),
  'turret',
  nil,
  collider,
  true,
  nil,
  shoot
)

local zapSound = love.audio.newSource('assets/sfx/big_laser.wav')
local zap = function (self, ent, scene, game)
  if ent.is == 'player' then
    if ent.exploding == false then zapSound:play() end
    ent:explode()
  end
end

templates.ZAP = template(
  love.graphics.newImage('assets/tiles/zap.png'),
  'zap',
  nil,
  zapCollider,
  false,
  zap
)

return templates
