--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Object = require("Object")
math.randomseed(os.time())

local WallConnector = {}
WallConnector.__index = WallConnector

setmetatable(WallConnector, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function WallConnector:load()
	Object.load(self)
	boom = love.audio.newSource("sfx/explode.ogg")
	boom:setLooping(false)
end