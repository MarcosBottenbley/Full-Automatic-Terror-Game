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

function Enemy:_init(x, y, v, sprite)
	Object._init(self, x, y, 20, 20, v, sprite)
end

function Enemy:draw()
	Object.draw(self,255,0,0)
end

function Enemy:update(dt, swidth, sheight)
	Object.update(self, dt, swidth, sheight)

	if self.x < 1 or self.x > swidth-self.width then
		self:bounce(1)
	end

	if self.y < 1 or self.y > sheight-self.height then
		self:bounce(0)
	end
end

function Enemy:bounce(side)
	if side == 1 then
		self.vx = -self.vx
	else
		self.vy = -self.vy
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