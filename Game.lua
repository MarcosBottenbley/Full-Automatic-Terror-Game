State = require("State")

local Game = {}
local help = "Press H for high scores, Esc for menu, P for points\n" ..
			"-Press Y to die    -Press X to not die"
local scorestring = "SCORE: "
local score = 0
local timer = 0
local waiting = false
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
				if (objects[i]:getID() ~= 3 and objects[j]:getID() ~= 2) or (objects[i]:getID() ~= 2 and objects[j]:getID() ~= 3) then
					if self:touching(objects[i], objects[j]) then

						-- objects collided
						objects[i].collided = true
						objects[j].collided = true
						-- set to explode
						objects[i].current_state = 2
						objects[j].current_state = 2
						-- start timer
						waiting = true

					end
				end
			end
		end
	end
	
	--for i=0, length - 1 do
	--	if objects[length - i].collided then
	--		if objects[length - i]:getID() == 3 then
	--			table.remove(objects, length - i)
	--		end
	--	end
	--end

	-- if they collided, waiting = true
	if waiting then
		-- wait for animation
		if timer > 1.6 then
			for i=0, length - 1 do
				if objects[length - i].collided then
					table.remove(objects, length - i)
				end
				waiting = false
				timer = 0
			end
		end
	end

	timer = timer + dt

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
	end
	
	love.graphics.setFont(self.scorefont)
	
	love.graphics.printf(
		scorestring .. score,
		width - 300, 10,
		300,
		"left"
	)
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

function Game:touching(obj1, obj2)
	local hb_1 = obj1:getHitBoxes()
	local hb_2 = obj2:getHitBoxes()

	local length1 = table.getn(hb_1)
	local length2 = table.getn(hb_2)

	if length1 >= length2 then
		for i = 1, length1 do
			for j = 1, length2 do
				local x_dist = math.pow(hb_1[i][1]-hb_2[j][1],2)
				local y_dist = math.pow(hb_1[i][2]-hb_2[j][2],2)
				local d = math.sqrt(x_dist + y_dist)

				if d < hb_1[i][3] + hb_2[j][3] then
					return true
				end
			end
		end
	else
		for i = 1, length2 do
			for j = 1, length1 do
				local x_dist = math.pow(hb_2[i][1]-hb_1[j][1],2)
				local y_dist = math.pow(hb_2[i][2]-hb_1[j][2],2)
				local d = math.sqrt(x_dist + y_dist)

				if d < hb_2[i][3] + hb_1[j][3] then
					return true
				end
			end
		end
	end
end

return Game