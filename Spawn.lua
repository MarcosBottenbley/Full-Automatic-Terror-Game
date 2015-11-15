--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Object = require("Object")
GlowBorg = require("GlowBorg")

local playerx = 0
local playery = 0
local e

local Spawn = {
	x = 10, y = 10,
	width = 0, height = 0,
	id = 4,
	--Radius to spawn enemies along (or inside)
	rad = 100,
	--Radius the player has to enter to trigger a spawn
	--(if 0, spawner will always be active)
	pl_rad = 0,
	--Time between enemy spawns
	spawnrate = 20, 
	--Amount of time since last spawn
	spawntimer = 0,
	--How many times the spawner can create enemies before it stops
	spawnLimit = 1,
	--How many enemies the spawner creates per spawn
	spawnAmount = 5,
	--How many times the spawner has spawned so far
	spawnNum = 0
}
Spawn.__index = Spawn

setmetatable(Spawn, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Spawn:_init(x,y,pr,r,sr,sl,sa,types)
	self.x = x
	self.y = y
	self.pl_rad = pr
	self.rad = r
	self.spawnrate = sr
	self.spawnLimit = sl
	if sa ~= nil then
		self.spawnAmount = sa
	end
	self.type = types
	self.spawntimer = self.spawnrate / 4

	self.validCollisions = {-1}
end

--takes background dimensions as arguments but doesn't use them
--(avoids unnecessary code in game:update)
function Spawn:update(dt,bx,by,px,py)
	self.spawntimer = self.spawntimer + dt
		
	pl_dist = self:calcDist(px, py)
	
	--Code for creating enemies. Spawn will only happen if the spawn limit
	--has not been reached, it has been enough time since the last spawn,
	--and either the player is inside the spawner's radius or the radius is <0.
	if ((self.pl_rad > 0 and pl_dist < self.pl_rad) or self.pl_rad <= 0) and
	self.spawntimer > self.spawnrate and self.spawnNum < self.spawnLimit then
		self.spawntimer = 0
		for i = 1, self.spawnAmount do
			local radial_pos = math.random()*math.pi*2
			local spawnx = self.x + math.cos(radial_pos) * self.rad
			local spawny = self.y + math.sin(radial_pos) * self.rad
			e = ObjectHole(spawnx, spawny, self.type)
		
			--print("SPAWN #" .. i .. " X:" .. spawnx .. " Y:" .. spawny .. " TYPE:" .. self.type)

			if table.getn(objects) < 150 then
				table.insert(objects, e)
			end
		end
		self.spawnNum = self.spawnNum + 1
	end
end

-- function Spawn:draw()
	-- love.graphics.setColor(255, 0, 0, 255)
	-- love.graphics.circle("line", self.x, self.y, self.rad, 100)
	-- love.graphics.setColor(255, 0, 255, 255)
	-- love.graphics.circle("line", self.x, self.y, self.pl_rad, 100)
	-- love.graphics.setColor(255, 255, 255, 255)
-- end

function Spawn:calcDist(x, y)
  return math.sqrt((self.x - x)^2 + (self.y - y)^2)
end

return Spawn
