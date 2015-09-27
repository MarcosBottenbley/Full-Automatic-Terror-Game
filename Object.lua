math.randomseed(os.time())

local Object= {
	x = 10, y = 10,
	width = 10, height = 10,
	sprites = {}, delta = 0,
	id = 0, collided = false
}
Object.__index = Object

setmetatable(Object, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Object:_init(x, y, file, width, height, frames, states, delay)
	self.x = x
	self.y = y

	self.sprite_sheet = love.graphics.newImage(file)

	self.width = width 	--width of each sprite in the frame
	self.height = height	--height of each sprite in the frame

	self.frames = frames	--number of frames
	self.states = states	--number of states (different animations)

	self.delay = delay		--delay between changing frames

	self.current_frame = 1
	self.current_state = 1

	self.sheet_width = self.sprite_sheet:getWidth()
	self.sheet_height = self.sprite_sheet:getHeight()
	
	self.timer = 0
	
	self.exploded = false

	self:load()
end

function Object:load()
	for i = 1, self.states do
		local h = (self.height * i) - (self.height-1)
		self.sprites[i] = {}

		for j = 1, self.frames do
			local w = (self.width * j) - (self.width-1)
			self.sprites[i][j] = love.graphics.newQuad(w,h,
				self.width,
				self.height,
				self.sheet_width,
				self.sheet_height)
		end
	end
end

function Object:update(dt)
	self.delta = self.delta + dt

	if self.delta >= self.delay then
		self.current_frame = (self.current_frame % self.frames) + 1
		self.delta = 0
	end
end

function Object:draw(r,g,b)
	if self.sprite_sheet ~= nil then
		love.graphics.draw(self.sprite_sheet, self.sprites[self.current_state][self.current_frame], self.x, self.y)
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

function Object:getX()
	return self.x
end

function Object:getY()
	return self.y
end

function Object:getID( ... )
	return self.id
end

function Object:getHitBoxes( ... )
	-- body
end

function Object:explode()
	
end

return Object