--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

State = require("State")

local Title = {name = "WORKING TITLE"}
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
	if self.time < 3 then
		local c = lerp(0, 255, self.time/3)
		return {c, c, c, 255}
	else
		return {255, 255, 255, 255}
	end
end

function Title:load()
	self.font = love.graphics.newFont("ka1.ttf", 74)
	self.width = self.font:getWidth(self.name)
	self.height = self.font:getHeight(self.name)
	self.sound = love.audio.newSource("sfx/crank_thxt.ogg")
end

function Title:update(dt)
	self.time = self.time + dt
	if self.time > 8 then
		switchTo(Menu)
	end
end

function Title:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor(self:fadein())
	love.graphics.print(
		self.name,
		center(width, self.width), center(height, self.height)
	)
end

function Title:keyreleased(key)
	if key == 'escape' then
		love.event.quit()
	else
		switchTo(Menu)
	end
end

function Title:keypressed(key)
end

function Title:start()
	self.time = 0
	self.sound:play()
end

function Title:stop()
	self.sound:stop()
end

return Title