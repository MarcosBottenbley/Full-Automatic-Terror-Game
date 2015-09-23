Object = require("Object")
math.randomseed(os.time())

local Enemy = {
	img = "gfx/enemy_sheet.png",
	width = 56, height = 56,
	frames = 8, states = 1,
	delay = 0.08, sprites = {},
	bounding_rad = 25
}
Enemy.__index = Enemy

setmetatable(Enemy, {
	__index = Object,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Enemy:_init(x, y, v)
	Object._init(self, x, y, v, 
		self.img, 
		self.width, 
		self.height, 
		self.frames, 
		self.states,
		self.delay
		)
end

function Enemy:draw()
	Object.draw(self,255,0,0)
end

function Enemy:update(dt, swidth, sheight)
	Object.update(self, dt)

	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

	if self.x < 1 then
		self.vx = math.abs(self.vx)
	end
	
	if self.x > swidth-self.width then
		self.vx = -1 * math.abs(self.vx)
	end

	if self.y < 1 then
		self.vy = math.abs(self.vy)
	end
	
	if self.y > sheight-self.height then
		self.vy = -1 * math.abs(self.vy)
	end
end

function Enemy:bounce(side)
	if side == 1 then
		self.vx = -self.vx
	else
		self.vy = -self.vy
	end
end

function Enemy:direction()
	if math.random(0,2) <= 1 then
		if math.random(0,2) >= 1 then
			self:bounce(0)
		else
			self:bounce(1)
		end
	end
end

return Enemy