math.randomseed(os.time())

local Object= {
	x = 10, y = 10,
	vx = 50, vy = 50,
	width = 10, height = 10,
	sprites = {}, delta = 0
}
Object.__index = Object

setmetatable(Object, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Object:_init(x, y, v, file, fwidth, fheight, frames, states, delay)
	self.x = x
	self.y = y
	self.vx = v
	self.vy = v

	self.sprite_sheet = love.graphics.newImage("gfx/enemy_sheet.png")

	self.fwidth = 56 	--width of each sprite in the frame
	self.fheight = 56	--height of each sprite in the frame

	self.frames = 5	--number of frames
	self.states = 1	--number of states (different animations)

	self.delay = 0.08		--delay between changing frames

	self.current_frame = 1
	self.current_state = 1

	self.width = self.sprite_sheet:getWidth()
	self.height = self.sprite_sheet:getHeight()

	self:load()
end

function Object:load()
	for i = 1, self.states do
		local h = self.fheight * (i-1)
		self.sprites[i] = {}

		for j = 1, self.frames do
			local w = self.width * (j-1)
			self.sprites[i][j] = love.graphics.newQuad(w,h,self.fwidth,self.fheight,self.width,self.height)
		end
	end
end

function Object:update(dt)
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

	self.delta = self.delta + dt

	if self.delta >= self.delay then
		self.current_frame = (self.current_frame % self.frames) + 1
		self.delta = 0
	end
end

function Object:draw(r,g,b)
	if self.sprite_sheet ~= nil then
		love.graphics.draw(self.sprite_sheet, self.sprites[self.current_state][self.current_frame], x, y)
	else
		if r ~= nil and g ~= nil and b ~= nil then
			love.graphics.setColor(r,g,b)
		else
			love.graphics.setColor(255,255,255,255)
		end
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	end
	love.graphics.setColor(255,255,255,255)
end

return Object