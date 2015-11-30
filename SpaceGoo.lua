--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Object = require("Object")

local time = love.timer.getTime()

local SpaceGoo = {
	img = 'gfx/goo.png',
	frames = 1, states = 1,
	delay = 0.1,
	x = 10, y = 10,
	width = 32, height = 32,
	bounding_rad = 16,
	id = 14, vertical = false,
	health = 5
}
SpaceGoo.__index = SpaceGoo

setmetatable(SpaceGoo, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function SpaceGoo:_init(x,y)
	self.x = x
	self.y = y

	Object._init(self, x, y,self.img,self.width,self.height,self.frames,self.states,self.delay)

	self.validCollisions = {2,3}
end

function SpaceGoo:load()
	Object.load(self)
end

function SpaceGoo:update(dt)
	Object.update(self,dt)
end

function SpaceGoo:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

function SpaceGoo:isDead( ... )
	if self.health == 0 then
		return true
	end

	if math.floor(love.timer.getTime() - time) == 5 then
		return true
	end
end

function SpaceGoo:collide(obj)
	if obj:getID() == 3 and self.health > 0 then
		self.health = self.health - 1
		self.hit = true
	else
		self.hit = false
	end
end


function SpaceGoo:draw(...)
	if self.hit then
		Object.draw(self,115, 73, 35,self.angle)
	else
		Object.draw(self,250 + self.health,255,255,self.angle)
	end
end

return SpaceGoo
