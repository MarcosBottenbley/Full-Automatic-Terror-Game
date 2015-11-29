--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

State = require("State")

local Menu2 = {"New Game", "Level Select", "Return to Menu"}
local selects = {"-New Game-", "-Level Select-", "-Return to Menu-"}
local widths = {}
local levelCount = 0
local selectwidths = {}
local selector = 0
local help = "Use the arrow keys to navigate and Enter to select"
local flash = false
local title1 = "ADJUST YOUR GAME"
local title2 = "SETTINGS"
local width = love.window.getWidth()
local height = love.window.getHeight()
--local alpha = 50		for flashing maybe in the future do not delete
--local adelt = 75

Menu2.__index = Menu2

setmetatable(Menu2, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

--- declares all menu sound effects, text, and text fonts

function Menu2:load()

	self.title1_font = love.graphics.newFont("ka1.ttf", 52)
	self.title2_font = love.graphics.newFont("ka1.ttf", 70)
	self.list_font = love.graphics.newFont("ka1.ttf", 30)
	self.help_font = love.graphics.newFont("PressStart2P.ttf", 12)

	self.title1_width = self.title1_font:getWidth(title1)
	self.title1_height = self.title1_font:getHeight(title1)
	
	self.title2_width = self.title2_font:getWidth(title2)
	self.title2_height = self.title2_font:getHeight(title2)

	for index,value in ipairs(Menu2) do
		widths[index] = self.list_font:getWidth(value)
	end

	for index,value in ipairs(selects) do
		selectwidths[index] = self.list_font:getWidth(value)
	end

	self.bg = love.graphics.newImage("gfx/menu_screen.png")

	timer1 = love.timer.getTime()
	timer2 = love.timer.getTime()

end

function Menu2:update(dt)
	timer2 = love.timer.getTime()
	if (timer2 - timer1) >= 0.2 then
		flash = not flash
		timer1 = love.timer.getTime()
	end
end
	

--- creates the actual list and background

function Menu2:draw()

	-- draw background
	love.graphics.draw(self.bg, 1, 1)

	-- draw the title
	if flash then
		love.graphics.setColor(255, 255, 255, 255)
	else
		love.graphics.setColor(255, 255, 255, 150)
	end

	--love.graphics.setColor(255,255,255,alpha)
	
	love.graphics.setFont(self.title1_font)
	love.graphics.print(
		title1,
		width/2 - self.title1_width/2, 50
	)
	love.graphics.setFont(self.title2_font)
	love.graphics.print(
		title2,
		width/2 - self.title2_width/2, 106
	)

	-- draw the menu list
	love.graphics.setFont(self.help_font)
	love.graphics.setColor({255, 255, 255, 255})
	item_space = 50 --hardcoded value (lua cant get size of table)

	love.graphics.print(
		help,
		10, height - 10
	)

	love.graphics.setFont(self.list_font)

	for index,value in ipairs(Menu2) do
		if selector + 1 == index then
			love.graphics.print(
				selects[index],
				center(width, selectwidths[index]), (item_space)*(index-1) + 230
			)
		else
			love.graphics.print(
				value,
				center(width, widths[index]), (item_space)*(index-1) + 230
				-- 226 is hardcoded until i check pix location in photoshop
			)
		end
	end

	if selector == 1 and (levelCount == 1 or levelCount == 2) then
		love.graphics.print(
			levelCount,
			width/2 - 15, height/2 + 100
		)
	end

	if selector == 1 and levelCount == 5 then
		love.graphics.print(
			levelCount - 1,
			width/2 - 15, height/2 + 100
		)
	end

	if selector == 1 and (levelCount == 3) then
		love.graphics.print(
			"3A",
			width/2 - 25, height/2 + 100
		)
	end

	if selector == 1 and (levelCount == 4) then
		love.graphics.print(
			"3B",
			width/2 - 25, height/2 + 100
		)
	end

	if selector == 1 and (levelCount == 0) then
		love.graphics.print(
			"Tutorial",
			width/2 - 90, height/2 + 100
		)
	end
end

--- selector operations and their sound effects

function Menu2:keyreleased(key)
	if key == 'escape' then
		switchTo(Menu)
	end

	if key == 'up' then
		selector = ((selector - 1) % 3)
		selected:play()
	end

	if key == 'down' then
		selector = ((selector + 1) % 3)
		selected:play()
	end

	if key == 'left' and selector ==  1 and levelCount == 0 then
		error:play()
	end

	if key == 'right' and selector == 1 and levelCount == 5 then
		error:play()
	end

	if key == 'left' and selector == 1 and levelCount > 0 then
		levelCount = levelCount - 1
	end

	if key == 'right' and selector == 1 and levelCount < 5 then
		levelCount = levelCount + 1
	end

	if key == 'return' then
		choose:play()

		if selector == 0 then
			menu_bgm:stop()
			love.timer.sleep(0.4)
			switchTo(StageIntro)
		elseif selector == 1 then
			menu_bgm:stop()
			love.timer.sleep(0.4)
			levelNum = levelCount
			switchTo(StageIntro)
		elseif selector == 2 then
			switchTo(Menu)
		end
	end
end

function Menu2:keypressed(key)
end

function Menu2:start()
end

function Menu2:stop()
end

return Menu2
