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