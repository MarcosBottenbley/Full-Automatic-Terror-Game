--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Enemy = require("Enemy")

local Turret = {
    img = "gfx/turret.png",
    width = 64, height = 64,
    frames = 2, states = 2,
    delay = 0, sprites = {},
    bounding_rad = 25, type = 't',
    angle = 0, active = true, bullet_timer = 0,
    target_angle_low, target_angle_high,
    stunned = false, stun_timer = 5,
    sparks
}
Turret.__index = Turret

setmetatable(Turret, {
    __index = Enemy,
    __call = function (cls, ... )
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

--tlow_deg and thigh_deg determine the turret's aiming range (in degrees)
function Turret:_init(x, y, tlow_deg, thigh_deg)
    Enemy._init(self, x, y, self.vel, self.img, self.width, self.height, self.frames, self.states, self.delay)
    self.target_angle_low = tlow_deg * (math.pi/180)
    self.target_angle_high = thigh_deg * (math.pi/180)
    self.angle = (self.target_angle_low + self.target_angle_high) / 2

    local temp = love.graphics.newImage("gfx/particle.png")
    self.sparks = love.graphics.newParticleSystem(temp, 10)
    self.sparks:setParticleLifetime(0.3, 0.7) -- Particles live at least 2s and at most 5s.
    self.sparks:setLinearAcceleration(-600, -600, 600, 600) -- Random movement in all directions.
    self.sparks:setColors(255, 255, 0, 255, 255, 255, 0, 0) -- Fade to transparency.
    self.sparks:setSizes(2)
    self.validCollisions = {2,3}
end

function Turret:update(dt, swidth, sheight, px, py)
    --Handles the stun logic: turret doesn't update if stunned, stun lasts 5 seconds
    self.sparks:update(dt)
    if self.stun_timer < 5 then
        self.stun_timer = self.stun_timer + dt
    else
        self.stunned = false
    end
    if self.stunned then
        return
    end

    Enemy.update(self, dt, swidth, sheight)
    if not self.active then
        self.bullet_timer = self.bullet_timer + dt
    end

    -- Code for updating turret sprite and status.
    -- When the turret fires, self.bullet_timer is set to 0 and the sprite is
    -- switched to state 1, frame 2 (firing). After .2 seconds, it switches to
    -- state 2 (inactive) and after 1.8 seconds it switches to state 1, frame 1
    -- (active) but doesn't actually activate the turret. Once the full 2 seconds
    -- are up, the turret is really active and ready to fire at the player.
    if self.bullet_timer > 2 then
        self.active = true
    elseif self.bullet_timer > 1.8 and not self.active then
        self.current_state = 1
        self.current_frame = 1
    elseif self.bullet_timer > .2 and not self.active then
        self.current_state = 2
    end

    --create temporary var to store angle between turret and player
    local temp_angle = math.atan((self.y - py) / (px - self.x))
    --extra code to get the angle between 0 and 2pi radians
    if px < self.x then
        temp_angle = temp_angle + math.pi
    elseif py > self.y then
        temp_angle = temp_angle + math.pi*2
    end

    --code for dealing with rotation nonsense
    local angle_correct = 1
    if math.abs(temp_angle - self.angle) > math.pi then
        angle_correct = -1
    end

    --aim turret towards player if the angle between them is in target range
    if temp_angle >= self.target_angle_low and temp_angle <= self.target_angle_high then
        self.angle = self.angle + ((temp_angle - self.angle)/math.abs(temp_angle - self.angle))*angle_correct*dt

        --if turret is active and aiming at player, then shoot
        if self.active and self.angle > temp_angle - (math.pi/10) and self.angle < temp_angle + (math.pi/10) then
            self:shoot()
        end
    end

    --more code for dealing with rotation nonsense
    if self.angle > math.pi*2 then
        self.angle = self.angle - math.pi*2
    elseif self.angle < 0 then
        self.angle = self.angle + math.pi*2
    end
end

function Turret:draw()
    if self.stunned then
        Object.draw(self, 155, 155, 155, math.pi/2 - self.angle)
    else
        Object.draw(self, 255, 255, 255, math.pi/2 - self.angle)
    end
    love.graphics.draw(self.sparks, self.x, self.y)
end

--Shoots two bullets and deactivates the turret, changing the sprite to
--the "firing" position
function Turret:shoot()
    local startposx = self.x + 20 * math.cos(self.angle)
    local startposy = self.y - 20 * math.sin(self.angle)
    local b1 = EnemyBullet(startposx + 14*math.sin(self.angle), startposy + 14*math.cos(self.angle), 400, self.angle) --magic numbers errywhere
    local b2 = EnemyBullet(startposx - 14*math.sin(self.angle), startposy - 14*math.cos(self.angle), 400, self.angle) --magic numbers errywhere
    table.insert(objects, b1)
    table.insert(objects, b2)
    self.bullet_timer = 0
    self.current_frame = 2
    self.active = false
end

function Turret:getType()
    return self.type
end

function Turret:getHitBoxes( ... )
    local hb = {}
    local hb_1 = {self.x, self.y, self.bounding_rad}
    table.insert(hb, hb_1)

    return hb
end

function Turret:collide(obj)
    if obj:getID() == 3 then
        self.stunned = true
        self.stun_timer = 0
        self.sparks:emit(10)
    end
end

return Turret
