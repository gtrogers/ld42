local templates = {}

local reify = function (self, x, y)
  local tile = {
    tile = self.tile.id,
    onHit = self.tile.onHit,
    collides = self.tile.collides,
    sprite = self.tile.sprite,
    onTouch = self.tile.onTouch,
    solid = self.tile.solid,
    x = x,
    y = y
  }
  
  return tile
end

local template = function (img, id, onHit, collider, solid, onTouch)
  local template = {}

  if img then img:setFilter('nearest', 'nearest') end
  
  template.tile = {
    onHit=onHit,
    collides=collider,
    sprite=img,
    id=id,
    solid=solid,
    onTouch = onTouch,
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
  scene:nextLevel(game)
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

templates.EMPTY = template(nil, 'empty')

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
  nil,
  collider,
  true,
  nil
)

return templates
