local anim8 = require('libs.anim8')

local slime = {}

local baseDamage = 4
local healInterval = 2 -- time in seconds between healing ticks
local textDisplayTime = 0.5

function slime:getBoundingBox()
  return {
    x = self.pos.x - self.spritesheet:getWidth() / 2,
    y = self.pos.y - self.spritesheet:getHeight() / 2,
    width = self.spritesheet:getWidth(),
    height = self.spritesheet:getHeight()
  }
end

function slime:draw()
	if self.textTimer > 0 then
		if self.isDamaged then
			love.graphics.setColor(1, 0, 0)
		 love.graphics.print("-"..baseDamage, self.pos.x+10, self.pos.y+10)
		elseif self.health < 100 then
			love.graphics.setColor(0, 1, 0)
			love.graphics.print("+"..baseDamage, self.pos.x+10, self.pos.y+10)
		end
	end
	love.graphics.setColor(1,1,1)

  self.currentAnim:draw(self.spritesheet, self.pos.x, self.pos.y, 0, 2, 2)
end

function slime:update(player, dt)
  local distance =  math.floor(math.sqrt(math.pow(player.pos.x-self.pos.x, 2) + math.pow(player.pos.y+10-self.pos.y, 2)))
	if player.attacked and distance <= 100 then
    if not self.isDamaged then
      self.health = self.health - baseDamage
      if self.health < 0 then
        self.health = 0
      end
      self.isDamaged = true
      self.textTimer = textDisplayTime
    end
	else
		self.isDamaged = false
		self.healTimer = self.healTimer + dt
		if self.health < 100 and self.healTimer >= healInterval then
			self.health = self.health + baseDamage
			self.healTimer = 0
			self.textTimer = textDisplayTime
		end
	end
	if self.textTimer > 0 then
		self.textTimer = self.textTimer - dt -- decrease the text display timer
	end
  print(self.health)

  self.currentAnim:update(dt)
end

function slime:new(pos)
  self.pos = pos
  self.spritesheet = love.graphics.newImage("assets/Slime.png")
	self.id = "enemy"

	self.health = 100
	self.healTimer = 0
	self.isDamaged = false

	self.textTimer = 0

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

return slime
