
local anim8 = require('libs.anim8')

local object = {}

function object:getDistance(other)
end

function object:update(player_pos, dt)
  local distance =  math.sqrt(math.pow(player_pos.x-self.pos.x, 2) + math.pow(player_pos.y-self.pos.y, 2))

  if math.floor(distance) <= 50 then
    self.nearPlayer = true
  else
    self.nearPlayer = false
  end


  if self.nearPlayer then
    self.currentAnim:pauseAtEnd()
  else
    self.currentAnim:gotoFrame(1)
  end
  self.currentAnim:update(dt)
end

function object:draw()
  self.currentAnim:draw(self.spritesheet, self.pos.x, self.pos.y, 0, 2, 2)
end

function object:new(pos, spritesheet, frames)
  self.pos = pos

  self.spritesheet = spritesheet

  self.grid = anim8.newGrid(16, 16, self.spritesheet:getWidth(), self.spritesheet:getHeight())
  self.currentAnim  = anim8.newAnimation(self.grid(frames, 1), 0.1)


  self.nearPlayer = false

  return object
end


return object
