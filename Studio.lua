State = require("State")

local Studio = {}
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
	self.logo = love.graphics.newImage("gfx/sss.png")
end

--- Center small inside large.
function center(large, small)
	return large/2 - small/2
end

function Studio:update(dt)
	self.time = self.time + dt
	if self.time > 3 then
		switchTo(Menu)
	end
end

function Studio:draw()
	love.graphics.draw(self.logo, 250, 210)
end

function Studio:keyreleased(key)
	if key == 'escape' then
		love.event.quit()
	else
		switchTo(Menu)
	end
end

function Studio:start()
	self.time = 0
end

function Studio:stop()

end

return Studio