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

local Orbiter = {
    width = 64, height = 64,
    frames = 3, states = 2,
    img = "gfx/asteroid1.png",
    delay = .1, sprites = {},
    bounding_rad = 29, vel = 100,
    angle, type = 'o', centerx = 0,
    centery = 0, center_dist = 0,
    spinning = false, spin_angle = 0,
    throwing = false, targetx = 0,
    targety = 0, throw_timer = 0,
    max_throw_time = 0
}
Orbiter.__index = Orbiter

setmetatable(Orbiter, {
    __index = Enemy,
    __call = function (cls, ... )
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function Orbiter:_init(x, y, cx, cy)
    -- print(self.width .. " " .. self.height)
    -- if math.random() > 0.5 then
        -- if math.random() > 0.5 then
            -- self.img = "gfx/asteroid2.png"
            -- self.width = 64
            -- self.height = 64
            -- self.frames = 3
            -- self.delay = 0.1
            -- self.bounding_rad = 29
        -- else
            -- self.img = "gfx/asteroid1.png"
            -- self.width = 64
            -- self.height = 64
            -- self.frames = 3
            -- self.delay = 0.1
            -- self.bounding_rad = 29
        -- end
    -- else
        -- if math.random() > 0.5 then
            -- self.img = "gfx/enemy_sheet.png"
            -- self.width = 60
            -- self.height = 60
            -- self.frames = 6
            -- self.delay = 0.12
            -- self.bounding_rad = 25
        -- else
            -- self.img = "gfx/metal_asteroid1.png"
            -- self.width = 64
            -- self.height = 64
            -- self.frames = 3
            -- self.delay = 0.1
            -- self.bounding_rad = 29
        -- end
    -- end
    -- print(self.width .. " " .. self.height)
    -- print("-------------")
    self.throw_timer = 0
    self.vel = math.random(100,150)
    if math.random() > 0.5 then
        self.vel = self.vel*-1
    end
    self.vel = (math.pi/180)*self.vel
    self.center_dist = math.sqrt((y - cy)^2 + (cx - x)^2)
    self.angle = math.atan((y - cy) / (cx - x))
    if cx < x then
        self.angle = self.angle + math.pi
    elseif cy > y then
        self.angle = self.angle + math.pi*2
    end
    self.centerx = cx
    self.centery = cy

    self.max_throw_time = math.random(0,5)

    Enemy._init(self, x, y, self.vel, self.img, self.width, self.height, self.frames, self.states, self.delay)
end

function Orbiter:update(dt, swidth, sheight, px, py)
    Enemy.update(self, dt, swidth, sheight)

    if self.throw_timer < (self.max_throw_time - 1.5) then
        self.throw_timer = self.throw_timer + dt
    elseif self.throw_timer < self.max_throw_time then
        self.throw_timer = self.throw_timer + dt
        self.spinning = true
    else
        self:throw(player:getX(), player:getY())
        self.throw_timer = -1000
    end

    if self.spinning then
        self.spin_angle = self.spin_angle + 10*dt
    else
        self.spin_angle = self.spin_angle + 0.5*dt
    end

    self.angle = self.angle + self.vel*dt

    -- move if not destroyed
    if not self.collided and not self.spinning then
        --move in the direction of self.angle
        self.x = self.centerx + self.center_dist * math.cos(self.angle)
        self.y = self.centery - self.center_dist * math.sin(self.angle)
    elseif self.spinning then
        if self.throwing then
            self.x = self.x + 500*dt*math.cos(self.target_angle)
            self.y = self.y - 500*dt*math.sin(self.target_angle)
        end
    end

    if self.x < 0 or self.x > swidth - self.width or self.y > sheight - self.height then
        self.collided = true
    end
end

function Orbiter:draw()
    Object.draw(self, 255, 255, 255, self.spin_angle)
end

function Orbiter:getType()
    return self.type
end

function Orbiter:getHitBoxes( ... )
    local hb = {}
    local hb_1 = {self.x, self.y, self.bounding_rad}
    table.insert(hb, hb_1)

    return hb
end

function Orbiter:collide(obj)
    if obj:getID() == 3 or obj:getID() == 2 then
        -- if self.scale >= 1 then
            -- self:split()
        -- end
        Enemy.collide(self, obj)
    end
end

function Orbiter:throw(tx, ty)
    self.throwing = true
    self.targetx = tx
    self.targety = ty
    self.target_angle = math.atan((self.y - self.targety) / (self.targetx - self.x))
    if self.targetx < self.x then
        self.target_angle = self.target_angle + math.pi
    elseif self.targety > self.y then
        self.target_angle = self.target_angle + math.pi*2
    end
end

function Orbiter:setAngle(angle)
    self.angle = angle
end

return Orbiter
