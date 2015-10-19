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
local help = "Press Esc to return to menu (I for invul)"
local scorestring = "SCORE: "
local score = 0
local enemy_count = 9
local level = "level/level1"
local create = {}
local player
local bgm1
local bgm2

local shake = false
local parallax = 10

local timer = 0
local waiting = false

local enemy_gone = false
local player_gone = false

local wormholes = {}

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
	love.graphics.setDefaultFilter("nearest", "nearest")

	Player = require("Player")
	GlowBorg = require("GlowBorg")
	Bullet = require("Bullet")
	PhantomShip = require("PhantomShip")
	SunBoss = require("SunBoss")
	Spawn = require("Spawn")
	DoubleShot = require("DoubleShot")
	Repair = require("Repair")
	SpeedUp = require("SpeedUp")
	Missile = require("Missile")
	Wormhole = require("Wormhole")
	ScreenTable = require("ScreenTable")

	self.helpfont = love.graphics.newFont("PressStart2P.ttf", 12)
	self.scorefont = love.graphics.newFont("PressStart2P.ttf", 20)

	blip = love.audio.newSource("sfx/bump.ogg")
	blip:setLooping(false)

	teleport = love.audio.newSource("sfx/teleport.mp3")
	teleport:setLooping(false)

	error = love.audio.newSource("sfx/error.wav")
	error:setLooping(false)

	bombblast = love.audio.newSource("sfx/bomb.wav")
	bombblast:setLooping(false)

	bgm = love.audio.newSource("sfx/gamelow.ogg")
	bgm:setLooping(true)

	bg_invul = love.audio.newSource("sfx/invul.ogg")
	bgm:setLooping(true)

	--default background
	bg_string = "gfx/large_bg.png"
	--looks for background filename in level file
	for line in love.filesystem.lines(level) do
		if string.find(line, "BG:") ~= nil then
			bg_string = string.sub(line, 4)
		end
	end
	background = love.graphics.newImage(bg_string)
	bg_width = background:getWidth()
	bg_height = background:getHeight()

	-- for parallax
	overlay = love.graphics.newImage("gfx/large_bg_2_overlay.png")

	enemies = {}
	bullets = {}
	objects = {}
end

function Game:start()
	bgm:play()
	bgm1 = true
	bgm2 = false

	--populates creation array with everything specified in level file
	for line in love.filesystem.lines(level) do
		if string.find(line, "BG:") == nil then
			obj, x, y, z, w = string.match(line, "(%a+)%((%d+),(%d+),(%d+),(%d+)%)")
			thing = {obj, tonumber(x), tonumber(y), tonumber(z), tonumber(w)}
			table.insert(create, thing)
		end
	end

	--creates objects in level from creation array
	for num, tuple in ipairs(create) do
		self:make(tuple[1], tuple[2], tuple[3], tuple[4], tuple[5])
	end

	-- set up wormholes
	for i = 1, table.getn(objects) do
		if objects[i]:getID() == 7 then
			table.insert(wormholes, objects[i])
		end
	end
	-- give wormholes teleports
	for i = 1, table.getn(wormholes) do
		wormholes[i]:setTeleport(wormholes[(i + 1) % table.getn(wormholes)])
	end

	enemy_count = 9
	score = 0
	recent_score = 0

	enemy_gone = false
	player_gone = false

	-- table.insert(objects, g)
	table.insert(objects, SunBoss(500, 500))

	camera = Camera(
			player:getWidth(), player:getHeight(),
			bg_width, bg_height
	)

	ST = ScreenTable(10,10,bg_width,bg_height)
end

