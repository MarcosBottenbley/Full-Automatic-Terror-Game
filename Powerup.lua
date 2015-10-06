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
	img = "gfx/power_up.png",
	width = 44, height = 47,
	frames = 2, states = 1,
	delay = 0.3, 
	vx = 10, vy = 10,
	sprites = {}, bounding_rad = 22,
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

function Powerup:load()
	Object.load(self)
end

function Powerup:_init(x, y, v, img, width, height, frames, states, delay)
	self.vx = v
	self.vy = v
	Object._init(self, x, y, img, width, height, frames, states, delay)
end

function Powerup:draw()
	Object.draw(self,255,0,0)
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

return Powerup
