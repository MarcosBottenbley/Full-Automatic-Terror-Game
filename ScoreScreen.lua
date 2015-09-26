State = require("State")

local ScoreScreen = {name = "Your Statistics"}
local help = "Press any key to return to menu"
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
	if self.time < 1 then
		local c = lerp(0, 255, self.time/1)
		return {c, c, c, 255}
	else
		return {255, 255, 255, 255}
	end
end

function ScoreScreen:load()
	self.font = love.graphics.newFont("ka1.ttf", 60)
	self.font2 = love.graphics.newFont("PressStart2P.ttf", 12)
	self.width = self.font:getWidth(self.name)
	self.height = self.font:getHeight(self.name)
	self.sound = love.audio.newSource("sfx/scorelow.ogg")
end

function ScoreScreen:update(dt)
	self.time = self.time + dt
end

function ScoreScreen:draw()
	
	love.graphics.setFont(self.font2)
	love.graphics.setColor(self:fadein())
	love.graphics.print(
		help,
		10, height - 10
	)
	
	love.graphics.setFont(self.font)
	love.graphics.setColor(self:fadein())
	love.graphics.print(
		self.name,
		center(width, self.width), height/12
	)

	love.graphics.setFont(love.graphics.newFont("ka1.ttf", 20))
	love.graphics.setColor(self:fadein())
	
	local length = table.getn(highscores)
	for i = 1, length do
		love.graphics.print(
			i .. ". " .. highscores[i],
			30, (height/12 + self.height) + (i*30)
		)
	end
	
	--[[love.graphics.print(
	"Number of Enemies Killed- 0\n\nNumber of Deaths- 0\n\nStatus of Enemy- TOAST",
	center(width, self.width) - 30, (height/12) + 180
	)--]]

end

function ScoreScreen:keyreleased(key)
	switchTo(Menu)
end

function ScoreScreen:start()
	self.time = 0
	self.sound:play()
end

function ScoreScreen:stop()
	self.sound:stop()
end

return ScoreScreen