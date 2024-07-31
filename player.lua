local anim8 = require('libs.anim8')
local enemies = require('enemies')

local player = {}

-- Normalize a vector
local function normalize(v)
  local magnitude = math.sqrt(v.x^2 + v.y^2)
  if magnitude == 0 then
    return { x = 0, y = 0 }
  end
  return { x = v.x / magnitude, y = v.y / magnitude }
end

-- Set the current animation based on movement and action
local function setAnimation(self)
  if self.attacked then
    self.currentAnim = self.attackAnim[self.direction]
  elseif self.isMoving then
    self.currentAnim = self.runAnim[self.direction]
  else
    self.currentAnim = self.idleAnim[self.direction]
  end
end

-- Check for collision between two bounding boxes
local function checkCollision(bb1, bb2)
  return bb1.x < bb2.x + bb2.width and
         bb1.x + bb1.width > bb2.x and
         bb1.y < bb2.y + bb2.height and
         bb1.y + bb1.height > bb2.y
end

-- Initialize player instance
function player:load(x, y)
  self.pos = { x = x, y = y }
  self.vel = { x = 0, y = 0 }
  self.speed = 200
  self.health = 100
  self.id = "player"

  self.spritesheet = love.graphics.newImage("assets/Player.png")
  self.width = self.spritesheet:getWidth()
  self.height = self.spritesheet:getHeight()

  self.grid = anim8.newGrid(32, 32, self.width, self.height)
  self.idleAnim = self:createAnimations(self.grid, '1-6', 1)
  self.runAnim = self:createAnimations(self.grid, '1-6', 4)
  self.attackAnim = self:createAnimations(self.grid, '1-4', 7)

  self.currentAnim = self.idleAnim.down
  self.isMoving = false
  self.direction = "down"
end

-- Create animations for idle, run, and attack
function player:createAnimations(grid, frames, startRow)
  return {
    down = anim8.newAnimation(grid(frames, startRow), 0.1),
    right = anim8.newAnimation(grid(frames, startRow + 1), 0.1),
    left = anim8.newAnimation(grid(frames, startRow + 1), 0.1):flipH(),
    up = anim8.newAnimation(grid(frames, startRow + 2), 0.1)
  }
end

-- Update player state
function player:update(dt, objects)
  self:handleMovement(dt)
  self:handleActions()
  self:checkCollisions(objects)
  self.currentAnim:update(dt)
end

-- Handle player movement
function player:handleMovement(dt)
  local moveX, moveY = 0, 0

  if love.keyboard.isDown('a') then
    moveX = -1
    self.direction = "left"
  elseif love.keyboard.isDown('d') then
    moveX = 1
    self.direction = "right"
  end

  if love.keyboard.isDown('w') then
    moveY = -1
    self.direction = "up"
  elseif love.keyboard.isDown('s') then
    moveY = 1
    self.direction = "down"
  end

  self.isMoving = moveX ~= 0 or moveY ~= 0
  self.vel = normalize({ x = moveX, y = moveY })
  self.vel.x = self.vel.x * self.speed
  self.vel.y = self.vel.y * self.speed

  self.pos.x = self.pos.x + self.vel.x * dt
  self.pos.y = self.pos.y + self.vel.y * dt
end

-- Handle player actions like attack
function player:handleActions()
  self.attacked = love.mouse.isDown(1)
  setAnimation(self)
end

-- Check for collisions with objects and enemies
function player:checkCollisions(objects)
  local playerBB = self:getBoundingBox()

  -- Check collisions with objects
  for _, obj in pairs(objects) do
    local objBB = obj:getBoundingBox()
    if checkCollision(playerBB, objBB) then
      print("Collision with object!")
    end
  end

  -- Check collisions with enemies
  local enemyBB = enemies.slime:getBoundingBox()
  if checkCollision(playerBB, enemyBB) then
    print("Collision with enemy!")
  end
end

-- Get player bounding box
function player:getBoundingBox()
  return {
    x = self.pos.x - self.width / 2,
    y = self.pos.y - self.height / 2,
    width = self.width,
    height = self.height
  }
end

-- Draw the player
function player:draw()
  self.currentAnim:draw(self.spritesheet, self.pos.x, self.pos.y, 0, 2, 2, 16, 16)
  love.graphics.circle("line", self.pos.x, self.pos.y + 10, 5)
end

return player

