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

local Bullet = {
	vel = 400,
	img = "gfx/bullet.png",
	width = 11, height = 84,
	frames = 1, states = 2,
	delay = 1, sprites = {},
	id = 3, collided = false,
	bounding_rad = 5, angle = 0,
	time = 0
}
Bullet.__index = Bullet

setmetatable(Bullet, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

--- initial spawn information

function Bullet:_init(x, y, v, a)
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

--- bullet, hitbox speed and direction

function Bullet:update(dt, swidth, sheight)
	Object.update(self, dt)

	self.y = self.y - math.sin(self.angle)*self.vel*dt
	self.x = self.x + math.cos(self.angle)*self.vel*dt

	self.hb_1[2] = self.hb_1[2] - math.sin(self.angle)*self.vel*dt
	self.hb_1[1] = self.hb_1[1] + math.cos(self.angle)*self.vel*dt

	-- makes bullets only last for 0.8 seconds of movement

	self.time = self.time + dt

	if self.time > 0.8 then
	 	self.collided = true
	end
end

function Bullet:draw()
	Object.draw(self, 255, 255, 255, math.pi/2 - self.angle)
end

-- handles when a bullet exits the map
function Bullet:exited_map(width, height)
	local y_pos = self.y + self.height
	local x_pos = self.x + self.height
	if y_pos < 0 or x_pos < 0 or y_pos > height or x_pos > width then
		self.dead = true
	end
end

function Bullet:getHitBoxes( ... )
	local hb = {}
	table.insert(hb, self.hb_1)

	return hb
end

function Bullet:collide(obj)
	self.dead = true
end

return Bullet
