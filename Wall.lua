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
	id = 8, connector = false,
	angle = 0
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

function Wall:_init(x,y,w,h,angle)
	self.x = x
	self.y = y
	self.width = w
	self.height = h

	if w ~= h then
		self.connector = true
	end

	self.angle = angle

end

function Wall:getHitBoxes( ... )
	local hb = {}

	if self.connector then
		local num = self.width / self.height
		for i = 1, i < num do
			local hb_1 = {self.x, self.y, self.height/2}
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