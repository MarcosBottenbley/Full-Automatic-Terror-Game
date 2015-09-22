Object = require("Object")
math.randomseed(os.time())

local Player = {
	vel = 200,
	img = "gfx/main_ship_sheet.png",
	width = 54, height = 70,
	frames = 5, states = 1,
	delay = 0.08, sprites = {}
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

function Player:_init(x, y, v)
	Object._init(self, x, y, 0, 
		self.img, 
		self.width,
		self.height,
		self.frames,
		self.states,
		self.delay)

	self.vel = v
end

function Player:update(dt, swidth, sheight)
	Object.update(self,dt)
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
	Object.draw(self,0,255,0)
end

return Player