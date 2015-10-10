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
	bounding_rad = 5, angle = 0
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

	self.hb_1 = {self.x, self.y, self.bounding_rad}-- + self.width/2, self.y + 5, self.bounding_rad}
end

function Bullet:update(dt, swidth, sheight)
	Object.update(self, dt)

	self.y = self.y - math.sin(math.pi/2 - self.angle)*self.vel*dt
	self.x = self.x + math.cos(math.pi/2 - self.angle)*self.vel*dt

	self.hb_1[2] = self.hb_1[2] - math.sin(math.pi/2 - self.angle)*self.vel*dt
	self.hb_1[1] = self.hb_1[1] + math.cos(math.pi/2 - self.angle)*self.vel*dt

end

function Bullet:draw()
	Object.draw(self,0,255,0,self.angle)
end

function Bullet:exited_screen(width, height)
	local y_pos = self.y + self.height
	local x_pos = self.x + self.height
	if y_pos < 0 or x_pos < 0 or y_pos > height or x_pos > width then
		return true
	end
end

function Bullet:getHitBoxes( ... )
	local hb = {}
	table.insert(hb, self.hb_1)

	return hb
end

return Bullet
