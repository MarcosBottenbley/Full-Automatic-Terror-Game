math.randomseed(os.time())

local Object= {
	x = 10, y = 10,
	vx = 50, vy = 50,
	width = 10, height = 10,
	sprite = nil
}
Object.__index = Object

setmetatable(Object, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Object:_init(x, y, w, h, v, sprite)
	self.x = x
	self.y = y
	self.vx = v
	self.vy = v
	self.sprite = sprite

	self:setDim(w,h)
end

function Object:setDim(w,h)
	if self.sprite ~= nil then
		self.width = self.sprite:getWidth()
		self.height = self.sprite:getHeight()
	else
		self.width = w
		self.height = h
	end
end

function Object:update(dt, swidth, sheight)
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt
end

function Object:draw(r,g,b)
	if self.sprite ~= nil then
		love.graphics.draw(self.sprite, self.x, self.y)
	else
		if r ~= nil and g ~= nil and b ~= nil then
			love.graphics.setColor(r,g,b)
		else
			love.graphics.setColor(255,255,255,255)
		end
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	end
	love.graphics.setColor(255,255,255,255)
end

return Object