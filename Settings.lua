--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

State = require("State")

local Settings = {name = "Volume"}
local categories = {"audio", "video", "controls",
{"main"},
{"parallax"},
{"rebind"}}

local selector = 1
--- selector 1 is audio
--- selector 2 is video
--- selector 3 is controls

local vselector = 1
--- vselector 1 is main, parallax, rebind
--- vselector 2 is brightness
--- vselector 3 is resolution
--- vselector 4 is full screen

local help = "Use Up and Down Arrow Keys to Adjust Volume\nUse Left and Right Arrow Keys to Adjust General Selection\nUse Escape to Return to the Menu"
Settings.__index = Settings
local help2 = "Use Up and Down Arrow Keys to Adjust Parallax Setting\nUse Left and Right Arrow Keys to Adjust General Selection\nUse Escape to Return to the Menu"
local help3 = "Use Enter to Rebind Controls\nUse Left and Right Arrow Keys to Adjust General Selection\nUse Escape to Return to the Menu"
local i = 50

local max = "MAX"
local min = "MIN"

parallax = 5

setmetatable(Settings, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Settings:fadein()
	if self.time < 1 then
		local c = lerp(0, 255, self.time/1)
		return {c, c, c, 255}
	else
		return {255, 255, 255, 255}
	end
end

function Settings:load()
	self.font = love.graphics.newFont("ka1.ttf", 36)
	self.font2 = love.graphics.newFont("PressStart2P.ttf", 12)

	self.width = self.font:getWidth(self.name)
	self.height = self.font:getHeight(self.name)

	self.sound = love.audio.newSource("sfx/scorelow.ogg")

	selected = love.audio.newSource("sfx/select.ogg")
	selected:setLooping(false)
end

function Settings:update(dt)
	self.time = self.time + dt

	if love.keyboard.isDown('up') and selector == 1 then
		if (i < 100) then
			i = i + 1
		end
		love.audio.setVolume((i*2)/100)
	elseif love.keyboard.isDown('down') and selector == 1 then
		if (i > 0) then
			i = i - 1
		end
		love.audio.setVolume((i*2)/100)
	end

	--- if love.keyboard.isDown('up') and selector == 2 then
	--- 	if (x < 10) then
	--- 		x = x + 1
	--- 	end
	--- elseif love.keyboard.isDown('down') and selector == 2 then
	--- 	if (x > 1) then
	--- 		x = x - 1
	--- 	end
	--- end

end

function Settings:draw()

	-- print the top list
	love.graphics.setFont(self.font)
	for j = 1, 3 do
		if j == selector then
		 	love.graphics.setColor(255, 0, 0, 255)
		end
		love.graphics.print(
			categories[j],
			30 + 220 * (j - 1), 30
		)
		-- reset if not red
		love.graphics.setColor(255, 255, 255, 255)
	end

	-- print the contents

	for k = 1, table.getn(categories[selector + 3]) do
		if k == vselector then
			love.graphics.setColor(255, 0, 0, 255)
		end
		love.graphics.print(
			categories[selector + 3][k],
			30, 90 + 50 * (k - 1)
		)

		-- reset if not red
		love.graphics.setColor(255, 255, 255, 255)
	end

	-- if we are on the volume tab, print the volume

	if selector == 1 then
		if i == 0 then
			love.graphics.print(
				min .. " volume",
				250, 350
			)
		elseif i == 100 then
			love.graphics.print(
				max .. " volume",
				250, 350
			)
		else
			love.graphics.print(
				i .. " percent",
				250, 350
			)
		end
	end

	if selector == 2 then
		if parallax == 1 then
			love.graphics.print(
				min .. " parallax",
				250, 350
			)
		elseif parallax == 10 then
			love.graphics.print(
				max .. " parallax",
				250, 350
			)
		else
			love.graphics.print(
				"parallax: " .. parallax,
				250, 350
			)
		end
	end

	love.graphics.setFont(self.font2)
	love.graphics.setColor(self:fadein())

	if selector == 1 then
		love.graphics.print(
			help,
			10, height - 35
		)
	elseif selector == 2 then
		love.graphics.print(
			help2,
			10, height - 35
		)
	else
		love.graphics.print(
			help3,
			10, height - 35
		)
	end

end

function Settings:keyreleased(key)

	if key == 'right' then
		if selector == 3 then
			selector = 1
		else
			selector = selector + 1
		end
		selected:play()
		vselector = 1
	end

	if key == 'left' then
		if selector == 1 then
			selector = 3
		else
			selector = selector - 1
		end
		selected:play()
		vselector = 1
	end

	if key == 'down' and selector == 2 and parallax > 1 then
		parallax = parallax - 1
	end

	if key == 'up' and selector == 2 and parallax < 10 then
		parallax = parallax + 1
	end

	if key == 'return' and selector == 3 then
		choose:play()
	end

	if key == 'escape' then
		switchTo(Menu)
	end
end

function Settings:keypressed(key)
end

function Settings:start()
	self.time = 0
	self.sound:play()
end

function Settings:stop()
	self.sound:stop()
end

return Settings
