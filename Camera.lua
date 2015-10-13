--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local Camera = {
	x = 0, y = 0,
	pw = 0, ph = 0,
	bgw = 0, bgh = 0,
	shake_range = 0
}
Camera.__index = Camera

setmetatable(Camera, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

--- starting camera position, player in center

function Camera:_init(player_width, player_height, bg_width, bg_height)
	-- initial position
	self.x = 0
	self.y = 0
	-- player sprite
	self.pw = player_width
	self.ph = player_height
	-- background
	self.bgw = bg_width
	self.bgh = bg_height
	-- shake range
	self.shake_range = 2
end

--- automatic camera position adjustment based on player
--- position relative to background

function Camera:move()
	local x, y = -1, -1

	if (self.x <= width/2) then x = 0 end
	if (self.y <= height/2) then y = 0 end

	if (self.x >= self.bgw - width/2 - self.pw) then
		x = -self.bgw + width + self.pw end
	if (self.y >= self.bgh - height/2 - self.ph) then
		y = -self.bgh + height + self.ph end

	if (x == -1) then x = -self.x + width/2 end
	if (y == -1) then y = -self.y + height/2 end

	return x, y
end

function Camera:shake()
	local x, y = self:move()
	local shake_amt = love.math.random(-self.shake_range, self.shake_range)

	return (x + shake_amt), (y + shake_amt)
end
--- manual camera adjustment to a set location

function Camera:position(px, py)
	self.x = px
	self.y = py
end

function Camera:setShake(shake_amt)
	self.shake_range = shake_amt
end

return Camera
