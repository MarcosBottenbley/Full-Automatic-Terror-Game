--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

State = require("State")

local Win = {
	name = "SECTOR CLEAR", bonus = "SCORE +3000",
	help = "Press any key to continue"
}

local victory
local final_victory
local winner = false

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
	self.font = love.graphics.newFont("ka1.ttf", 50)
	self.fontsmall = love.graphics.newFont("PressStart2P.ttf", 30)
	self.fontsmaller = love.graphics.newFont("PressStart2P.ttf", 12)

	victory = love.audio.newSource("sfx/win.ogg")
	victory:setLooping(false)
	
	final_victory = love.audio.newSource("sfx/winfinal.ogg")
	final_victory:setLooping(false)
end

function Win:start()
	if levelNum == max_level then
		winner = true
	else
		winner = false
	end
	print(levelNum)
	print(max_level)
	
	if winner then
		self.name = "GAME CLEAR"
	else
		self.name = "SECTOR CLEAR"
	end
	
	self.namewidth = self.font:getWidth(self.name)
	self.nameheight = self.font:getHeight(self.name)
	
	self.bonuswidth = self.font:getWidth(self.name)
	self.bonusheight = self.font:getHeight(self.name)
	
	if winner then
		final_victory:play()
	else
		victory:play()
	end
	self.time = 0
end

--- Center small inside large.
function center(large, small)
	return large/2 - small/2
end

function Win:fadein()
	if self.time < 1 then
		local c = lerp(0, 255, self.time/1)
		return {c, c, c, 255}
	else
		return {255, 255, 255, 255}
	end
end

function Win:update(dt)
	self.time = self.time + dt
end

function Win:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor(self:fadein())
	love.graphics.print(
		self.name,
		center(width, self.namewidth), center(height, self.nameheight)
	)

	if winner then
		love.graphics.setFont(self.fontsmall)
		love.graphics.print(
			self.bonus,
			center(width, self.bonuswidth), center(height, self.bonusheight) + 100
		)
	end

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
		if not winner then
			if levelNum == 1 then
				levelNum = levelNum + 1
				switchTo(Intro2)
			elseif levelNum == 2 then
				levelNum = levelNum + 1
				switchTo(Intro3)
			end
		else
			levelNum = 1
			switchTo(ScoreScreen)
		end
	end
end

function Win:keypressed(key)
end

function Win:stop()
	victory:stop()
	final_victory:stop()
end

return Win
