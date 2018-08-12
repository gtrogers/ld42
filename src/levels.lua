local text = require('src.gameText')

local levels = {}

local level = function (path, difficulty, name, color, next, commMessage, openComm)
  return {
    path = path,
    difficulty = difficulty,
    name = name,
    color = color,
    next = next,
    commMessage = commMessage,
    openComm = openComm
  }
end

local CYAN   = {0, 255, 255}
local YELLOW = {255, 255, 0}
local RED    = {236, 51, 100}

levels[1] = level(
  'assets/stages/simple_corridor.png', 1, 'Level 1', CYAN, 2,
  text['intro'], true)

levels[2] = level(
  'assets/stages/opening.png', 3, 'Openings ...', CYAN, 3,
  text['danger'], true)

levels[3] = level(
  'assets/stages/engine_room.png', 1, '... to darkness', CYAN, 4,
  text['ship_switch'], true)

levels[4] = level(
  'assets/stages/nebula_room.png', 1, 'Engine room', CYAN, 5,
  text['warps'], false)
 
levels[5] = level(
  'assets/stages/tractor_puzzle_easy.png',
  1, 'Strange attractors', CYAN, 6,
  text['tractor'], true)

levels[6] = level(
  'assets/stages/tractor_puzzle_medium.png',
  1, 'Artifical gravity', CYAN, 7,
  text['speculation'], false)

levels[7] = level(
  'assets/stages/bullet_puzzle_easy.png',
  1, 'Cohesion-no-cohesion', CYAN, 8,
  text['lasers'], true)

levels[8] = level(
  'assets/stages/bullet_puzzle_medium.png',
  1, 'Gates', CYAN, 9,
  text['behind_you'], false)
  
levels[9] = level(
  'assets/stages/winder.png',
  1, 'Spirals', CYAN, 10)
 
levels[10] = level(
  'assets/stages/dash_puzzle_easy.png',
  1, 'Danger', CYAN, 11, text['beams'], true)

levels[11] = level(
  'assets/stages/dash_puzzle_medium.png',
  1, 'More danger', CYAN, 12, text['more_spec'], false)

levels[12] = level(
  'assets/stages/combi_puzzle_1.png',
  1, 'Combination lock', CYAN, 13)
  
levels[13] = level(
  'assets/stages/combi_puzzle_2.png',
  1, 'Permutations', CYAN, 14)
 
levels[14] = level(
  'assets/stages/dash_puzzle_medium.png',
  3, 'DANGER!', CYAN, 15)
 
levels[15] = level(
  'assets/stages/winder_2.png',
  1, 'Dodge and weave', CYAN, 16, text['understand'], false)

levels[16] = level(
  'assets/stages/patience.png',
  1, 'Patience', CYAN, 17)
 
levels[17] = level(
  'assets/stages/more_danger.png',
  4, 'MORE DANGER!', CYAN, 18)

levels[18] = level(
  'assets/stages/foundry.png',
  1, 'Foundry', CYAN, 19)

levels[19] = level(
  'assets/stages/forge.png',
  1, 'Forge', CYAN, 20)
 
levels[20] = level(
  'assets/stages/fire.png',
  1.5, 'Fire', CYAN, 21, text['revelation_1'], false)

levels[21] = level(
  'assets/stages/escape.png',
  1, 'Escape?', CYAN, 1, text['revelation_2'], false)
  
return levels
