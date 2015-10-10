--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

State = require("State")
Camera = require("Camera")

local Game = {}
local help = "Press Esc to return to menu"
local scorestring = "SCORE: "
local score = 0
local enemy_count = 9
local level = "level0"
local create = {}
local player

local timer = 0
local waiting = false

local enemy_gone = false
local player_gone = false

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
	PhantomShip = require("PhantomShip")
	Spawn = require("Spawn")
	Powerup = require("Powerup")

	self.helpfont = love.graphics.newFont("PressStart2P.ttf", 12)
	self.scorefont = love.graphics.newFont("PressStart2P.ttf", 20)

	blip = love.audio.newSource("sfx/bump.ogg")
	blip:setLooping(false)

	bgm = love.audio.newSource("sfx/gamelow.ogg")
	bgm:setLooping(true)

	background = love.graphics.newImage("gfx/large_bg.png")
	bg_width = background:getWidth()
	bg_height = background:getHeight()
	
	if not love.filesystem.exists("level0") then
		love.filesystem.write("level0", level0)
	end

	enemies = {}
	bullets = {}
	objects = {}
end

function Game:start()
	bgm:play()
	
	for line in love.filesystem.lines(level) do
		obj, x, y = string.match(line, "(%a+)%((%d+),(%d+)%)")
		thing = {obj, tonumber(x), tonumber(y)}
		table.insert(create, thing)
	end
	
	for num, tuple in ipairs(create) do
		self:make(tuple[1], tuple[2], tuple[3])
	end

	enemy_count = 9
	score = 0
	recent_score = 0

	enemy_gone = false
	player_gone = false

	-- player = Player(bg_width/2, bg_height/2, 200)
	-- table.insert(objects, player)

	-- powerup = Powerup(bg_width/2 - 50, bg_height/2 - 50, 0)
	-- table.insert(objects, powerup)

	-- table.insert(objects, Spawn(200, 400, 300, 'g'))
	-- table.insert(objects, Spawn(1200, 1200, 100, 'f'))

	-- table.insert(objects, Spawn(500, 1000, 300, 'g'))
	-- table.insert(objects, Spawn(1000, 200, 300, 'f'))

	-- table.insert(objects, Spawn(1200, 1600, 300, 'g'))
	-- table.insert(objects, Spawn(100, 1600, 300, 'g'))

	-- local g = GlowBorg()
	-- g:setPosition(100, 100)


	-- table.insert(objects, g)

	camera = Camera(
			player:getWidth(), player:getHeight(),
			bg_width, bg_height
	)
end

function Game:stop()
	bgm:stop()

	local length = table.getn(objects)
	for i = 0, length - 1 do
		table.remove(objects, length - i)
	end
	
	length = table.getn(create)
	for i = 0, length - 1 do
		table.remove(create, length - i)
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
			table.remove(highscores, 7)
			break
		end
	end
end

