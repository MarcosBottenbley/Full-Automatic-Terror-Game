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
	
	enemy_sprite = love.graphics.newImage("gfx/gel.png")
	enemy_width = enemy_sprite:getWidth()
	enemy_height = enemy_sprite:getHeight()
	
	player_sprite = love.graphics.newImage("gfx/toast.png")
	player_width = player_sprite:getWidth()
	player_height = player_sprite:getHeight()
	
	self.helpfont = love.graphics.newFont("PressStart2P.ttf", 12)
	
	blip = love.audio.newSource("sfx/bump.ogg")
	blip:setLooping(false)
	ding = love.audio.newSource("sfx/ding.mp3")
	ding:setLooping(false)
	bootdown = love.audio.newSource("sfx/shutdown.mp3")
	bootdown:setLooping(false)

	bgm = love.audio.newSource("sfx/gamelow.ogg")
	bgm:setLooping(true)

	background = love.graphics.newImage("gfx/game_screen.png")

	enemies = {}

	for i = 1, 9 do
		table.insert(enemies, Enemy(math.random(800 - enemy_width), math.random(600 - enemy_height), math.random(40,80)))
	end

	for _, e in ipairs(enemies) do
		e:direction()
	end

	player1 = Player(width/2, height/2, 200)
	
	for _, e in ipairs(enemies) do
		print(" " .. e.width)
	end
	
	print(" " .. player1.width)
end

function Game:start()
	--bgm:play()
	
	--[[enemies = {}

	for i = 1, 9 do
		table.insert(enemies, Enemy(math.random(800 - enemy_width), math.random(600 - enemy_height), math.random(40,80), enemy_sprite))
	end

	for _, e in ipairs(enemies) do
		e:direction()
	end

	player1 = Player(width/2, height/2, 200, player_sprite)--]]
	
	for _, e in ipairs(enemies) do
		print(" " .. e.width)
	end
	
	print(" " .. player1.width)
end

function Game:stop()
	bgm:stop()
	
	for _, e in ipairs(enemies) do
		print(" " .. e.width)
	end
	
	print(" " .. player1.width)
end

function Game:update(dt)
	time = time + dt

	for _, e in ipairs(enemies) do
		e:update(dt, width, height)
	end

	player1:update(dt, width, height)

end

function Game:draw(dt)
	love.graphics.draw(background, 0, 0)
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