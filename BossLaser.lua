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

local num = 0
local count = 0

local BossLaser = {
    vel = 400,
    width = 10, height = 10,
    frames = 1, states = 2,
    delay = 1, sprites = {},
    id = 15, bounding_rad = 5,
    lstatus = false
}
BossLaser.__index = BossLaser

setmetatable(BossLaser, {
    __index = Object,
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

--- sets enemy bullet’s velocity, angle, position, images,
--- states, frames, and delay

function BossLaser:_init(x, y, d, status)
    self.x = x
    self.y = y
    self.direction = d
    self.lstatus = status
    --[[
    Object._init(self, x, y,
        self.img,
        self.width,
        self.height,
        self.frames,
        self.states,
        self.delay)
    --]]

    if self.direction == "right" or self.direction == "left" then
        self.width = 2500
        self.height = 10
        num = self.width / self.height
    else
        self.width = 10
        self.height = 2500
        num = self.height / self.width
    end

    self.validCollisions = {2,3}
    self.hb = {}
    self:makeHitboxesBefore()
end

function BossLaser:getHitBoxes()
    local temp = {}
    if self.lstatus then
        return self.hb
    end

    local temp_hb = {self.x, self.y, self.bounding_rad}
    table.insert(temp, temp_hb)
    return temp
end

function BossLaser:update(dt, swidth, sheight)
    if self.lstatus then
        --self:makeHitboxes()
        self.validCollisions = {2,3}
        self:updateHitboxes()
    else
        self.validCollisions = {}
        --self.hb = {}
    end
end

function BossLaser:updateHitboxes()
    for _, hb in ipairs(self.hb) do
        if self.direction == "right" then
            hb[1] = self.x + hb[4]
            hb[2] = self.y
        elseif self.direction == "left" then
            hb[1] = self.x - hb[4]
            hb[2] = self.y
        elseif self.direction == "down" then
            hb[1] = self.x
            hb[2] = (self.y + hb[4]) - self.height/2
        elseif self.direction == "up" then
            hb[1] = self.x
            hb[2] = (self.y - hb[4]) - self.height/2
        end
    end
end

function BossLaser:makeHitboxes()
    if self.direction == "right" then
        if count < num then
            local offset = (self.height * count) - (self.height/2) - self.width/2
            local hb_1 = {self.x + offset, self.y, self.height/2, offset}
            table.insert(self.hb, hb_1)
        end
    elseif self.direction == "left" then
        if count < num then
            local offset = (self.height * count) - (self.height/2) - self.width/2
            local hb_1 = {self.x - offset, self.y, self.height/2, offset}
            table.insert(self.hb, hb_1)
        end
    elseif self.direction == "down" then
        if count < num then
            local offset = (self.width * count) - (self.width/2)
            local hb_1 = {self.x, (self.y + offset) - self.height/2, self.width/2, offset}
            table.insert(self.hb, hb_1)
        end
    elseif self.direction == "up" then
        if count < num then
            local offset = (self.width * count) - (self.width/2)
            local hb_1 = {self.x, (self.y - offset) - self.height/2, self.width/2, offset}
            table.insert(self.hb, hb_1)
        end
    end

    count = count + 1
end

function BossLaser:makeHitboxesBefore(...)
    --local hb = {}
    if self.direction == "right" then
        for i = 1, math.floor(num) do
            local offset = (self.height * i) - (self.height/2) - self.width/2
            local hb_1 = {self.x + offset, self.y, self.height/2, offset}
            table.insert(self.hb, hb_1)
        end
    elseif self.direction == "left" then
        for i = 1, math.floor(num) do
            local offset = (self.height * i) - (self.height/2) - self.width/2
            local hb_1 = {self.x - offset, self.y, self.height/2, offset}
            table.insert(self.hb, hb_1)
        end
    elseif self.direction == "down" then
        for i = 1, math.floor(num) do
            local offset = (self.width * i) - (self.width/2)
            local hb_1 = {self.x, (self.y + offset) - self.height/2, self.width/2, offset}
            table.insert(self.hb, hb_1)
        end
    elseif self.direction == "up" then
        for i = 1, math.floor(num) do
            local offset = (self.width * i) - (self.width/2)
            local hb_1 = {self.x, (self.y - offset) - self.height/2, self.width/2, offset}
            table.insert(self.hb, hb_1)
        end
    end
end

function BossLaser:setStatus(status)
    self.lstatus = status
end

function BossLaser:changeDirection(direction)
    self.direction = direction
end

function BossLaser:draw()
    if self.lstatus then
        love.graphics.setColor(255, 0, 0, 200)
        love.graphics.rectangle("fill", self.x - self.width/2, self.y - self.height/2, self.width, self.height)
        love.graphics.setColor(255, 255, 255, 255)
    end
end

return BossLaser
