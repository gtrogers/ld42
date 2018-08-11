local dispatch = function (self, name, args)
  -- safeley call methods on scenes
  local method = self.scenes[#self.scenes][name]
  if method then
    method(unpack(args))
  else
    print('Missing method call: ' .. name)
  end
end

local push = function (self, scene)
  table.insert(self.scenes, scene)
end

local pop = function (self, scene)
  table.remove(self.scenes)
end

local draw = function (self, screen)
  self.scenes[#self.scenes]:draw(screen)
end

local update = function (self, dt, game)
  self.scenes[#self.scenes]:update(dt, game)
end

return function ()
  local sceneHandler = {}
  sceneHandler.scenes = {}

  sceneHandler.push = push
  sceneHandler.pop = pop
  sceneHandler.draw = draw
  sceneHandler.update = update
  sceneHandler.dispatch = dispatch

  return sceneHandler
end
