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
	width = 9, height = 40,
	frames = 1, states = 2,
	delay = 1, sprites = {},
	id = 3, collided = false,
	bounding_rad = 5
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

function Bullet:_init(x, y, v)
	self.vy = v
	Object._init(self, x, y, 
		self.img, 
		self.width,
		self.height,
		self.frames,
		self.states,
		self.delay)
end

function Bullet:update(dt, swidth, sheight)
	Object.update(self, dt)

	self.y = self.y + self.vy*dt

end

function Bullet:draw()
	Object.draw(self,0,255,0)
end

function Bullet:exited_screen(swidth, sheight)
	local y_pos = self.y + self.height
	local x_pos = self.x + self.height
	if y_pos < 0 or x_pos < 0 or y_pos > sheight or x_pos > swidth then
		return true
	end
end

function Bullet:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x + self.width/2, self.y + 5, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

return Bullet