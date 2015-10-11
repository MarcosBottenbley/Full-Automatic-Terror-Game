--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local SpatialSquare = {
	objects = {},
	neighbors = {}
}
SpatialSquare.__index = SpatialSquare

setmetatable(SpatialSquare, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function SpatialSquare:_init(x,y,width,height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
end

function

function SpatialSquare:getCoordinates()
	local coordiantes = {self.x, self.y}
end

function SpatialSquare:touching(obj1, obj2)

end