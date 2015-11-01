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
math.randomseed(os.time())

local PhantomShip = {
	img = "gfx/phantom_ship.png",
	width = 40, height = 52,
	frames = 5, states = 2,
	delay = 0.12, sprites = {},
	bounding_rad = 20, type = 'f',
	vel = 0, fireRate = 2, timer = 4,
	goDown
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
	self.vel = math.random(80,160)
	local choice = {true, false}
	self.goDown = choice[math.random(2)]
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
	
	--move/stop moving during explosion
	if not self.collided then
		if self.goDown then
			self.y = self.y + self.vel*dt
		else
			self.y = self.y - self.vel*dt
		end
	end
	
	if self.x >= bg_width then
		self.x = 0
	end
	if self.x < -1 then
		self.x = bg_width - 1
	end
	if self.y >= bg_height then
		self.y = 0
	end
	if self.y < -1 then
		self.y = bg_height - 1
	end
end

function PhantomShip:draw()
	if self.goDown then
		Enemy.draw(self, 255, 255, 255)
	else
		Object.draw(self, 255, 255, 255, math.pi)
	end
end

function PhantomShip:shoot(px, py)
	--incredibly hacky
	local playerInFront = false
	if (py > self.y and py < self.y + 400 and self.goDown) or 
	(py < self.y and py > self.y - 400 and not self.goDown) then
		playerInFront = true
	end
	
	if (px < self.x + 28.5 and px > self.x - 28.5) and playerInFront then
		if self.goDown then
			local b = EnemyBullet(self.x, self.y+40, 600, -math.pi/2)
		else
			local b = EnemyBullet(self.x, self.y-40, -600, math.pi/2)
		end
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

function PhantomShip:collide(obj)
	self.delay = 0.09
	Enemy.collide(self, obj)
end

return PhantomShip
