State = require("State")

local Game = {}
local help = "Press H for high scores, Esc for menu, P for points\n" ..
			"-Press Y to die    -Press X to not die"
local scorestring = "SCORE: "
local score = 0
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
end

function Game:start()
	bgm:play()
	
	score = 0
	recent_score = 0
	
	for i = 1, 9 do
		local g = GlowBorg()
		table.insert(objects, g)
	end

	player1 = Player(width/2, height/2, 200)
	table.insert(objects, player1)
end

function Game:stop()
	bgm:stop()
	
	for i, thing in ipairs(objects) do
		table.remove(objects, i)
	end
end

function Game:lose()
	self:scoreCheck()
	switchTo(GameOver)
end

function Game:win()
	score = score + 3000
	self:scoreCheck()
	switchTo(Win)
end

function Game:scoreCheck()
	for rank, hs in ipairs(highscores) do
		if score > tonumber(hs) then
			recent_score = rank
			table.insert(highscores, rank, score)
			table.remove(highscores, 6)
			break
		end
	end
end

function Game:update(dt)
	time = time + dt

	local x = 1
	for _, o in ipairs(objects) do
		o:update(dt, width, height)

		if o:getID() == 3 and o:exited_screen(width, height) then
			table.remove(objects, x)
		end

		x = x + 1
	end

	local length = table.getn(objects)
	for i=1, length - 1 do
		for j = i + 1, length do
			if objects[i]:getID() ~= objects[j]:getID() then
				local d = self:calc_dist(objects[i]:getX(), objects[j]:getX(), objects[i]:getY(), objects[j]:getY())
				if d < 10 then
					objects[i].collided = true
					objects[j].collided = true
				end
			end
		end
	end
	
	for i=0, length - 1 do
		if objects[length - i].collided then
			table.remove(objects, length - i)
		end
	end
	
	

end

function Game:draw(dt)
	love.graphics.draw(background, 0, 0)
	love.graphics.setFont(self.helpfont)

	love.graphics.print(
		help,
		10, height - 20
	)

	for _, o in ipairs(objects) do
		o:draw()

		if o:getID() == 3 then
			love.graphics.setColor(255,255,255,255)
			love.graphics.print("X: " .. tostring(o:getX()), 10, 10)
			love.graphics.print("Y: " .. tostring(o:getY()), 10, 30)
		end
	end
	
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
	
	--there's definitely a better way to do this
	if key == 'escape' then
		switchTo(Menu)
	end
	
	if key == 'h' then
		switchTo(ScoreScreen)
	end
	
	if key == 'y' then
		self:lose()
	end
	
	if key == 'x' then
		self:win()
	end
	
	if key == 'p' then
		score = score + 100
	end
end

function Game:calc_dist(x1, x2, y1, y2)
	local x_dist = math.pow(x2-x1,2)
	local y_dist = math.pow(y2-y1,2)

	return math.sqrt(x_dist + y_dist)
end

return Game