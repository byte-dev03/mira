local button = {}


function button:draw()
  love.graphics.draw(self.image, self.pos.x, self.pos.y)
end

function button:new(image, pos)
  self.image = image
  self.pos = pos

  return self
end

return button
