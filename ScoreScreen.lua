State = require("State")

local ScoreScreen = {name = "Your Statistics"}
ScoreScreen.__index = ScoreScreen

setmetatable(ScoreScreen, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ScoreScreen:fadein()
	if self.time < 4 then
		local c = lerp(0, 255, self.time/4)
		return {c, c, c, 255}
	else
		return {255, 255, 255, 255}
	end
end

function ScoreScreen:load()
	self.font = love.graphics.newFont("ka1.ttf", 60)
	self.width = self.font:getWidth(self.name)
	self.height = self.font:getHeight(self.name)
	self.sound = love.audio.newSource("Extra Stages.mp3")
end
function ScoreScreen:update(dt)
	self.time = self.time + dt
	if self.time > 21 then
		switchTo(Title)
	end
end
function ScoreScreen:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor(self:fadein())
	love.graphics.print(
		self.name,
		center(width, self.width), height/12
	)
	love.graphics.setFont(love.graphics.newFont(10))
	love.graphics.setColor({255, 255, 255, 255})
	--love.graphics.print(love.timer.getFPS(), 10, 10)
	love.graphics.print(self.time, 10, 20)

	love.graphics.setFont(love.graphics.newFont("ka1.ttf", 20))
	love.graphics.setColor(self:fadein())
	love.graphics.print(
	"Number of Enemies Killed- 0\n\nNumber of Deaths- 0\n\nStatus of Enemy- TOAST",
	center(width, self.width) - 30, (height/12) + 180
	)

end
function ScoreScreen:keyreleased(key)
	switchTo(Title)
end
function ScoreScreen:start()
	self.time = 0
	self.sound:play()
end
function ScoreScreen:stop()
	self.sound:stop()
end

return ScoreScreen