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

local Enemy = {
	vx = 10, vy = 10,
	sprites = {},
	id = 1, collided = false
}
Enemy.__index = Enemy

setmetatable(Enemy, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Enemy:load()
	Object.load(self)
	boom = love.audio.newSource("sfx/explode.ogg")
	boom:setLooping(false)
end

--- calls object initialization, sets position, speed, states, and other
--- enemy details

function Enemy:_init(x, y, v, img, width, height, frames, states, delay)
	self.vx = v
	self.vy = v
	Object._init(self, x, y, img, width, height, frames, states, delay)
	self.validCollisions = {2,3}
end

function Enemy:draw()
	Object.draw(self,255,255,255)
end

--- called if an enemy dies, reduces speed and then explodes

function Enemy:update(dt, swidth, sheight)
	Object.update(self, dt)

	if self.x < 1 then
		self.vx = math.abs(self.vx)
	end

	if self.x > swidth-self.width then
		self.vx = -1 * math.abs(self.vx)
	end

	if self.y < 1 then
		self.vy = math.abs(self.vy)
	end

	if self.y > sheight-self.height then
		self.vy = -1 * math.abs(self.vy)
	end

	--if self.inbombrange() and player.keyreleased('b') and player.bomb > 0 then
	--	self:explode()
	--end
	
	self:explode()
end

--- reverses enemy direction in either x or y direction
--- at random, maintains velocity

function Enemy:bounce(side)
	if side == 1 then
		self.vx = -self.vx
	else
		self.vy = -self.vy
	end
end

--- decides whether bounce reverses x or y velocity

function Enemy:direction()
	if math.random(0,2) <= 1 then
		if math.random(0,2) >= 1 then
			self:bounce(0)
		else
			self:bounce(1)
		end
	end
end

--- on enemy death, increases score or sets boolean 
--- of exploded to true

function Enemy:explode()
	if self.exploded == false and self.current_state == 2 then
		--score = score + 200
		boom:play()
		--TODO: make uncollidable somehow?
		self.exploded = true
	end
end

--- manually moves an enemy to a set position

function Enemy:setPosition(x, y)
	self.x = x
	self.y = y
end

function Enemy:getX()
	return self.x
end

function Enemy:getY()
	return self.y
end

--- determines if an enemy is on the player’s screen (bomb range)

--function Enemy:inbombrange()
	-- we need the player’s current location
	--local px = player.getX()
	--local py = player.getY()
	--if self.distanceFrom(px, py) < 300 then
	--	return true
	--end
--end

function Enemy:distanceFrom(x, y)
	return math.sqrt((x - self.x)^2 + (y - self.y)^2)
end

function Enemy:collide(obj)
	print("DESTROYED")
	self.dead = true
	self.validCollisions = {}
end

return Enemy
