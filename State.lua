--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

State = {}
State.__index = State

setmetatable(State, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function State:load()
end

function State:update(dt)
end

function State:draw()
end

function State:keyreleased(key)
end

function State:start()
end

function State:stop()
end