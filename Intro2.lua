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

local Intro2 = {
	bg = nil, pos = 0,
	script_pos = 1,
	lines = {}
}
Intro2.__index = Intro2

setmetatable(Intro2, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Intro2:load()
	self.list_font = love.graphics.newFont("ka1.ttf", 15)
	text_height = (self.list_font):getHeight()
	self.bg = love.graphics.newImage("gfx/intro_screen.png")

	self.pos = -(self.bg:getHeight() - height)
end

function Intro2:start()
	self.lines = {
		"You've escaped the first sector",
		"Oh shit some enemy robot fighter ships\n or something",
		"Fuck 'em up"
	}

	time = 0
	changed = 0
	self.pos = -(self.bg:getHeight() - height)
	self.script_pos = 1
end

function Intro2:update(dt)
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

function Intro2:keyreleased(key)
	switchTo(Game)
end

function Intro2:keypressed(key)
end

function Intro2:stop()
	time = 0
	changed = 0
	self.pos = -(self.bg:getHeight() - height)
	self.script_pos = 1
end

function Intro2:draw()
	love.graphics.translate(0,self.pos)
	love.graphics.draw(self.bg, 0, 0)

	if time >= 2 then
		love.graphics.translate(0, -self.pos)

		love.graphics.setColor(20, 20, 20, 160)
		love.graphics.rectangle("fill", 20, 200, 700, 250)
		love.graphics.setColor(255, 255, 255, 255)
		-- border
		love.graphics.rectangle("line", 20, 200, 700, 250)

		love.graphics.print(self.lines[self.script_pos], 40, height/2 - text_height * 4)
	end

end

return Intro2
