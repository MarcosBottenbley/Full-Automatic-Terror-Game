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
	id = 6, collided = false,
	bounding_rad = 5, angle = 0,
	on = false
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

function BossLaser:_init(x, y, d, on)
	self.x = x
	self.y = y
	self.direction = d
	self.on = on
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
		self.width = 300
		self.height = 10
		num = self.width / self.height
	else
		num = self.height / self.width
		self.width = 10
		self.height = 300
	end

	self.validCollisions = {2,3}
end

function BossLaser:getHitBoxes()
	return self.hb
end

function BossLaser:update(dt, swidth, sheight)

	if self.on then
		if self.direction == "right" then
			if count < num then
				local offset = (self.height * i) - (self.height/2) - self.width/2
				local hb_1 = {self.x + offset, self.y, self.height/2}
				table.insert(self.hb, hb_1)
			end
		elseif self.direction == "left" then
			if count < num then
				local offset = (self.height * i) - (self.height/2) - self.width/2
				local hb_1 = {self.x - offset, self.y, self.height/2}
				table.insert(self.hb, hb_1)
			end
		elseif self.direction == "down" then
			if count < num then
				local offset = (self.width * i) - (self.width/2)
				local hb_1 = {self.x, (self.y + offset) - self.height/2, self.width/2}
				table.insert(self.hb, hb_1)
			end
		elseif self.direction == "up" then
			if count < num then
				local offset = (self.width * i) - (self.width/2)
				local hb_1 = {self.x, (self.y - offset) - self.height/2, self.width/2}
				table.insert(self.hb, hb_1)
			end
		end

		count = count + 1
	end
end

function BossLaser:toggle()
	self.on = not self.on
	if self.on then
		self.validCollisions = {2,3}
	else
		self.validCollisions = {}
		self.hb = {}
	end
end

function BossLaser:draw()
	if self.on then
		for _, hb in ipairs(self.hb) do
			love.graphics.rectangle("fill", hb[1], hb[2], 10, 10)
		end
	end
end

return BossLaser
