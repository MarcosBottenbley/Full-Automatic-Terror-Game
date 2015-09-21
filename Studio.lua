State = require("State")

Studio.__index = Studio

setmetatable(Studio, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Studio:fadein()
	if self.time < 9.5 then
		local c = lerp(0, 255, self.time/9.5)
		return {c, c, c, 255}
	else
		return {255, 255, 255, 255}
	end
end

function Studio:load()
	self.width = self.font:getWidth(self.name)
	self.height = self.font:getHeight(self.name)
	self.logo = love.graphics.newImage("gfx/sss.png")
end

--- Center small inside large.
function center(large, small)
	return large/2 - small/2
end

function Studio:update(dt)
	self.time = self.time + dt
	if self.time > 19 then
		switchTo(Menu)
	end
end

function Studio:draw()
	love.draw(logo, 1, 1)
	-- love.draw(logo, center(width, logo:getWidth()), center(height, logo:getHeight()))
end

function Studio:keyreleased(key)
	if key == 'escape' then
		love.event.quit()
	else
		switchTo(Title)
	end
end

return Studio