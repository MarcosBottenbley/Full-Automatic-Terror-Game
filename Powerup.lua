--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Object = require("Object")

local Powerup = {
	width = 40, height = 40,
	vx = 10, vy = 10,
	bounding_rad = 20,
	id = 5, collided = false
}
Powerup.__index = Powerup

setmetatable(Powerup, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Powerup:_init(x, y, v)
	self.vx = v
	self.vy = v
	self.collided = false
	Object._init(self, x, y, self.img, self.width, self.height, self.frames, self.states, self.delay)

	self.validCollisions = {2}
end

function Powerup:draw()
	Object.draw(self,255,255,255)
end

function Powerup:update(dt, swidth, sheight)
	Object.update(self, dt)

	if self.x < 1 then
		self.vx = math.abs(self.vx)
	end

	if self.x > swidth-self.width then
		self.vx = -1 * math.abs(self.vx)
	end

	if self.y < 1 then
		self.vy = math.abs(self.vy)
	end

	if self.y > sheight-self.height then
		self.vy = -1 * math.abs(self.vy)
	end
end

function Powerup:bounce(side)
	if side == 1 then
		self.vx = -self.vx
	else
		self.vy = -self.vy
	end
end

function Powerup:direction()
	if math.random(0,2) <= 1 then
		if math.random(0,2) >= 1 then
			self:bounce(0)
		else
			self:bounce(1)
		end
	end
end

function Powerup:setPosition(x, y)
	self.x = x
	self.y = y
end

function Powerup:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

function Powerup:getType()
	return self.type
end

function Powerup:getValid(...)
	local table = {2}
	return table
end

function Powerup:collide(obj)
	self.dead = true
end

return Powerup
