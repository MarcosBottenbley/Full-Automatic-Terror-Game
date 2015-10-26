--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Object = require("Object")

local Wormhole = {
	img = "gfx/wormhole.png",
	frames = 9, states = 1,
	delay = 0.06,
	width = 80, height = 80,
	vx = 20, vy = 20,
	xset = 0, yset = 0,
	bounding_rad = 30,
	id = 7, collided = false,
	tele_x = 0, tele_y = 0,
	sprites = {}
}

Wormhole.__index = Wormhole

setmetatable(Wormhole, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

--- initial spawn information

-- xset is the x offset upon being spawned there, either 0, 1, or -1 * certain distance
-- yset is the y offset upon being spawned there, either 0, 1, or -1 * certain distance

function Wormhole:_init(x, y)
	self.collided = false
	self.xset = xset
	self.yset = yset
	self.tele_x = 0
	self.tele_y = 0
	Object._init(self, x, y,
		self.img,
		self.width,
		self.height,
		self.frames,
		self.states,
		self.delay)

	self.hb_1 = {self.x, self.y, self.bounding_rad}
	self.validCollisions = {2}
end

-- function Wormhole:draw()
--  	Object.draw(self, 255, 255, 255)
-- end
--
-- function Wormhole:update(dt, swidth, sheight)
-- 	Object.update(self, dt)
-- end

function Wormhole:setTeleport(tx, ty)
	self.tele_x = tx
	self.tele_y = ty
end

function Wormhole:teleport()
	return self.tele_x, self.tele_y
end

function Wormhole:setPosition(x, y)
	self.x = x
	self.y = y
end

function Wormhole:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

function Wormhole:getType()
	return self.type
end

function Wormhole:getValid(...)
	return self.validCollisions
end

function Wormhole:collide(obj)
	-- if it's the player, teleport the player
	-- player.setPosition(self:teleport())
end

return Wormhole
