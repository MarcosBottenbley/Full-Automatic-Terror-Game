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
  pl_rad = 100
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

function Spawn:_init(x,y,r,pr,types)
  self.x = x
  self.y = y
  self.rad = r
  self.pl_rad = pr
  self.type = types
  self.spawned = false
end

function Spawn:update(dt,x,y)
	playerx = x
	playery = y

	dist = self:calcDist()

	if self.spawned == false then
		if dist <= self.pl_rad then
			for i = 1, 5 do
				if self.type == 'g' then
					e = GlowBorg()
				else
					e = PhantomShip()
				end
			local radial_pos = math.random(math.pi*2)
			local spawnx = math.cos(radial_pos) * self.rad
			local spawny = math.sin(radial_pos) * self.rad

			e:setPosition(spawnx, spawny)
				table.insert(objects, e)
			end
			self.spawned = true
		end
	end
end

function Spawn:calcDist()
  return math.sqrt((self.x - playerx)^2 + (self.y - playery)^2)
end

return Spawn