function Game:stop()
	bgm:stop()
	bg_invul:stop()

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
	timer = timer + dt

	ST:update(dt, objects)

	if player.invul and bgm1 then
		bgm:stop()
		bg_invul:play()
		bgm1 = false
		bgm2 = true
	elseif (not player.invul) and bgm2 then
		bg_invul:stop()
		bgm:play()
		bgm1 = true
		bgm2 = false
	end

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
			o:exited_map(bg_width + player:getWidth(), bg_height + player:getHeight()) then
			table.remove(objects, x)
		end

		if o:getID() == 1 and o:getType() == 'f' then
			o:shoot(dt,playerx,playery)
		end

		if o:isDead() then
			table.remove(objects, x)
		end

		x = x + 1
	end

	--[[
	local length = table.getn(objects)
	for i=1, length - 1 do
		for j = i + 1, length do
			if objects[i]:getID() ~= objects[j]:getID() and objects[i].collided == false and objects[j].collided == false then
				if self:valid(objects[i], objects[j]) then
					if self:touching(objects[i], objects[j]) then
						-- love.timer.sleep(0.08)
						-- objects collided
						objects[i].collided = true
						objects[j].collided = true
						-- set to explode
						objects[i].current_state = 2
						objects[i].current_frame = 1
						objects[j].current_state = 2
						objects[j].current_frame = 1
						-- begin screen shake
						shake = true
					end
				end
				--terrible collision code for stuff that doesn't explode
				if objects[i]:getID() ~= 4 and objects[j]:getID() ~= 4 then
					if self:touching(objects[i], objects[j]) then
						--collision between player and powerup
						if objects[i]:getID() == 2 and objects[j]:getID() == 5 then
							--checks for type of powerup to determine effects
							if objects[j]:getType() == 'ds' then
								objects[i].double = true
							elseif objects[j]:getType() == 'r' then
								objects[i].health = objects[i].health + 2
							elseif objects[j]:getType() == 'sp' then
								objects[i].max_vel = objects[i].max_vel + 100
							end
							objects[j].collided = true
						elseif objects[i]:getID() == 5 and objects[j]:getID() == 2 then
							--checks for type of powerup to determine effects
							if objects[i]:getType() == 'ds' then
								objects[j].double = true
							elseif objects[i]:getType() == 'r' then
								objects[j].health = objects[j].health + 2
							elseif objects[i]:getType() == 'sp' then
								objects[j].max_vel = objects[j].max_vel + 100
							end
							objects[i].collided = true
						end
						--collision between boss and player bullet
						if objects[i]:getID() == 3 and objects[j]:getID() == 1 and
						objects[j]:getType() == 'b' then
							objects[i].collided = true
							objects[j]:hit()
						elseif objects[i]:getID() == 1 and objects[j]:getID() == 3 and
						objects[i]:getType() == 'b'  then
							objects[j].collided = true
							objects[i]:hit()
						end
					end
				end
			end
		end
	end

	--check for when to end explosion animation and remove object.
	--For enemies/player, this starts a .58 second timer so the
	--explosion animation will play, but for bullet/enemybullet/powerup/boss (temp)
	--the object will immediately be removed
	for i = 0, length - 1 do
		if objects[length - i].collided then
			--player collision won't kill player unless health is at 1
			if objects[length - i]:getID() == 2 and objects[length - i]:alive() then
				objects[length - i]:hit()
				if objects[length - i]:alive() then
					objects[length - i].current_state = 1
					objects[length - i].collided = false
				else
					objects[length - i].current_state = 2
					objects[length - i].collided = true
				end
			-- remove objects that collided and end shake
			elseif objects[length - i].timer > .58 then
				table.remove(objects, length - i)
				score = score + 200
				enemy_count = enemy_count - 1
				-- end the screen shake
				shake = false
			elseif objects[length - i]:getID() == 3  or objects[length - i]:getID() == 5 or
			(objects[length - i]:getID() == 1 and objects[length - i]:getType() == 'b') or
			objects[length - i]:getID() == 6 then
				table.remove(objects, length - i)
			else
				objects[length - i].timer = objects[length - i].timer + dt
				if objects[length - i]:getID() == 2 then
					objects[length - i].max_vel = 0--objects[length - i].max_vel / 1.1
				end
				objects[length - i].vel = 0--objects[length - i].vel / 1.1
			end
		end
	end
	--]]

	--checks for win/lose states
	length = table.getn(objects)
	enemy_gone = true
	player_gone = true
	for i=1, length do
		if objects[i]:getID() == 1 and objects[i]:getType() == 'b' then
			enemy_gone = false
		elseif objects[i]:getID() == 2 then
			player_gone = false
		end
	end

	if enemy_gone then
		--time = 0
		--self:win()
	elseif player_gone then
		time = 0
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

	--boss collision is handled elsewhere because we want it to have health
	if (id_one == 1 and obj1:getType() == 'b') or (id_two == 1 and obj2:getType() == 'b') then
		valid = false
	end

	return valid
