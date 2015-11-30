--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Object = require("Object")

local SpaceGoo = {
	img = 'gfx/goo.png',
	frames = 3, states = 1,
	delay = 0.1,
	x = 10, y = 10,
	width = 20, height = 20,
	bounding_rad = 20,
	id = 14, vertical = false
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

--post dimentions is 20X20
--vert fence dims are 18X180
--hori fence dims are 180X18
function SpaceGoo:_init(x,y)
	self.x = x
	self.y = y

	Object._init(self, x, y,self.img,self.width,self.height,self.frames,self.states,self.delay)

	self.validCollisions = {2}
	self.hb = self:makeHitboxes()
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
	return self.hb
end


function SpaceGoo:draw(...)
	-- body
	Object.draw(self,255,255,255,self.angle)

	--draw circle to represent point that Game checks to see if it should draw
	--the SpaceGoo or not

	-- love.graphics.setColor(0, 0, 255, 255)
	-- if self.vertical then
		-- love.graphics.circle("fill", self.x + self.height/2, self.y + self.width/2, 10, 100)
	-- else
		-- love.graphics.circle("fill", self.x + self.width/2, self.y + self.height/2, 10, 100)
	-- end
	-- love.graphics.setColor(255, 255, 255, 255)
end

return SpaceGoo
