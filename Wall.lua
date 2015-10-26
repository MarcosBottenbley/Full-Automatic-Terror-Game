--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local w
local h

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

function Wall:_init(x,y,width,height)
	self.x = x
	self.y = y

	w = width
	h = height

	if width > height then
		self.width = width
		self.height = height
		self.angle = math.pi
	else
		self.width = height
		self.height = width
		self.angle = math.pi/2
	end

	
	Object._init(self, x, y,self.img,self.width,self.height,self.frames,self.states,self.delay)

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
	if w > h then
		local num = w / h
		for i = 1, math.floor(num) do
			local offset = (h * i) - (h/2) - w/2
			local hb_1 = {self.x + offset, self.y, h/2}
			table.insert(hb, hb_1)
		end
	elseif h > w then
		local num = h / w
		for i = 1, math.floor(num) do
			local offset = (w * i) - (w/2)
			local hb_1 = {self.x, (self.y + offset) - h/2, w/2}
			table.insert(hb, hb_1)
		end
	else
	  local hb_1 = {self.x, self.y, w/2}
		table.insert(hb, hb_1)
	end

	return hb
end

function Wall:draw(...)
	-- body
	Object.draw(self,255,255,255,self.angle)
end

return Wall