end

function Game:draw(dt)

	-- coordinates
	camera:position(player:getX(), player:getY())
	local cx, cy = 0, 0

	if shake then
		cx, cy = camera:shake()
	else
		cx, cy = camera:move()
	end

	-- zoom in
	if time < 0.8 then
		v = time / 0.8;
		v = 1 - (1 - v) * (1 - v)
		X = (1 * v) + (2 * (1 - v))
		love.graphics.scale(1/X, 1/X)
	end

	-- move background
	love.graphics.translate(cx, cy)
	love.graphics.draw(background, 0, 0)
	ST:draw()
	-- parallax
	love.graphics.translate(cx/parallax, cy/parallax)
	love.graphics.draw(overlay, 0, 0)

	love.graphics.translate(-cx/parallax, -cy/parallax)

	for _, o in ipairs(objects) do
		o:draw()

		if o:getID() == 2 or o:getID() == 1 or o:getID() == 3 then
			local t = o:getHitBoxes()
			for _, h in ipairs(t) do
				love.graphics.setColor(255, 0, 0, 255)
				love.graphics.circle("line", h[1], h[2], h[3], 100)
				love.graphics.setColor(255, 255, 255, 255)
			end
		end

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
	-- zoom in
	love.graphics.translate(-cx, -cy)
	if time < 0.8 then
		v = time / 0.8;
		v = 1 - (1 - v) * (1 - v)
		X = (1 * v) + (2 * (1 - v))
		love.graphics.scale(X, X)
	end

	love.graphics.setFont(self.helpfont)
	love.graphics.print(
		help,
		10, height - 20
	)

	love.graphics.setFont(self.scorefont)
	love.graphics.print(
		"HEALTH: " .. player:getHealth(),
		10, 10
	)

	love.graphics.print(
		"BOMBS: " .. player:getBomb(),
		250, 10
	)

	love.graphics.printf(
		scorestring .. score,
		width - 300, 10,
		300,
		"left"
	)

	fps = love.timer.getFPS()
	love.graphics.print(tostring(fps), 700, 10)

	if player:flash() then
		local t = player:getFlashTimer() + .6
		local alpha = (255 * t)
		love.graphics.setColor(255, 255, 255, alpha)
		love.graphics.rectangle('fill', 0, 0, 2000, 2000)
	end

end

function Game:keyreleased(key)
	player:keyreleased(key)

	if key == 'escape' then
		time = 0
		switchTo(Menu)
	end
end

function Game:keypressed(key)
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

--creates specified object based on three letter code and up to
--four constructor arguments (this isn't great and will probably
--be changed)
function Game:make(thing, x, y, z, w)
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
	elseif thing == "osb" then
		obj = SunBoss(x, y)
	elseif thing == "sgb" then
		obj = Spawn(x, y, z, w, 'g')
	elseif thing == "sps" then
		obj = Spawn(x, y, z, w, 'f')
	elseif thing == "pwr" then
		obj = DoubleShot(x, y, 0)
	elseif thing == "rep" then
		obj = Repair(x, y, 0)
	elseif thing == "spd" then
		obj = SpeedUp(x, y, 0)
	elseif thing == "wrm" then
		obj = Wormhole(x, y)
	end

	table.insert(objects, obj)
end

return Game
