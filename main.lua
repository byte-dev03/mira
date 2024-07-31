
local player = require("player")
local object = require("object")
local ui = require("ui")
local enemies = require('enemies')
local camera = require("libs/camera")
local cam = camera(0, 0, 1.5, 0)
local objects = {}

local objs_pos = {}

local function orderY(a, b)
	return a.y < b.y
end

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  ui:load()

  player:load(300, 300)

  enemies:load()

	objs_pos[1] = player.pos
	objs_pos[2] = enemies.slime.pos


  table.insert(objects, object:new(
		"chest",
    {x=500, y=200},
    love.graphics.newImage("assets/Chest_Animated.png"),
    "1-5")
  )
	objs_pos[3] = objects[1].pos


end


function love.update(dt)

  ui:update()

  table.sort(objs_pos, orderY)

  for _, obj in pairs(objects) do
		obj:update(player.pos, dt)
  end
	player:update(dt, objects)
	enemies:update(player, dt)

  cam:lookAt(player.pos.x, player.pos.y)
end

function love.draw()
  love.graphics.setBackgroundColor(love.math.colorFromBytes(100, 100, 100, 255))

  cam:attach()

  -- Create a table to store all objects to be drawn
  local objectsToDraw = {}

  -- Add player to the table
  table.insert(objectsToDraw, player)

  -- Add enemies to the table
  table.insert(objectsToDraw, enemies.slime)

  -- Add objects to the table
  for _, obj in pairs(objects) do
    table.insert(objectsToDraw, obj)
  end

  -- Sort the table by y-position
  table.sort(objectsToDraw, function(a, b) return a.pos.y < b.pos.y end)

  -- Draw all objects in the sorted order
  for _, obj in pairs(objectsToDraw) do
    obj:draw()
  end

  -- Draw UI on top of everything
  ui:draw()

  cam:detach()
end
