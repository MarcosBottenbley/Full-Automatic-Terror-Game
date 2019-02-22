--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local Frame = {
    x = 0, y = 0,
    width = 0, height = 0,
    in_frame = false
}
Frame.__index = Frame

setmetatable(Frame, {
    __index = Camera,
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function Frame:_init(x, y)
    self.x = x
    self.y = y
end

function Frame:getCoordinates()
    return -self.x, -self.y
end

function Frame:entered(px,py)
    if px > self.x and px < self.x + 800
        and py > self.y and py < self.y + 600 then
        return true
    else
        return false
    end
end

return Frame
