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

function Enemy:_init(x, y, v, img, width, height, frames, states, delay)
	self.vx = v
	self.vy = v
	Object._init(self, x, y, img, width, height, frames, states, delay)
end

function Enemy:draw()
	Object.draw(self,255,0,0)
end

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
	
	self:explode()
end

function Enemy:bounce(side)
	if side == 1 then
		self.vx = -self.vx
	else
		self.vy = -self.vy
	end
end

function Enemy:direction()
	if math.random(0,2) <= 1 then
		if math.random(0,2) >= 1 then
			self:bounce(0)
		else
			self:bounce(1)
		end
	end
end

function Enemy:explode()
	if self.exploded == false and self.current_state == 2 then
		--score = score + 200
		boom:play()
		--TODO: make uncollidable somehow?
		self.exploded = true
	end
end

return Enemy