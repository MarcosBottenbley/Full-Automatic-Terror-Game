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
  rad = 100, id = 4,
  pl_rad = 100, spawntimer = 10,
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

function Spawn:_init(x,y,pr,r,types)
  self.x = x
  self.y = y
  self.rad = r
  self.pl_rad = pr
  self.type = types
  --- self.spawned = false

  self.validCollisions = {-1}
end

function Spawn:update(dt,x,y)
	playerx = x
	playery = y
	self.spawntimer = self.spawntimer + dt

	dist = self:calcDist()

	--- if self.spawned == false then
	if self.spawntimer > 10 then
		if dist <= self.pl_rad then
			self.spawntimer = 0
			for i = 1, 5 do
				if self.type == 'g' then
					e = GlowBorg()
				elseif self.type == 'f' then
					e = PhantomShip()
				elseif self.type == 'd' then
					e = DualMaster()
				else
					e = GlowBorg()
				end
			local radial_pos = math.random(math.pi*2)
			local spawnx = self.x + math.cos(radial_pos) * self.rad
			local spawny = self.y + math.sin(radial_pos) * self.rad
			
			print("SPAWN #" .. i .. " X:" .. spawnx .. " Y:" .. spawny)

			e:setPosition(spawnx, spawny)
				table.insert(objects, e)
			end
			--- self.spawned = true
		end
	end
end

-- function Spawn:draw()
	-- love.graphics.setColor(255, 0, 0, 255)
	-- love.graphics.circle("line", self.x, self.y, self.rad, 100)
	-- love.graphics.setColor(255, 0, 255, 255)
	-- love.graphics.circle("line", self.x, self.y, self.pl_rad, 100)
	-- love.graphics.setColor(255, 255, 255, 255)
-- end

function Spawn:calcDist()
  return math.sqrt((self.x - playerx)^2 + (self.y - playery)^2)
end

return Spawn
