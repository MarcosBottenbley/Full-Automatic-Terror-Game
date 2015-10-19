--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Object = require("Object")

local Wormhole = {
	width = 80, height = 80,
	vx = 20, vy = 20,
	xset = 0, yset = 0,
	bounding_rad = 40,
	id = 7, collided = false
}

Wormhole.__index = Wormhole

setmetatable(Wormhole, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

--- initial spawn information

-- xset is the x offset upon being spawned there, either 0, 1, or -1 * certain distance
-- yset is the y offset upon being spawned there, either 0, 1, or -1 * certain distance

function Wormhole:_init(x, y, v, xset, yset)
	self.vx = v
	self.vy = v
	self.collided = false
	self.xset = xset
	self.yset = yset
	Object._init(self, x, y,
		self.img,
		self.width,
		self.height,
		self.frames,
		self.states,
		self.delay)

	self.hb_1 = {self.x, self.y, self.bounding_rad}

	self.validCollisions = {3}
end

function Wormhole:draw()
	Object.draw(self, 255, 255, 255)
end

function Wormhole:update(dt, swidth, sheight)
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

function Wormhole:bounce(side)
	if side == 1 then
		self.vx = -self.vx
	else
		self.vy = -self.vy
	end
end

function Wormhole:direction()
	if math.random(0,2) <= 1 then
		if math.random(0,2) >= 1 then
			self:bounce(0)
		else
			self:bounce(1)
		end
	end
end

function Wormhole:setPosition(x, y)
	self.x = x
	self.y = y
end

function Wormhole:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

function Wormhole:getType()
	return self.type
end

function Wormhole:getValid(...)
	local table = {3}
	return table
end


return Wormhole
