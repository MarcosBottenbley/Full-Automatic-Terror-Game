Object = require("Object")
math.randomseed(os.time())

local Bullet = {
	vel = 400,
	img = "gfx/bullet.png",
	width = 15, height = 46,
	frames = 1, states = 1,
	delay = 1, sprites = {}
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
	Object._init(self, x, y, v, 
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

return Bullet