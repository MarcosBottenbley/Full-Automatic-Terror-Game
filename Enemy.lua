local Enemy = {
	x = 10, y = 10,
	vx = 20, vy = 20,
	r = 10
}
Enemy.__index = Enemy

setmetatable(Enemy, {
	__call = function (cls, ...)
		return cls.new(...)
	end,
})

function Enemy.new(x, y, v)
	local self = setmetatable({}, Enemy)
	self.x = x
	self.y = y
	self.vx = v
	self.vy = v

	return self
end

function Enemy:draw()
	love.graphics.draw(
		enemy_sprite, 
		self.x, self.y, 
		0, 
		.5, .5, 
		enemy_width/2, enemy_width/2
	)
end

function Enemy:update(dt)
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

	if self.x < enemy_width/4 or self.x > width-enemy_width/4 then
		self:bounce(1)
	end

	if self.y < enemy_height/4 or self.y > height-enemy_height/4 then
		self:bounce(0)
	end
end

function Enemy:direction()
	if math.floor(math.random(0,2)) == 1 then
		self:bounce(1)
	end
end

function Enemy:bounce(side)
	if side == 1 then
		self.vx = -self.vx
	else
		self.vy = -self.vy
	end
end

return Enemy