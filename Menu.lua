State = require("State")

local Menu = {"New Game", "Brightness", "Volume", "High Scores", "Quit"}
local selects = {"-New Game-", "-Brightness-", "-Volume-", "-High Scores-", "-Quit-"}
local widths = {}
local selectwidths = {}
local selector = 0
local help = "Use the arrow keys to navigate and Enter to select"
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
	self.font2 = love.graphics.newFont("PressStart2P.ttf", 12)
	
	for index,value in ipairs(Menu) do
		widths[index] = self.font:getWidth(value)
	end
	
	for index,value in ipairs(selects) do
		selectwidths[index] = self.font:getWidth(value)
	end
	
	menu_bgm = love.audio.newSource("sfx/menulow.ogg")
	menu_bgm:setLooping(true)
	
	choose = love.audio.newSource("sfx/choose.ogg")
	choose:setLooping(false)
	
	selected = love.audio.newSource("sfx/select.ogg")
	selected:setLooping(false)
	
	self.bg = love.graphics.newImage("gfx/menu_screen.png")
end

function Menu:update(dt)
end

function Menu:draw()
	love.graphics.draw(self.bg, 1, 1)
	love.graphics.setFont(self.font2)
	love.graphics.setColor({255, 255, 255, 255})
	item_space = height / 5 --hardcoded value (lua cant get size of table)
	
	love.graphics.print(
		help,
		10, height - 10
	)
	
	love.graphics.setFont(self.font)
	
	for index,value in ipairs(Menu) do
		if selector + 1 == index then
			love.graphics.print(
				selects[index],
				center(width, selectwidths[index]), (item_space)*(index-1) + 25
			)
		else
			love.graphics.print(
				value,
				center(width, widths[index]), (item_space)*(index-1) + 25
				--25 is also hardcoded because i'm lazy
			)
		end
	end
end

function Menu:keyreleased(key)
	if key == 'escape' then
		love.event.quit()
		blip:play()
	end
	
	if key == 'up' then
		selector = ((selector - 1) % 5)
<<<<<<< HEAD
		blip:play()
=======
		selected:play()
>>>>>>> 6979c4e83d63e5f90b09e1d36ec7619a2e443540
	end
	
	if key == 'down' then 
		selector = ((selector + 1) % 5)
<<<<<<< HEAD
		blip:play()
=======
		selected:play()
>>>>>>> 6979c4e83d63e5f90b09e1d36ec7619a2e443540
	end
	
	if key == 'return' then
		choose:play()
	
		if selector == 0 then
			ding:play()
			love.timer.sleep(0.4)
			switchTo(Game)
		elseif selector == 3 then
			ding:play()
			love.timer.sleep(0.4)
			switchTo(ScoreScreen)
		elseif selector == 4 then
			bootdown:play()
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