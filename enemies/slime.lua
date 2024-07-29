local anim8 = require('libs.anim8')

local sprite = {}

function sprite:draw()
  self.currentAnim:draw(self.spritesheet, self.pos.x, self.pos.y, 0, 2, 2)
end

function sprite:update(dt)
  self.currentAnim:update(dt)
end

function sprite:new(pos)
  self.pos = pos
  self.spritesheet = love.graphics.newImage("assets/Slime.png")

  self.grid = anim8.newGrid(32, 32, self.spritesheet:getWidth(), self.spritesheet:getHeight())

  self.idleAnim = {
    left = anim8.newAnimation(self.grid('1-4', 1), 0.1):flipH(),
    right = anim8.newAnimation(self.grid('1-4', 1), 0.1),
  }
  self.walkAnim = {
    left = anim8.newAnimation(self.grid('1-6', 2), 0.1):flipH(),
    right = anim8.newAnimation(self.grid('1-6', 2), 0.1),
  }

  self.currentAnim = self.idleAnim.right

  self.isMoving = false

  return self
end

return sprite
