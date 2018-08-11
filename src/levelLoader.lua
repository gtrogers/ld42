local TILE_NAMES = {}
TILE_NAMES['02550255'] = 'wall'

local pixelToTile = function (pixel, x, y)
  local tileName = 'empty'
  if TILE_NAMES[pixel] then
    tileName = TILE_NAMES[pixel]
  end
  return {
    x = x, y = y, tile = tileName
  }
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
