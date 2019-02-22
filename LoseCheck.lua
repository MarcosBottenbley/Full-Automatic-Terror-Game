--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local LoseCheck = {}
LoseCheck.__index = LoseCheck

setmetatable(LoseCheck, {
    __call = function (cls, ... )
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function LoseCheck:_init(id)
    if id == 1 then
        self.current = death
    end
end

function LoseCheck:setPlayer(player)
    self.player = player
end

local death = function (...)
    return self.player:getHealth()
end

function LoseCheck:getstatus(...)
    return self.current()
end

return LoseCheck
