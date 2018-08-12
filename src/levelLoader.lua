local tileTemplates = require('src/tileTemplates')
local key = require('src/ents/key')

local TILE_NAMES = {}
TILE_NAMES['02550255'] = tileTemplates.WALL
TILE_NAMES['00255255'] = tileTemplates.DESTRUCTABLE
TILE_NAMES['2552550255'] = tileTemplates.WARP_LEFT
TILE_NAMES['0255255255'] = tileTemplates.WARP_RIGHT
TILE_NAMES['2550255255'] = tileTemplates.SWITCH
TILE_NAMES['255200255255'] = tileTemplates.SWITCHABLE
TILE_NAMES['25500255'] = tileTemplates.TURRET
TILE_NAMES['128128128255'] = tileTemplates.DECOR
TILE_NAMES['0128255255'] = tileTemplates.KEY_HINT
TILE_NAMES['0255128255'] = tileTemplates.RECEPTOR
TILE_NAMES['128255255255'] = tileTemplates.KEYABLE

local pixelToTile = function (pixel, x, y)
  local tile = nil
  local template = TILE_NAMES[pixel]
  if template then
    tile = template:reify(x, y)
  else
    tile = tileTemplates.EMPTY:reify(x, y)
  end
  return tile
end

return function (levelPath)
  local img = love.graphics.newImage(levelPath)
  local data = img:getData()
  local width = img:getWidth()
  local height = img:getHeight()

  local levelMap = {}
  levelMap.map = {}
  levelMap.ents = {}

  for i = 0, (width-1) do
    for j = 0, (height-1) do
      local r, g, b, a = data:getPixel(i, j)
      local pixel = table.concat{r, g, b, a}
      local t = pixelToTile(pixel, i, j)
      table.insert(levelMap.map, t)
      if t.tile == 'keyHint' then
        table.insert(levelMap.ents, key(t.x * 32, t.y * 32))
      end
    end
  end

  return levelMap
end
