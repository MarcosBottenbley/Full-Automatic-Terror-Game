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
	bounding_rad = 25, type = 'g',
	vel = 130, chase_range = 500
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
	Enemy._init(self, self.x, self.y, self.vel, self.img, self.width, self.height, self.frames, self.states, self.delay)
end

function GlowBorg:update(dt, swidth, sheight, px, py)
	Enemy.update(self, dt, swidth, sheight)

	--print("PLAYER: " .. py .. " " .. px)
	local angle = math.atan((py - self.y) / (px - self.x))

	--if not exploding
	if not self.collided and 
	--and if player is within chasing range
	(self.x - px)^2 + (self.y - py)^2 < self.chase_range^2 then
		--move towards player
		if px - self.x > 0 then
			self.x = self.x + self.vel * dt * math.cos(angle)
			self.y = self.y + self.vel * dt * math.sin(angle)
		else
			self.x = self.x - self.vel * dt * math.cos(angle)
			self.y = self.y - self.vel * dt * math.sin(angle)
		end
	end
end

function GlowBorg:draw()
	Enemy.draw(self, 255, 255, 255)
end

function GlowBorg:getType()
	return self.type
end

function GlowBorg:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

return GlowBorg
