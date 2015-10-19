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

local Missile = {
	vel = 350, turnSpeed = math.pi*2,
	lockDistance = 300, lockTime,
	id = 3, collided = false,
	width = 10, height = 10,
	bounding_rad = 12.5, angle = 0,
	target_x, target_y, target,
	hb_1
}
Missile.__index = Missile

setmetatable(Missile, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

--- initial spawn information

function Missile:_init(x, y, v, a)
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
	self.target = nil
	self.validCollisions = {1}
end

--- Missile, hitbox speed and direction

function Missile:update(dt)
	local closestDist = self.lockDistance
	
	self.target_x = nil
	self.target_y = nil
	
	if self.target == nil then
		for _, o in ipairs(objects) do
			if self:dist(o) < closestDist and o:getID() == 1 then
				self.target_x = o:getX()
				self.target_y = o:getY()
				self.target = o
				closestDist = self:dist(o)
			end
		end
	else
		self.target_x = self.target:getX()
		self.target_y = self.target:getY()
		if self.target.collided then
			self.target = nil
		end
	end
	
	--Code for calculating target angle. It's kind of messy right now,
	--but it gets the angle (0 to 2*pi) between the missile and the target.
	--If the missile is not targeting any object, then the target angle 
	--becomes the current angle and the trajectory won't change.
	local target_angle = 0
	if self.target_x ~= nil and self.target_y ~= nil then
		if self.target_x - self.x > 0 then
			target_angle = math.atan(-(self.target_y - self.y) / (self.target_x - self.x))
			if target_angle < 0 then
				target_angle = target_angle + math.pi*2
			end
		else
			target_angle = math.atan(-(self.target_y - self.y) / (self.target_x - self.x)) + math.pi
		end
	else
		target_angle = self.angle
	end
	
	--Code for changing the angle and moving the missile. angleDir will
	--return whether the missile should rotate clockwise, counterclockwise
	--or not at all, and the speed of rotation is determined by turnSpeed.
	local rotate = self:angleDir(self.angle, target_angle)
	local angvel = rotate * self.turnSpeed * dt
	self.angle = self.angle + angvel
	
	self.y = self.y - (math.sin(self.angle)*self.vel*dt)
	self.x = self.x + (math.cos(self.angle)*self.vel*dt)
	
	self.hb_1 = {self.x, self.y, self.bounding_rad}
end

function Missile:draw()
	love.graphics.setColor(255,188,188,188)
	
	love.graphics.circle('fill', self.x, self.y, self.bounding_rad - 1, 100)
	
	love.graphics.setColor(255,255,255,255)
end

--- handles when a Missile exits the map

function Missile:exited_map(width, height)
	local y_pos = self.y + self.height
	local x_pos = self.x + self.height
	if y_pos < 0 or x_pos < 0 or y_pos > height or x_pos > width then
		return true
	end
end

--Returns distance from missile to object
function Missile:dist(obj)
	return math.sqrt((obj:getX() - self.x)^2 + (obj:getY() - self.y)^2)
end

--Calculates direction to turn based on current angle and angle to target
function Missile:angleDir(a_start, a_finish)
	local diff = a_start - a_finish
	
	if math.abs(diff) > math.pi then
		if diff > 0 then return 1
		else return -1
		end
	elseif math.abs(diff) < math.pi then
		if diff < 0 then return 1
		elseif diff > 0 then return -1
		else return 0
		end
	end
end

function Missile:getHitBoxes( ... )
	local hb = {}
	table.insert(hb, self.hb_1)
	return hb
end

function Missile:collide(obj)
	self.dead = true
end

return Missile
