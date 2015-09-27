State = require("State")

local VolScreen = {name = "Volume"}
local help = "Use Up and Down Arrow Keys to Adjust Volume\nUse Any Other Key to Return to the Menu"
VolScreen.__index = VolScreen
local i = 50;

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

	love.graphics.printf(
		i,
		0, 300, 800, 'center'
	)

end

function VolScreen:keyreleased(key)
	if key == 'up' then
		i = i + 1
		love.audio.setVolume((i*2)/100)
	elseif key == 'down' then
		i = i - 1
		love.audio.setVolume((i*2)/100)
	else
		love.audio.setVolume((i*2)/100)
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