--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

math.randomseed(os.time())

Enemy = require("Enemy")

local Asteroid = {
	width = 60, height = 60,
	frames = 1, states = 0,
	delay = .1, sprites = {},
	bounding_rad = 29, vel = 130,
	bouncing = false, angle,
	b_timer, type = 'a',
	scale = 1
}
Asteroid.__index = Asteroid

setmetatable(Asteroid, {
	__index = Enemy,
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Asteroid:_init(scale)
	Enemy._init(self, self.x, self.y, self.vel, nil, self.width, self.height, self.frames, self.states, self.delay)
	self.validCollisions = {1,2,3,6}
	self.angle = math.random()*math.pi*2
	self.scale = scale
end

function Asteroid:update(dt, swidth, sheight, px, py)
	Enemy.update(self, dt, swidth, sheight)

	-- move if not destroyed
	if not self.collided then
		--if bouncing off something, accelerate by 3200 every dt
		if self.bouncing then
			self.vel = self.vel + 3200 * dt
			self.b_timer = self.b_timer - dt
			if self.b_timer <= 0 then
				self.bouncing = false
				self.vel = 130
			end
		end
		--move in the direction of self.angle
		self.x = self.x + self.vel * dt * math.cos(self.angle)
		self.y = self.y - self.vel * dt * math.sin(self.angle)
	end
end

function Asteroid:draw()
	love.graphics.setColor(131,92,59,255)
	
	love.graphics.circle("fill", self.x, self.y, 30*self.scale, 100)
	
	love.graphics.setColor(255,255,255,255)
end

function Asteroid:getType()
	return self.type
end

function Asteroid:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad*self.scale}
	table.insert(hb, hb_1)

	return hb
end

function Asteroid:collide(obj)
	if obj:getID() == 3 or obj:getID() == 6 then
		if self.scale >= 1 then
			self:split()
		end
		Enemy.collide(self, obj)
	elseif obj:getType() ~= 'a' then
		--code for bouncing off stuff. asteroids will bounce off anything but
		--bullets and other asteroids. will damage player but not enemy on bounce.
		ox = obj:getX()
		oy = obj:getY()
		self.angle = math.atan((self.y - oy) / (ox - self.x))
		self.bouncing = true
		self.b_timer = .15
		if ox > self.x then
			self.angle = self.angle + math.pi
		end
	end
end

function Asteroid:split()
	for i=1,3 do
		o = Asteroid(self.scale/2)
		o:setAngle(math.random()*math.pi*2)
		o:setPosition(self.x, self.y)
		table.insert(objects, o)
	end
end

function Asteroid:setAngle(angle)
	self.angle = angle
end

return Asteroid
