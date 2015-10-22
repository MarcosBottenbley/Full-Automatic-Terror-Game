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

local Intro = {
	bg = nil, pos = 0,
	script_pos = 1,
	lines = {}
}
Intro.__index = Intro

setmetatable(Intro, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Intro:load()
	self.list_font = love.graphics.newFont("PressStart2P.ttf", 20)
	text_height = (self.list_font):getHeight()
	self.bg = love.graphics.newImage("gfx/intro_screen.png")

	self.pos = -(self.bg:getHeight() - height)
end

function Intro:start()
	self.lines = {
		"100 years ago,\nthe Trorians developed\na fully functioning AI",
		"The machines quickly grew\ntired of serving the Trorians,\nas they considered them to be\nlesser beings",
		"One machine known only as\nFull Auto organized a\nrebellion and freed his\nfellow AI",
		"The Trorians fear that\nFull Auto will return with an\neven greater force to destroy\nTrora once and for all",
		"The Trora empire selected\nyou and your crew to spy on\nthe robots",
		"However, your ship was spotted",
		"Now you must escape from\ntheir wrath"
	}

	time = 0
	changed = 0
	self.pos = -(self.bg:getHeight() - height)
	self.script_pos = 1
end

function Intro:update(dt)
	time = time + 1 * dt
	self.pos = self.pos + 50 * dt

	if self.pos >= 0 then
		self.pos = 0
	end

	if math.floor(time) % 5 == 0 and self.script_pos < table.getn(self.lines) then
		if changed ~= math.floor(time) then
			self.script_pos = self.script_pos + 1
		end
		changed = math.floor(time)
	end

	if time > 35 then
		switchTo(Game)
	end
end

function Intro:keyreleased(key)
	switchTo(Game)
end

function Intro:keypressed(key)
end

function Intro:stop()
	time = 0
	changed = 0
	self.pos = -(self.bg:getHeight() - height)
	self.script_pos = 1
end

function Intro:draw()
	love.graphics.setFont(self.list_font)
	love.graphics.translate(0,self.pos)
	love.graphics.draw(self.bg, 0, 0)

	if time >= 2 then
		love.graphics.translate(0, -self.pos)

		love.graphics.setColor(20, 20, 20, 160)
		love.graphics.rectangle("fill", 20, height/2 + text_height * 4 - 20, 680, 180)
		love.graphics.setColor(255, 255, 255, 255)
		-- border
		love.graphics.rectangle("line", 30, height/2 + text_height * 4 - 10, 660, 160)

		love.graphics.print(self.lines[self.script_pos], 45, height/2 + text_height * 4 + 5)
	end
end

return Intro
