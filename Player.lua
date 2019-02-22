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
local f_timer
local firable

local timeChange
local pos
local t_timer
local destination
local clockwise
local arrow

local Player = {
    vel = 0, max_vel = 200,
    accel = 0, max_accel = 800,
    img = "gfx/main_ship_sheet.png",
    width = 42, height = 57,
    frames = 5, states = 2,
    delay = 0.12, sprites = {},
    id = 2, collided = false, fast = false,
    bounding_rad = 25, angle1 = math.pi/2,
    move_angle = math.pi/2, draw_angle = math.pi/2,
    ang_vel = 0, double = false,
    health = 10, bomb = 3, h_jump = 5,
    invul = false, dam_timer = 0, damaged = false,
    bomb_flash = false, flash_timer = .6,
    teleporttimer = 0, chargeTime = 0, charged = false,
    inframe = false, jumptimer = 0, isJumping = false,
    camera_x = 0, camera_y = 0, winner = false,
    b_angle, b_timer, bouncing, dead_timer = 0,
    weaponSpeeds = {.18, .4, .5}, current_weapon = 1,
    chargeSpeed = 1,
    partCount = 0, pMessaging, part_timer = 0
}
Player.__index = Player

setmetatable(Player, {
    __index = Object,
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function Player:_init(x, y, v)

    f_timer = 0
    firable = false

    timeChange = 0
    pos = 1
    t_timer = 0
    destination = math.pi/2
    clockwise = false

    Object._init(self, x, y,
        self.img,
        self.width,
        self.height,
        self.frames,
        self.states,
        self.delay)

    self.max_vel = v

    self.hb_1 = {self.x, self.y - 18.5, 10}
    self.hb_2 = {self.x, self.y + 10.5, 19}

    self.validCollisions = {1,6,5,7,8,14}
    -- thrusters = {x1,y1,x2,y2,x3,y3} pos of thrusters
    self.thrusters = {}
    self:intitializeThrusters()
end

function Player:load()
    Object.load(self)
    pew = love.audio.newSource("sfx/pew_lower.ogg")
    pew:setLooping(false)
    playerhit = love.audio.newSource("sfx/playerhit.ogg")
    playerhit:setLooping(false)
    bump = love.audio.newSource("sfx/bump1.ogg")
    bump:setLooping(false)
    part = love.audio.newSource("sfx/getpart.ogg")
    part:setLooping(false)
    self.partfont = love.graphics.newFont("PressStart2P.ttf", 12)
    arrow = love.graphics.newImage("gfx/indicator.png")
end

function Player:update(dt, swidth, sheight)
    Object.update(self,dt)
    self:partUpdate(dt)
    if f_timer < self.weaponSpeeds[self.current_weapon] then
        f_timer = f_timer + dt
    end
    t_timer = t_timer + dt
    timeChange = dt

    if f_timer >= self.weaponSpeeds[self.current_weapon] then
        firable = true
        f_timer = self.weaponSpeeds[self.current_weapon]
    else
        firable = false
    end

    self.teleporttimer = self.teleporttimer + dt

    if self.flash_timer > .58 then
        self.bomb_flash = false
    end

    if self.damaged then
        self.dam_timer = self.dam_timer + dt
    end

    if self.dam_timer > 0.5 then
        self.damaged = false
        self.dam_timer = 0
    end

    if self.collided then
        self.dead_timer = self.dead_timer + dt
    end

    if self.dead_timer > self.frames * self.delay - .02 then
        self.dead = true
    end

    if not self.bouncing and not self.collided then

        self.vel = 0

        if self.slowed then
            self.max_vel = 80
        else
            if self.fast then
                self.max_vel = 300
            else
                self.max_vel = 200
            end
        end

        local thrusting = false
        self:smoothturn()
        --turn left or right
        if love.keyboard.isDown('left') then
            --self:smoothturn(math.pi)
            if destination == math.pi*2 then
                self.move_angle = math.pi
            end
            if love.keyboard.isDown('x') or not love.keyboard.isDown('z') then
                destination = self:closerAngle(self.move_angle, math.pi)
            else
                self.move_angle = math.pi
            end
            self.vel = self.max_vel
            thrusting = true
        end
        if love.keyboard.isDown('right') then
            --self:smoothturn(0)
            if destination == math.pi then
                self.move_angle = math.pi*2
            end
            if love.keyboard.isDown('x') or not love.keyboard.isDown('z') then
                destination = self:closerAngle(self.move_angle, math.pi*2)
            else
                self.move_angle = math.pi*2
            end
            self.vel = self.max_vel
            thrusting = true
        end
        if love.keyboard.isDown('down') then
            --self:smoothturn(math.pi*(3/2))
            if destination == math.pi/2 then
                self.move_angle = math.pi*(3/2)
            end
            if love.keyboard.isDown('x') or not love.keyboard.isDown('z') then
                destination = self:closerAngle(self.move_angle, math.pi*(3/2))
            else
                self.move_angle = math.pi*(3/2)
            end
            self.vel = self.max_vel
            thrusting = true
        end
        if love.keyboard.isDown('up') then
            --self:smoothturn(math.pi/2)
            if destination == math.pi*(3/2) then
                self.move_angle = math.pi/2
            end
            if love.keyboard.isDown('x') or not love.keyboard.isDown('z') then
                destination = self:closerAngle(self.move_angle, math.pi/2)
            else
                self.move_angle = math.pi/2
            end
            self.vel = self.max_vel
            thrusting = true
        end
        if love.keyboard.isDown('up') and love.keyboard.isDown('right') then
            --self:smoothturn(math.pi/4)
            if love.keyboard.isDown('x') or not love.keyboard.isDown('z') then
                destination = self:closerAngle(self.move_angle, math.pi/4)
            else
                self.move_angle = math.pi/4
            end
            self.vel = self.max_vel
            thrusting = true
        end
        if love.keyboard.isDown('up') and love.keyboard.isDown('left') then
            --self:smoothturn(math.pi*(3/4))
            if love.keyboard.isDown('x') or not love.keyboard.isDown('z') then
                destination = self:closerAngle(self.move_angle, math.pi*(3/4))
            else
                self.move_angle = math.pi*(3/4)
            end
            self.vel = self.max_vel
            thrusting = true
        end
        if love.keyboard.isDown('down') and love.keyboard.isDown('right') then
            --self:smoothturn(math.pi*(7/4))
            if love.keyboard.isDown('x') or not love.keyboard.isDown('z') then
                destination = self:closerAngle(self.move_angle, math.pi*(7/4))
            else
                self.move_angle = math.pi*(7/4)
            end
            self.vel = self.max_vel
            thrusting = true
        end
        if love.keyboard.isDown('down') and love.keyboard.isDown('left') then
            --self:smoothturn(math.pi*(5/4))
            if love.keyboard.isDown('x') or not love.keyboard.isDown('z') then
                destination = self:closerAngle(self.move_angle, math.pi*(5/4))
            else
                self.move_angle = math.pi*(5/4)
            end
            self.vel = self.max_vel
            thrusting = true
        end

        if thrusting then
            self.particles:setLinearAcceleration(0,100,0,0)
        else
            self.particles:setLinearAcceleration(0,20,0,0)
        end

        if self.isJumping == true then
            self.jumptimer = self.jumptimer + dt
            self.vel = 1800
            self.invul = true
            if self.jumptimer > 0.2 then
                self.invul = false
                self.isJumping = false
                self.jumptimer = 0
                self.vel = max_vel
            end
        end

        if love.keyboard.isDown('x') or not love.keyboard.isDown('z') then
            self.draw_angle = self.move_angle
        end

        self.y = self.y - math.sin(self.move_angle)*self.vel*dt
        self.x = self.x + math.cos(self.move_angle)*self.vel*dt
    elseif self.bouncing and not self.collided then
        self:bounce(dt)
        self.b_timer = self.b_timer - dt
        if self.b_timer <= 0 then
            self.bouncing = false
            self.vel = 0
        end
    end

    if self.x < 1 then
        self.x = 1
    end

    if self.y < 1 then
        self.y = 1
    end

    if self.x > (swidth - self.width) then
        self.x = (swidth - self.width)
    end

    if self.y > (sheight - self.height) then
        self.y = (sheight - self.height)
    end

    self.hb_1[1] = self.x + 18.5 * math.cos(self.draw_angle)
    self.hb_1[2] = self.y - 18.5 * math.sin(self.draw_angle)

    self.hb_2[1] = self.x - 10.5 * math.cos(self.draw_angle)
    self.hb_2[2] = self.y + 10.5 * math.sin(self.draw_angle)

    self.flash_timer = self.flash_timer + dt

    if love.keyboard.isDown('z') then
        if firable then
            if not (self.current_weapon == 3 and not self.charged)then
                self:fire()
            elseif self.current_weapon == 3 then
                self.chargeTime = self.chargeTime + dt*self.chargeSpeed
            end
        end
    end
    --self.thrusters = {-11,17,1,21,13,17}
    self.slowed = false
end

function Player:easeOutCubic(t, b, c, d)
    local t1 = t / d
    t1 = t1 - 1
    return c*(t1*t1*t1 + 1) + b
end

function Player:smoothturn()
    local factor = self:easeOutCubic(t_timer, 0, 1, 5)
    self.move_angle = self.move_angle + (destination - self.move_angle) * factor
    --print(t_timer)
end

--Finds the closest angle multiple of the target angle to the current angle.
--Basically, this returns the target angle +/- whatever multiple of 2*pi
--will result in the least amount of rotation from the current angle.
function Player:closerAngle(current, target)
    local var = (current - target) / (math.pi*2)

    if (math.abs(current - (target + (math.pi*2)*math.floor(var))) <
    math.abs(current - (target + (math.pi*2)*math.ceil(var)))) then
        clockwise = false
        return target + (math.pi*2)*math.floor(var)
    else
        clockwise = true
        return target + (math.pi*2)*math.ceil(var)
    end
end

function Player:draw()
    --transform the angle so it works with love.draw()
    local love_angle = math.pi/2 - self.draw_angle
    if self.damaged then
        Object.draw(self,155,155,155, love_angle)
    else
        if self.invul then
            Object.draw(self,255,255,0, love_angle)
        elseif self.bouncing then
            Object.draw(self,30,144,255, love_angle)
        elseif self.slowed then
            Object.draw(self, 33, 215, 29, love_angle)
        else
            Object.draw(self,255,255,255, love_angle)
        end
    end
    --Draw particle thrusters. Right now they're always on.
    --We're using the built-in LOVE rotation in graphics.draw() to rotate them,
    --which honestly might be more trouble than it's worth. The origin offsets
    --are all magic numbers that I basically just tweaked until they worked.
    if not self.collided then
        love.graphics.draw(self.particles, self.x, self.y, love_angle, 1, 1, -11, -9)
        love.graphics.draw(self.particles, self.x, self.y, love_angle, 1, 1, 1, -13)
        love.graphics.draw(self.particles, self.x, self.y, love_angle, 1, 1, 13, -9)
    end

    love.graphics.setFont(self.partfont)
    if self.pMessaging then
        love.graphics.print("" .. self.partCount .. " OF 4 PARTS COLLECTED", self.x + 50, self.y + 50)
    end
end

function Player:keyreleased(key)
    if key == 'i' then
        self:toggleInvul()
    end

    if key == 'z' then
        if self.current_weapon == 3 and firable then
            self.charged = true
            self:fire()
        end
    end

    if key == 'c' then
        self:useBomb()
    end

    if key == ' ' then
        self:useJump()
    end

    if key == '1' then
        if self.current_weapon ~= 1 then
            laser_arm:play()
            self.current_weapon = 1
        end
    elseif key == '2' then
        if self.current_weapon ~= 2 then
            missile_arm:play()
            self.current_weapon = 2
        end
    elseif key == '3' then
        if self.current_weapon ~= 3 then
            charge_arm:play()
            self.current_weapon = 3
        end
    end

    if key == '0' then
        self.health = self.health + 5
    end

    if key == '9' then
        self.h_jump = self.h_jump + 5
    end

    if key == '8' then
        self.bomb = self.bomb + 5
    end

    if key == '7' then
        levelNum = 4
        switchTo(Intro3)
    end

    if key == '6' then
        levelNum = 3
        switchTo(Intro4)
    end

    if key == '5' then
        levelNum = 5
        switchTo(Intro5)
    end
end

function Player:keypressed(key)
    if key == 'left' or key == 'right' or key == 'up' or key == 'down' then
        t_timer = 0
    end

    if key == 'z' then
        if self.current_weapon == 3 and firable then
            self.charged = false
        end
    end
end

--Changes the player's angle based on the direction passed in.
--Passing in 1 increases the angle (turns left) and -1 decreases
--the angle (turns right).
function Player:turn(direction)
    if direction == 1 or direction == -1 then
        self.ang_vel = math.pi * direction
    end
end

function Player:fire()
    f_timer = 0

    if self.current_weapon == 3 then
        local c = ChargeShot(self.hb_1[1], self.hb_1[2], 600, self.chargeTime, self.draw_angle)
        table.insert(objects, c)
        pew:play()
        self.chargeTime = 0
        self.charged = false
    elseif self.current_weapon == 2 then
        local m = Missile(self.hb_1[1], self.hb_1[2], 600, self.draw_angle)
        table.insert(objects, m)
        pew:play()
    elseif self.current_weapon == 1 then
        if self.double then
            --code
            local b1 = Bullet(self.hb_1[1] + 10*math.sin(self.draw_angle), self.hb_1[2] + 10*math.cos(self.draw_angle), 600, self.draw_angle) --magic numbers errywhere
            local b2 = Bullet(self.hb_1[1] - 10*math.sin(self.draw_angle), self.hb_1[2] - 10*math.cos(self.draw_angle), 600, self.draw_angle) --magic numbers errywhere
            table.insert(objects, b1)
            table.insert(objects, b2)
            pew:play()
        else
            local b = Bullet(self.hb_1[1], self.hb_1[2], 600, self.draw_angle) --magic numbers errywhere
            table.insert(objects, b)
            pew:play()
        end
    end
end

function Player:useJump()
    if self.isJumping == false then

        if self.h_jump == 0 then
            error:play()
        else
            jump:play()
            self.vel = 40
            self.h_jump = self.h_jump - 1
            self.isJumping = true
        end
    end
end

function Player:useBomb()
    if self.bomb == 0 then
        error:play()
    else
        self.bomb = self.bomb - 1
        bombblast:play()

        local length = table.getn(objects)
        -- loop through objects and remove enemies close to player
        for i = 0, length - 1 do
            local o = objects[length - i]
          if (o:getX() > self.x - width/2 or o:getX() < self.x + width/2) and
            (o:getY() > self.y - height/2 or o:getY() < self.y + height/2) and
            (o:getID() == 1) then
                if o:getType() ~= 'b' and o:getType() ~= 't' and o:getType() ~= 'a' then
                o:setDead()
                end
            end
            self.bomb_flash = true
            self.flash_timer = 0
        end
    end
end

function Player:toggleInvul()
    self.invul = not self.invul
    self.i_timer = 0
end

function Player:getHitBoxes( ... )
    local hb = {}
    table.insert(hb, self.hb_1)
    table.insert(hb, self.hb_2)

    return hb
end

function Player:explode()
    if self.exploded == false and self.current_state == 2 then
        --TODO: make uncollidable somehow?
        self.exploded = true
    end
end

function Player:setHitBoxes(x1, y1, x2, y2)
    self.hb_1[1] = x1
    self.hb_1[2] = y1

    self.hb_2[1] = x2
    self.hb_2[2] = y2
end

function Player:getX()
    return self.x
end

function Player:getY()
    return self.y
end

function Player:setX(newX)
    self.x = newX
end

function Player:setY(newY)
    self.y = newY
end

function Player:getWidth()
    return self.width
end

function Player:getHeight()
    return self.height
end

function Player:hit()
    if not (self.invul or self.damaged) then
        self.health = self.health - 1
        if self:alive() then
            self.damaged = true
            self.dam_timer = 0
        end
        playerhit:play()
    end
end

function Player:alive()
    return self.health > 0
end

function Player:getHealth()
    return self.health
end

function Player:getBomb()
    return self.bomb
end

function Player:getJump()
    return self.h_jump
end

function Player:flash()
    return self.bomb_flash
end

function Player:getFlashTimer()
    return self.flash_timer
end

function Player:collide(obj)
    -- enemy
    if obj:getID() == 1 or obj:getID() == 6 or obj:getID() == 15 then
        self:hit()
        if not self:alive() then
            self.collided = true
            self:changeAnim(2)
        end
    -- powerup
    elseif obj:getID() == 5 then
        if obj:getType() == 'ds' then
            self.double = true
            self.weaponSpeeds[2] = .25
            self.chargeSpeed = 1.5
        elseif obj:getType() == 'r' then
            for i=1, 2 do
                if self.health < 10 then
                    self.health = self.health + 1
                end
            end
        elseif obj:getType() == 'sp' then
            self.max_vel = self.max_vel + 100
            self.fast = true
        end
    -- wormhole
    elseif obj:getID() == 7 then
        if self.teleporttimer > 1 then
            self.teleporttimer = 0
            self.x, self.y = obj:teleport()
            teleport:play()
        end
        -- love.timer.sleep(0.2)
        -- wall
    elseif obj:getID() == 8 then
        if self.isJumping then
            self.invul = false
            self.isJumping = false
            self.jumptimer = 0
            self.vel = self.max_vel
        end
        bump:play()
        ox = obj:getX()
        oy = obj:getY()
        if obj:isVertical() then
            if ox < self.x then
                self.b_angle = 0
            else
                self.b_angle = math.pi
            end
        else
            if oy < self.y then
                self.b_angle = math.pi/2
            else
                self.b_angle = math.pi*(3/2)
            end
        end
        self.bouncing = true
        self.b_timer = .2
    elseif obj:getID() == 9 then
        self.winner = true
    elseif obj:getID() == 14 then
        self.slowed = true
    end

    if obj:getType() == 'b' then
        if self.isJumping then
            self.invul = false
            self.isJumping = false
            self.jumptimer = 0
            self.vel = self.max_vel
        end
        ox = obj:getX()
        oy = obj:getY()
        self.b_angle = self.move_angle + math.pi
        self.bouncing = true
        self.b_timer = .2
    end
end

function Player:bounce(dt)
    self.vel = self.vel + 2000 * dt
    self.x = self.x + self.vel * dt * math.cos(self.b_angle)
    self.y = self.y + self.vel * dt * math.sin(self.b_angle)
end

function Player:isDamaged()
    return self.damaged
end

function Player:enterFrame(x,y)
    self.camera_x, self.camera_y = -x, -y
    inframe = true
end

function Player:isInFrame()
    return inframe
end

function Player:getFrameCoordinates()
    return self.camera_x, self.camera_y
end

-- add boosters to ships
function Player:intitializeThrusters()
    self.particles:setParticleLifetime(0.6, 1)
    self.particles:setEmissionRate(40)
    self.particles:setSizeVariation(1)
    self.particles:setLinearAcceleration(0, 100, 0, 200)
    self.particles:setColors(255, 255, 160, 255, 255, 0, 0, 100)
end

--Returns values for the game class to use in drawing the weapon bar.
--The first value is for calculating the current weapon's cooldown %,
--the next two are for drawing the level of charge for the charge shot.
function Player:getBarValues()
    return f_timer / self.weaponSpeeds[self.current_weapon], math.modf(self.chargeTime)
end

function Player:getType()
    return ""
end

function Player:getWeapon()
    return self.current_weapon
end

function Player:getPart()
    self.partCount = self.partCount + 1
    self.pMessaging = true
    self.part_timer = 0
    part:play()
end

--temp fix for making "x of 4 parts" message
function Player:partUpdate(dt)
    if self.pMessaging then
        self.part_timer = self.part_timer + dt
    end
    if self.part_timer > 2 then
        self.pMessaging = false
        self.part_timer = 0
    end
    if self.partCount >= 4 then
        self.winner = true
    end
end

function Player:drawObjectiveMarker(obj_x, obj_y)
    local obj_angle = math.atan((self.y - obj_y) / (obj_x - self.x))
    if obj_x < self.x then
        obj_angle = obj_angle + math.pi
    elseif obj_y > self.y then
        obj_angle = obj_angle + math.pi*2
    end

    local love_angle = (math.pi/2) - obj_angle
    love.graphics.draw(arrow, self.x + 50*math.cos(obj_angle), self.y - 50*math.sin(obj_angle), love_angle, 0.5)
end

return Player
