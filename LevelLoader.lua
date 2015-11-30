--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

bgm = nil
local manager

local LevelLoader = {
	level = "level/level0",
	bg_string = "gfx/large_bg_string.png",
	hordeMode = false, won = false,
	h_timer = 0, waveMode = false
}
LevelLoader.__index = LevelLoader

setmetatable(LevelLoader, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function LevelLoader:_init(lvlNum)
	self:setLevel(lvlNum)
	self:load()
end

function LevelLoader:setLevel(lvlNum)
	self.level = "level/level" .. lvlNum
	if lvlNum == 2 then
		self.hordeMode = true
	elseif lvlNum == 6 then
		self.waveMode = true
	end
end

function LevelLoader:load(...)
	local create = {}

	for line in love.filesystem.lines(self.level) do
		if string.find(line, "BG:") ~= nil then
			self.bg_string = string.sub(line, 4)
		end
	end

	self.background = love.graphics.newImage(self.bg_string)

	if levelNum == 1 then
		bgm = love.audio.newSource("sfx/bgm_1.ogg")
	elseif levelNum == 2 or levelNum == 6 then
		bgm = love.audio.newSource("sfx/bgm_2.ogg")
	elseif levelNum == 3 then
		bgm = love.audio.newSource("sfx/bgm_3.ogg")
	elseif levelNum == 4 then
		bgm = love.audio.newSource("sfx/bgm_4.ogg")
	else
		bgm = love.audio.newSource("sfx/bgm_1.ogg")
	end
	bgm:setLooping(true)

	bg_invul = love.audio.newSource("sfx/invul.ogg")
	bg_invul:setLooping(false)

	--populates creation array with everything specified in level file
	for line in love.filesystem.lines(self.level) do
		--if the level is in wave mode, then use wave manager to load rest of level
		if string.find(line, "wave:") ~= nil then
			manager = WaveManager(self.level)
			manager:load()
			for num, tuple in ipairs(create) do
				self:make(tuple)
			end
			return
		elseif string.find(line, "BG:") == nil then
			-- obj, x, y, z, w = string.match(line, "(%a+)%((%d+),(%d+),(%d+),(%d+)%)")
			-- thing = {obj, tonumber(x), tonumber(y), tonumber(z), tonumber(w)}
			-- table.insert(create, thing)
			subline = line
			arg = ""
			thing = {}
			table.insert(thing, string.match(subline, "(%a+)%(*"))
			subline = string.sub(subline, 5)
			while arg ~= nil do
				arg = string.match(subline, "(%d+),*")
				if arg ~= nil then
					subline = string.sub(subline, arg:len() + 2)
					table.insert(thing, tonumber(arg))
				end
			end
			table.insert(create, thing)
		end
	end

	--creates objects in level from creation array
	for num, tuple in ipairs(create) do
		self:make(tuple)
	end
end

function LevelLoader:make(object)
	local o

	if object[1] == "pla" then
		player = Player(object[2], object[3], 200)
		if levelNum == 4 or levelNum == 3 then
			player.bomb = 0
			player.h_jump = 0
		end
		if levelNum == 6 then
			player.bomb = 1
		end
		if levelNum == 0 then
			player.bomb = 99
			player.h_jump = 99
		end
		table.insert(objects, player)
		return
	elseif object[1] == "ogb" then
		o = GlowBorg()
		o:setPosition(object[2], object[3])
	elseif object[1] == "ocb" then
		o = CircleBorg()
		o:setPosition(object[2], object[3])
	elseif object[1] == "ops" then
		o = PhantomShip()
		o:setPosition(object[2], object[3])
	elseif object[1] == "odm" then
		o = DualMaster()
		o:setPosition(object[2], object[3])
	elseif object[1] == "osb" then
		o = SunBoss(object[2], object[3])
	elseif object[1] == "sgb" then
		o = Spawn(object[2], object[3], object[4], object[5], object[6], object[7], object[8], 'g')
	elseif object[1] == "sps" then
		o = Spawn(object[2], object[3], object[4], object[5], object[6], object[7], object[8], 'f')
	elseif object[1] == "sdm" then
		o = Spawn(object[2], object[3], object[4], object[5], object[6], object[7], object[8], 'd')
	elseif object[1] == "pwr" then
		o = DoubleShot(object[2], object[3], 0)
	elseif object[1] == "rep" then
		o = Repair(object[2], object[3], 0)
	elseif object[1] == "spd" then
		o = SpeedUp(object[2], object[3], 0)
	elseif object[1] == "wrm" then
		o = Wormhole(object[2], object[3])
		o:setTeleport(object[4], object[5])
	elseif object[1] == "wnh" then
		o = Winhole(object[2], object[3])
	elseif object[1] == "frm" then
		table.insert(frames, Frame(object[2],object[3]))
	elseif object[1] == "wal" then
		o = Wall(object[2], object[3], object[4], object[5])
	elseif object[1] == "mbl" then
		o = MetalBall(object[2], object[3], object[4], object[5])
	elseif object[1] == "ast" then
		o = Asteroid(1, object[2], object[3])
	elseif object[1] == "omb" then
		o = MoonBoss(object[2], object[3])
	elseif object[1] == "tur" then
		o = Turret(object[2], object[3], object[4], object[5])
	elseif object[1] == "wpt" then
		o = WeaponPart(object[2], object[3], object[4])
	elseif object[1] == "osc" then
		o = ScaredBorg()
		o:setPosition(object[2], object[3])
	elseif object[1] == "oss" then
		o = SunBoss2(object[2], object[3])
	end
	table.insert(objects, o)
end

function LevelLoader:update(dt, score, game)

	--[[
	--checks for win/lose states
	length = table.getn(objects)
	local enemy_gone = true
	local player_gone = true
	for i=1, length do
		if objects[i]:getID() == 1 and objects[i]:getType() == 'b' then
			enemy_gone = false
		end
	end

	if enemy_gone and not ended then
		if levelNum == 1 then
			game:advance()
			time = 0
			h_timer = 0
		end
	end
	]]
	
	if self.waveMode then
		manager:update(dt, game)
	end

	if self.hordeMode then
		self:hordeCheck(dt, game)
	end

	if player.winner == true then
		game:advance()
	end

	if player:isDead() and not ended then
		game:lose()
	end
end

function LevelLoader:hordeCheck(dt, game)
	self.h_timer = self.h_timer + dt
	if self.h_timer > 90 then
		game:advance()
	end
end

function LevelLoader:hordeDraw()
	local timeLeft = math.floor(90 - self.h_timer)
	love.graphics.print(
		"TIME: " .. timeLeft,
		310, 10
	)
end

function LevelLoader:waveDraw()
	local timeLeft = math.floor(90 - self.h_timer)
	love.graphics.print(
		"WAVE: " .. manager:getWave(),
		310, 10
	)
end

function LevelLoader:getBackground()
	return self.background
end

function LevelLoader:getBackgroundDimensions()
	return self.background:getWidth(), self.background:getHeight()
end

return LevelLoader
