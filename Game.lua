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
local levelNum = 1
local level
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

local hordeMode = false
local h_timer = 0

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
	DualMaster = require("DualMaster")
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
	
	level = "level/level" .. levelNum

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
	
	if level == "level/level2" then 
		hordeMode = true
	end

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

	for i = 1, table.getn(wormholes) do
		-- print(wormholes[i]:getY())
	end
	-- give wormholes teleports
	for i = 1, table.getn(wormholes) do
		local worm = wormholes[(i + 1) % table.getn(wormholes) + 1]
		wormholes[i]:setTeleport(worm:getX(), worm:getY())
		print("i: " .. i .. " "
					.. wormholes[i]:getX() .. " " .. wormholes[i]:getY() .. " "
					.. worm:getX() .. " " .. worm:getY())
	end

	enemy_count = 9
	score = 0
	recent_score = 0

	enemy_gone = false
	player_gone = false

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
	if levelNum == 1 then
		self:switchTo(Game)
	elseif levelNum == 2 then
		self:scoreCheck()
		switchTo(Win)
	end
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

		if o:getID() == 3 or o:getID() == 6 then
			o:exited_map(bg_width + player:getWidth(), bg_height + player:getHeight())
		end

		if o:getID() == 1 and o:getType() == 'f' then
			o:shoot(dt,playerx,playery)
		end

		if o:isDead() then
			if o:getID() == 1 then
				score = score + 200
			end
			table.remove(objects, x)
		end

		x = x + 1
	end

	--checks for win/lose states
	if hordeMode then
		self:hordeCheck()
	end
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
		--- time = 0
		--- self:win()
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
		self:drawHitboxes(o)
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
		10, 40
	)

	love.graphics.printf(
		scorestring .. score,
		width - 300, 10,
		300,
		"left"
	)
	
	if hordeMode then
		self:hordeDraw()
	end

	fps = love.timer.getFPS()
	love.graphics.print(tostring(fps), 700, 10)

	if player:flash() then
		local t = player:getFlashTimer() + .6
		local alpha = (255 * t)
		love.graphics.setColor(255, 255, 255, alpha)
		love.graphics.rectangle('fill', 0, 0, 2000, 2000)
	end
end

function Game:drawHitboxes(obj)
	local t = obj:getHitBoxes()
	if obj:getID() ~= 4 then
		for _, h in ipairs(t) do
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.circle("line", h[1], h[2], h[3], 100)
			love.graphics.setColor(255, 255, 255, 255)
		end
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
	--body
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
	elseif thing == "odm" then
		obj = DualMaster()
		obj:setPosition(x, y)
	elseif thing == "osb" then
		obj = SunBoss(x, y)
	elseif thing == "sgb" then
		obj = Spawn(x, y, z, w, 'g')
	elseif thing == "sps" then
		obj = Spawn(x, y, z, w, 'f')
	elseif thing == "sdm" then
		obj = Spawn(x, y, z, w, 'd')
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

function hordeCheck(dt)
	h_timer = h_timer + dt
	if h_timer > 120 then
		self:win()
	end
end

function hordeDraw()
	local timeLeft = math.floor(120 - h_timer)
	love.graphics.print(
		"TIME: " .. timeLeft,
		250, 10
	)
end

return Game
