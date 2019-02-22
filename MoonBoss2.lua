--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Enemy = require("Enemy")
Winhole = require("Winhole")

local time = 0

local MoonBoss2 = {
    img = "gfx/moon_boss.png",
    width = 128, height = 128,
    frames = 9, states = 2,
    delay = 0.12, sprites = {},
    bounding_rad = 64, type = 'b',
    health = 40, s_timer = 0,
    dmg_timer = 0, shoot_angle = 0,
    vel = 100, damaged = false,
    move_angle = 0, bouncing,
    b_timer, b_angle
}
MoonBoss2.__index = MoonBoss2

setmetatable(MoonBoss2, {
    __index = Enemy,
    __call = function (cls, ... )
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function MoonBoss2:_init(x,y)
    Enemy._init(self, x, y, v, self.img, self.width, self.height, self.frames, self.states, self.delay)
    self.validCollisions = {2, 3, 8}
end

function MoonBoss2:load()
    Object.load(self)
    bosshit = love.audio.newSource("sfx/bosshit.ogg")
    bosshit:setLooping(false)
end

function MoonBoss2:update(dt, swidth, sheight, px, py)
    Enemy.update(self, dt, swidth, sheight)
    print("im alive")
    time = time + dt

    self.s_timer = self.s_timer + dt
    if self.damaged then
        self.dmg_timer = self.dmg_timer + dt
    end

    self.shoot_angle = self.shoot_angle + (math.pi/2)*dt*(7.66 - (self.health/6))

    --print("PLAYER: " .. py .. " " .. px)
    self.move_angle = math.atan((py - self.y) / (px - self.x))

    if not self:alive() then
        self.validCollisions = {}
        if time > 3 then
            self.collided = true
            self.current_state = 2
            self.current_frame = 1
        end
    elseif not self.bouncing then
        if self:distanceFrom(px, py) < 500 then
            --move towards player (weird if statement because i don't
            --totally understand the math)
            if px - self.x > 0 then
                self.x = self.x + self.vel * dt * math.cos(self.move_angle)
                self.y = self.y + self.vel * dt * math.sin(self.move_angle)
            else
                self.x = self.x - self.vel * dt * math.cos(self.move_angle)
                self.y = self.y - self.vel * dt * math.sin(self.move_angle)
            end
        end
    else
        print("bounce")
        self:bounce(dt)
        self.b_timer = self.b_timer - dt
        if self.b_timer <= 0 then
            print("stopbounce")
            self.bouncing = false
            self.vel = 100
        end
    end

    --shots get faster as health gets lower
    if self.s_timer > 0.5 / ((-9/39)*self.health + (389/39)) then
        self:shoot()
    end

    if self.dmg_timer > 0.2 then
        self.damaged = false
        self.dmg_timer = 0
    end
end

function MoonBoss2:draw()
    if self.damaged then
        Object.draw(self,255,100,100)
    elseif not self:alive() then
        Object.draw(self,255, 100, 100, self.shoot_angle)
    else
        Object.draw(self,255,255,255)
    end
end

function MoonBoss2:getType()
    return self.type
end

function MoonBoss2:getHitBoxes( ... )
    local hb = {}
    local hb_1 = {self.x, self.y, self.bounding_rad}
    table.insert(hb, hb_1)

    return hb
end

--returns the distance between MoonBoss2' origin and (x, y)
function MoonBoss2:distanceFrom(x, y)
    return math.sqrt((x - self.x)^2 + (y - self.y)^2)
end

function MoonBoss2:hit()
    self.health = self.health - 1
    self.damaged = true
    self.dmg_timer = 0
    bosshit:play()
end

function MoonBoss2:alive()
    return self.health > 0
end

function MoonBoss2:getHealth(...)
    return self.health
end

function MoonBoss2:shoot()
    local b = EnemyBullet(self.x, self.y+40, 600, self.shoot_angle)
    table.insert(objects, b)
    self.s_timer = 0
end

function MoonBoss2:collide(obj)
    if obj:getID() == 3 then
        self:hit()
        if not self:alive() then
            time = 0
            local gh = Winhole(self.x, self.y)
            table.insert(objects, gh)
        end
    end

    if obj:getID() == 8 then
        print("wallcollide")
        ox = obj:getX()
        oy = obj:getY()
        if obj:isVertical() then
            print("vert")
            if ox < self.x then
                self.b_angle = 0
            else
                self.b_angle = math.pi
            end
        else
            print("horz")
            if oy < self.y then
                self.b_angle = math.pi*(3/2)
            else
                self.b_angle = math.pi/2
            end
        end
        self.bouncing = true
        self.b_timer = .2
    end
end

function MoonBoss2:bounce(dt)
    self.vel = self.vel + 2000 * dt
    self.x = self.x + self.vel * dt * math.cos(self.b_angle)
    self.y = self.y - self.vel * dt * math.sin(self.b_angle)
end

return MoonBoss2
