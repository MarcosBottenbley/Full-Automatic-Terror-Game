State = require("State")

local GameOver = {name = "GAME OVER BROH", 
help = "Press any key to continue"}
GameOver.__index = GameOver

setmetatable(GameOver, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function GameOver:load()
	self.font = love.graphics.newFont("ka1.ttf", 74)
	self.width = self.font:getWidth(self.name)
	self.height = self.font:getHeight(self.name)
	
	self.fontsmaller = love.graphics.newFont("PressStart2P.ttf", 12)
	
	lose = love.audio.newSource("sfx/lose.ogg")
	lose:setLooping(false)
end

--- Center small inside large.
function center(large, small)
	return large/2 - small/2
end

function GameOver:update(dt)
	self.time = self.time + dt
end

function GameOver:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(
		self.name,
		center(width, self.width), center(height, self.height)
	)
	
	if self.time > 2 then
		love.graphics.setFont(self.fontsmaller)
		love.graphics.print(
		self.help,
		10, height - 10
		)
	end
end

function GameOver:keyreleased(key)
	if self.time > 1 then
		switchTo(ScoreScreen)
	end
end

function GameOver:start()
	lose:play()
	self.time = 0
end

function GameOver:stop()
end

return GameOver