--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Enemy = require("Enemy")

local GlowBorg = {
	img = "gfx/enemy_sheet.png",
	width = 60, height = 60,
	frames = 6, states = 2,
	delay = 0.12, sprites = {},
	bounding_rad = 25
}
GlowBorg.__index = GlowBorg

setmetatable(GlowBorg, {
	__index = Enemy,
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function GlowBorg:_init()
	local x = math.random(width - self.width)
	local y = 56
	local v = math.random(40,80)
	v = -v
	Enemy._init(self, x, y, v, self.img, self.width, self.height, self.frames, self.states, self.delay)
end

function GlowBorg:update(dt, swidth, sheight)
	Enemy.update(self, dt, swidth, sheight)

	self.y = self.y + self.vy*dt
end

function GlowBorg:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

return GlowBorg