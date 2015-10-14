--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

State = require("State")

local Menu = {"New Game", "Settings", "High Scores", "Quit"}
local selects = {"-New Game-", "-Settings-", "-High Scores-", "-Quit-"}
local widths = {}
local selectwidths = {}
local selector = 0
local help = "Use the arrow keys to navigate and Enter to select"
local flash = false
local title = "FULL AUTOMATIC\n          TERROR"
local width = love.window.getWidth()
local height = love.window.getHeight()
--local alpha = 50		for flashing maybe in the future do not delete
--local adelt = 75

Menu.__index = Menu

setmetatable(Menu, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

--- declares all menu sound effects, text, and text fonts

function Menu:load()

	self.title_font = love.graphics.newFont("ka1.ttf", 52)
	self.list_font = love.graphics.newFont("ka1.ttf", 30)
	self.help_font = love.graphics.newFont("PressStart2P.ttf", 12)

	title_width = self.title_font:getWidth(title)
	title_height = self.title_font:getHeight(title)

	for index,value in ipairs(Menu) do
		widths[index] = self.list_font:getWidth(value)
	end

	for index,value in ipairs(selects) do
		selectwidths[index] = self.list_font:getWidth(value)
	end

	menu_bgm = love.audio.newSource("sfx/menulow.ogg")
	menu_bgm:setLooping(true)

	choose = love.audio.newSource("sfx/choose.ogg")
	choose:setLooping(false)

	selected = love.audio.newSource("sfx/select.ogg")
	selected:setLooping(false)

	quitgame = love.audio.newSource("sfx/shutdown.mp3")
	quitgame:setLooping(false)

	self.bg = love.graphics.newImage("gfx/menu_screen.png")

	-- for flashing title
	timer1 = love.timer.getTime()
	timer2 = love.timer.getTime()
end

--- code for flashing title

function Menu:update(dt)

	timer2 = love.timer.getTime()
	if (timer2 - timer1) >= 0.2 then
		flash = not flash
		timer1 = love.timer.getTime()
	end

	--[[
	alpha = alpha + adelt * dt

	if alpha <= 50 or alpha >= 255 then
		adelt = -adelt
	end
	--]]

end

--- creates the actual list and background

function Menu:draw()

	-- draw background
	love.graphics.draw(self.bg, 1, 1)

	-- draw the title
	love.graphics.setFont(self.title_font)

	if flash then
		love.graphics.setColor(255, 255, 255, 255)
	else
		love.graphics.setColor(255, 255, 255, 150)
	end

	--love.graphics.setColor(255,255,255,alpha)
	love.graphics.print(
		title,
		width/2 - title_width/2, 50
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

	for index,value in ipairs(Menu) do
		if selector + 1 == index then
			love.graphics.print(
				selects[index],
				center(width, selectwidths[index]), (item_space)*(index-1) + 230
			)
		else
			love.graphics.print(
				value,
				center(width, widths[index]), (item_space)*(index-1) + 230
				--226 is hardcoded until i check pix location in photoshop
			)
		end
	end
end

--- selector operations and their sound effects

function Menu:keyreleased(key)
	if key == 'escape' then
		love.event.quit()
	end

	if key == 'up' then
		selector = ((selector - 1) % 5)
		selected:play()
	end

	if key == 'down' then
		selector = ((selector + 1) % 5)
		selected:play()
	end

	if key == 'return' then
		choose:play()

		if selector == 0 then
			love.timer.sleep(0.4)
			switchTo(Intro)
		elseif selector == 1 then
			love.timer.sleep(0.4)
			switchTo(Settings)
		elseif selector == 2 then
			love.timer.sleep(0.4)
			switchTo(ScoreScreen)
		elseif selector == 3 then
			menu_bgm:stop()
			quitgame:play()
			love.timer.sleep(2)
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
