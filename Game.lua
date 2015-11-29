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
local help = "Press Esc to pause (I for invul, P for skip)"
local scorestring = "SCORE: "
local level
local create = {}
local bgm_normal
local bgm_starman
local flash = false

local pstring1 = "GAME PAUSED"
local pstring2 = "Press Q to quit to menu, Esc to resume,\nor R to restart the level."

local h_timer = 0
local timer = 0
local waiting = false
local pause = false
local frames = {}

local p

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
	Missile = require("Missile")
	ChargeShot = require("ChargeShot")
	PhantomShip = require("PhantomShip")
	DualMaster = require("DualMaster")
	SunBoss = require("SunBoss")
	Spawn = require("Spawn")
	ObjectHole = require("ObjectHole")
	DoubleShot = require("DoubleShot")
	Repair = require("Repair")
	SpeedUp = require("SpeedUp")
	Wormhole = require("Wormhole")
	ScreenTable = require("ScreenTable")
	Wall = require("Wall")
	Frame = require("Frame")
	Winhole = require("Winhole")
	MetalBall = require("MetalBall")
	MoonBoss = require("MoonBoss")
	Turret = require("Turret")
	Asteroid = require("Asteroid")
	WeaponPart = require("WeaponPart")

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

	laser_arm = love.audio.newSource("sfx/laser_arm.mp3")
	laser_arm:setLooping(false)

	missile_arm = love.audio.newSource("sfx/missile_arm.mp3")
	missile_arm:setLooping(false)

	charge_arm = love.audio.newSource("sfx/charge_arm.ogg")
	charge_arm:setLooping(false)

	bgm_1 = love.audio.newSource("sfx/bgm_1.ogg")
	bgm_1:setLooping(true)

	bgm_2 = love.audio.newSource("sfx/bgm_2.ogg")
	bgm_2:setLooping(true)

	bgm_3 = love.audio.newSource("sfx/bgm_3.ogg")
	bgm_3:setLooping(true)

	bg_invul = love.audio.newSource("sfx/invul.ogg")
	bg_invul:setLooping(false)

	-- for parallax
	overlay = love.graphics.newImage("gfx/large_bg_2_overlay.png")

	healthbar = love.graphics.newImage("gfx/health_bar.png")

	bomb = love.graphics.newImage("gfx/bomb.png")
	hyper = love.graphics.newImage("gfx/hyper.png")

	laser_s = love.graphics.newImage("gfx/laser_select.png")
	missle_s = love.graphics.newImage("gfx/missle_select.png")
	power_s = love.graphics.newImage("gfx/power_select.png")

	enemies = {}
	bullets = {}
	objects = {}

	self:particles()
end

function Game:start()
	time = 0
	ended = false
	pause = false

	player = Player(0,0,0)
	level = LevelLoader(levelNum)

	bgm:play()
	bgm_normal = true
	bgm_starman = false

	bg_width, bg_height = level:getBackgroundDimensions()
	background = level:getBackground()

	-- set up wormholes
	for i = 1, table.getn(objects) do
		if objects[i]:getID() == 7 then
			table.insert(wormholes, objects[i])
		end
	end

	-- give wormholes teleports
	-- for i = 1, table.getn(wormholes) do
	-- 	local worm = wormholes[(i + 1) % table.getn(wormholes) + 1]
	-- 	wormholes[i]:setTeleport(worm:getX(), worm:getY())
	-- end

	-- local worm
	-- for i = 1, table.getn(wormholes) do
	 	-- if math.fmod(i, 2) == 1 then
	 		-- worm = wormholes[(i + 1)]
		-- else
	 		-- worm = wormholes[(i - 1)]
	 	-- end
	 	-- wormholes[i]:setTeleport(worm:getX(), worm:getY())
	-- end

	camera = Camera(
			player:getWidth(), player:getHeight(),
			bg_width, bg_height
	)

	-- table.insert(frames, Frame(1000,1000,0,0))
	-- table.insert(frames, Frame(400,400,0,0))

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
	if levelNum == 2 then
		levelNum = levelNum + 1
		switchTo(Intro3)
	else
		self:scoreCheck()
		levelNum = 0
		score = 0
		recent_score = 0
		ended = true
		switchTo(GameOver)
	end
end

function Game:win()
	score = score + 3000
	self:scoreCheck()
	score = 0
	recent_score = 0
	ended = true
	switchTo(Win)
end

