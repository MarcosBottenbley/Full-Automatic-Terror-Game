--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

math.randomseed(os.time())

Enemy = require("Enemy")

local Orbiter = {
	width = 64, height = 64,
	frames = 3, states = 2,
	img = "gfx/asteroid1.png",
	delay = .1, sprites = {},
	bounding_rad = 29, vel = 100,
	angle, type = 'o'
}
Orbiter.__index = Orbiter

setmetatable(Orbiter, {
	__index = Enemy,
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Orbiter:_init(x, y)
	if math.random() > 0.5 then
		if math.random() > 0.5 then
			self.img = "gfx/asteroid2.png"
		end
	else
		if math.random() > 0.5 then
			self.img = "gfx/enemy_sheet.png"
			self.width = 60
			self.height = 60
			self.frames = 6
			self.delay = 0.12
			self.bounding_rad = 25
		else
			self.img = "gfx/metal_asteroid1.png"
		end
	end

	Enemy._init(self, x, y, self.vel, self.img, self.width, self.height, self.frames, self.states, self.delay)
	self.validCollisions = {1,2,3,6}
	self.angle = math.random()*math.pi*2
end

function Orbiter:update(dt, swidth, sheight, px, py)
	Enemy.update(self, dt, swidth, sheight)

	-- move if not destroyed
	if not self.collided then
		--if bouncing off something, accelerate by 3200 every dt
		if self.bouncing then
			self.vel = self.vel + 3200 * dt
			self.b_timer = self.b_timer - dt
			if self.b_timer <= 0 then
				self.bouncing = false
				self.vel = 130
			end
		end
		--move in the direction of self.angle
		--self.x = self.x + self.vel * dt * math.cos(self.angle)
		--self.y = self.y - self.vel * dt * math.sin(self.angle)
	end
	
	if self.x > bg_width then
		self.x = 1
	elseif self.x < 0 then
		self.x = bg_width - 1
	end
	
	if self.y > bg_height then
		self.y = 1
	elseif self.y < 0 then
		self.y = bg_height - 1
	end
end

-- function Orbiter:draw()
	-- love.graphics.push()
	-- love.graphics.scale(0.9)
	-- Object.draw(self, 255, 255, 255)
	-- love.graphics.pop()
-- end

function Orbiter:getType()
	return self.type
end

function Orbiter:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

function Orbiter:collide(obj)
	if obj:getID() == 3 or obj:getID() == 6 then
		-- if self.scale >= 1 then
			-- self:split()
		-- end
		Enemy.collide(self, obj)
	elseif obj:getType() ~= 'a' then
		-- code for bouncing off stuff. asteroids will bounce off anything but
		-- bullets and other asteroids. will damage player but not enemy on bounce.
		ox = obj:getX()
		oy = obj:getY()
		self.angle = math.atan((self.y - oy) / (ox - self.x))
		self.bouncing = true
		self.b_timer = .15
		if ox > self.x then
			self.angle = self.angle + math.pi
		end
	end
end

function Orbiter:split()
	for i=1,3 do
		o = Orbiter(self.scale/2)
		o:setAngle(math.random()*math.pi*2)
		o:setPosition(self.x, self.y)
		table.insert(objects, o)
	end
end

function Orbiter:setAngle(angle)
	self.angle = angle
end

return Orbiter
