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
		
		if self.x < 1 and not once_l then
			blip:play()
			once_l = true
		elseif once_l and self.x >= 1 then
			once_l = false
		end
		
		if self.x < 1 then
			self.x = 1
		end
	end

	if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
		self.x = self.x+self.vel*dt
		
		if self.x > (width - self.width) and not once_r then
			blip:play()
			once_r = true
		elseif once_r and self.x <= (width - self.width) then
			once_r = false
		end

		if self.x > (width - self.width) then
			self.x = (width - self.width)
		end
	end

	if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
		self.y = self.y + self.vel*dt
		
		if self.y > (height - self.height) and not once_d then
			blip:play()
			once_d = true
		elseif once_d and self.y <= (height - self.height) then
			once_d = false
		end

		if self.y > (height - self.height) then
			self.y = (height - self.height)
		end
	end

	if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
		self.y = self.y-self.vel*dt
		
		if self.y < 1 and not once_u then
			blip:play()
			once_u = true
		elseif once_u and self.y >= 1 then
			once_u = false
		end

		if self.y < 1 then
			self.y = 1
		end
	end
end

function Player:draw(player_sprite)
	love.graphics.draw(player_sprite, self.x, self.y)
end

return Player