function Game:nextLevel()
	switchTo(Win)
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
	if pause then
		return
	end

	psystem:update(dt)
	--comment this next line out to keep the level zoomed out
	time = time + dt
	timer = timer + dt

	ST:update(dt, objects)

	if player.invul and bgm_normal and player.isJumping == false then
		bgm:stop()
		bg_invul:play()
		bgm_normal = false
		bgm_starman = true
	elseif (not player.invul) and bgm_starman then
		bg_invul:stop()
		bgm:play()
		bgm_normal = true
		bgm_starman = false
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
			if -cy - 200 < oy and oy < -1 * (cy - 1000) then
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

	self:drawHUD()

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

	if pause then
		love.graphics.setColor(0, 0, 0, 150)
		love.graphics.rectangle('fill', 0, 0, 2000, 2000)
		love.graphics.setColor(255,255,255,255)

		love.graphics.setFont(self.scorefont)

		love.graphics.print(
			pstring1, width/2 - self.scorefont:getWidth(pstring1)/2,
			height/2 - self.scorefont:getHeight(pstring1)/2
		)

		love.graphics.setFont(self.helpfont)
		love.graphics.print(
			pstring2, width/2 - self.helpfont:getWidth(pstring2)/2,
			height/2 - self.helpfont:getHeight(pstring2)/2 + self.scorefont:getHeight(pstring1)
		)
	end

	-- love.graphics.draw(psystem, love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
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

function Game:drawHUD()

	love.graphics.setFont(self.helpfont)
	love.graphics.print(
		help,
		10, height - 20
	)

	love.graphics.setFont(self.scorefont)
	love.graphics.print(
		"HEALTH:", 10, 10
	)

	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle("fill", 151, 6, 148 * (player:getHealth() / 10), 18)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(healthbar, 150, 5)

	love.graphics.setFont(self.scorefont)
	love.graphics.print(
		"WEAPON:", 10, 40
	)

	local weaponBarValues = {player:getBarValues()}

	if weaponBarValues[2] == 0 and weaponBarValues[3] == 0 then
		love.graphics.setColor(35, 200, 35, 255)
		love.graphics.rectangle("fill", 151, 36, 148 * weaponBarValues[1], 18)
	elseif weaponBarValues[2] == 0 then
		love.graphics.setColor(35, 200, 35, 255)
		love.graphics.rectangle("fill", 151, 36, 148, 18)
		love.graphics.setColor(17.5, 222.5, 17.5, 255)
		love.graphics.rectangle("fill", 151, 36, 148 * weaponBarValues[3], 18)
	elseif weaponBarValues[2] == 1 then
		love.graphics.setColor(17.5, 222.5, 17.5, 255)
		love.graphics.rectangle("fill", 151, 36, 148, 18)
		love.graphics.setColor(0, 255, 0, 255)
		love.graphics.rectangle("fill", 151, 36, 148 * weaponBarValues[3], 18)
	elseif weaponBarValues[2] == 2 then
		love.graphics.setColor(0, 255, 0, 255)
		love.graphics.rectangle("fill", 151, 36, 148, 18)
		love.graphics.setColor(0, 255, 255, 255)
		love.graphics.rectangle("fill", 151, 36, 148 * weaponBarValues[3], 18)
	elseif weaponBarValues[2] > 2 then
		if flash then
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.rectangle("fill", 151, 36, 148, 18)
		else
			love.graphics.setColor(0, 255, 255, 255)
			love.graphics.rectangle("fill", 151, 36, 148, 18)
		end
		flash = not flash
	end

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(healthbar, 150, 35)

	love.graphics.printf(
		scorestring .. score,
		width - 300, 10,
		300,
		"left"
	)
	-- BOMBS
	love.graphics.draw(bomb, width - 300, 44 - bomb:getHeight()/2)
	love.graphics.print(
		"X" .. player:getBomb(),
		width - 270, 40
	)
	-- HYPERJUMPS
	love.graphics.draw(hyper, width - 200, 44 - hyper:getHeight()/2)
	love.graphics.print(
		"X" .. player:getJump(),
		width - 168, 40
	)
	-- SELECTOR
	love.graphics.setColor(0, 255, 0, 150)
	love.graphics.rectangle("fill", width - ((-(player:getWeapon() - 1) * 60 + 177)) + 4, height - 36, 24, 24)
	love.graphics.setColor(255, 255, 255, 255)

	-- LASER
	love.graphics.print("1", width - 200, height - 28)
	love.graphics.draw(laser_s, width - 177, height - 40)
	-- MISSLE
	love.graphics.print("2", width - 140, height - 28)
	love.graphics.draw(missle_s, width - 117, height - 40)
	-- POWER CHARGE
	love.graphics.print("3", width - 80, height - 28)
	love.graphics.draw(power_s, width - 57, height - 40)
end

function Game:drawHitboxes(obj)
	local t = obj:getHitBoxes()
	if obj:getID() ~= 4 and obj:getID() ~= 10 then
		for _, h in ipairs(t) do
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.circle("line", h[1], h[2], h[3], 100)
			love.graphics.setColor(255, 255, 255, 255)
		end
	end
end

function Game:keyreleased(key)
	player:keyreleased(key)

	if key == 'q' and pause then
		levelNum = 0
		score = 0
		switchTo(Menu)
	end

	if key == 'r' and pause then
		switchTo(StageIntro)
	end

	if key == 'escape' then
		pause = not pause
	end

	if key == 'p' then
		self:advance()
	end
end

function Game:keypressed(key)
	player:keypressed(key)
end

function Game:inFrame()
	for _,frame in ipairs(frames) do
		if frame:entered(player:getX(), player:getY()) then
			return frame:getCoordinates()
		end
	end
	return 1, 1
end

function Game:particles()
	local img = love.graphics.newImage("gfx/particle.png")

	psystem = love.graphics.newParticleSystem(img, 100)
	psystem:setParticleLifetime(1, 3) -- Particles live at least 2s and at most 5s.
	psystem:setEmissionRate(20)
	psystem:setSizeVariation(1)
	psystem:setLinearAcceleration(0, -10, 0, 0) -- Random movement in all directions.
	psystem:setColors(255, 255, 0, 255, 255, 0, 0, 100) -- Fade to transparency.
end

return Game
