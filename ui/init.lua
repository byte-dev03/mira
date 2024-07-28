local ui = {}
local button = require("ui.button")

function ui:load()
  self.buttons = {
    pause = button:new(love.graphics.newImage("assets/ui/Pause_Button.png"), { x = 300, y = 10 } ),
  }
end

function ui:update()
  
end

function ui:draw()
  for _, btn in pairs(self.buttons) do
    btn:draw()
  end
end

return ui
