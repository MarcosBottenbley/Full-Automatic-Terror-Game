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
	health = 10, time = 0, angle = 0,
	vel = 100
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
	Enemy._init(self, x, y, v, self.img, self.width, self.height, self.frames, self.states, self.delay)
end

function SunBoss:update(dt, swidth, sheight, px, py)
	self.time = self.time + dt
	Enemy.update(self, dt, swidth, sheight)
	self.angle = self.angle + (math.pi/2)*dt

	--print("PLAYER: " .. py .. " " .. px)
	local angle_p = math.atan((py - self.y) / (px - self.x))

	if self:distanceFrom(px, py) < 500 then
		--move towards player (weird if statement because i don't
		--totally understand the math)
		if px - self.x > 0 then
			self.x = self.x + self.vel * dt * math.cos(angle_p)
			self.y = self.y + self.vel * dt * math.sin(angle_p)
		else
			self.x = self.x - self.vel * dt * math.cos(angle_p)
			self.y = self.y - self.vel * dt * math.sin(angle_p)
		end
	end
	
	if self.health < 1 then
		self.collided = true
	end
	
	if self.time >= 0.25 then
		self:shoot()
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

function SunBoss:shoot()
	local b = EnemyBullet(self.x, self.y+40, 600, self.angle)
	table.insert(objects, b)
	self.time = 0
end

return SunBoss
