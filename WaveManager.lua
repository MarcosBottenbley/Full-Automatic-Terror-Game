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

local WaveManager = {}
WaveManager.__index = WaveManager

setmetatable(WaveManager, {
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function WaveManager:_init()
	wave = 0
	clear = false
	check = false
end

function WaveManager:update()
	clear = true
	for _, o in ipairs(objects) do
		if o:getID() == 1 then
			clear = false
		end
	end
end

return WaveManager