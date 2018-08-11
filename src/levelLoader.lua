local TILE_NAMES = {}
TILE_NAMES['02550255'] = 'wall'

local collides = function (self, x, y, size)
  -- TODO move tile into a class
  -- FIXME assuming the player is the same size as the tile
  local entLeft = x
  local entRight = x + size
  local tileLeft = self.x * size
  local tileRight = tileLeft + size
  local entTop = y
  local entBottom = y + size
  local tileTop = self.y * size
  local tileBottom = tileTop + size

  return (entLeft < tileRight) and (entRight > tileLeft) and 
    (entTop < tileBottom) and (entBottom > tileTop)
end

local pixelToTile = function (pixel, x, y)
  local tile = {x = x, y = y, tile = 'empty'}

  if TILE_NAMES[pixel] then
    tile.tile = TILE_NAMES[pixel]
    tile.collides = collides
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