function Game:update(dt)
	time = time + dt

	local playerx = 0
	local playery = 0
	local x = 1
	for _, o in ipairs(objects) do
		-- update Spawn

		if x == 1 then
			playerx = o:getX()
			playery = o:getY()
		end

		if o:getID() == 4 then
			o:update(dt, playerx, playery)
		end

		o:update(dt, bg_width, bg_height, playerx, playery)

		if o:getID() == 3 and
			o:exited_screen(bg_width + player:getWidth(), bg_height + player:getHeight()) then
			table.remove(objects, x)
		end

		if o:getID() == 1 and o:getType() == 'f' then
			o:shoot(dt,playerx,playery)
		end

		x = x + 1
	end

	local length = table.getn(objects)
	for i=1, length - 1 do
		for j = i + 1, length do
			if objects[i]:getID() ~= objects[j]:getID() and objects[i].collided == false and objects[j].collided == false then
				if self:valid(objects[i], objects[j]) then
					if self:touching(objects[i], objects[j]) then

						-- objects collided
						objects[i].collided = true
						objects[j].collided = true
						-- set to explode
						objects[i].current_state = 2
						objects[i].current_frame = 1
						objects[j].current_state = 2
						objects[j].current_frame = 1
					end
				end
				--shitty powerup collision code
				if objects[i]:getID() ~= 4 and objects[j]:getID() ~= 4 then
					if self:touching(objects[i], objects[j]) then
						if objects[i]:getID() == 2 and objects[j]:getID() == 5 then
							objects[i].powerup = true
							objects[j].collided = true
						elseif objects[i]:getID() == 5 and objects[j]:getID() == 2 then
							objects[j].powerup = true
							objects[i].collided = true
						end
					end
				end
			end
		end
	end

	--check for when to end explosion animation and remove object
	for i=0, length - 1 do
		if objects[length - i].collided then
			if objects[length - i].timer > .58 then
				table.remove(objects, length - i)
				score = score + 200
				enemy_count = enemy_count - 1
			elseif objects[length - i]:getID() == 3  or objects[length - i]:getID() == 5 then
				table.remove(objects, length - i)
			else
				objects[length - i].timer = objects[length - i].timer + dt
			end
		end
	end

	--checks for win/lose states
	length = table.getn(objects)
	enemy_gone = true
	player_gone = true
	for i=1, length do
		if objects[i]:getID() == 1 then
			enemy_gone = false
		elseif objects[i]:getID() == 2 then
			player_gone = false
		end
	end

	if enemy_gone then
		self:win()
	elseif player_gone then
		self:lose()
	end
end

function Game:valid(obj1, obj2)
	local valid = false

	local id_one = obj1:getID()
	local id_two = obj2:getID()

	if id_one ~= 4 and id_two ~= 4 and id_one ~= 5 and id_two ~= 5 then
		if (id_one == 2 and id_two ~= 3) or (id_two == 2 and id_one ~= 3) or id_one == 1 or id_two == 1 then
			valid = true
		end
	end

	return valid
end

function Game:draw(dt)

	-- coordinates
	camera:position(player:getX(), player:getY())
	local cx, cy = camera:move()

	-- move background
	love.graphics.translate(cx, cy)

	love.graphics.draw(background, 0, 0)

	for _, o in ipairs(objects) do
		o:draw()

		--if o:getID() == 2 or o:getID() == 1 then
		--	local t = o:getHitBoxes()
		--	for _, h in ipairs(t) do
		--		love.graphics.setColor(255, 0, 0, 255)
		--		love.graphics.circle("line", h[1], h[2], h[3], 100)
		--		love.graphics.setColor(255, 255, 255, 255)
		--	end
		--end

		--wrap around
		--[[if o:getID() == 2 then
			if o:getX() < width/2 then
				o:setX(bg_width - width/2 - 1)
			end
			if o:getY() < height/2 then
				o:setY(bg_height - height/2 - 1)
			end
			if o:getX() > bg_width - width/2 then
				o:setX(width/2 + 1)
			end
			if o:getY() > bg_height - height/2 then
				o:setY(height/2 + 1)
			end
		end--]]

	end
	-- move text
	love.graphics.translate(-cx, -cy)

	love.graphics.setFont(self.helpfont)
	love.graphics.print(
		help,
		10, height - 20
	)

	love.graphics.setFont(self.scorefont)
	love.graphics.printf(
		scorestring .. score,
		width - 300, 10,
		300,
		"left"
	)

end

function Game:keyreleased(key)
	player:keyreleased(key)

	if key == 'escape' then
		switchTo(Menu)
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

function Game:make(thing, x, y)
	local obj

	if thing == "pla" then
		player = Player(x, y, 200)
		table.insert(objects, player)
		return
	elseif thing == "ogb" then
		obj = GlowBorg()
		obj:setPosition(x, y)
	elseif thing == "ops" then
		obj = PhantomShip()
		obj:setPosition(x, y)
	elseif thing == "sgb" then
		obj = Spawn(x, y, 300, 'g')
	elseif thing == "sps" then
		obj = Spawn(x, y, 100, 'f')
	elseif thing == "pwr" then
		obj = Powerup(x, y, 0)
	end

	table.insert(objects, obj)
end

return Game
