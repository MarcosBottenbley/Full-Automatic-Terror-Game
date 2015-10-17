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

local Player = {
	vel = 0, max_vel = 200,
	accel = 0, max_accel = 800,
	img = "gfx/main_ship_sheet.png",
	width = 42, height = 57,
	frames = 5, states = 2,
	delay = 0.12, sprites = {},
	id = 2, collided = false,
	bounding_rad = 25, angle1 = 0,
	ang_vel = 0, double = false,
	health = 5, bomb = 3, invul = false,
	d_timer = 0, damaged = false,
	i_timer = 0, missile = false,
	bomb_flash = false, flash_timer = .6
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
	self.double = false

	self.hb_1 = {self.x, self.y - 18.5, 10}
	self.hb_2 = {self.x, self.y + 10.5, 19}

	self.validCollisions = {1,3}
end

function Player:load()
	Object.load(self)
	pew = love.audio.newSource("sfx/pew.ogg")
	pew:setLooping(false)
	playerhit = love.audio.newSource("sfx/playerhit.ogg")
	playerhit:setLooping(false)
end

function Player:update(dt, swidth, sheight)
	Object.update(self,dt)

	if self.flash_timer > .58 then
		self.bomb_flash = false
	end

	if self.damaged then
		self.d_timer = self.d_timer + dt
	end

	if self.d_timer > 0.2 then
		self.damaged = false
		self.d_timer = 0
	end

	if self.health < 1 then
		self.collided = true
	end

	if self.invul then
		self.i_timer = self.i_timer + dt
	end

	if self.i_timer > .25 then
		self.i_timer = 0
	end

	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		self.ang_vel = -math.pi * dt
		self.angle1 = self.angle1 + self.ang_vel
	elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
		self.ang_vel = math.pi * dt
	 	self.angle1 = self.angle1 + self.ang_vel
	end

	--is the player moving
	local moving = false

	--get acceleration (if not moving, accelerate opposite velocity)
	if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
	 	self.accel = -self.max_accel
		moving = true
	elseif love.keyboard.isDown('up') or love.keyboard.isDown('w') then
		self.accel = self.max_accel
		moving = true
	elseif self.vel > 0 then
		self.accel = -self.max_accel
	elseif self.vel < 0 then
		self.accel = self.max_accel
	else
		self.accel = 0
	end

	--accelerate (not past max velocity)
	if (self.accel >= 0 and self.vel < self.max_vel) or
		(self.accel <= 0 and self.vel > -self.max_vel) then
		self.vel = self.vel + self.accel * dt
	end

	--stop player from moving back and forth when not pressing up/down
	if math.abs(self.vel) < self.max_vel / 10 and not moving then
		self.vel = 0
	end

	self.y = self.y - math.sin(math.pi/2 - self.angle1)*self.vel*dt
	self.x = self.x + math.cos(math.pi/2 - self.angle1)*self.vel*dt

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

	self.hb_1[1] = self.x + 18.5 * math.sin(self.angle1)
	self.hb_1[2] = self.y - 18.5 * math.cos(self.angle1)

	self.hb_2[1] = self.x - 10.5 * math.sin(self.angle1)
	self.hb_2[2] = self.y + 10.5 * math.cos(self.angle1)

	self.flash_timer = self.flash_timer + dt
end

function Player:draw()
	if self.damaged then
		Object.draw(self,155,155,155, self.angle1)
	else
		if self.i_timer > 0.125 then
			Object.draw(self,255,255,0, self.angle1)
		else
			Object.draw(self,255,255,255, self.angle1)
		end
	end
end

function Player:keyreleased(key)
	if key == 'z' then
		pew:play()
		if self.missile then
			local m = Missile(self.hb_1[1], self.hb_1[2], 600, self.angle1)
			table.insert(objects, m)
		elseif self.double then
			--code
			local b1 = Bullet(self.hb_1[1] + 10*math.cos(self.angle1), self.hb_1[2] + 10*math.sin(self.angle1), 600, self.angle1) --magic numbers errywhere
			local b2 = Bullet(self.hb_1[1] - 10*math.cos(self.angle1), self.hb_1[2] - 10*math.sin(self.angle1), 600, self.angle1) --magic numbers errywhere
			table.insert(objects, b1)
			table.insert(objects, b2)
		else
			local b = Bullet(self.hb_1[1], self.hb_1[2], 600, self.angle1) --magic numbers errywhere
			table.insert(objects, b)
		end

	end

	if key == 'left' or key == 'right' then
		self.ang_vel = 0
	end

	if key == 'i' then
		self.invul = not self.invul
		self.i_timer = 0
	end

	if key == 'b' then
		-- if self.exploded == true then
		-- end
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
				  	table.remove(objects, length - i)
						self.bomb_flash = true
						self.flash_timer = 0
					end
				end
			end

		end
	end

	if key == '1' then
		self.missile = false
	end

	if key == '2' then
		self.missile = true
	end
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
	if not self.invul then
		self.health = self.health - 1
	end
	if self:alive() then
		self.damaged = true
		self.d_timer = 0
	end
	playerhit:play()
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

function Player:flash()
	return self.bomb_flash
end

return Player
