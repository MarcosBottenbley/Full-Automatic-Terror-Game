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
	hb_1, time = 0, hit_limit = 5
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

function ChargeShot:_init(x, y, v, ct, a)
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
	self.validCollisions = {1,6,8}
	
	if ct < 1 then
		self.hit_limit = 2
		self.bounding_rad = 10
	elseif ct > 1 and ct < 2 then
		self.hit_limit = 5
		self.bounding_rad = 16
	elseif ct > 2 and ct < 3 then
		self.hit_limit = 8
		self.bounding_rad = 22
	elseif ct > 3 then
		self.hit_limit = 12
		self.bounding_rad = 30
	end
	
	if ct > 3 then
		ct = 4
	end
	self.hit_limit = 5*math.ceil(ct)
	self.bounding_rad = 10*math.ceil(ct)
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
	if obj:getID() == 8 then
		self.dead = true
	else
		self.hit_limit = self.hit_limit - 1
		if self.hit_limit <= 0 then
			self.dead = true
		end
	end
end

return ChargeShot
