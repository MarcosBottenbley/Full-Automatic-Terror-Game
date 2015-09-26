State = require("State")

local Game = {}
local help = "Press H for high scores and Esc for menu"
local scorestring = "SCORE: "
score = 0
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
	GlowBorg = require("GlowBorg")
	Bullet = require("Bullet")
	
	self.helpfont = love.graphics.newFont("PressStart2P.ttf", 12)
	self.scorefont = love.graphics.newFont("PressStart2P.ttf", 20)
	
	blip = love.audio.newSource("sfx/bump.ogg")
	blip:setLooping(false)
	
	bgm = love.audio.newSource("sfx/gamelow.ogg")
	bgm:setLooping(true)

	background = love.graphics.newImage("gfx/game_screen.png")

	enemies = {}
	bullets = {}
	objects = {}

	for i = 1, 9 do
		local g = GlowBorg()
		--table.insert(enemies, Enemy(math.random(800 - enemy_width), math.random(600 - enemy_height), math.random(40,80)))
		table.insert(enemies, g)
		table.insert(objects, g)
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

	player1:update(dt, width, height)

	for _, e in ipairs(enemies) do
		e:update(dt, width, height)
	end
	
	local x = 1
	for _, b in ipairs(bullets) do
		b:update(dt, width, height)

		if b:exited_screen(width,height) then
			table.remove(bullets, x)
		end

		x = x + 1
	end

	for i=1,table.getn(objects) do
		
	end

end

function Game:draw(dt)
	--love.graphics.draw(background, 0, 0)
	love.graphics.setFont(self.helpfont)

	love.graphics.print(
		help,
		10, height - 10
	)
	
	love.graphics.setFont(self.scorefont)
	
	love.graphics.printf(
		scorestring .. score,
		width - 300, 10,
		300,
		"left"
	)
	
	for _, b in ipairs(bullets) do
		b:draw()

		love.graphics.setColor(255,255,255,255)
		--love.graphics.print("X: " .. tostring(b:getX()), 10, 10)
		--love.graphics.print("Y: " .. tostring(b:getY()), 10, 30)
	end

	player1:draw()
	
	for _, e in ipairs(enemies) do
		e:draw()
	end
end

function Game:keyreleased(key)
	player1:keyreleased(key)
	
	if key == 'escape' then
		switchTo(Menu)
	end
	
	if key == 'h' then
		switchTo(ScoreScreen)
	end
end

function Game:calc_dist(x1, x2, y1, y2)
	local x_dist = math.pow(x2-x1,2)
	local y_dist = math.pow(y2-y1,2)

	return math.sqrt(x_dist + y_dist)
end

return Game