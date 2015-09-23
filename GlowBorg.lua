Enemy = require("Enemy")

local GlowBorg = {
	img = "gfx/enemy_sheet.png"
	width = 62, height = 62,
	frames = 5, states = 1,
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
	local x = math.random(800 - self.width)
	local y = math.random(600 - self.height)
	local v = math.random(40,80)
	Enemy._init(self, x, y, v)
end

function GlowBorg:update()
	
end