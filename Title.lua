State = require("State")

local Title = {name = "FALLOUT 4"}
Title.__index = Title

setmetatable(Title, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Title:fadein()
	if self.time < 11 then
		local c = lerp(0, 255, self.time/11)
		return {c, c, c, 255}
	else
		return {255, 255, 255, 255}
	end
end
function Title:load()
	self.font = love.graphics.newFont("ka1.ttf", 94)
	self.width = self.font:getWidth(self.name)
	self.height = self.font:getHeight(self.name)
	self.sound = love.audio.newSource("sfx/crank_thxt.ogg")
end
function Title:update(dt)
	self.time = self.time + dt
	if self.time > 21 then
		switchTo(Game)
	end
end
function Title:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor(self:fadein())
	love.graphics.print(
		self.name,
		center(width, self.width), center(height, self.height)
	)
	love.graphics.setFont(love.graphics.newFont(10))
	love.graphics.setColor({255, 255, 255, 255})
	--love.graphics.print(love.timer.getFPS(), 10, 10)
	love.graphics.print(self.time, 10, 20)
end
function Title:keyreleased(key)
	switchTo(Game)
end
function Title:start()
	self.time = 0
	self.sound:play()
end
function Title:stop()
	self.sound:stop()
end

return Title