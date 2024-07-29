local enemies = {}
local slime = require('enemies.slime')

function enemies:load()
  slime:new({ x = 300, y = 40 })
end

function enemies:update(dt)
  slime:update(dt)
end

function enemies:draw()
  slime:draw()
end

return enemies
