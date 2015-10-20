--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Enemy = require("Enemy")
EnemyBullet = require("EnemyBullet")

local time = 0

local DualMaster = {
	img = "gfx/enemy_3.png",
	width = 44, height = 60,
	frames = 3, states = 2,
	delay = 0.12, sprites = {},
	bounding_rad = 20, type = 'f',
	vel = 60, fireRate = 5
}
DualMaster.__index = DualMaster

setmetatable(DualMaster, {
	__index = Enemy,
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

--- initializes phantom ships with random positions but consistent
--- movement speed

function DualMaster:_init()
	--self.vel = math.random(40,80)
	Enemy._init(self, self.x, self.y, self.vel, self.img, self.width, self.height, self.frames, self.states, self.delay)
end

function DualMaster:update(dt, swidth, sheight)
	Enemy.update(self, dt, swidth, sheight)

	self.y = self.y - self.vel*dt
	if self.y < 0 then
		self.y = bg_height
	end
end

function DualMaster:shoot(dt,px,py)
	time = time + dt
	if (py < self.y + self.height and py > self.y - self.height) and 
	(px > self.x - 400 or px < self.x + 400) then
		if time >= self.fireRate then
			local b1 = EnemyBullet(self.x + 40, self.y, 600, 0)
			local b2 = EnemyBullet(self.x - 40, self.y, 600, math.pi)
			table.insert(objects, b1)
			table.insert(objects, b2)
			time = 0
		end
	end
end

function DualMaster:getType()
	return self.type
end

function DualMaster:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

return DualMaster