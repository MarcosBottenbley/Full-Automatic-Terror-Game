--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local wave
local clear
local check
local timer
local enemies = {}
local level
local maxwave

local WaveManager = {}
WaveManager.__index = WaveManager

setmetatable(WaveManager, {
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function WaveManager:_init(lvl)
	wave = 0
	clear = false
	check = false
	level = lvl
	timer = 0
	
	for i = 1, 10 do
		enemies[i] = {}
	end
end

function WaveManager:load()
	local create = {}
	local wNum = 1
	local makestuff = false

	--populates creation array with everything specified in level file
	for line in love.filesystem.lines(level) do
		if string.find(line, "wave:") ~= nil then
			wNum = tonumber(string.sub(line, 6))
			maxwave = tonumber(string.sub(line, 6))
			makestuff = true
		end
		if string.find(line, ":") == nil and makestuff then
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
			table.insert(enemies[wNum], thing)
			print("fun:" .. wNum)
			print(line)
		end
	end
end

function WaveManager:update(dt, game)
	-- for _, o in ipairs(objects) do
		-- if o:getID() == 1 then
			-- clear = false
		-- end
	-- end
	-- if clear then check end
	
	timer = timer + dt
	
	if timer > 1 then
		clear = true
		for _, o in ipairs(objects) do
			if o:getID() == 1 and o:getType() ~= 't' then
				clear = false
			end
		end
		timer = 0
	end
	
	if clear then
		if wave == maxwave then
			game:advance()
		else
			wave = wave + 1
		end
		clear = false
		self:start()
	end
end

function WaveManager:start()
	for _, object in ipairs(enemies[wave]) do
		local etype
		if object[1] == "ogb" then
			etype = 'g'
		elseif object[1] == "ocb" then
			etype = 'c'
		elseif object[1] == "ops" then
			etype = 'f'
		elseif object[1] == "odm" then
			etype = 'd'
		elseif object[1] == "tur" then
			etype = 't'
		elseif object[1] == "osc" then
			etype = 's'
		elseif object[1] == "oss" then
			etype = 'b'
		end
		if etype ~= nil then
			local o = ObjectHole(object[2], object[3], etype)
			table.insert(objects, o)
		end
	end
	
end

function WaveManager:getWave()
	return wave
end

return WaveManager