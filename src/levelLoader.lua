local tileTemplates = require('src/tileTemplates')

local TILE_NAMES = {}
TILE_NAMES['02550255'] = tileTemplates.WALL
TILE_NAMES['00255255'] = tileTemplates.DESTRUCTABLE
TILE_NAMES['2552550255'] = tileTemplates.WARP_LEFT
TILE_NAMES['0255255255'] = tileTemplates.WARP_RIGHT
TILE_NAMES['2550255255'] = tileTemplates.SWITCH
TILE_NAMES['255200255255'] = tileTemplates.SWITCHABLE
TILE_NAMES['25500255'] = tileTemplates.TURRET

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

  for i = 0, (width-1) do
    for j = 0, (height-1) do
      local r, g, b, a = data:getPixel(i, j)
      local pixel = table.concat{r, g, b, a}
      table.insert(levelMap, pixelToTile(pixel, i, j))
    end
  end

  return levelMap
end
