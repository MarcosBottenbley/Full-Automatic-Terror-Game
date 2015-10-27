--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local WinCheck = {}
WinCheck.__index = WinCheck

setmetatable(WinCheck, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function WinCheck:_init(id)
	if id == 1 then
		self.current = boss
	elseif id == 2 then
		self.current = time
	elseif id == 3 then
		self.current = location
	end 
end

function WinCheck:setPlayer(player)
	self.player = player
end

function WinCheck:setGoal(goal)
	self.goal = goal
end

local boss = function (...)
	return self.goal:getHealth()
end

local time = function (...)
	return self.goal
end

local location = function (...)
	plx = self.player:getX()
	ply = self.player:getY()

	gx = self.goal:getX()
	gy = self.goal:getY()

	return math.sqrt(math.pow(plx - gx, 2) + math.pow(ply - gy, 2))
end

function WinCheck:getstatus(...)
	return self.current()
end

return WinCheck