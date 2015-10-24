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
	bg = "gfx/large_bg.png"
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
	for line in love.filesystem.lines(self.level) do
		if string.find(line, "BG:") ~= nil then
			self.bg_string = string.sub(line, 4)
		end
	end

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
	end

	table.insert(objects, obj)
end

function LevelLoader:getBackground(...)
	return love.graphics.newImage(self.bg)
end

return LevelLoader