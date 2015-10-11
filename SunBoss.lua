--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Enemy = require("Enemy")

local SunBoss = {
	img = "gfx/sun_boss.png",
	width = 150, height = 150,
	frames = 4, states = 2,
	delay = 0.12, sprites = {},
	bounding_rad = 60, type = 'b',
	health = 10
}
SunBoss.__index = SunBoss

setmetatable(SunBoss, {
	__index = Enemy,
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function SunBoss:_init(x,y)
	local v = math.random(40,80)
	v = -v
	Enemy._init(self, x, y, v, self.img, self.width, self.height, self.frames, self.states, self.delay)
end

function SunBoss:update(dt, swidth, sheight, px, py)
	Enemy.update(self, dt, swidth, sheight)

	--print("PLAYER: " .. py .. " " .. px)
	local angle = math.atan((py - self.y) / (px - self.x))

	if self:distanceFrom(px, py) < 500 then
		--move towards player (weird if statement because i don't
		--totally understand the math)
		if px - self.x > 0 then
			self.x = self.x + 150 * dt * math.cos(angle)
			self.y = self.y + 150 * dt * math.sin(angle)
		else
			self.x = self.x - 150 * dt * math.cos(angle)
			self.y = self.y - 150 * dt * math.sin(angle)
		end
	end
	
	if self.health < 1 then
		self.collided = true
	end
end

function SunBoss:getType()
	return self.type
end

function SunBoss:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

--returns the distance between SunBoss' origin and (x, y)
function SunBoss:distanceFrom(x, y)
	return math.sqrt((x - self.x)^2 + (y - self.y)^2)
end

function SunBoss:hit()
	self.health = self.health - 1
end

return SunBoss
