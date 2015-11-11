--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Enemy = require("Enemy")

local Turret = {
	img = "gfx/turret.png",
	width = 64, height = 64,
	frames = 2, states = 2,
	delay = 0.12, sprites = {},
	bounding_rad = 25, type = 't',
	angle
}
Turret.__index = Turret

setmetatable(Turret, {
	__index = Enemy,
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Turret:_init(x, y)
	Enemy._init(self, x, y, self.vel, self.img, self.width, self.height, self.frames, self.states, self.delay)
	self.validCollisions = {2,3}
end

function Turret:update(dt, swidth, sheight, px, py)
	Enemy.update(self, dt, swidth, sheight)

	self.angle = math.atan((self.y - py) / (px - self.x))
	if px > self.x then
		self.angle = self.angle + math.pi
	end


end

function Turret:draw()
	Object.draw(self, 255, 255, 255, math.pi*(3/2) - self.angle)
end

function Turret:getType()
	return self.type
end

function Turret:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

function Turret:collide(obj)
	if obj:getID() == 3 then
		--do something
	end
end

return Turret
