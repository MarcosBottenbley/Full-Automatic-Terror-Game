--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Object = require("Object")

local WeaponPart = {
	width = 64, height = 64,
	frames = 1, states = 1,
	bounding_rad = 30, delay = 0,
	id = 13, collided = false,
	img = "gfx/part1.png"
}
WeaponPart.__index = WeaponPart

setmetatable(WeaponPart, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function WeaponPart:_init(x, y, partNum)
	Object._init(self, x, y, self.img, self.width, self.height, self.frames, self.states, self.delay)
	self.img = "gfx/part" .. partNum .. ".png"

	self.validCollisions = {2}
end

function WeaponPart:draw()
	Object.draw(self,255,255,255)
end

function WeaponPart:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

function WeaponPart:getType()
	return self.type
end

function WeaponPart:getValid(...)
	return self.validCollisions
end

function WeaponPart:collide(obj)
	self.dead = true
	obj:getPart()
end

return WeaponPart
