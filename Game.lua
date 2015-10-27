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
local help = "Press Esc to return to menu (I for invul, P for skip)"
local scorestring = "SCORE: "
local score = 0
local enemy_count = 9
local level
local create = {}
local bgm1
local bgm2

local h_timer = 0
local timer = 0
local waiting = false
local frames = {}

local wormholes = {}

--you can't prove this isn't good practice
ended = false

local background
bg_width, bg_height = 0, 0

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

	LevelLoader = require("LevelLoader")

	Player = require("Player")
	GlowBorg = require("GlowBorg")
	CircleBorg = require("CircleBorg")
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
	Wall = require("Wall")
	Frame = require("Frame")
	Winhole = require("Winhole")

	self.helpfont = love.graphics.newFont("PressStart2P.ttf", 12)
	self.scorefont = love.graphics.newFont("PressStart2P.ttf", 20)

	blip = love.audio.newSource("sfx/bump.ogg")
	blip:setLooping(false)

	teleport = love.audio.newSource("sfx/teleport.mp3")
	teleport:setLooping(false)

	error = love.audio.newSource("sfx/error.wav")
	error:setLooping(false)

	jump = love.audio.newSource("sfx/jump.wav")
	jump:setLooping(false)

	bombblast = love.audio.newSource("sfx/bomb.wav")
	bombblast:setLooping(false)

	bgm = love.audio.newSource("sfx/gamelow.ogg")
	bgm:setLooping(true)

	bg_invul = love.audio.newSource("sfx/invul.ogg")
	bgm:setLooping(false)

	-- for parallax
	overlay = love.graphics.newImage("gfx/large_bg_2_overlay.png")

	enemies = {}
	bullets = {}
	objects = {}
end

function Game:start()
	time = 0
	
	bgm:play()
	bgm1 = true
	bgm2 = false

	ended = false

	player = Player(0,0,0)
	level = LevelLoader(levelNum)

	bg_width, bg_height = level:getBackgroundDimensions()
	background = level:getBackground()

	-- set up wormholes
	for i = 1, table.getn(objects) do
		if objects[i]:getID() == 7 then
			table.insert(wormholes, objects[i])
		end
	end

	-- give wormholes teleports
	for i = 1, table.getn(wormholes) do
		local worm = wormholes[(i + 1) % table.getn(wormholes) + 1]
		wormholes[i]:setTeleport(worm:getX(), worm:getY())
	end

	-- local worm
	-- for i = 1, table.getn(wormholes) do
	-- 	if math.fmod(i, 2) == 1 then
	-- 		worm = wormholes[(i + 1)]
	-- 	else
	-- 		worm = wormholes[(i - 1)]
	-- 	end
	-- 	wormholes[i]:setTeleport(worm:getX(), worm:getY())
	-- end

	enemy_count = 9
	score = 0
	recent_score = 0

	camera = Camera(
			player:getWidth(), player:getHeight(),
			bg_width, bg_height
	)

	--table.insert(frames, Frame(1000,1000,0,0))
	--table.insert(frames, Frame(400,400,0,0))

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

	length = table.getn(wormholes)
	for i = 0, length - 1 do
		table.remove(wormholes, length - i)
	end
	
	level = nil
end

function Game:lose()
	self:scoreCheck()
	levelNum = 1
	ended = true
	switchTo(GameOver)
end

function Game:win()
	score = score + 3000
	self:scoreCheck()
	levelNum = 1
	ended = true
	switchTo(Win)
end

function Game:nextLevel()
	levelNum = levelNum + 1
	if (levelNum - 1) == 1 then
		switchTo(Intro2)
	elseif (levelNum - 1) == 2 then
		switchTo(Intro3)
	else
		self:win()
	end
end

function Game:advance()
	if levelNum == max_level then
		self:win()
	else
		self:nextLevel()
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

	if player.invul and bgm1 and player.isJumping == false then
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

		if o:isDead() then
			if o:getID() == 1 then
				score = score + 200
			end
			table.remove(objects, x)
		end

		x = x + 1
	end
	--checks for win/lose states
	-- if level.hordeMode then
		-- self:hordeCheck(dt)
	-- end
	-- length = table.getn(objects)
	-- enemy_gone = true
	-- for i=1, length do
		-- if objects[i]:getID() == 1 and objects[i]:getType() == 'b' then
			-- enemy_gone = false
		-- end
	-- end

	-- if enemy_gone and not ended then
		-- if not level.hordeMode then
			-- self:win()
			-- time = 0
			-- h_timer = 0
		-- end
	-- end
	
	-- if player:isDead() and not ended then
		-- time = 0
		-- levelNum = 1
		-- h_timer = 0
		-- self:lose()
	-- end
	level:update(dt, score, self)
end

function Game:draw(dt)

	-- coordinates
	camera:position(player:getX(), player:getY())
	local cx, cy = 0, 0
	local fx, fy = self:inFrame()

	-- not in a frame
	if fx == 1 and fy == 1 then
		if player:isDamaged() then
			cx, cy = camera:shake()
		else
			cx, cy = camera:move()
		end
	-- inside a frame
	else
		camera:position(fx, fy)
		if player:isDamaged() then
			cx, cy = camera:shake()
			cx = cx + fx
			cy = cy + fy
		else
			cx, cy = fx, fy
		end
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
	--ST:draw()
	-- parallax
	love.graphics.translate(cx/(parallax + 1), cy/(parallax + 1))
	love.graphics.draw(overlay, 0, 0)

	love.graphics.translate(-cx/(parallax + 1), -cy/(parallax + 1))

	for _, o in ipairs(objects) do
		local ox = o:getX()
		local oy = o:getY()
		local ow = o:getWidth()/2
		local oh = o:getHeight()/2
		ox = ox + ow
		oy = oy + oh
		if -cx < ox and ox < -1 * (cx - 1000) then
			if -cy < oy and oy < -1 * (cy - 1000) then
				o:draw()
			end
		end

		--self:drawHitboxes(o)
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

	love.graphics.print(
		"HYPERJUMPS: " .. player:getJump(),
		10, 70
	)

	love.graphics.printf(
		scorestring .. score,
		width - 300, 10,
		300,
		"left"
	)

	if level.hordeMode then
		level:hordeDraw()
	end

	--fps = love.timer.getFPS()
	--love.graphics.print(tostring(fps), 700, 10)

	if player:flash() then
		local t = player:getFlashTimer() + .6
		local alpha = (255 * t)
		love.graphics.setColor(255, 255, 255, alpha)
		love.graphics.rectangle('fill', 0, 0, 2000, 2000)
	end
end

-- function Game:hordeCheck(dt)
	-- h_timer = h_timer + dt
	-- if h_timer > 120 then
		-- time = 0
		-- h_timer = 0
		-- self:win()
	-- end
-- end

-- function Game:hordeDraw()
	-- local timeLeft = math.floor(120 - h_timer)
	-- love.graphics.print(
		-- "TIME: " .. timeLeft,
		-- 250, 10
	-- )
-- end

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
		levelNum = 1
		switchTo(Menu)
	end

	if key == 'p' then
		self:advance()
	end
end

function Game:keypressed(key)
	--body
end

function Game:inFrame()
	for _,frame in ipairs(frames) do
		if frame:entered(player:getX(), player:getY()) then
			return frame:getCoordinates()
		end
	end
	return 1, 1
end

return Game
