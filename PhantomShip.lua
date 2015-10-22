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

local PhantomShip = {
	img = "gfx/phantom_ship.png",
	width = 40, height = 52,
	frames = 5, states = 2,
	delay = 0.12, sprites = {},
	bounding_rad = 20, type = 'f',
	vel = 0, fireRate = 2, timer = 4
}
PhantomShip.__index = PhantomShip

setmetatable(PhantomShip, {
	__index = Enemy,
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

--- initializes phantom ships with random positions but consistent
--- movement speed

function PhantomShip:_init()
	self.vel = math.random(40,80)
	Enemy._init(self, self.x, self.y, self.vel, self.img, self.width, self.height, self.frames, self.states, self.delay)
end

function PhantomShip:update(dt, swidth, sheight, px, py)
	self.timer = self.timer + dt
	Enemy.update(self, dt, swidth, sheight)
	
	if self.timer > self.fireRate then
		if self:shoot(px, py) then
			self.timer = 0
		end
	end

	self.y = self.y + self.vel*dt
	if self.x >= bg_width then
		self.x = 0
	end
	if self.y >= bg_height then
		self.y = 0
	end
end

function PhantomShip:shoot(px, py)
	if (px < self.x + 28.5 and px > self.x - 28.5) and py > self.y then
		local b = EnemyBullet(self.x, self.y+40, 600, -math.pi/2)
		table.insert(objects, b)
		return true
	else
		return false
	end
end

function PhantomShip:getType()
	return self.type
end

function PhantomShip:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

return PhantomShip
