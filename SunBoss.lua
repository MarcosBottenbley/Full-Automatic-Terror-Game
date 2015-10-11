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
	health = 10, s_timer = 0,
	d_timer = 0, angle = 0,
	vel = 100, damaged = false
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

function SunBoss:load()
	Object.load(self)
	bosshit = love.audio.newSource("sfx/bosshit.ogg")
	bosshit:setLooping(false)
end

function SunBoss:update(dt, swidth, sheight, px, py)
	self.s_timer = self.s_timer + dt
	if self.damaged then
		self.d_timer = self.d_timer + dt
	end
	
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
	
	if self.s_timer > 0.25 then
		self:shoot()
	end
	
	if self.d_timer > 0.2 then
		self.damaged = false
		self.d_timer = 0
	end
end

function SunBoss:draw()
	if self.damaged then
		Object.draw(self,255,100,100)
	else
		Object.draw(self,255,255,255)
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
	self.damaged = true
	self.d_timer = 0
	bosshit:play()
end

function SunBoss:shoot()
	local b = EnemyBullet(self.x, self.y+40, 600, self.angle)
	table.insert(objects, b)
	self.s_timer = 0
end

return SunBoss
