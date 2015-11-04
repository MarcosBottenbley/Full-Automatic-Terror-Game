--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Object = require("Object")
math.randomseed(os.time())
local f_timer = 0
local firable = false

local timeChange = 0
local pos = 1
local t_timer = 0
local destination = math.pi/2
local clockwise = false

local Player = {
	vel = 0, max_vel = 200,
	accel = 0, max_accel = 800,
	img = "gfx/main_ship_sheet.png",
	width = 42, height = 46,
	frames = 5, states = 2,
	delay = 0.12, sprites = {},
	id = 2, collided = false,
	bounding_rad = 25, angle1 = math.pi/2,
	move_angle = math.pi/2, draw_angle = math.pi/2,
	ang_vel = 0, double = false,
	health = 10, bomb = 100, h_jump = 5,
	invul = false, d_timer = 0, damaged = false,
	missile = false, missile_fire_timer = 0,
	bomb_flash = false, flash_timer = .6,
	teleporttimer = 0, bulletSpeed = .18,
	inframe = false, jumptimer = 0, isJumping = false,
	camera_x = 0, camera_y = 0, winner = false,
	b_angle, b_timer, bouncing
}
Player.__index = Player

setmetatable(Player, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Player:_init(x, y, v)
	Object._init(self, x, y,
		self.img,
		self.width,
		self.height,
		self.frames,
		self.states,
		self.delay)

	self.max_vel = v

	self.hb_1 = {self.x, self.y - 18.5, 10}
	self.hb_2 = {self.x, self.y + 10.5, 19}

	self.validCollisions = {1,6,5,7,8}
	-- thrusters = {x1,y1,x2,y2,x3,y3} pos of thrusters
	self.thrusters = {}
	self:intitializeThrusters()
end

function Player:load()
	Object.load(self)
	pew = love.audio.newSource("sfx/pew.ogg")
	pew:setLooping(false)
	playerhit = love.audio.newSource("sfx/playerhit.ogg")
	playerhit:setLooping(false)
	bump = love.audio.newSource("sfx/bump1.ogg")
	bump:setLooping(false)
end

function Player:update(dt, swidth, sheight)
	Object.update(self,dt)
	f_timer = f_timer + dt
	t_timer = t_timer + dt
	self.missile_fire_timer = self.missile_fire_timer + dt
	timeChange = dt

	if f_timer >= self.bulletSpeed then
		firable = true
	else
	    	firable = false
	end

	self.teleporttimer = self.teleporttimer + dt

	if self.flash_timer > .58 then
		self.bomb_flash = false
	end

	if self.damaged then
		self.d_timer = self.d_timer + dt
	end

	if self.d_timer > 0.5 then
		self.damaged = false
		self.d_timer = 0
	end

	if self.health < 1 then
		self.collided = true
	end
	
	if not self.bouncing then
		
		self.vel = 0

		local thrusting = false
		self:smoothturn()
		--turn left or right
		if love.keyboard.isDown('left') then
			--self:smoothturn(math.pi)
			if destination == math.pi*2 then
				self.move_angle = math.pi
			end
			destination = self:closerAngle(self.move_angle, math.pi)
			self.vel = self.max_vel
			thrusting = true
		end
		if love.keyboard.isDown('right') then
			--self:smoothturn(0)
			if destination == math.pi then
				self.move_angle = math.pi*2
			end
			destination = self:closerAngle(self.move_angle, math.pi*2)
			self.vel = self.max_vel
			thrusting = true
		end
		if love.keyboard.isDown('down') then
			--self:smoothturn(math.pi*(3/2))
			if destination == math.pi/2 then
				self.move_angle = math.pi*(3/2)
			end
			destination = self:closerAngle(self.move_angle, math.pi*(3/2))
			self.vel = self.max_vel
			thrusting = true
		end
		if love.keyboard.isDown('up') then
			--self:smoothturn(math.pi/2)
			if destination == math.pi*(3/2) then
				self.move_angle = math.pi/2
			end
			destination = self:closerAngle(self.move_angle, math.pi/2)
			self.vel = self.max_vel
			thrusting = true
		end
		if love.keyboard.isDown('up') and love.keyboard.isDown('right') then
			--self:smoothturn(math.pi/4)
			destination = self:closerAngle(self.move_angle, math.pi/4)
			self.vel = self.max_vel
			thrusting = true
		end
		if love.keyboard.isDown('up') and love.keyboard.isDown('left') then
			--self:smoothturn(math.pi*(3/4))
			destination = self:closerAngle(self.move_angle, math.pi*(3/4))
			self.vel = self.max_vel
			thrusting = true
		end
		if love.keyboard.isDown('down') and love.keyboard.isDown('right') then
			--self:smoothturn(math.pi*(7/4))
			destination = self:closerAngle(self.move_angle, math.pi*(7/4))
			self.vel = self.max_vel
			thrusting = true
		end
		if love.keyboard.isDown('down') and love.keyboard.isDown('left') then
			--self:smoothturn(math.pi*(5/4))
			destination = self:closerAngle(self.move_angle, math.pi*(5/4))
			self.vel = self.max_vel
			thrusting = true
		end

		if thrusting then
			self.particles:setLinearAcceleration(0,100,0,0)
		else
			self.particles:setLinearAcceleration(0,20,0,0)
		end

		if self.isJumping == true then
			self.jumptimer = self.jumptimer + dt
			self.vel = 1800
			self.invul = true
			if self.jumptimer > 0.2 then
				self.invul = false
				self.isJumping = false
				self.jumptimer = 0
				self.vel = max_vel
			end
		end

		if love.keyboard.isDown('x') or not love.keyboard.isDown('z') then
			self.draw_angle = self.move_angle
		end

		self.y = self.y - math.sin(self.move_angle)*self.vel*dt
		self.x = self.x + math.cos(self.move_angle)*self.vel*dt
	else
		self:bounce(dt)
		self.b_timer = self.b_timer - dt
		if self.b_timer <= 0 then
			self.bouncing = false
			self.vel = 0
		end
	end

	if self.x < 1 then
		self.x = 1
	end

	if self.y < 1 then
		self.y = 1
	end

	if self.x > (swidth - self.width) then
		self.x = (swidth - self.width)
	end

	if self.y > (sheight - self.height) then
		self.y = (sheight - self.height)
	end

	self.hb_1[1] = self.x + 18.5 * math.cos(self.draw_angle)
	self.hb_1[2] = self.y - 18.5 * math.sin(self.draw_angle)

	self.hb_2[1] = self.x - 10.5 * math.cos(self.draw_angle)
	self.hb_2[2] = self.y + 10.5 * math.sin(self.draw_angle)

	self.flash_timer = self.flash_timer + dt

	if love.keyboard.isDown('z') then
		if firable then
			self:fire()
		end
	end
	--self.thrusters = {-11,17,1,21,13,17}
end

function Player:easeOutCubic(t, b, c, d)
	local t1 = t / d
	t1 = t1 - 1
	return c*(t1*t1*t1 + 1) + b
end

function Player:smoothturn()
	local factor = self:easeOutCubic(t_timer, 0, 1, 5)
	self.move_angle = self.move_angle + (destination - self.move_angle) * factor
	--print(t_timer)
end

--Finds the closest angle multiple of the target angle to the current angle.
--Basically, this returns the target angle +/- whatever multiple of 2*pi
--will result in the least amount of rotation from the current angle.
function Player:closerAngle(current, target)
	local var = (current - target) / (math.pi*2)

	if (math.abs(current - (target + (math.pi*2)*math.floor(var))) <
	math.abs(current - (target + (math.pi*2)*math.ceil(var)))) then
		clockwise = false
		return target + (math.pi*2)*math.floor(var)
	else
		clockwise = true
		return target + (math.pi*2)*math.ceil(var)
	end
end

function Player:draw()
	--transform the angle so it works with love.draw()
	local love_angle = math.pi/2 - self.draw_angle
	if self.damaged then
		Object.draw(self,155,155,155, love_angle)
	else
		if self.invul then
			Object.draw(self,255,255,0, love_angle)
		elseif self.bouncing then
			Object.draw(self,30,144,255, love_angle)
		else
			Object.draw(self,255,255,255, love_angle)
		end
	end
	--Draw particle thrusters. Right now they're always on.
	--We're using the built-in LOVE rotation in graphics.draw() to rotate them,
	--which honestly might be more trouble than it's worth. The origin offsets
	--are all magic numbers that I basically just tweaked until they worked.
	love.graphics.draw(self.particles, self.x, self.y, love_angle, 1, 1, -11, -15)
	love.graphics.draw(self.particles, self.x, self.y, love_angle, 1, 1, 1, -19)
	love.graphics.draw(self.particles, self.x, self.y, love_angle, 1, 1, 13, -15)
end

function Player:keyreleased(key)
	if key == 'i' then
		self:toggleInvul()
	end

	if key == 'c' then
		self:useBomb()
	end

	if key == ' ' then
		self:useJump()
	end

	if key == '1' then
		if self.missile == false then
			missile_arm:play()
		else
			laser_arm:play()
		end
		self:weaponSelect()
	end
end

function Player:keypressed(key)
	if key == 'left' or key == 'right' or key == 'up' or key == 'down' then
		t_timer = 0
	end
end

--Changes the player's angle based on the direction passed in.
--Passing in 1 increases the angle (turns left) and -1 decreases
--the angle (turns right).
function Player:turn(direction)
	if direction == 1 or direction == -1 then
		self.ang_vel = math.pi * direction
	end
end

function Player:fire()
	f_timer = 0

	local missile_delay = 0.8
	if self.double == true then
		missile_delay = 0.5
	end

	if self.missile then
		if self.missile_fire_timer > missile_delay then
			local m = Missile(self.hb_1[1], self.hb_1[2], 600, self.draw_angle)
			table.insert(objects, m)
			pew:play()
			self.missile_fire_timer = 0
		end
	elseif self.double then
		--code
		local b1 = Bullet(self.hb_1[1] + 10*math.sin(self.draw_angle), self.hb_1[2] + 10*math.cos(self.draw_angle), 600, self.draw_angle) --magic numbers errywhere
		local b2 = Bullet(self.hb_1[1] - 10*math.sin(self.draw_angle), self.hb_1[2] - 10*math.cos(self.draw_angle), 600, self.draw_angle) --magic numbers errywhere
		table.insert(objects, b1)
		table.insert(objects, b2)
		pew:play()
	else
		local b = Bullet(self.hb_1[1], self.hb_1[2], 600, self.draw_angle) --magic numbers errywhere
		table.insert(objects, b)
		pew:play()
	end
end

function Player:weaponSelect()
	self.missile = not self.missile
end

function Player:useJump()
	if self.isJumping == false then

		if self.h_jump == 0 then
			error:play()
		else
			jump:play()
			self.vel = 40
			self.h_jump = self.h_jump - 1
			self.isJumping = true
		end
	end
end

function Player:useBomb()
	if self.bomb == 0 then
		error:play()
	else
		self.bomb = self.bomb - 1
		bombblast:play()

		local length = table.getn(objects)
		-- loop through objects and remove enemies close to player
		for i = 0, length - 1 do
			local o = objects[length - i]
		  if (o:getX() > self.x - width/2 or o:getX() < self.x + width/2) and
			(o:getY() > self.y - height/2 or o:getY() < self.y + height/2) and
			(o:getID() == 1) then
				if o:getType() ~= 'b' then
				o:setDead()
				end
			end
			self.bomb_flash = true
			self.flash_timer = 0
		end
	end
end

function Player:toggleInvul()
	self.invul = not self.invul
	self.i_timer = 0
end

function Player:getHitBoxes( ... )
	local hb = {}
	table.insert(hb, self.hb_1)
	table.insert(hb, self.hb_2)

	return hb
end

function Player:explode()
	if self.exploded == false and self.current_state == 2 then
		--TODO: make uncollidable somehow?
		self.exploded = true
	end
end

function Player:setHitBoxes(x1, y1, x2, y2)
	self.hb_1[1] = x1
	self.hb_1[2] = y1

	self.hb_2[1] = x2
	self.hb_2[2] = y2
end

function Player:getX()
	return self.x
end

function Player:getY()
	return self.y
end

function Player:setX(newX)
	self.x = newX
end

function Player:setY(newY)
	self.y = newY
end

function Player:getWidth()
	return self.width
end

function Player:getHeight()
	return self.height
end

function Player:hit()
	if not (self.invul or self.damaged) then
		self.health = self.health - 1
		if self:alive() then
			self.damaged = true
			self.d_timer = 0
		end
		playerhit:play()
	end
end

function Player:alive()
	return self.health > 0
end

function Player:getHealth()
	return self.health
end

function Player:getBomb()
	return self.bomb
end

function Player:getJump()
	return self.h_jump
end

function Player:flash()
	return self.bomb_flash
end

function Player:getFlashTimer()
	return self.flash_timer
end

function Player:collide(obj)
	-- enemy
	if obj:getID() == 1 or obj:getID() == 6 then
		self:hit()
		if not self:alive() then
			self.dead = true
		end
	-- powerup
	elseif obj:getID() == 5 then
		if obj:getType() == 'ds' then
			self.double = true
		elseif obj:getType() == 'r' then
			self.health = self.health + 2
		elseif obj:getType() == 'sp' then
			self.max_vel = self.max_vel + 100
		end
	-- wormhole
	elseif obj:getID() == 7 then
		if self.teleporttimer > 1 then
			self.teleporttimer = 0
			self.x, self.y = obj:teleport()
			teleport:play()
		end
		-- love.timer.sleep(0.2)
	elseif obj:getID() == 8 then
		bump:play()
		ox = obj:getX()
		oy = obj:getY()
		if obj:isVertical() then
			if ox < self.x then
				self.b_angle = 0
			else
				self.b_angle = math.pi
			end
		else
			if oy < self.y then
				self.b_angle = math.pi/2
			else
				self.b_angle = math.pi*(3/2)
			end
		end
		self.bouncing = true
		self.b_timer = .2
	elseif obj:getID() == 9 then
		self.winner = true
	end
end

function Player:bounce(dt)
	if self.isJumping then
		self.invul = false
		self.isJumping = false
		self.jumptimer = 0
		self.vel = self.max_vel
	end
	self.vel = self.vel + 2000 * dt
	self.x = self.x + self.vel * dt * math.cos(self.b_angle)
	self.y = self.y + self.vel * dt * math.sin(self.b_angle)
end

function Player:isDamaged()
	return self.damaged
end

function Player:enterFrame(x,y)
	self.camera_x, self.camera_y = -x, -y
	inframe = true
end

function Player:isInFrame()
	return inframe
end

function Player:getFrameCoordinates()
	return self.camera_x, self.camera_y
end

-- add boosters to ships
function Player:intitializeThrusters()
	self.particles:setParticleLifetime(0.3, 0.7)
	self.particles:setEmissionRate(40)
	self.particles:setSizeVariation(1)
	self.particles:setLinearAcceleration(0, 100, 0, 200)
	self.particles:setColors(255, 255, 160, 255, 255, 0, 0, 100)
end

return Player
