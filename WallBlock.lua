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

local WallBlock = {}
WallBlock.__index = WallBlock

setmetatable(WallBlock, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function WallBlock:load()
	Object.load(self)
	boom = love.audio.newSource("sfx/explode.ogg")
	boom:setLooping(false)
end