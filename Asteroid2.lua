--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

math.randomseed(os.time())

Enemy = require("Enemy")

--Version of Asteroid based on MetalBall for use in level 3B.
local Asteroid2 = {
    width = 64, height = 64,
    frames = 3, states = 2,
    img = "gfx/asteroid1.png",
    delay = .1, sprites = {},
    bounding_rad = 29, vel = 130,
    bouncing = false, angle,
    b_timer, type = 'a',
    scale = 1
}
Asteroid2.__index = Asteroid2

setmetatable(Asteroid2, {
    __index = Enemy,
    __call = function (cls, ... )
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function Asteroid2:_init(x, y, vx, vy, rev)
    if math.random() > 0.5 then
        self.img = "gfx/asteroid2.png"
    end

    Enemy._init(self, x, y, self.vel, self.img, self.width, self.height, self.frames, self.states, self.delay)
    self.validCollisions = {1,2,3,6,8}
    self.angle = math.random()*math.pi*2
    self.scale = scale
    --super hacky way to implement setting vx/vy in level file.
    --Later, we'll have to either make this determine the angle
    --for realsies or change the Asteroid2 code to be based on x/y
    --velocity instead of velocity and angle.
    if vx ~= nil and vy ~= nil then
        self.vel = math.sqrt(vx^2 + vy^2)
        if vy == 0 then
            if rev == 0 then
                self.angle = 0
            elseif rev == 1 then
                self.angle = math.pi
            end
        elseif vx == 0 then
            if rev == 0 then
                self.angle = math.pi/2
            elseif rev == 1 then
                self.angle = math.pi*(3/2)
            end
        end
    end
end

function Asteroid2:update(dt, swidth, sheight, px, py)
    Enemy.update(self, dt, swidth, sheight)

    if self.x < 0  then
        self.angle = 0
    elseif self.y < 0 then
        self.angle = math.pi*(3/2)
    elseif self.x > swidth - self.width then
        self.angle = math.pi
    elseif self.y > sheight - self.height then
        self.angle = math.pi/2
    end

    -- move if not destroyed
    if not self.collided then
        --move in the direction of self.angle
        self.x = self.x + self.vel * dt * math.cos(self.angle)
        self.y = self.y - self.vel * dt * math.sin(self.angle)
    end
end

function Asteroid2:getType()
    return self.type
end

function Asteroid2:getHitBoxes( ... )
    local hb = {}
    local hb_1 = {self.x, self.y, self.bounding_rad*self.scale}
    table.insert(hb, hb_1)

    return hb
end

function Asteroid2:collide(obj)
    if obj:getID() == 2 or obj:getID() == 3 then
        Enemy.collide(self, obj)
    elseif obj:getID() == 8 then
        ox = obj:getX()
        oy = obj:getY()
        if obj:isVertical() then
            if ox < self.x then
                self.angle = 0
            else
                self.angle = math.pi
            end
        else
            if oy < self.y then
                self.angle = math.pi*(3/2)
            else
                self.angle = math.pi/2
            end
        end
    end
end

function Asteroid2:setAngle(angle)
    self.angle = angle
end

return Asteroid2
