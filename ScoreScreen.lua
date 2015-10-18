--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

State = require("State")

local ScoreScreen = {name = "HIGH SCORES"}
local help = "Press any key to return to menu"
local bg
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

function ScoreScreen:fadein2()
	if self.time < 1 then
		local c = lerp(0, 255, self.time/1)
		return {c, c, c, 255}
	else
		return {255, 25, 25, 255}
	end
end

function ScoreScreen:load()
	self.font = love.graphics.newFont("ka1.ttf", 60)
	self.font2 = love.graphics.newFont("PressStart2P.ttf", 12)
	self.width = self.font:getWidth(self.name)
	self.height = self.font:getHeight(self.name)
	self.sound = love.audio.newSource("sfx/scorelow.ogg")

	bg = love.graphics.newImage("gfx/hi_score.png")
end

function ScoreScreen:update(dt)
	self.time = self.time + dt
end

function ScoreScreen:draw()

	love.graphics.draw(bg, 0, 0)

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

	love.graphics.setFont(love.graphics.newFont("ka1.ttf", 32))

	local length = table.getn(highscores)
	-- for i = 1, length do
	for i = 1, 6 do
		if i == recent_score then
			love.graphics.setColor(self:fadein2())
		else
			love.graphics.setColor(self:fadein())
		end

		love.graphics.print(
			i .. ". " .. highscores[i],
			width/2 - 100,
			(height/12 + 100) + (i*50)
		)
		-- love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
	end

end

function ScoreScreen:keyreleased(key)
	switchTo(Menu)
end

function ScoreScreen:keypressed(key)
end

function ScoreScreen:start()
	self.time = 0
	self.sound:play()
end

function ScoreScreen:stop()
	self.sound:stop()
end

return ScoreScreen
