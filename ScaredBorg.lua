--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Enemy = require("Enemy")
SpaceGoo = require("SpaceGoo")
local time = 0

local ScaredBorg = {
    img = "gfx/enemy_sheet.png",
    width = 60, height = 60,
    frames = 6, states = 2,
    delay = 0.12, sprites = {},
    bounding_rad = 25, type = 's',
    vel = 200, run_range = 150,
    bouncing = false, b_angle,
    b_timer, kludgevar, sparks
}
ScaredBorg.__index = ScaredBorg

setmetatable(ScaredBorg, {
    __index = Enemy,
    __call = function (cls, ... )
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function ScaredBorg:_init()
    Enemy._init(self, self.x, self.y, self.vel, self.img, self.width, self.height, self.frames, self.states, self.delay)
    self.validCollisions = {1,2,3}
    local temp = love.graphics.newImage("gfx/post.png")
    self.sparks = love.graphics.newParticleSystem(temp, 10)
    self.sparks:setParticleLifetime(0.3, 0.7) -- Particles live at least 0.3s and at most 0.7s.
    self.sparks:setLinearAcceleration(-400, -400, 400, 400) -- Random movement in all directions.
    self.sparks:setColors(255, 255, 0, 255, 255, 255, 0, 0) -- Fade to transparency.
    self.sparks:setSizes(0.3)
end

function ScaredBorg:update(dt, swidth, sheight, px, py)
    time = time + dt
    Enemy.update(self, dt, swidth, sheight)
    self.sparks:update(dt)

    --print("PLAYER: " .. py .. " " .. px)
    local angle = math.atan((py - self.y) / (px - self.x))

    --if not exploding
    if not self.collided and
    --and player is within chasing range
    (self.x - px)^2 + (self.y - py)^2 < self.run_range^2 and
    --and ScaredBorg is not currently bouncing off something
    not self.bouncing then
        --move towards player
        local poop = SpaceGoo(self.x,self.y)
        table.insert(objects,poop)

        if px - self.x < 0 then
            self.x = self.x + self.vel * dt * math.cos(angle)
            self.y = self.y + self.vel * dt * math.sin(angle)
        else
            self.x = self.x - self.vel * dt * math.cos(angle)
            self.y = self.y - self.vel * dt * math.sin(angle)
        end
    elseif self.bouncing then
        self:bounce(dt)
        self.b_timer = self.b_timer - dt
        if self.b_timer <= 0 then
            self.bouncing = false
            self.vel = 130
        end
    end
end

function ScaredBorg:bounce(dt)
    self.vel = self.vel + 1600 * dt
    if not self.kludgevar then
        self.x = self.x + self.vel * dt * math.cos(self.b_angle)
        self.y = self.y + self.vel * dt * math.sin(self.b_angle)
    else
        self.x = self.x - self.vel * dt * math.cos(self.b_angle)
        self.y = self.y - self.vel * dt * math.sin(self.b_angle)
    end
end

function ScaredBorg:draw()
    Enemy.draw(self, 184, 222, 58)
    if self.b_angle ~= nil then
        if self.kludgevar then
            love.graphics.draw(self.sparks, self.x + (self.width/2)*math.cos(self.b_angle),
            self.y + (self.height/2)*math.sin(self.b_angle))
        else
            love.graphics.draw(self.sparks, self.x - (self.width/2)*math.cos(self.b_angle),
            self.y - (self.height/2)*math.sin(self.b_angle))
        end
    end
end

function ScaredBorg:getType()
    return self.type
end

function ScaredBorg:getHitBoxes( ... )
    local hb = {}
    local hb_1 = {self.x, self.y, self.bounding_rad}
    table.insert(hb, hb_1)

    return hb
end

function ScaredBorg:collide(obj)
    if obj:getID() ~= 1 and obj:getID() ~= 8 then
        self.delay = .1
        Enemy.collide(self, obj)
    elseif obj:getID() == 1 and obj:getType() == 'g' then
        ox = obj:getX()
        oy = obj:getY()
        self.b_angle = math.atan((oy - self.y) / (ox - self.x))
        self.bouncing = true
        self.b_timer = .15
        self.kludgevar = false
        if ox > self.x then
            self.kludgevar = true
        end
        self.sparks:emit(5)
    end
end

return ScaredBorg
