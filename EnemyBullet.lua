--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Bullet = require("Bullet")
math.randomseed(os.time())

local EnemyBullet = {
	vel = 400,
	img = "gfx/ps_bullet.png",
	width = 11, height = 38,
	frames = 1, states = 2,
	delay = 1, sprites = {},
	id = 6, collided = false,
	bounding_rad = 5, angle = 0,
	time = 0
}
EnemyBullet.__index = EnemyBullet

setmetatable(EnemyBullet, {
	__index = Bullet,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

--- sets enemy bullet’s velocity, angle, position, images,
--- states, frames, and delay

function EnemyBullet:_init(x, y, v, a)
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
	self.validCollisions = {2,3}
end

--- makes bullets only last for 1 second of movement

function EnemyBullet:update(dt, swidth, sheight)
	Object.update(self, dt)

	self.y = self.y - math.sin(self.angle)*self.vel*dt
	self.x = self.x + math.cos(self.angle)*self.vel*dt

	self.hb_1[2] = self.hb_1[2] - math.sin(self.angle)*self.vel*dt
	self.hb_1[1] = self.hb_1[1] + math.cos(self.angle)*self.vel*dt

	-- makes bullets only last for 1 seconds of movement

	self.time = self.time + dt

	if self.time > 1 then
	 	self.collided = true
	end
end

return EnemyBullet
