local enemies = {}
local slime = require('enemies.slime')

function enemies:load()
  self.slime = slime:new({ x = 300, y = 40 })
end

function enemies:update(player, dt)
  self.slime:update(player, dt)
end

function enemies:draw()
  self.slime:draw()
end

return enemies
