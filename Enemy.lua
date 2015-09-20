Object = require("Object")
math.randomseed(os.time())

local Enemy = {
	img = "gfx/enemy_sheet.png",
	width = 56, height = 56
}
Enemy.__index = Enemy

setmetatable(Enemy, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Enemy:_init(x, y, v)
	Object._init(self, x, y, v, self.img, self.width, self.height, 5, 1, 0.08)
end

function Enemy:draw()
	Object.draw(self,255,0,0)
end

function Enemy:update(dt, swidth, sheight)
	Object.update(self, dt)

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