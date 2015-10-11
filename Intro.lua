--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

State = require("State")

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
	self.list_font = love.graphics.newFont("ka1.ttf", 30)
	self.bg = love.graphics.newImage("gfx/intro_screen.png")

	text = {
	"Your home planet, Trora, is located in the Meyliv Galaxy.",

	"The nearby Zenith Nebula had drawn scientific minds from
	around the universe to study its strange energy.",

	"Trora's officials did not want this to escalate into an
	energy race, for that would lead to war.",

	"However, they did not have the knowledge to harness the
	energy alone.",

	"They made a deal that would satisfy everyone, but would
	also leave Trora with an advantage.",

	"Everyone shared their knowledge and, as a result, they
	were able to harness and contain the energy.",

	"As payment for their contributions, each participant was
	given a share of the resource.",

	"However, Trora kept the most because they were closest to
	the nebula.",

	"They used the Zenith Energy to create a line of
	powerful spacecraft for their leader’s escort.",

	"You are the pilot of one of these ships.",

	"The residents of a another planet, Snides, sought these
	ships in order to reverse engineer them.",

	"While they are masters of teleportation technology, they
	could not match Trora’s speed and firepower.",

	"They ambushed you on your way back to Trora and captured
	you.",

	"Several months have passed, and the enemy has created an
	enhanced army of ships with the energy.",

	"As they were about to eliminate you, you somehow managed
	to escape.",

	"You must survive and reach home in order to warn your
	planet of the imminent threat."}

end

function Intro:update(dt)

end

function Intro:draw()
	love.graphics.translate(0, -dt)
	love.graphics.draw(self.bg, 0, 0)
end

function Intro:keyreleased(key)

end

function Intro:start()

end

function Intro:stop()

end

return Intro
