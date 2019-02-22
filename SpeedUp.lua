--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Powerup = require("Powerup")

local SpeedUp = {
    img = "gfx/speed_power_up.png",
    width = 44, height = 47,
    frames = 2, states = 1,
    delay = 0.3,
    vx = 10, vy = 10,
    sprites = {}, bounding_rad = 15,
    id = 5, type = 'sp', collided = false
}
SpeedUp.__index = SpeedUp

setmetatable(SpeedUp, {
    __index = Powerup,
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function SpeedUp:_init(x, y, v)
    self.vx = v
    self.vy = v
    self.collided = false
    Object._init(self, x, y, self.img, self.width, self.height, self.frames, self.states, self.delay)
end

function SpeedUp:draw()
    Object.draw(self,255,255,255)
end

return SpeedUp
