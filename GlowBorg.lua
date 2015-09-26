Enemy = require("Enemy")

local GlowBorg = {
	img = "gfx/enemy_sheet.png",
	width = 56, height = 56,
	frames = 8, states = 1,
	delay = 0.08, sprites = {},
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

function GlowBorg:getRadius( ... )
	return self.bounding_rad
end

return GlowBorg