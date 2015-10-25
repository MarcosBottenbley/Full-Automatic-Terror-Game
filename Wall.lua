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
	x = 10, y = 10,
	width = 30, height = 30,
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

	self.validCollisions = {2}
	self.hb = self:makeHitboxes()
end

function Wall:update(dt)
	-- body
end

function Wall:getHitBoxes( ... )
	return self.hb
end


function Wall:makeHitboxes(...)
	local hb = {}
	if self.width > self.height then
		local num = self.width / self.height
		for i = 1, math.floor(num) do
			local offset = (self.height * i) - (self.height/2)
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
	Object.draw(self,255,255,255,self.angle)
end

return Wall