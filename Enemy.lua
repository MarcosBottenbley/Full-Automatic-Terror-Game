Object = require("Object")
math.randomseed(os.time())

local Enemy = {}
Enemy.__index = Enemy

setmetatable(Enemy, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Enemy:_init(x, y, w, h, v, sprite)
	Object._init(self, x, y, w, h, v)
	self.sprite = sprite
end

function Enemy:draw()
	if self.sprite ~= nil then
		love.graphics.draw(self.sprite, self.x, self.y)
	else
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		love.graphics.setColor(255,255,255,255)
	end
end

function Enemy:direction()
	if math.random(0,2) <= 1 then
		if math.random(0,2) >= 1 then
			self:bounce(0)
		else
			self:bounce(1)
		end
	end
end

return Enemy