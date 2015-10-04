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
	vel = 100,
	img = "gfx/main_ship_sheet.png",
	width = 42, height = 57,
	frames = 5, states = 2,
	delay = 0.08, sprites = {},
	id = 2, collided = false,
	bounding_rad = 25, angle1 = 0,
	ang_vel = 0
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

	self.vel = v

	self.hb_1 = {self.x, self.y - 18.5, 10}
	self.hb_2 = {self.x, self.y + 10.5, 19}
end

function Player:load()
	Object.load(self)
	pew = love.audio.newSource("sfx/pew.ogg")
	pew:setLooping(false)
end

function Player:update(dt, swidth, sheight)
	Object.update(self,dt)

	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		--self.x = self.x-self.vel*dt
		self.ang_vel = -math.pi * dt
		self.angle1 = self.angle1 + self.ang_vel
	elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
	 	--self.x = self.x+self.vel*dt
		self.ang_vel = math.pi * dt
	 	self.angle1 = self.angle1 + self.ang_vel
	end


	targetx1 = math.cos(self.ang_vel) * (self.hb_1[1] - self.x) - math.sin(self.ang_vel) * (self.hb_1[2] - self.y) + self.x
	targety1 = math.sin(self.ang_vel) * (self.hb_1[1] - self.x) + math.cos(self.ang_vel) * (self.hb_1[2] - self.y) + self.y

	targetx2 = math.cos(self.ang_vel) * (self.hb_2[1] - self.x) - math.sin(self.ang_vel) * (self.hb_2[2] - self.y) + self.x
	targety2 = math.sin(self.ang_vel) * (self.hb_2[1] - self.x) + math.cos(self.ang_vel) * (self.hb_2[2] - self.y) + self.y

	self.hb_1[1] = targetx1
	self.hb_1[2] = targety1

	self.hb_2[1] = targetx2
	self.hb_2[2] = targety2


	if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
	 	--self.y = self.y+self.vel*dt
	 	--[[self.y = self.y - (self.hb_1[2] - self.y) * dt
	 	self.x = self.x - (self.hb_1[1] - self.x) * dt

	 	self.hb_1[2] = self.hb_1[2] - ((self.y - self.height/2) - self.y) * dt
	 	self.hb_1[1] = self.hb_1[1] - ((self.y - self.height/2) - self.x) * dt

	 	self.hb_2[2] = self.hb_2[2] - (self.hb_1[2] - self.y) * dt
	 	self.hb_2[1] = self.hb_2[1] - (self.hb_1[1] - self.x) * dt--]]
		
		
		
		self.y = self.y + math.sin(math.pi/2 - self.angle1)*self.vel*dt
	 	self.x = self.x - math.cos(math.pi/2 - self.angle1)*self.vel*dt

	 	self.hb_1[2] = self.hb_1[2] + math.sin(math.pi/2 - self.angle1)*self.vel*dt
	 	self.hb_1[1] = self.hb_1[1] - math.cos(math.pi/2 - self.angle1)*self.vel*dt

	 	self.hb_2[2] = self.hb_2[2] + math.sin(math.pi/2 - self.angle1)*self.vel*dt
	 	self.hb_2[1] = self.hb_2[1] - math.cos(math.pi/2 - self.angle1)*self.vel*dt
	end
	if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
	 	--self.y = self.y-self.vel*dt
	 	--[[self.y = self.y + (self.hb_1[2] - self.y) * dt
	 	self.x = self.x + (self.hb_1[1] - self.x) * dt

	 	self.hb_1[2] = self.hb_1[2] + ((self.hb_1[2] + 30) - self.y) * dt
	 	self.hb_1[1] = self.hb_1[1] + ((self.hb_1[1] + 30) - self.x) * dt

	 	self.hb_2[2] = self.hb_2[2] + (self.hb_1[2] - self.y) * dt
	 	self.hb_2[1] = self.hb_2[1] + (self.hb_1[1] - self.x) * dt--]]
		
		self.y = self.y - math.sin(math.pi/2 - self.angle1)*self.vel*dt
	 	self.x = self.x + math.cos(math.pi/2 - self.angle1)*self.vel*dt

	 	self.hb_1[2] = self.hb_1[2] - math.sin(math.pi/2 - self.angle1)*self.vel*dt
	 	self.hb_1[1] = self.hb_1[1] + math.cos(math.pi/2 - self.angle1)*self.vel*dt

	 	self.hb_2[2] = self.hb_2[2] - math.sin(math.pi/2 - self.angle1)*self.vel*dt
	 	self.hb_2[1] = self.hb_2[1] + math.cos(math.pi/2 - self.angle1)*self.vel*dt
		
		
	end


	-- if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
	-- 	self.x = self.x-self.vel*dt
	--
	-- 	if self.x < 1 and not once_l then
	-- 		blip:play()
	-- 		once_l = true
	-- 	elseif once_l and self.x >= 1 then
	-- 		once_l = false
	-- 	end
	--
	-- 	if self.x < 1 then
	-- 		self.x = 1
	-- 	end
	--
	-- end
	--
	-- if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
	-- 	self.x = self.x+self.vel*dt
	--
	-- 	if self.x > (swidth - self.width) and not once_r then
	-- 		blip:play()
	-- 		once_r = true
	-- 	elseif once_r and self.x <= (swidth - self.width) then
	-- 		once_r = false
	-- 	end
	--
	-- 	if self.x > (swidth - self.width) then
	-- 		self.x = (swidth - self.width)
	-- 	end
	-- end
	--
	-- if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
	-- 	self.y = self.y + self.vel*dt
	--
	-- 	if self.y > (sheight - self.height) and not once_d then
	-- 		blip:play()
	-- 		once_d = true
	-- 	elseif once_d and self.y <= (sheight - self.height) then
	-- 		once_d = false
	-- 	end
	--
	-- 	if self.y > (sheight - self.height) then
	-- 		self.y = (sheight - self.height)
	-- 	end
	-- end
	--
	-- if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
	-- 	self.y = self.y-self.vel*dt
	--
	-- 	if self.y < 1 and not once_u then
	-- 		blip:play()
	-- 		once_u = true
	-- 	elseif once_u and self.y >= 1 then
	-- 		once_u = false
	-- 	end
	--
	-- 	if self.y < 1 then
	-- 		self.y = 1
	-- 	end
	-- end
end

function Player:draw()
	Object.draw(self,0,255,0, self.angle1)
end

function Player:keyreleased(key)
	if key == 'z' then
		pew:play()
		local b = Bullet(self.hb_1[1], self.hb_1[2], 600, self.angle1) --magic numbers errywhere
		table.insert(objects, b)
	end

	if key == 'left' or key == 'right' then
		self.ang_vel = 0
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

return Player
