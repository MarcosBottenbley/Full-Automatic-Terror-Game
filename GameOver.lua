State = require("State")

local GameOver = {name = "GAME OVER BROH"}
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
	
	lose = love.audio.newSource("sfx/lose.ogg")
	lose:setLooping(false)
end

--- Center small inside large.
function center(large, small)
	return large/2 - small/2
end

function GameOver:update(dt)
end

function GameOver:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(
		self.name,
		center(width, self.width), center(height, self.height)
	)
end

function GameOver:keyreleased(key)
	switchTo(Title)
end

function GameOver:start()
	lose:play()
end

function GameOver:stop()
end

return GameOver