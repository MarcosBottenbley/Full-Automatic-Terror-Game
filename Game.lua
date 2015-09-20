State = require("State")

local Game = {}
local help = "Press H for high scores and Esc for menu"
Game.__index = Game

setmetatable(Game, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Game:load(arg)
	math.randomseed(os.time())

	Player = require("Player")
	Enemy = require("Enemy")
	
	self.helpfont = love.graphics.newFont("PressStart2P.ttf", 12)
	
	blip = love.audio.newSource("sfx/bump.ogg")
	blip:setLooping(false)
	
	bgm = love.audio.newSource("sfx/gamelow.ogg")
	bgm:setLooping(true)

	enemies = {}

	for i = 1, 9 do
		table.insert(enemies, Enemy(math.random(800 - 62), math.random(600 - 62), math.random(40,80)))
	end

	for _, e in ipairs(enemies) do
		e:direction()
	end

	player1 = Player(width/2, height/2, 200)
end

function Game:start()
	bgm:play()
end

function Game:stop()
	bgm:stop()
end

function Game:update(dt)
	time = time + dt

	for _, e in ipairs(enemies) do
		e:update(dt, width, height)
	end

	player1:update(dt, width, height)

end

function Game:draw(dt)

	love.graphics.setFont(self.helpfont)

	love.graphics.print(
		help,
		10, height - 10
	)

	player1:draw()
	
	for _, e in ipairs(enemies) do
		e:draw()
	end
end

function Game:keyreleased(key)
	if key == 'escape' then
		switchTo(Menu)
	end
	
	if key == 'h' then
		switchTo(ScoreScreen)
	end
end

return Game