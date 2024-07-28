local player = require("player")
local object = require("object")

local objects = {}

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  player:load(300, 300)

  table.insert(objects, object:new(
    {x=500, y=200},
    love.graphics.newImage("assets/Chest_Animated.png"), 
    "1-5")
  )
end

function love.update(dt)

  player:update(dt)

  for _, obj in pairs(objects) do
    obj:update(player.pos, dt)
  end

end

function love.draw()
  love.graphics.setBackgroundColor(love.math.colorFromBytes(100, 100, 100, 255))

  for _, obj in pairs(objects) do
    obj:draw()
  end

  player:draw()

end
