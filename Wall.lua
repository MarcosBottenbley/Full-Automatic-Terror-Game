--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Object = require("Object")

local Wall = {
	img = 'gfx/fence.png',
	frames = 3, states = 1,
	delay = 0.1,
	x = 10, y = 10,
	width = 180, height = 18,
	id = 8
}
Wall.__index = Wall

setmetatable(Wall, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Wall:_init(x,y,w,h,horizontal)
	self.x = x
	self.y = y
	self.width = w
	self.height = h

	Object._init(self, x, y,
		self.img,
		self.width,
		self.height,
		self.frames,
		self.states,
		self.delay)

	self.validCollisions = {2}
	self.hb = self:makeHitboxes()
end

function Wall:load()
	Object.load(self)
end

function Wall:update(dt)
	-- body
	Object.update(self,dt)
end

function Wall:getHitBoxes( ... )
	return self.hb
end

function Wall:makeHitboxes(...)
	local hb = {}
	if self.width > self.height then
		local num = self.width / self.height
		for i = 1, math.floor(num) do
			local offset = (self.height * i) - (self.height/2) - self.width/2
			local hb_1 = {self.x + offset, self.y, self.height/2}
			table.insert(hb, hb_1)
		end
	elseif self.height > self.width then
		local num = self.height / self.width
		for i = 1, math.floor(num) do
			local offset = (self.width * i) - (self.width/2)
			local hb_1 = {self.x, self.y + offset, self.width/2}
			table.insert(hb, hb_1)
		end
	else
	  local hb_1 = {self.x, self.y, self.width/2}
		table.insert(hb, hb_1)
	end

	return hb
end

function Wall:draw(...)
	-- body
	Object.draw(self,255,255,255,0)
end

return Wall
