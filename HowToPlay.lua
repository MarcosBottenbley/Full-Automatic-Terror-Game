--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

State = require("State")

local time = 0
local changed = 0
local bgm

local help4 = "Use Left and Right Arrow Keys to Adjust Information Page\nPress Any Other Key to Return to the Main Menu"

local HowToPlay = {
	bg = nil, pos = 0,
	script_pos = 1,
	lines = {}
}
HowToPlay.__index = HowToPlay

setmetatable(Intro, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function HowToPlay:load()
	self.list_font = love.graphics.newFont("PressStart2P.ttf", 20)
	self.list_font_2 = love.graphics.newFont("PressStart2P.ttf", 12)
	text_height = (self.list_font):getHeight()
	self.bg = love.graphics.newImage("gfx/intro_screen.png")

	self.pos = -(self.bg:getHeight() - height)

	bgm = love.audio.newSource("sfx/cutscene.ogg")
	bgm:setLooping(true)
end

function HowToPlay:start()
	self.lines = {
		"To control your ship,\nuse the arrow keys.\nThe camera will move to\nfollow you.",
		"To fire your weapon,\nuse the Z key. Your weapon fires\nin the direction that your ship\nis facing.",
		"To switch between your two\nweapons, press the 1 key.\nThe first weapon is a laser\nthat fires in a straight line.",
		"The second weapon has a slower\nfire rate and speed. However,\nit adjusts its path to\nhit nearby enemies.",
		"To use a bomb,\nuse the C key. The bomb\nkills all enemies on the screen.",
		"To use a hyper jump,\nuse the spacebar. The hyper jump\nlaunches your ship forward for a\nshort duration. It kills all\nenemies that you come in contact\nwith during the jump.",
		"You only have a limited number\nof bombs and hyper jumps, so use\nthem wisely. Their numbers\nreset each level.",
		"Your ship automatically strafes\nwhile shooting. To shoot while\nmoving normally, hold down\nthe X key.",
		"Killing an enemy awards you 200\npoints. Completing a level\nawards you 3000 points.",
		"Usually, to move to the next\nlevel, enter the gold portal.\nHowever, for most of these\nlevels, the portal will not\nappear right away.",
		"Also, some levels do not use\ngold portals at all. So pay\nattention to those cutscenes\nto figure out how to win.",
		"You are now ready to play\nthe game.\nGood Luck!"
	}

	time = 0
	self.pos = -(self.bg:getHeight() - height)
	self.script_pos = 1

	bgm:play()
end

function HowToPlay:update(dt)
	time = time + 1 * dt
	self.pos = self.pos + 25 * dt

	if self.pos >= 0 then
		self.pos = 0
	end
end

function HowToPlay:keyreleased(key)
	if key == 'left' and self.script_pos > 1 then
		self.script_pos = self.script_pos - 1
	elseif key == 'left' and self.script_pos == 1 then
		error:play()
	elseif key == 'right' and self.script_pos < 12 then
		self.script_pos = self.script_pos + 1
	elseif key == 'right' and self.script_pos == 12 then
		error:play()
	else
		switchTo(Menu)
	end
end

function HowToPlay:keypressed(key)
end

function HowToPlay:stop()
	time = 0
	changed = 0
	self.script_pos = 1

	bgm:stop()
end

function HowToPlay:draw()

	local page = "Page " .. self.script_pos .. " of 12"
	local pagewidth = self.list_font:getWidth(page)
	local pageheight = self.list_font:getHeight(page)

	love.graphics.setFont(self.list_font)
	love.graphics.draw(self.bg, 0, 0)

	love.graphics.setColor(20, 20, 20, 160)
	love.graphics.rectangle("fill", 20, height/2 + text_height * 4 - 20, 680, 180)
	love.graphics.setColor(255, 255, 255, 255)
	-- border
	love.graphics.rectangle("line", 30, height/2 + text_height * 4 - 10, 660, 160)

	love.graphics.print(self.lines[self.script_pos], 45, height/2 + text_height * 4 + 5)

	love.graphics.print(
		page,
		width/2 - pagewidth/2, 50
	)

	love.graphics.setFont(self.list_font_2)

	love.graphics.print(
		help4,
		10, height - 35
	)

end

return HowToPlay
