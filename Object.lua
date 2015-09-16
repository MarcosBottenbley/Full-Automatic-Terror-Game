math.randomseed(os.time())

local Object= {
	x = 10, y = 10,
	vx = 50, vy = 50,
	width = 10, height = 10
}
Object.__index = Object

setmetatable(Object, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Object:_init(x, y, w, h, v)
	self.x = x
	self.y = y
	self.vx = v
	self.vy = v
	self.width = w
	self.height = h
end

function Object:update(dt, swidth, sheight)
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

	if self.x < 1 or self.x > swidth-self.width then
		self:bounce(1)
	end

	if self.y < 1 or self.y > sheight-self.height then
		self:bounce(0)
	end
end

function Object:bounce(side)
	if side == 1 then
		self.vx = -self.vx
	else
		self.vy = -self.vy
	end
end

function Object:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Object