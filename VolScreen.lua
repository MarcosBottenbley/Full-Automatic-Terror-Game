--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

State = require("State")

local VolScreen = {name = "Volume"}
local help = "Use Up and Down Arrow Keys to Adjust Volume\nUse Any Other Key to Return to the Menu"
VolScreen.__index = VolScreen
local i = 50;
local max = "MAX"
local min = "MIN"

setmetatable(VolScreen, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function VolScreen:fadein()
	if self.time < 1 then
		local c = lerp(0, 255, self.time/1)
		return {c, c, c, 255}
	else
		return {255, 255, 255, 255}
	end
end

function VolScreen:load()
	self.font = love.graphics.newFont("ka1.ttf", 60)
	self.font2 = love.graphics.newFont("PressStart2P.ttf", 12)
	self.width = self.font:getWidth(self.name)
	self.height = self.font:getHeight(self.name)
	self.sound = love.audio.newSource("sfx/scorelow.ogg")
end

function VolScreen:update(dt)
	self.time = self.time + dt
end

function VolScreen:draw()
	
	love.graphics.setFont(self.font2)
	love.graphics.setColor(self:fadein())
	love.graphics.print(
		help,
		10, height - 25
	)
	
	love.graphics.setFont(self.font)
	love.graphics.setColor(self:fadein())
	love.graphics.print(
		self.name,
		center(width, self.width), height/12
	)

	love.graphics.setFont(love.graphics.newFont("ka1.ttf", 40))
	
	love.graphics.printf(
		"Master Volume:  ",
		0, 200, 800, 'center'
	)
	
	
	if i == 100 then
		love.graphics.printf(
			max,
			0, 300, 800, 'center'
		)
	elseif i == 0 then
		love.graphics.printf(
			min,
			0, 300, 800, 'center'
		)
	else 
		love.graphics.printf(
			i,
			0, 300, 800, 'center'
		)	end

end

function VolScreen:keyreleased(key)
	if key == 'up' then
		if (i < 100) then
			i = i + 1
		end
		love.audio.setVolume((i*2)/100)
	elseif key == 'down' then
		
		if (i > 0) then
			i = i - 1
		end
		love.audio.setVolume((i*2)/100)
	else
		switchTo(Menu)
	end
end

function VolScreen:start()
	self.time = 0
	self.sound:play()
end

function VolScreen:stop()
	self.sound:stop()
end

return VolScreen