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

local Bullet = {
	vel = 400,
	img = "gfx/ps_bullet.png",
	width = 11, height = 38,
	frames = 1, states = 2,
	delay = 1, sprites = {},
	id = 3, collided = false,
	bounding_rad = 5, angle = 0
}
Bullet.__index = Bullet

setmetatable(PhantomBullet, {
	__index = Bullet,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function PhantomBullet:_init(x, y, v, a)
	self.vel = v
	self.angle = a
	Bullet._init(self, x, y,
		self.img,
		self.width,
		self.height,
		self.frames,
		self.states,
		self.delay)

	self.hb_1 = {self.x, self.y, self.bounding_rad}-- + self.width/2, self.y + 5, self.bounding_rad}
end
-- 
-- function PhantomBullet:update(dt, swidth, sheight)
-- 	Bullet.update(self, dt)
--
-- 	self.y = self.y - math.sin(math.pi/2 - self.angle)*self.vel*dt
-- 	self.x = self.x + math.cos(math.pi/2 - self.angle)*self.vel*dt
--
-- 	self.hb_1[2] = self.hb_1[2] - math.sin(math.pi/2 - self.angle)*self.vel*dt
-- 	self.hb_1[1] = self.hb_1[1] + math.cos(math.pi/2 - self.angle)*self.vel*dt
--
-- end
--
-- function PhantomBullet:draw()
-- 	Bullet.draw(self,0,255,0,self.angle)
-- end
--
-- function PhantomBullet:exited_screen(swidth, sheight)
-- 	local y_pos = self.y + self.height
-- 	local x_pos = self.x + self.height
-- 	if y_pos < 0 or x_pos < 0 or y_pos > sheight or x_pos > swidth then
-- 		return true
-- 	end
-- end
--
-- function PhantomBullet:getHitBoxes( ... )
-- 	local hb = {}
-- 	table.insert(hb, self.hb_1)
--
-- 	return hb
-- end

return PhantomBullet
