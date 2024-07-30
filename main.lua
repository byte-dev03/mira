
function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  player = require("player")
  object = require("object")
  ui = require("ui")
  enemies = require('enemies')
  camera = require("libs/camera")
  cam = camera(0, 0, 1.5, 0)


  ui:load()

  player:load(300, 300)

  enemies:load()

  objects = { enemies.slime, player }

  table.insert(objects, object:new(
		"chest",
    {x=500, y=200},
    love.graphics.newImage("assets/Chest_Animated.png"),
    "1-5")
  )


end

function sortByDrawOrder(a, b)
	return a.pos.y < b.pos.y
end

function love.update(dt)

  ui:update()

	table.sort(objects, sortByDrawOrder)

  for _, obj in pairs(objects) do
		if obj.id == "player" then
			obj:update(dt)
		elseif obj.id == "enemy" then
			enemies:update(player, dt)
		else
			obj:update(player.pos, dt)
		end
  end


  cam:lookAt(player.pos.x, player.pos.y)
end

function love.draw()
  love.graphics.setBackgroundColor(love.math.colorFromBytes(100, 100, 100, 255))

  cam:attach()

    ui:draw()


    for _, obj in pairs(objects) do
      obj:draw()
    end


  cam:detach()
end
