--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Powerup = require("Powerup")

local DoubleShot = {
	img = "gfx/power_up.png",
	width = 44, height = 47,
	frames = 2, states = 1,
	delay = 0.3, 
	vx = 10, vy = 10,
	sprites = {}, bounding_rad = 22,
	id = 5, type = 'ds', collided = false
}
DoubleShot.__index = DoubleShot

setmetatable(DoubleShot, {
	__index = Powerup,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function DoubleShot:_init(x, y, v)
	self.vx = v
	self.vy = v
	self.collided = false
	print(self.states)
	Object._init(self, x, y, self.img, self.width, self.height, self.frames, self.states, self.delay)
end

return DoubleShot
