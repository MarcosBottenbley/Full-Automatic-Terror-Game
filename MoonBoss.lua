--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu


--1000x1000
--(x,y) 1000,1000
--128x128
Enemy = require("Enemy")
Winhole = require("Winhole")
math.randomseed(os.time())

local time = 0

--pos stuff
-- 0 = top middle
-- 1 = top left corner
-- 2 = left middle
-- 3 = bottom left corner
-- 4 = bottom middle
-- 5 = bottom right corner
-- 6 = right middle
-- 7 = top right corner
local MoonBoss = {
	img = "gfx/moon_boss.png",
	width = 128, height = 128,
	frames = 4, states = 2,
	delay = 0.12, sprites = {},
	bounding_rad = 64, type = 'b',
	health = 40, s_timer = 0,
	dmg_timer = 0, angle = 0,
	vel = 100, damaged = false,
	pos = 0
}
MoonBoss.__index = MoonBoss

setmetatable(MoonBoss, {
	__index = Enemy,
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function MoonBoss:_init(x,y)
	Enemy._init(self, x, y, v, self.img, self.width, self.height, self.frames, self.states, self.delay)
end

function MoonBoss:load()
	Object.load(self)
	bosshit = love.audio.newSource("sfx/bosshit.ogg")
	bosshit:setLooping(false)
end

function MoonBoss:update(dt, swidth, sheight, px, py)
	Enemy.update(self, dt, swidth, sheight)
	time = time + dt
	
	self.s_timer = self.s_timer + dt
	if self.damaged then
		self.dmg_timer = self.dmg_timer + dt
	end

	--[[
	if self.pos == 7 then
		self:move(1500, 1000 + self.height) -- 0
	elseif self.pos == 6 then
		self:move(2000 - self.width, 1000 + self.height) -- 7
	elseif self.pos == 5 then
		self:move(2000 - self.width, 1500) -- 6
	elseif self.pos == 4 then
		self:move(2000 - self.width, 2000 - self.height) -- 5
	elseif self.pos == 3 then
		self:move(1500, 2000 - self.height) -- 4
	elseif self.pos == 2 then
		self:move(1000 + self.width, 2000 - self.height) -- 3
	elseif self.pos == 1 then
		self:move(1000 + self.width, 1500) -- 2
	elseif self.pos == 0 then
		self:move(1000 + self.width, 1000 + self.height) -- 1
	end
	]]

	self:checkpos()

	
	
	if self.dmg_timer > 0.2 then
		self.damaged = false
		self.dmg_timer = 0
	end
end

function MoonBoss:checkpos( ... )
	if self.x == (1000 + self.width) and self.y == (1000 + self.height) then
		self.pos = 1
	elseif self.x == (1000 + self.width) and self.y == 1500 then
		self.pos = 2
	elseif self.x == (1000 + self.width) and self.y == (2000 - self.height) then
		self.pos = 3
	elseif self.x == 1500 and self.y == (2000 - self.height) then
		self.pos = 4
	elseif self.x == (2000 - self.width) and self.y == (2000 - self.height) then
		self.pos = 5
	elseif self.x == (2000 - self.width) and self.y == 1500 then
		self.pos = 6
	elseif self.x == (2000 - self.width) and self.y == (1000 + self.height) then
		self.pos = 7
	elseif self.x == 1500 and self.y == (1000 + self.height) then
		self.pos = 0
	end
end

function MoonBoss:hit()
	self.health = self.health - 1
	self.damaged = true
	self.dmg_timer = 0
	bosshit:play()
end

function MoonBoss:move(destx, desty)
	local factor = self:easeInQuint(time, 0, 1, 10)
	self.x = self.x + (destx - self.x) * factor

	self.y = self.y + (desty - self.y) * factor
end

function MoonBoss:easeInQuint(t, b, c, d)
	local t1 = t/d
	return c*t1*t1*t1*t1*t1 + b
end

function MoonBoss:alive()
	return self.health > 0
end

function MoonBoss:getHealth(...)
	return self.health
end

function MoonBoss:spawn4()
	local g1 = GlowBorg()
	local g2 = GlowBorg()
	local g3 = GlowBorg()
	local g4 = GlowBorg()
	if self.pos == 2 or self.pos == 6 then
		g1:setPosition(self.x,self.y + 50)
		g2:setPosition(self.x,self.y - 50)
		g3:setPosition(self.x,self.y + 100)
		g4:setPosition(self.x,self.y - 100)
	else
		g1:setPosition(self.x + 50,self.y)
		g2:setPosition(self.x - 50,self.y)
		g3:setPosition(self.x + 100,self.y)
		g4:setPosition(self.x - 100,self.y)
	end
	table.insert(objects, g1)
	table.insert(objects, g2)
	table.insert(objects, g3)
	table.insert(objects, g4)
end

function MoonBoss:spawnCircleBorg(px,py)
	local c1 = CircleBorg()
	local c2 = CircleBorg()
	local c3 = CircleBorg()
	local c4 = CircleBorg()
	c1:setPosition(px,py+100)
	c2:setPosition(px,py-100)
	c3:setPosition(px+100,py)
	c4:setPosition(px-100,py)

	table.insert(objects, c1)
	table.insert(objects, c2)
	table.insert(objects, c3)
	table.insert(objects, c4)
end

function MoonBoss:spawnAround(px, py)
	local g1 = GlowBorg()
	local g2 = GlowBorg()
	local g3 = GlowBorg()
	local g4 = GlowBorg()
	g1:setPosition(px,py+100)
	g2:setPosition(px,py-100)
	g3:setPosition(px+100,py)
	g4:setPosition(px-100,py)
	table.insert(objects, g1)
	table.insert(objects, g2)
	table.insert(objects, g3)
	table.insert(objects, g4)
end

function MoonBoss:getHitBoxes( ... )
	local hb = {}
	local hb_1 = {self.x, self.y, self.bounding_rad}
	table.insert(hb, hb_1)

	return hb
end

function MoonBoss:collide(obj)
	if obj:getID() == 3 then
		self:hit()
		if not self:alive() then
			time = 0
			local gh = Winhole(self.x, self.y)
			table.insert(objects, gh)
		end
	end
end

return MoonBoss