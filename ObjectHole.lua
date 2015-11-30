--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Object = require("Object")
GlowBorg = require("GlowBorg")

local playerx = 0
local playery = 0
local e

local ObjectHole = {
	x = 10, y = 10,
	width = 80, height = 80,
	id = 10, img = "gfx/wormhole.png",
	frames = 9, states = 1,
	delay = 0.06, sprites = {},
	type = 'g', spawntimer = 0
}
ObjectHole.__index = ObjectHole

setmetatable(ObjectHole, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ObjectHole:_init(x,y,t)
	Object._init(self, x, y, 
				self.img, 
				self.width, 
				self.height, 
				self.frames, 
				self.states, 
				self.delay)
	
	self.type = t
	self.validCollisions = {-1}
end

--takes background dimensions as arguments but doesn't use them
--(avoids unnecessary code in game:update)
function ObjectHole:update(dt)
	Object.update(self, dt)
	self.spawntimer = self.spawntimer + dt
	if self.spawntimer > 1 then
		if self.type == 'g' then
			e = GlowBorg()
		elseif self.type == 'c' then
			e = CircleBorg()
		elseif self.type == 'f' then
			e = PhantomShip()
		elseif self.type == 'd' then
			e = DualMaster()
		elseif self.type == 't' then
			e = Turret(self.x, self.y, 0, 360)
		elseif self.type == 's' then
			e = ScaredBorg()
		elseif self.type == 'b' then
			e = SunBoss2()
		else
			e = GlowBorg()
		end

		e:setPosition(self.x, self.y)
		
		table.insert(objects, e)
		self.dead = true
	end
end

function ObjectHole:draw()
	Object.draw(self, 200, 0, 200)
end

return ObjectHole