Object = require("Object")

local playerx = 0
local playery = 0

local Spawn = {
  x = 10, y = 10,
  rad = 100
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

function Spawn:_init(x,y,r,types)
  self.x = x
  self.y = y
  self.rad = r
  self.types = types
end

function Spawn:update(dt,x,y)
  playerx = x
  playery = y

  dist = self:calcDist()
end

function Spawn:calcDist()

  return 
end
