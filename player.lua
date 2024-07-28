local anim8 = require('libs.anim8')
local utils = require("utils")

local player = {}

local function normalize(v)
  local magnitude = math.sqrt(v.x * v.x + v.y * v.y)

  if magnitude == 0 then
    return { x = 0, y = 0 }
  end

  return {
    x = v.x / magnitude,
    y = v.y / magnitude,
  }
end

function player:load(x,y)
  self.vel = { x = 0, y = 0 }
  self.pos = { x = x, y = y }
  self.speed = 200

  self.spritesheet = love.graphics.newImage("assets/Player.png")

  self.grid = anim8.newGrid(32, 32, self.spritesheet:getWidth(), self.spritesheet:getHeight())
  self.idleAnim = {
    down = anim8.newAnimation(self.grid('1-6', 1), 0.1),
    right = anim8.newAnimation(self.grid('1-6', 2), 0.1),
    left = anim8.newAnimation(self.grid('1-6', 2), 0.1):flipH(),
    up = anim8.newAnimation(self.grid('1-6', 3), 0.1)
  }

  self.runAnim = {
    down = anim8.newAnimation(self.grid('1-6', 4), 0.1),
    right = anim8.newAnimation(self.grid('1-6', 5), 0.1),
    left = anim8.newAnimation(self.grid('1-6', 5), 0.1):flipH(),
    up = anim8.newAnimation(self.grid('1-6', 6), 0.1)
  }

  self.attackAnim = {
    down = anim8.newAnimation(self.grid('1-4', 7), 0.1),
    right = anim8.newAnimation(self.grid('1-4', 8), 0.1),
    left = anim8.newAnimation(self.grid('1-4', 8), 0.1):flipH(),
    up = anim8.newAnimation(self.grid('1-4', 9), 0.1)
  }

  self.currentAnim = self.idleAnim.down

  self.isMoving = false
  self.direction = "down"
end

function player:update(dt)
  local moveX, moveY = 0, 0

  if love.keyboard.isDown('a') then
    moveX = -1
    self.isMoving = true
    self.direction = "left"
  elseif love.keyboard.isDown('d') then
    moveX = 1
    self.isMoving = true
    self.direction = "right"
  end

  if love.keyboard.isDown('w') then
    moveY = -1
    self.direction = "up"
    self.isMoving = true
  elseif love.keyboard.isDown('s') then
    moveY = 1
    self.direction = "down"
    self.isMoving = true
  end

  self.vel = normalize({ x = moveX, y = moveY })
  self.vel.x = self.vel.x * self.speed
  self.vel.y = self.vel.y * self.speed

  if self.vel.x ~= 0 or self.vel.y ~= 0 then
    self.isMoving = true
  else
    self.isMoving = false
  end

  self.pos.x = self.pos.x + self.vel.x * dt
  self.pos.y = self.pos.y + self.vel.y * dt

  if love.mouse.isDown(1) then
    self.attacked = true
  else
    self.attacked = false
  end

  if not self.isMoving then
    if self.direction == "left" then
      self.currentAnim = self.idleAnim.left
    elseif self.direction == "right" then
      self.currentAnim = self.idleAnim.right
    elseif self.direction == "up" then
      self.currentAnim = self.idleAnim.up
    else
      self.currentAnim = self.idleAnim.down
    end
  else
    if self.direction == "left" then
      self.currentAnim = self.runAnim.left
    elseif self.direction == "right" then
      self.currentAnim = self.runAnim.right
    elseif self.direction == "up" then
      self.currentAnim = self.runAnim.up
    else
      self.currentAnim = self.runAnim.down
    end
  end

  if self.attacked then
    if self.direction == "left" then
      self.currentAnim = self.attackAnim.left
    elseif self.direction == "right" then
      self.currentAnim = self.attackAnim.right
    elseif self.direction == "up" then
      self.currentAnim = self.attackAnim.up
    else
      self.currentAnim = self.attackAnim.down
    end
  end

  self.currentAnim:update(dt)
end

function player:draw()
  self.currentAnim:draw(self.spritesheet, self.pos.x, self.pos.y, 0, 2, 2)
end

return player
