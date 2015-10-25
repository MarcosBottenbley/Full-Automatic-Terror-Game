--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local LevelLoader = {
	level = "level/level0",
	bg_string = "gfx/large_bg_string.png",
	hordeMode = false, won = false,
	h_timer = 0
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
end

function LevelLoader:load(...)
	local create = {}

	for line in love.filesystem.lines(self.level) do
		if string.find(line, "BG:") ~= nil then
			self.bg_string = string.sub(line, 4)
		end
	end

	self.background = love.graphics.newImage(self.bg_string)

	--populates creation array with everything specified in level file
	for line in love.filesystem.lines(self.level) do
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
end

function LevelLoader:make(thing, x, y, z, w)
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
	elseif thing == "frm" then
		table.insert(frames, Frame(x,y))
	end

	table.insert(objects, obj)
end

function LevelLoader:update(dt, score)
	--checks for win/lose states
	if self.hordeMode then
		self:hordeCheck(dt)
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

	if enemy_gone and not ended then
		if not self.hordeMode then
			self:win(score)
			time = 0
			h_timer = 0
		end
	end
	if player_gone and not ended then
		time = 0
		levelNum = 1
		self.hordeMode = false
		h_timer = 0
		self:lose()
	end
end

function LevelLoader:hordeCheck(dt)
	h_timer = h_timer + dt
	if h_timer > 120 then
		time = 0
		h_timer = 0
		self:win()
	end
end

function LevelLoader:hordeDraw()
	local timeLeft = math.floor(120 - h_timer)
	love.graphics.print(
		"TIME: " .. timeLeft,
		250, 10
	)
end

function LevelLoader:lose()
	-- self:scoreCheck()
	levelNum = 1
	hordeMode = false
	ended = true
	switchTo(LevelLoaderOver)
end

function LevelLoader:win()
	-- score = score + 3000
	if levelNum == 1 then
		levelNum = 2
		self.hordeMode = true
		switchTo(Intro2)
	elseif levelNum == 2 then
		-- self:scoreCheck()
		levelNum = 1
		self.hordeMode = false
		ended = true
		switchTo(Win)
	end
end

function LevelLoader:getBackground()
	return self.background
end

function LevelLoader:getBackgroundDimensions()
	return self.background:getWidth(), self.background:getHeight()
end

return LevelLoader
