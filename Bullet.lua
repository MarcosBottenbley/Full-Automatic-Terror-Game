Object = require("Object")
math.randomseed(os.time())

local Bullet = {
	vel = 400,
	img = "gfx/bullet.png",
	width = 15, height = 46,
	frames = 1, states = 1,
	delay = 1, sprites = {},
	id = 3, collided = false
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

return Bullet