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
local max_health = 100

local FinalBoss = {
    img = "gfx/final_boss.png",
    width = 352, height = 216,
    frames = 4, states = 1,
    delay = 0.12, sprites = {},
    bounding_rad = 100, type = 'b',
    health = 100, dmg_timer = 0,
    angle = 0, damaged = false
}
FinalBoss.__index = FinalBoss

setmetatable(FinalBoss, {
    __index = Enemy,
    __call = function (cls, ... )
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function FinalBoss:_init(x,y)
    Enemy._init(self, x, y, v, self.img, self.width, self.height, self.frames, self.states, self.delay)
end

function FinalBoss:load()
    Object.load(self)
    bosshit = love.audio.newSource("sfx/bosshit.ogg")
    bosshit:setLooping(false)
end

function FinalBoss:update(dt, swidth, sheight, px, py)
    Enemy.update(self, dt, swidth, sheight)
    time = time + dt

    if self.damaged then
        self.dmg_timer = self.dmg_timer + dt
    end

    --print("PLAYER: " .. py .. " " .. px)
    local angle_p = math.atan((py - self.y) / (px - self.x))

    if not self:alive() then
        self.validCollisions = {}
        if time > 3 then
            self.collided = true
            self.current_state = 2
            self.current_frame = 1
        end
    end

    if self.dmg_timer > 0.2 then
        self.damaged = false
        self.dmg_timer = 0
    end
end

function FinalBoss:draw()
    self:drawHealthBar()
    if self.damaged then
        Object.draw(self,255,100,100)
    elseif not self:alive() and not self.collided then
        Object.draw(self,0, 0, 0)
    elseif not self.collided then
        Object.draw(self,255,255,255)
    end
end

function FinalBoss:drawHealthBar()
    local percent = math.floor((self.health / max_health) * 100)
    local length = (self.width * percent) /100
    if percent > 50 then
        love.graphics.setColor(0, 255, 0, 150)
    elseif percent < 50 and percent > 20 then
        love.graphics.setColor(222, 209, 37, 150)
    else
        love.graphics.setColor(255, 0, 0, 150)
    end
    love.graphics.rectangle("fill", self.x - self.width/2, self.y - 100, length , 10)
    love.graphics.setColor(255, 255, 255, 255)
end

function FinalBoss:getType()
    return self.type
end

function FinalBoss:getHitBoxes( ... )
    local hb = {}
    local hb_1 = {self.x, self.y, self.bounding_rad}
    table.insert(hb, hb_1)

    return hb
end

--returns the distance between FinalBoss' origin and (x, y)
function FinalBoss:distanceFrom(x, y)
    return math.sqrt((x - self.x)^2 + (y - self.y)^2)
end

function FinalBoss:hit()
    self.health = self.health - 1
    self.damaged = true
    self.dmg_timer = 0
    bosshit:play()
end

function FinalBoss:alive()
    return self.health > 0
end

function FinalBoss:getHealth(...)
    return self.health
end

function FinalBoss:collide(obj)
    if obj:getID() == 3 then
        self:hit()
        if not self:alive() then
            time = 0
            local gh = Winhole(self.x, self.y)
            table.insert(objects, gh)
        end
    end
end

return FinalBoss
