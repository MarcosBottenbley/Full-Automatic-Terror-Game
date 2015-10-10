--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local Camera = {
	x = 0, y = 0
}
Camera.__index = Camera

setmetatable(Camera, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Camera:_init()
	self.x = 0
	self.y = 0
end

function Camera:move()
	local x, y = -1, -1

	if (self.x <= width/2) then x = 0 end
	if (self.y <= height/2) then y = 0 end
	if (self.x >= bg_width - width/2) then x = -bg_width + width end
	if (self.y >= bg_height - height/2) then y = -bg_height + height end

	if (x == -1) then x = -self.x + width/2 end
	if (y == -1) then y = -self.y + height/2 end

	return x, y
end

function Camera:position(px, py)
	self.x = px
	self.y = py
end

return Camera
