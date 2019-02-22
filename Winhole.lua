--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Object = require("Object")

local Winhole = {
    img = "gfx/wormhole.png",
    frames = 9, states = 1,
    delay = 0.06,
    width = 80, height = 80,
    bounding_rad = 30,
    id = 9, collided = false,
    sprites = {}
}

Winhole.__index = Winhole

setmetatable(Winhole, {
    __index = Object,
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

--- initial spawn information

-- xset is the x offset upon being spawned there, either 0, 1, or -1 * certain distance
-- yset is the y offset upon being spawned there, either 0, 1, or -1 * certain distance

function Winhole:_init(x, y)
    self.collided = false
    self.xset = xset
    self.yset = yset
    self.tele_x = 0
    self.tele_y = 0
    Object._init(self, x, y,
        self.img,
        self.width,
        self.height,
        self.frames,
        self.states,
        self.delay)

    self.hb_1 = {self.x, self.y, self.bounding_rad}
    self.validCollisions = {2}
end

-- function Winhole:draw()
--      Object.draw(self, 255, 255, 255)
-- end
--
-- function Winhole:update(dt, swidth, sheight)
--  Object.update(self, dt)
-- end

function Winhole:draw()
    Object.draw(self, 255, 255, 0)
end

function Winhole:setPosition(x, y)
    self.x = x
    self.y = y
end

function Winhole:getHitBoxes( ... )
    local hb = {}
    local hb_1 = {self.x, self.y, self.bounding_rad}
    table.insert(hb, hb_1)

    return hb
end

function Winhole:getType()
    return self.type
end

function Winhole:getValid(...)
    return self.validCollisions
end

function Winhole:collide(obj)
    -- if it's the player, teleport the player
    -- player.setPosition(self:teleport())
end

return Winhole
