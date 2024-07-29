

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  player = require("player")
  object = require("object")
  ui = require("ui")
  enemies = require('enemies')
  camera = require("libs/camera")
  cam = camera(0, 0, 1.5, 0)

  objects = {}

  ui:load()

  player:load(300, 300)

  enemies:load()

  table.insert(objects, object:new(
    {x=500, y=200},
    love.graphics.newImage("assets/Chest_Animated.png"), 
    "1-5")
  )

end

function love.update(dt)

  ui:update()

  player:update(dt)

  for _, obj in pairs(objects) do
    obj:update(player.pos, dt)
  end

  enemies:update(dt)

  cam:lookAt(player.pos.x, player.pos.y)
end

function love.draw()
  love.graphics.setBackgroundColor(love.math.colorFromBytes(100, 100, 100, 255))

  cam:attach()

    ui:draw()


    for _, obj in pairs(objects) do
      obj:draw()
    end

    enemies:draw()
    player:draw()

  cam:detach()
end
