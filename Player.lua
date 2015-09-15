local Player = {
	x = 10, y = 10,
	width = 10, height = 10,
	vel = 10
}
Player.__index = Player

setmetatable(Player, {
	__call = function (cls, ...)
		return cls.new(...)
	end,
})

function Player.new(x, y, w, h, v)
	local self = setmetatable({}, Player)
	self.x = x
	self.y = y
	self.width = w
	self.height = h
	self.vel = v

	return self
end

function Player:update(dt)
	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		self.x = self.x-self.vel*dt

		if self.x < 1 then
			self.x = 1
			blip:play()
		end
	end

	if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
		self.x = self.x+self.vel*dt

		if self.x > (width - self.width) then
			self.x = (width - self.width)
			blip:play()
		end
	end

	if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
		self.y = self.y + self.vel*dt

		if self.y > (height - self.height) then
			self.y = (height - self.height)
			blip:play()
		end
	end

	if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
		self.y = self.y-self.vel*dt

		if self.y < 1 then
			self.y = 1
			blip:play()
		end
	end
end

function Player:draw(player_sprite)
	love.graphics.draw(player_sprite, self.x, self.y)
end

return Player