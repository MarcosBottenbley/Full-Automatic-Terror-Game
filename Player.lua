Object = require("Object")
math.randomseed(os.time())

local Player = {
	vel = 200
}
Player.__index = Player

setmetatable(Player, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Player:_init(x, y, w, h, v, sprite)
	Object._init(self, x, y, w, h)
	self.vel = v
	self.sprite = sprite
end

function Player:update(dt, swidth, sheight)
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

		if self.x > (swidth - self.width) and not once_r then
			blip:play()
			once_r = true
		elseif once_r and self.x <= (swidth - self.width) then
			once_r = false
		end

		if self.x > (swidth - self.width) then
			self.x = (swidth - self.width)
		end
	end

	if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
		self.y = self.y + self.vel*dt

		if self.y > (sheight - self.height) and not once_d then
			blip:play()
			once_d = true
		elseif once_d and self.y <= (sheight - self.height) then
			once_d = false
		end

		if self.y > (sheight - self.height) then
			self.y = (sheight - self.height)
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

function Player:draw()
	if self.sprite ~= nil then
		love.graphics.draw(self.sprite, self.x, self.y)
	else
		love.graphics.setColor(0,255,0,255)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		love.graphics.setColor(255,255,255,255)
	end
end

return Player