local button = {}

function button:new(image, pos)
  self.image = image
  self.pos = pos
end

function button:draw()
  love.graphics.draw(self.image, self.pos.x, self.pos.y)
end

return button
