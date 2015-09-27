State = require("State")

local Win = {name = "YOU DID IT BROH", bonus = "SCORE +3000", 
help = "Press any key to return to menu"}
Win.__index = Win

setmetatable(Win, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Win:load()
	self.font = love.graphics.newFont("ka1.ttf", 74)
	self.namewidth = self.font:getWidth(self.name)
	self.nameheight = self.font:getHeight(self.name)
	
	self.fontsmall = love.graphics.newFont("PressStart2P.ttf", 30)
	self.bonuswidth = self.font:getWidth(self.name)
	self.bonusheight = self.font:getHeight(self.name)
	
	self.fontsmaller = love.graphics.newFont("PressStart2P.ttf", 12)
	
	victory = love.audio.newSource("sfx/win.ogg")
	victory:setLooping(false)
end

--- Center small inside large.
function center(large, small)
	return large/2 - small/2
end

function Win:update(dt)
	self.time = self.time + dt
end

function Win:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(
		self.name,
		center(width, self.namewidth), center(height, self.nameheight)
	)
	
	love.graphics.setFont(self.fontsmall)
	love.graphics.print(
		self.bonus,
		center(width, self.bonuswidth), center(height, self.bonusheight) + 100
	)
	
	if self.time > 2 then
		love.graphics.setFont(self.fontsmaller)
		love.graphics.print(
		self.help,
		10, height - 10
		)
	end
end

function Win:keyreleased(key)
	if self.time > 2 then
		switchTo(ScoreScreen)
	end
end

function Win:start()
	victory:play()
	self.time = 0
end

function Win:stop()

end

return Win