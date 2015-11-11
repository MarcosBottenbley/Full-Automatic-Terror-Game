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

local MetalBall = {
	width = 64, height = 64,
	frames = 3, states = 2,
	img = "gfx/asteroid1.png",
	delay = .1, sprites = {},
	bounding_rad = 29, vel = 130,
	bouncing = false, angle,
	b_timer, type = 'a',
	scale = 1
}
MetalBall.__index = MetalBall

setmetatable(MetalBall, {
	__index = Enemy,
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function MetalBall:_init(scale, vx, vy)
	if math.random() > 0.5 then
		self.img = "gfx/asteroid2.png"
	end
	
	Enemy._init(self, self.x, self.y, self.vel, self.img, self.width, self.height, self.frames, self.states, self.delay)
	self.validCollisions = {1,2,3,6,8}
	self.angle = math.random()*math.pi*2
	self.scale = scale
	--super hacky way to implement setting vx/vy in level file.
	--Later, we'll have to either make this determine the angle
	--for realsies or change the MetalBall code to be based on x/y
	--velocity instead of velocity and angle.
	if vx ~= nil and vy ~= nil then
		self.vel = math.sqrt(vx^2 + vy^2)
		if vy == 0 then
			if vx > 0 then
				self.angle = 0
			else
				self.angle = math.pi
			end
		elseif vx == 0 then
			if vy > 0 then 
				self.angle = math.pi/2
			else
				self.angle = math.pi*(3/2)
			end
		end
	end
end

function MetalBall:update(dt, swidth, sheight, px, py)
	Enemy.update(self, dt, swidth, sheight)
	
	if self.x < 0 or self.y < 0
	or self.x > swidth - self.width or self.y > sheight - self.height then 
		self.angle = self.angle + math.pi
	end

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
		self.x = self.x + self.vel * dt * math.cos(self.angle)
		self.y = self.y - self.vel * dt * math.sin(self.angle)
	end
end

-- function MetalBall:draw()
	-- love.graphics.setColor(131,92,59,255)
	
	-- love.graphics.circle("fill", self.x, self.y, 30*self.scale, 100)
	
	-- love.graphics.setColor(255,255,255,255)
-- end

function MetalBall:getType()
	return self.type
end

function MetalBall:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad*self.scale}
	table.insert(hb, hb_1)

	return hb
end

function MetalBall:collide(obj)
	if obj:getID() == 2 then
		-- if self.scale >= 1 then
			-- self:split()
		-- end
		Enemy.collide(self, obj)
	elseif obj:getID() == 8 then
		ox = obj:getX()
		oy = obj:getY()
		if obj:isVertical() then
			if ox < self.x then
				self.angle = 0
			else
				self.angle = math.pi
			end
		else
			if oy < self.y then
				self.angle = math.pi*(3/2)
			else
				self.angle = math.pi/2
			end
		end
	end
	-- elseif obj:getType() ~= 'a' then
		-- code for bouncing off stuff. asteroids will bounce off anything but
		-- bullets and other asteroids. will damage player but not enemy on bounce.
		-- ox = obj:getX()
		-- oy = obj:getY()
		-- self.angle = math.atan((self.y - oy) / (ox - self.x))
		-- self.bouncing = true
		-- self.b_timer = .15
		-- if ox > self.x then
			-- self.angle = self.angle + math.pi
		-- end
	-- end
end

function MetalBall:split()
	for i=1,3 do
		o = MetalBall(self.scale/2)
		o:setAngle(math.random()*math.pi*2)
		o:setPosition(self.x, self.y)
		table.insert(objects, o)
	end
end

function MetalBall:setAngle(angle)
	self.angle = angle
end

return MetalBall
