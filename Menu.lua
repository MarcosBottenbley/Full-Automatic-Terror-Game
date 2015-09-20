State = require("State")

local Menu = {"New Game", "Brightness", "Volume", "High Scores", "Quit"}
local selects = {"-New Game-", "-Brightness-", "-Volume-", "-High Scores-", "-Quit-"}
local widths = {}
local selectwidths = {}
local selector = 0
Menu.__index = Menu

setmetatable(Menu, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Menu:load()
	self.font = love.graphics.newFont("ka1.ttf", 50)
	for index,value in ipairs(Menu) do
		widths[index] = self.font:getWidth(value)
	end
	
	for index,value in ipairs(selects) do
		selectwidths[index] = self.font:getWidth(value)
	end
	
	menu_bgm = love.audio.newSource("sfx/chippy.mp3")
	menu_bgm:setLooping(true)
end

function Menu:update(dt)
end

function Menu:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor({255, 255, 255, 255})
	ummm = height / 5 --hardcoded value (lua cant get size of table)
	
	for index,value in ipairs(Menu) do
		if selector + 1 == index then
			love.graphics.print(
				selects[index],
				center(width, selectwidths[index]), (height/5)*(index-1) + 25
			)
		else
			love.graphics.print(
				value,
				center(width, widths[index]), (height/5)*(index-1) + 25
				--25 is also hardcoded because i'm lazy
			)
		end
	end
end

function Menu:keyreleased(key)
	if key == 'up' then
		selector = ((selector - 1) % 5)
	end
	
	if key == 'down' then 
		selector = ((selector + 1) % 5)
	end
	
	if key == 'return' then
		if selector == 0 then
			switchTo(Game)
		elseif selector == 3 then
			switchTo(ScoreScreen)
		elseif selector == 4 then
			love.event.quit()
		end
	end
end

function Menu:start()
	menu_bgm:play()
end

function Menu:stop()
	menu_bgm:stop()
end

return Menu