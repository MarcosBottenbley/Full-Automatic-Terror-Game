--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Object = require("Object")
math.randomseed(os.time())

local ChargeShot = {
	vel = 300, turnSpeed = math.pi*2,
	lockDistance = 300, lockTime,
	id = 3, collided = false,
	width = 10, height = 10,
	bounding_rad = 30, angle = 0,
	hb_1, time = 0, hits = 5
}
ChargeShot.__index = ChargeShot

setmetatable(ChargeShot, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

--- initial spawn information

function ChargeShot:_init(x, y, v, a)
	self.vel = v
	self.angle = a
	Object._init(self, x, y,
		self.img,
		self.width,
		self.height,
		self.frames,
		self.states,
		self.delay)

	self.hb_1 = {self.x, self.y, self.bounding_rad}
	self.validCollisions = {1}
end

--- ChargeShot, hitbox speed and direction

function ChargeShot:update(dt)

	self.hb_1 = {self.x, self.y, self.bounding_rad}

	self.time = self.time + dt

	if self.time < 1.2 then
		self.y = self.y - math.sin(self.angle)*self.vel*dt
		self.x = self.x + math.cos(self.angle)*self.vel*dt
	else
		self.dead = true
	end

end

function ChargeShot:draw()
	love.graphics.setColor(255,0,0,188)
	
	love.graphics.circle('fill', self.x, self.y, self.bounding_rad - 1, 100)
	
	love.graphics.setColor(255,255,255,255)
end

--- handles when a ChargeShot exits the map

function ChargeShot:exited_map(width, height)
	local y_pos = self.y + self.height
	local x_pos = self.x + self.height
	if y_pos < 0 or x_pos < 0 or y_pos > height or x_pos > width then
		self.dead = true
	end
end

function ChargeShot:getHitBoxes( ... )
	local hb = {}
	table.insert(hb, self.hb_1)
	return hb
end

function ChargeShot:collide(obj)
	self.dead = true
end

return ChargeShot
