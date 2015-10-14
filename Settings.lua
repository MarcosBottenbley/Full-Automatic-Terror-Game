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
										 {"main", "sfx", "music"},
										 {"parallax", "brightness", "resolution", "full screen"},
										 {"rebind"}}
local selector = 1
local vselector = 1

local help = "Use Left and Right Arrow Keys to Adjust Volume\nPress escape to Return to the Menu"
Settings.__index = Settings
local i = 50;
local max = "MAX"
local min = "MIN"

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

	if love.keyboard.isDown('right') then
		if (i < 100) then
			i = i + 1
		end
		love.audio.setVolume((i*2)/100)
	elseif love.keyboard.isDown('left') then

		if (i > 0) then
			i = i - 1
		end
		love.audio.setVolume((i*2)/100)
	end
end

function Settings:draw()

	-- print the top list
	love.graphics.setFont(self.font)
	for i = 1, 3 do
		if i == selector then
			love.graphics.setColor(255, 0, 0, 255)
		end
		love.graphics.print(
			categories[i],
			30 + 220 * (i - 1), 30
		)
		-- reset if not red
		love.graphics.setColor(255, 255, 255, 255)
	end

	-- print the contents
	for i = 1, table.getn(categories[selector + 3]) do
		if i == vselector then
			love.graphics.setColor(255, 0, 0, 255)
		end
		love.graphics.print(
			categories[selector + 3][i],
			30, 90 + 50 * (i - 1)
		)
		-- reset if not red
		love.graphics.setColor(255, 255, 255, 255)
	end

	love.graphics.print(
		selector,
		400, 400
	)

	love.graphics.setFont(self.font2)
	love.graphics.setColor(self:fadein())
	love.graphics.print(
		help,
		10, height - 25
	)

	-- love.graphics.setFont(self.font)
	-- love.graphics.setColor(self:fadein())
	-- love.graphics.print(
	-- 	self.name,
	-- 	center(width, self.width), height/12
	-- )
	--
	-- love.graphics.setFont(love.graphics.newFont("ka1.ttf", 40))
	--
	-- love.graphics.printf(
	-- 	"Master Volume:  ",
	-- 	0, 200, 800, 'center'
	-- )
	--
	--
	-- if i == 100 then
	-- 	love.graphics.printf(
	-- 		max,
	-- 		0, 300, 800, 'center'
	-- 	)
	-- elseif i == 0 then
	-- 	love.graphics.printf(
	-- 		min,
	-- 		0, 300, 800, 'center'
	-- 	)
	-- else
	-- 	love.graphics.printf(
	-- 		i,
	-- 		0, 300, 800, 'center'
	-- 	)	end

end

function Settings:keyreleased(key)

	if key == 'right' then
		selector = ((selector - 1) % 3) + 1
		selected:play()
		vselector = 1
	end

	if key == 'left' then
		selector = ((selector + 1) % 3) + 1
		selected:play()
		vselector = 1
	end

	if key == 'down' then
		vselector = ((vselector + 1) % table.getn(categories[selector + 3]) + 1)
		selected:play()
	end

	if key == 'up' then
		vselector = ((vselector - 1) % table.getn(categories[selector + 3]) + 1)
		selected:play()
	end

	if key == 'escape' then
		switchTo(Menu)
	end
end

function Settings:start()
	self.time = 0
	self.sound:play()
end

function Settings:stop()
	self.sound:stop()
end

return Settings
